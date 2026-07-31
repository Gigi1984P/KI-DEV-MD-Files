# Solution: Authentication Architecture

## Components

### Password Authentication
```typescript
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

export async function verifyPassword(
  password: string, 
  hash: string
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}
```

### Session Management (JWT + Refresh Tokens)
```typescript
// Access token: short-lived (15 min)
const accessToken = jwt.sign(
  { sub: user.id, role: user.role },
  process.env.JWT_SECRET,
  { expiresIn: '15m' }
);

// Refresh token: long-lived, stored in httpOnly cookie
const refreshToken = crypto.randomBytes(32).toString('hex');
await db.insert(sessions).values({
  userId: user.id,
  token: refreshToken,
  expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
});
```

### Rate Limiting
```typescript
import { Ratelimit } from '@upstash/ratelimit';

const ratelimit = new Ratelimit({
  redis: redis,
  limiter: Ratelimit.slidingWindow(5, '1 m'),
  analytics: true,
});

export async function login(req: Request) {
  const { success } = await ratelimit.limit(
    req.ip + ':login'
  );
  if (!success) return new Response('Too many attempts', { status: 429 });
  // ...
}
```

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Client    │────▶│   API Route  │────▶│   Database  │
│             │     │              │     │             │
│ - Password  │     │ - Validate   │     │ - Hash      │
│ - MFA code  │     │ - Rate limit │     │ - Session   │
│ - Cookie    │◀────│ - JWT issue  │◀────│ - Audit log │
└─────────────┘     └──────────────┘     └─────────────┘
```

## Implementation Steps

1. **Hash passwords** with bcrypt (12+ rounds)
2. **Issue short-lived access tokens** (15 minutes)
3. **Store refresh tokens** in httpOnly, Secure, SameSite=Strict cookies
4. **Implement rate limiting** per IP and per user
5. **Add MFA** with TOTP (authenticator apps) or WebAuthn
6. **Log all events** (success, failure, MFA challenge)
7. **Provide logout** that invalidates session server-side


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-authentication/` — Build recipes
- `09-boilerplates/authentication/` — Starter templates
