# Server Components

## Philosophy

Server Components are the default in Next.js App Router. They render on the server, send HTML to the client, and never ship JavaScript for their logic.

## What Server Components Can Do

### Direct Data Fetching
```tsx
// Server Component — fetch directly
async function ProductPage({ params }: { params: { id: string } }) {
  const product = await db.query.products.findFirst({
    where: eq(products.id, params.id)
  });
  
  if (!product) notFound();
  
  return <ProductDetail product={product} />;
}
```

### Access Backend Resources
```tsx
async function Dashboard() {
  // Direct database access
  const users = await db.select().from(users);
  
  // File system
  const data = await fs.readFile('./data/config.json');
  
  // Environment variables (server-only)
  const apiKey = process.env.API_KEY;
  
  return <UserList users={users} />;
}
```

### Render Client Components as Children
```tsx
// Server Component
export default function Page() {
  return (
    <div>
      <h1>Dashboard</h1>
      <!-- Server-rendered content -->
      <Stats />
      
      <!-- Client Component interleaved -->
      <ClientChart />
    </div>
  );
}
```

## What Server Components Cannot Do

- ❌ `useState`, `useEffect`, `useContext`
- ❌ Event handlers (`onClick`, `onSubmit`)
- ❌ Browser APIs (`window`, `document`, `localStorage`)
- ❌ `useRouter` from next/navigation (use next/navigation in Client Components)

## Patterns

### Interleaving Pattern
```tsx
// Server Component passes data to Client Component
export default async function ProductList() {
  const products = await getProducts();
  
  return (
    <ul>
      {products.map(p => (
        <li key={p.id}>
          <ProductCard product={p} />
        </li>
      ))}
    </ul>
  );
}

// Client Component for interactivity
'use client';
function ProductCard({ product }: { product: Product }) {
  const [isLiked, setIsLiked] = useState(false);
  
  return (
    <div>
      <h3>{product.name}</h3>
      <button onClick={() => setIsLiked(!isLiked)}>
        {isLiked ? '❤️' : '🤍'}
      </button>
    </div>
  );
}
```

### Streaming with Suspense
```tsx
export default function Page() {
  return (
    <>
      <header><Navbar /></header>
      <Suspense fallback={<PostSkeleton />}>
        <PostList />  {/* Slow: streamed when ready */}
      </Suspense>
      <Suspense fallback={<CommentsSkeleton />}>
        <Comments />  {/* Slower: streamed independently */}
      </Suspense>
    </>
  );
}
```

### Caching with React Cache
```tsx
import { cache } from 'react';

const getUser = cache(async (id: string) => {
  return db.query.users.findFirst({ where: eq(users.id, id) });
});

// Called multiple times in component tree, executes once
export default async function Layout({ params }: { params: { userId: string } }) {
  const user = await getUser(params.userId);
  return <div>{user?.name}</div>;
}
```

## Error Handling

```tsx
// error.tsx — Catches errors in Server Components
'use client';

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <div>
      <h2>Something went wrong</h2>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

## Anti-Patterns

- **Over-fetching**: Fetching data the client doesn't need
- **Prop drilling**: Passing data through many Server Component layers — use context in Client Components or fetch closer to usage
- **Mixing concerns**: Server Component that also needs client behavior — split into Server + Client
- **No fallback**: Server Component that takes 5s to load with no loading UI


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
