# PostgreSQL Multi-Tenancy

## Strategies

### 1. Row-Level Security (RLS) - Recommended

```sql
-- Enable RLS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY tenant_isolation ON orders
  USING (tenant_id = current_setting('app.current_tenant')::UUID);

-- Set tenant in application
SET LOCAL app.current_tenant = 'tenant-uuid';
```

**Pros:** Single database, simple backup, cross-tenant analytics possible
**Cons:** Complex policies, potential leakage risk

### 2. Schema Per Tenant

```sql
-- Each tenant gets their own schema
CREATE SCHEMA tenant_1;
CREATE TABLE tenant_1.orders (...);

CREATE SCHEMA tenant_2;
CREATE TABLE tenant_2.orders (...);
```

**Pros:** Strong isolation, easy single-tenant migration
**Cons:** Schema proliferation, harder migrations

### 3. Database Per Tenant

```sql
-- Each tenant gets their own database
CREATE DATABASE tenant_1;
CREATE DATABASE tenant_2;
```

**Pros:** Maximum isolation, independent scaling
**Cons:** Connection pool complexity, expensive backups

## Implementation: RLS

```typescript
// lib/db.ts
import { drizzle } from 'drizzle-orm/postgres-js';

export async function withTenant(tenantId: string, fn: () => Promise<any>) {
  await db.execute(`SET LOCAL app.current_tenant = '${tenantId}'`);
  try {
    return await fn();
  } finally {
    await db.execute('SET LOCAL app.current_tenant = NULL');
  }
}

// Usage
const orders = await withTenant(tenantId, async () => {
  return db.select().from(orders);
});
```

## Tenant Identification

```typescript
// middleware.ts
export async function middleware(request: NextRequest) {
  const subdomain = request.headers.get('host')?.split('.')[0];
  const tenant = await getTenantBySubdomain(subdomain);
  
  request.headers.set('x-tenant-id', tenant.id);
  return NextResponse.next({ request });
}
```

## Performance

- **Indexes**: Always include `tenant_id` in composite indexes
- **Partitioning**: Partition by `tenant_id` for very large tenants
- **Query Planning**: RLS adds overhead — test with realistic data

## Anti-Patterns

- Missing RLS policies (tenant data leaks)
- Hardcoding tenant IDs in queries
- Not testing RLS policies
- Sharing connection pools without tenant context


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
