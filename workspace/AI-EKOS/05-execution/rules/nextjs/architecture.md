---
tags:
  - anti-patterns
  - auth
  - best-practices
  - database
  - nextjs
  - performance
  - postgres
  - react
  - sql
summary: "Next.js Architecture"
read_when:
  - "Implementing nextjs features"
  - "Troubleshooting nextjs issues"
---

# Next.js Architecture

## App Router vs Pages Router

### Decision Matrix

| Criteria | App Router | Pages Router |
|----------|-----------|-------------|
| **New Project** | Recommended | Legacy only |
| **Server Components** | Native | Not supported |
| **Streaming** | Built-in | Limited |
| **Nested Layouts** | Native | Complex |
| **API Routes** | `route.ts` | `pages/api` |
| **Migration Effort** | Medium | — |
| **Ecosystem Maturity** | Growing | Stable |
| **Learning Curve** | Steeper | Familiar |

### When to Use App Router
- New projects starting 2026+
- Need for server-first architecture
- Complex layout requirements
- SEO-critical with dynamic content
- Real-time or streaming features

### When to Stick with Pages Router
- Large existing codebase
- Heavy dependency on `getServerSideProps` patterns
- Third-party middleware incompatible with App Router
- Team not ready for paradigm shift

## Project Structure

```
my-app/
├── app/                    # App Router (new)
│   ├── layout.tsx         # Root layout
│   ├── page.tsx            # Root page
│   ├── loading.tsx         # Loading UI
│   ├── error.tsx           # Error boundary
│   ├── not-found.tsx       # 404 page
│   ├── (marketing)/        # Route group
│   ├── dashboard/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── settings/
│   │       └── page.tsx
│   └── api/               # API routes
│       └── webhook/
│           └── route.ts
├── components/
│   ├── ui/                # Primitive components
│   ├── forms/             # Form components
│   └── layouts/           # Layout components
├── lib/
│   ├── db/                # Database utilities
│   ├── auth/              # Authentication
│   └── utils/             # Shared utilities
├── hooks/                  # Custom hooks
├── types/                  # TypeScript types
├── public/                 # Static assets
├── styles/                 # Global styles
├── next.config.js
├── tailwind.config.ts
└── tsconfig.json
```

## Server Components First

### Philosophy
Start with Server Components. Only use Client Components when:
- You need browser APIs (window, document)
- You need React hooks (useState, useEffect)
- You need event handlers (onClick, onSubmit)
- You need client-side data fetching

### Default to Server
```tsx
// This is a Server Component by default
export default async function Page() {
  const data = await fetchData(); // Direct data fetching
  return <div>{data}</div>;
}
```

### Opt-in to Client
```tsx
'use client';

import { useState } from 'react';

export default function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}
```

## Data Fetching Patterns

### Server Component Fetching
```tsx
// Parallel fetching
async function Page() {
  const [user, posts] = await Promise.all([
    fetch('/api/user'),
    fetch('/api/posts')
  ]);
  // ...
}
```

### Using React Query (Client)
```tsx
'use client';
import { useQuery } from '@tanstack/react-query';

function Dashboard() {
  const { data, isLoading } = useQuery({
    queryKey: ['dashboard'],
    queryFn: fetchDashboard
  });
}
```

## Performance Strategies

### Static Generation
```tsx
// Generate at build time
export const dynamic = 'force-static';

// Revalidate periodically
export const revalidate = 3600; // 1 hour
```

### Streaming with Suspense
```tsx
import { Suspense } from 'react';

export default function Page() {
  return (
    <>
      <h1>Dashboard</h1>
      <Suspense fallback={<Skeleton />}>
        <SlowWidget />
      </Suspense>
    </>
  );
}
```

### Image Optimization
```tsx
import Image from 'next/image';

<Image
  src="/photo.jpg"
  width={800}
  height={600}
  priority        // Above-the-fold
  placeholder="blur"
  blurDataURL="..."
/>
```

## Environment Configuration

### Required Env Vars
```bash
# .env.local
NEXT_PUBLIC_APP_URL=https://myapp.com
DATABASE_URL=postgresql://...
NEXTAUTH_SECRET=...
NEXTAUTH_URL=https://myapp.com
```

### Runtime vs Build Time
- `NEXT_PUBLIC_*` — Available in browser (build time)
- All others — Server only (runtime)

## Anti-Patterns

- Fetching data in `useEffect` when Server Component suffices
- Using `'use client'` at the top level unnecessarily
- Ignoring `Suspense` boundaries
- Blocking the root layout with slow data
- Over-fetching in loops without `cache()`


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
