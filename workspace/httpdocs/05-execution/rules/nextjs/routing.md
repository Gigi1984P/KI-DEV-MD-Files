# Next.js Routing

## App Router Conventions

### File-Based Routing
```
app/
├── page.tsx              # / (home)
├── layout.tsx            # Root layout
├── loading.tsx           # Loading UI for / and children
├── error.tsx             # Error boundary for / and children
├── not-found.tsx         # 404 for /
├── about/
│   └── page.tsx          # /about
├── blog/
│   ├── page.tsx          # /blog (blog list)
│   └── [slug]/
│       └── page.tsx      # /blog/my-post
├── (marketing)/          # Route group (no URL segment)
│   ├── landing/
│   │   └── page.tsx      # /landing
│   └── pricing/
│       └── page.tsx      # /pricing
├── (shop)/
│   ├── cart/
│   │   └── page.tsx      # /cart
│   └── checkout/
│       └── page.tsx      # /checkout
├── dashboard/
│   ├── page.tsx          # /dashboard
│   ├── layout.tsx        # Dashboard layout (sidebar, etc.)
│   ├── settings/
│   │   ├── page.tsx      # /dashboard/settings
│   │   └── profile/
│   │       └── page.tsx  # /dashboard/settings/profile
│   └── @analytics/       # Parallel route
│       └── page.tsx
└── api/
    ├── users/
    │   └── route.ts      # /api/users
    └── webhook/
        └── stripe/
            └── route.ts  # /api/webhook/stripe
```

### Dynamic Segments
```tsx
// app/blog/[slug]/page.tsx
export default async function BlogPost({
  params,
}: {
  params: { slug: string };
}) {
  const post = await getPost(params.slug);
  return <article>{post.content}</article>;
}

// Generate static params at build time
export async function generateStaticParams() {
  const posts = await getAllPosts();
  return posts.map((post) => ({
    slug: post.slug,
  }));
}
```

### Catch-All Segments
```tsx
// app/docs/[...slug]/page.tsx
// Matches: /docs/installation, /docs/installation/windows, etc.
export default async function DocsPage({
  params,
}: {
  params: { slug: string[] };
}) {
  const path = params.slug.join('/');
  const doc = await getDoc(path);
  return <DocContent doc={doc} />;
}
```

## Navigation

### Link Component
```tsx
import Link from 'next/link';

// Basic link
<Link href="/about">About</Link>

// With active state
'use client';
import { usePathname } from 'next/navigation';

function NavLink({ href, children }: { href: string; children: React.ReactNode }) {
  const pathname = usePathname();
  const isActive = pathname === href;
  
  return (
    <Link
      href={href}
      className={isActive ? 'text-blue-600' : 'text-gray-600'}
    >
      {children}
    </Link>
  );
}
```

### Programmatic Navigation
```tsx
'use client';
import { useRouter } from 'next/navigation';

function BackButton() {
  const router = useRouter();
  return <button onClick={() => router.back()}>Back</button>;
}

// With search params
function Search() {
  const router = useRouter();
  const searchParams = useSearchParams();
  
  function handleSearch(term: string) {
    const params = new URLSearchParams(searchParams);
    if (term) params.set('q', term);
    else params.delete('q');
    
    router.push(`/search?${params.toString()}`);
  }
}
```

## Route Groups

### Layout Groups
```
(app)/                    # No effect on URL
├── layout.tsx            # Shared layout
├── page.tsx              # /
└── about/
    └── page.tsx          # /about

(shop)/
├── layout.tsx            # Different layout (e.g., no nav)
├── cart/
│   └── page.tsx          # /cart
└── checkout/
    └── page.tsx          # /checkout
```

### Parallel Routes
```
dashboard/
├── layout.tsx            # Renders children + @analytics + @team
├── page.tsx              # /dashboard
├── @analytics/
│   └── page.tsx          # Shown in parallel
├── @team/
│   └── page.tsx          # Shown in parallel
└── settings/
    └── page.tsx          # /dashboard/settings
```

```tsx
// dashboard/layout.tsx
export default function DashboardLayout({
  children,
  analytics,
  team,
}: {
  children: React.ReactNode;
  analytics: React.ReactNode;
  team: React.ReactNode;
}) {
  return (
    <div>
      <div>{children}</div>
      <div className="grid grid-cols-2">
        <div>{analytics}</div>
        <div>{team}</div>
      </div>
    </div>
  );
}
```

## Intercepting Routes

```
feed/
├── page.tsx              # /feed
└── photo/
    └── [id]/
        └── page.tsx      # /feed/photo/1

@modal/                   # Intercept in modal
├── (.)photo/
│   └── [id]/
│       └── page.tsx      # Intercepts /feed/photo/1
└── default.tsx           # Fallback when direct navigation
```

## Anti-Patterns

- Using `<a>` instead of `<Link>` (full page reload)
- Dynamic segments without validation (404 instead of error)
- Route groups that affect URL structure unexpectedly
- Parallel routes without `default.tsx` fallback
- Using `useRouter` in Server Components


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
