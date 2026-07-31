# Solution: Controller Architecture

## Overview
Controllers handle HTTP requests, delegate to services, and format responses. They should be thin — business logic belongs in services.

## Implementation

### RESTful Controller

```typescript
// controllers/UserController.ts
import { Request, Response } from 'express';
import { UserService } from '../services/UserService';
import { createUserSchema, updateUserSchema } from '../schemas/userSchema';

export class UserController {
  constructor(private userService: UserService) {}

  async create(req: Request, res: Response) {
    try {
      const data = createUserSchema.parse(req.body);
      const user = await this.userService.create(data);
      res.status(201).json(user);
    } catch (error) {
      if (error instanceof ZodError) {
        return res.status(400).json({ errors: error.errors });
      }
      throw error;
    }
  }

  async findById(req: Request, res: Response) {
    const user = await this.userService.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  }

  async update(req: Request, res: Response) {
    const data = updateUserSchema.parse(req.body);
    const user = await this.userService.update(req.params.id, data);
    res.json(user);
  }

  async delete(req: Request, res: Response) {
    await this.userService.delete(req.params.id);
    res.status(204).send();
  }
}
```

### Route Configuration

```typescript
// routes/userRoutes.ts
import { Router } from 'express';
import { UserController } from '../controllers/UserController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();
const controller = new UserController(userService);

router.post('/', authenticate, controller.create.bind(controller));
router.get('/:id', authenticate, controller.findById.bind(controller));
router.put('/:id', authenticate, authorize('users:write'), controller.update.bind(controller));
router.delete('/:id', authenticate, authorize('users:delete'), controller.delete.bind(controller));

export default router;
```

## Error Handling

```typescript
// middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';

export function errorHandler(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  console.error('Error:', err);

  if (err instanceof ValidationError) {
    return res.status(400).json({
      error: 'Validation Error',
      message: err.message,
      details: err.details,
    });
  }

  if (err instanceof NotFoundError) {
    return res.status(404).json({
      error: 'Not Found',
      message: err.message,
    });
  }

  res.status(500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong',
  });
}
```

## Anti-Patterns

- Business logic in controller
- Direct database access from controller
- No input validation
- Generic error responses leaking implementation details
- Not using dependency injection


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-controller/` — Build recipes
- `09-boilerplates/controller/` — Starter templates
