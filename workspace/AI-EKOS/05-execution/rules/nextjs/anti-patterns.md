# Next.js Anti-Patterns

## Server Component Anti-Patterns

### 1. Fetching Data in Loops
```tsx
// ❌ BAD: N+1 queries
async function ProductList() {
  const products = await db.select().from(products);
  return (
    <div>
      {products.map(p => (
        <Product key={p.id} id={p.id} />  // Each calls db again
      ))}
    </div>
  );
}

// ✅ GOOD: Single query with join
async function ProductList() {
  const productsWithDetails = await db.query.products.findMany({
    with: { details: true },
  });
  return (
    <div>
      {productsWithDetails.map(p => (
        <Product key={p.id} data={p} />
      ))}
    </div>
  );
}
```

### 2. Prop Drilling Server Data
```tsx
// ❌ BAD: Passing through 5 layers
export default async function Layout() {
  const user = await getUser();
  return <Nav user={user} />;  // Nav passes to UserMenu
}                          // UserMenu passes to Avatar

// ✅ GOOD: Fetch where needed, use React cache()
const getUser = cache(async () => db.query.users.findFirst());

function Nav() {
  return <UserMenu />;  // UserMenu fetches directly
}
```

### 3. Blocking Root Layout
```tsx
// ❌ BAD: Root layout waits for slow data
export default async function RootLayout() {
  const analytics = await getSlowAnalytics();  // Blocks entire page
  return <html>...</html>;
}

// ✅ GOOD: Stream with Suspense
export default function RootLayout() {
  return (
    <html>
      <body>
        <Suspense fallback={<AnalyticsSkeleton />}>
          <Analytics />
        </Suspense>
      </body>
    </html>
  );
}
```

## Client Component Anti-Patterns

### 4. Over-fetching Client-Side
```tsx
// ❌ BAD: Fetching everything client-side
'use client';
function Dashboard() {
  const { data: user } = useUser();
  const { data: posts } = usePosts();
  const { data: analytics } = useAnalytics();
  // 3 network requests, waterfall
}

// ✅ GOOD: Server Components for data, Client for interactivity
// Server Component fetches all, passes to Client Components
export default async function DashboardPage() {
  const [user, posts, analytics] = await Promise.all([
    getUser(), getPosts(), getAnalytics()
  ]);
  return <DashboardClient {...{ user, posts, analytics }} />;
}
```

### 5. Unnecessary 'use client'
```tsx
// ❌ BAD: Entire page is client because of one button
'use client';
export default function Page() {
  return (
    <div>
      <Header />
      <Content />
      <InteractiveButton />  // Only this needs client
    </div>
  );
}

// ✅ GOOD: Extract client boundary
export default function Page() {
  return (
    <div>
      <Header />
      <Content />
      <InteractiveButton />  // Separate 'use client' component
    </div>
  );
}
```

## Performance Anti-Patterns

### 6. No Image Optimization
```tsx
// ❌ BAD: Unoptimized images
<img src="/hero.jpg" width="800" height="600" />

// ✅ GOOD: Next.js Image component
import Image from 'next/image';
<Image
  src="/hero.jpg"
  alt="Hero"
  width={800}
  height={600}
  priority  // Above the fold
  placeholder="blur"
/>
```

### 7. No Loading States
```tsx
// ❌ BAD: Users see blank page for 5 seconds
export default async function Dashboard() {
  const data = await fetchSlowData();
  return <Dashboard data={data} />;
}

// ✅ GOOD: Streaming with loading.tsx
// app/dashboard/loading.tsx
export default function Loading() {
  return <DashboardSkeleton />;
}

// app/dashboard/page.tsx — Suspense handles automatically
```

## Security Anti-Patterns

### 8. Exposing Secrets Client-Side
```tsx
// ❌ BAD: Environment variable leaked
export default function Config() {
  return <div>API Key: {process.env.API_KEY}</div>;
}

// ✅ GOOD: Only NEXT_PUBLIC_* in client
// Server-only env vars accessible in Server Components
export default async function ServerComponent() {
  const data = await fetch(process.env.API_SECRET); // Server only
  return <div>{data}</div>;
}
```

### 9. No Input Validation
```tsx
// ❌ BAD: Direct database query from params
export default async function Page({ params }: { params: { id: string } }) {
  const user = await db.query.users.findFirst({
    where: eq(users.id, params.id) // No validation
  });
}

// ✅ GOOD: Validate with Zod
import { z } from 'zod';

const paramsSchema = z.object({
  id: z.string().uuid(),
});

export default async function Page({ params }: { params: { id: string } }) {
  const { id } = paramsSchema.parse(params);
  const user = await db.query.users.findFirst({
    where: eq(users.id, id)
  });
}
```

## API Route Anti-Patterns

### 10. Synchronous File Operations
```typescript
// ❌ BAD: Blocking request
import fs from 'fs';
export async function POST(req: Request) {
  const data = fs.readFileSync('./large-file.csv'); // Blocks event loop
  return Response.json({ processed: data.length });
}

// ✅ GOOD: Streaming and async
export async function POST(req: Request) {
  const stream = req.body;
  await processStream(stream); // Non-blocking
  return Response.json({ status: 'processing' });
}
```

## Summary Checklist
- [ ] No N+1 queries — fetch related data in single query
- [ ] No unnecessary 'use client' — keep boundaries small
- [ ] No blocking root layouts — use Suspense
- [ ] No unoptimized images — use next/image
- [ ] No missing loading states — implement loading.tsx
- [ ] No exposed secrets — use NEXT_PUBLIC_ prefix correctly
- [ ] No unvalidated inputs — use Zod schemas
- [ ] No sync file ops in API routes — use async/streaming


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
