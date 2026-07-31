---
tags:
  - anti-patterns
  - best-practices
  - database
  - nextjs
  - performance
  - postgres
  - react
  - sql
summary: "Solution: Authorization Architecture"
read_when:
  - "Designing authorization architecture"
  - "Reviewing authorization implementation"
---

# Solution: Authorization Architecture

## RBAC (Role-Based Access Control)

```typescript
// Roles and permissions
const ROLES = {
  admin: ['users:read', 'users:write', 'orders:read', 'orders:write', 'settings:manage'],
  manager: ['orders:read', 'orders:write', 'reports:read'],
  user: ['orders:read', 'profile:manage'],
} as const;

// Middleware
export async function authorize(permission: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    const user = req.user;
    const userPermissions = ROLES[user.role];
    
    if (!userPermissions.includes(permission)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    
    next();
  };
}

// Usage
app.get('/api/users', authenticate, authorize('users:read'), getUsers);
```

## ABAC (Attribute-Based Access Control)

```typescript
// Policy: Users can edit their own posts
function canEditPost(user: User, post: Post): boolean {
  return user.id === post.authorId || user.role === 'admin';
}

// Middleware
app.put('/api/posts/:id', authenticate, async (req, res) => {
  const post = await db.posts.findById(req.params.id);
  
  if (!canEditPost(req.user, post)) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  
  // ... update post
});
```

## Implementation Patterns

### Middleware Stack
```typescript
// Combined auth + authorization
app.get('/api/admin/users',
  authenticate,      // Verify JWT/session
  requireRole('admin'), // Check role
  getUsers
);
```

### Resource-Level Checks
```typescript
// Always check resource ownership
app.get('/api/orders/:id', authenticate, async (req, res) => {
  const order = await db.orders.findById(req.params.id);
  
  if (!order) return res.status(404).json({ error: 'Not found' });
  if (order.userId !== req.user.id && req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Forbidden' });
  }
  
  res.json(order);
});
```

## Audit Logging

```typescript
async function authorizeAndLog(
  user: User,
  resource: string,
  action: string,
  allowed: boolean
) {
  await db.auditLogs.create({
    userId: user.id,
    resource,
    action,
    allowed,
    timestamp: new Date(),
  });
}
```

## Anti-Patterns

- Route-level auth without resource-level checks
- Client-side authorization (can be bypassed)
- Hardcoded role strings throughout codebase
- No audit trail for sensitive operations


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-authorization/` — Build recipes
- `09-boilerplates/authorization/` — Starter templates
