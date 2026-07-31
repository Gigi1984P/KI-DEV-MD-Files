---
tags:
  - anti-patterns
  - auth
  - best-practices
  - nextjs
  - performance
  - react
  - security
summary: "Next.js Middleware"
read_when:
  - "Implementing nextjs features"
  - "Troubleshooting nextjs issues"
---

# Next.js Middleware

## Overview

Middleware runs before each request, enabling authentication, redirects, rewrites, and header manipulation at the edge.

## Use Cases

### Authentication
```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');
  
  // Protect dashboard routes
  if (request.nextUrl.pathname.startsWith('/dashboard')) {
    if (!token) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
    
    // Validate token (synchronous check)
    try {
      const payload = jwt.verify(token.value, process.env.JWT_SECRET);
      // Add user info to headers for downstream use
      const response = NextResponse.next();
      response.headers.set('x-user-id', payload.sub as string);
      return response;
    } catch {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/protected/:path*'],
};
```

### A/B Testing
```typescript
export function middleware(request: NextRequest) {
  const cookie = request.cookies.get('experiment');
  
  if (!cookie) {
    const variant = Math.random() > 0.5 ? 'A' : 'B';
    const response = NextResponse.next();
    response.cookies.set('experiment', variant, { maxAge: 60 * 60 * 24 * 7 });
    return response;
  }
  
  return NextResponse.next();
}
```

### Geographic Redirects
```typescript
export function middleware(request: NextRequest) {
  const country = request.geo?.country || 'US';
  
  if (country === 'DE' && !request.nextUrl.pathname.startsWith('/de')) {
    return NextResponse.redirect(new URL('/de' + request.nextUrl.pathname, request.url));
  }
  
  return NextResponse.next();
}
```

## Performance

- Middleware runs at the edge (Vercel Edge Network)
- Cold start: ~0ms (runs before Next.js)
- Keep lightweight — no heavy computation
- Use `matcher` config to limit execution scope

## Anti-Patterns

- Database queries in middleware (slows every request)
- Complex business logic (belongs in API routes)
- No matcher config (runs on every request including static files)
- Modifying request body (not supported)

## Testing

```typescript
// __tests__/middleware.test.ts
import { middleware } from './middleware';
import { NextRequest } from 'next/server';

describe('middleware', () => {
  it('redirects unauthenticated users', () => {
    const req = new NextRequest(new URL('http://localhost/dashboard'));
    const res = middleware(req);
    expect(res.status).toBe(307);
  });
});
```

## Related
- `05-execution/rules/nextjs/security.md` — Security patterns
- `07-patterns/authentication/` — Authentication patterns
