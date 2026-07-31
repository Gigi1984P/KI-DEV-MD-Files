---
tags:
  - ai
  - anti-patterns
  - auth
  - best-practices
  - embeddings
  - rag
  - security
summary: "Next.js Security"
read_when:
  - "Implementing nextjs features"
  - "Troubleshooting nextjs issues"
---

# Next.js Security

## Headers Configuration

```javascript
// next.config.js
const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on',
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload',
  },
  {
    key: 'X-Frame-Options',
    value: 'SAMEORIGIN',
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff',
  },
  {
    key: 'Referrer-Policy',
    value: 'origin-when-cross-origin',
  },
  {
    key: 'Content-Security-Policy',
    value: "default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline'",
  },
];

module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: securityHeaders,
      },
    ];
  },
};
```

## Environment Variable Security

```typescript
// ❌ NEVER expose server secrets to client
export const config = {
  // This would leak to browser
  apiKey: process.env.API_SECRET,
};

// ✅ Only expose NEXT_PUBLIC_ variables
export const publicConfig = {
  appUrl: process.env.NEXT_PUBLIC_APP_URL,
};
```

## API Route Security

```typescript
// app/api/sensitive/route.ts
import { rateLimit } from '@/lib/rate-limit';

export async function POST(request: Request) {
  // Rate limiting
  const { success } = await rateLimit.check(request);
  if (!success) {
    return new Response('Too many requests', { status: 429 });
  }
  
  // Input validation
  const body = await request.json();
  const result = schema.safeParse(body);
  if (!result.success) {
    return new Response('Invalid input', { status: 400 });
  }
  
  // Authorization
  const user = await getUser(request);
  if (!user?.roles.includes('admin')) {
    return new Response('Forbidden', { status: 403 });
  }
  
  // Process request
}
```

## Anti-Patterns

- Storing JWT in localStorage (use httpOnly cookies)
- Disabling CSP for development (keep it strict)
- Trusting client-side validation alone
- Exposing internal API endpoints publicly

## Related
- `05-execution/checklists/security.md` — Security review checklist
- `07-patterns/authentication/` — Authentication patterns
