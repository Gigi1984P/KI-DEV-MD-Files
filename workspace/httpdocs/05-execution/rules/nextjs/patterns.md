# Next.js Patterns

## Pattern: Interleaved Server/Client Components

### Problem
Complex pages need server-side data AND client interactivity.

### Solution
```tsx
// Server Component fetches data
export default async function ProductPage({ params }: { params: { id: string } }) {
  const product = await getProduct(params.id);
  return (
    <div>
      <ProductInfo product={product} />
      <ReviewForm productId={product.id} /> {/* Client Component */}
    </div>
  );
}

// Client Component for interactivity
'use client';
function ReviewForm({ productId }: { productId: string }) {
  const [rating, setRating] = useState(0);
  // ... interactive form
}
```

## Pattern: Loading Skeleton

```tsx
// app/dashboard/loading.tsx
export default function Loading() {
  return (
    <div className="space-y-4">
      <div className="h-8 bg-gray-200 rounded w-1/3 animate-pulse" />
      <div className="h-64 bg-gray-200 rounded animate-pulse" />
    </div>
  );
}
```

## Pattern: Error Boundary

```tsx
// app/dashboard/error.tsx
'use client';

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  useEffect(() => {
    logError(error);
  }, [error]);

  return (
    <div>
      <h2>Something went wrong</h2>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

## Pattern: Parallel Data Fetching

```tsx
// Parallel fetching with Promise.all
export default async function Dashboard() {
  const [user, orders, analytics] = await Promise.all([
    getUser(),
    getOrders(),
    getAnalytics(),
  ]);

  return (
    <div>
      <UserCard user={user} />
      <OrderList orders={orders} />
      <AnalyticsChart data={analytics} />
    </div>
  );
}
```

## Pattern: Cache with React cache()

```tsx
import { cache } from 'react';

const getUser = cache(async (id: string) => {
  return db.query.users.findFirst({ where: eq(users.id, id) });
});

// Called multiple times, executes once
export default async function Layout({ params }: { params: { userId: string } }) {
  const user = await getUser(params.userId);
  return <div>{user.name}</div>;
}
```

## Pattern: Revalidation on Demand

```tsx
'use server';

import { revalidatePath, revalidateTag } from 'next/cache';

export async function createPost(formData: FormData) {
  await db.insert(posts).values(formData);
  revalidatePath('/posts');
  revalidateTag('posts');
}
```

## Pattern: Middleware for Auth

```tsx
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token');
  
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/protected/:path*'],
};
```

## Pattern: API Route with Validation

```tsx
// app/api/users/route.ts
import { z } from 'zod';

const userSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

export async function POST(request: Request) {
  const body = await request.json();
  const data = userSchema.parse(body);
  
  const user = await db.insert(users).values(data).returning();
  return Response.json(user);
}
```


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
