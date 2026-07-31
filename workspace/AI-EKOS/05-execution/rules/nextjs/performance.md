---
tags:
  - anti-patterns
  - best-practices
  - nextjs
  - performance
  - react
summary: "Next.js Performance"
read_when:
  - "Implementing nextjs features"
  - "Troubleshooting nextjs issues"
---

# Next.js Performance

## Core Web Vitals Targets

| Metric | Target | Poor |
|--------|--------|------|
| **LCP** (Largest Contentful Paint) | ≤2.5s | >4s |
| **INP** (Interaction to Next Paint) | ≤200ms | >500ms |
| **CLS** (Cumulative Layout Shift) | ≤0.1 | >0.25 |
| **TTFB** (Time to First Byte) | ≤600ms | >1s |

## Image Optimization

```tsx
import Image from 'next/image';

// Prioritize above-the-fold
<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority
  placeholder="blur"
  blurDataURL="data:image/jpeg;base64,..."
/>

// Lazy load below-the-fold
<Image
  src="/gallery.jpg"
  alt="Gallery"
  width={800}
  height={600}
  loading="lazy"
/>
```

## Font Optimization

```tsx
// app/layout.tsx
import { Inter } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  display: 'swap', // Prevent FOIT
  preload: true,
});

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={inter.className}>
      <body>{children}</body>
    </html>
  );
}
```

## Code Splitting

### Dynamic Imports
```tsx
import { Suspense } from 'react';
import dynamic from 'next/dynamic';

const HeavyChart = dynamic(() => import('./HeavyChart'), {
  loading: () => <ChartSkeleton />,
  ssr: false, // Only client-side
});

export default function Dashboard() {
  return (
    <Suspense fallback={<ChartSkeleton />}>
      <HeavyChart />
    </Suspense>
  );
}
```

## Data Fetching Optimization

### Parallel Fetching
```tsx
export default async function Dashboard() {
  const [user, orders, analytics] = await Promise.all([
    getUser(),
    getOrders(),
    getAnalytics(),
  ]);
  return <Dashboard {...{ user, orders, analytics }} />;
}
```

### Streaming
```tsx
export default function Page() {
  return (
    <>
      <Suspense fallback={<SlowSkeleton />}>
        <SlowComponent />
      </Suspense>
      <FastComponent />
    </>
  );
}
```

## Bundle Size

### Analyze Bundle
```bash
npm install -D @next/bundle-analyzer
```

```js
// next.config.js
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

module.exports = withBundleAnalyzer({
  // config
});
```

### Reduce Dependencies
- Use `lodash-es` instead of `lodash`
- Import specific functions: `import { debounce } from 'lodash-es'`
- Tree-shake unused code

## Anti-Patterns
- Large inline scripts blocking render
- Unoptimized images
- Synchronous data fetching in loops
- No loading states for async content


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
