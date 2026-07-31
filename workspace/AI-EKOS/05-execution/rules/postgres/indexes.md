---
tags:
  - anti-patterns
  - best-practices
  - database
  - performance
  - postgres
  - sql
summary: "PostgreSQL Index Strategies"
read_when:
  - "Implementing postgres features"
  - "Troubleshooting postgres issues"
---

# PostgreSQL Index Strategies

## Index Types

### B-Tree (Default)
```sql
CREATE INDEX idx_users_email ON users(email);
```
- Equality, range queries
- `=`, `<`, `>`, `BETWEEN`, `LIKE 'text%'`

### Hash
```sql
CREATE INDEX idx_users_api_key ON users USING HASH(api_key);
```
- Equality only: `=`
- Faster lookups for exact matches

### GiST (Generalized Search Tree)
```sql
CREATE INDEX idx_locations ON locations USING GiST(latlng);
```
- Geospatial data
- Nearest-neighbor queries

### GIN (Generalized Inverted Index)
```sql
CREATE INDEX idx_posts_tags ON posts USING GIN(tags);
CREATE INDEX idx_docs ON docs USING GIN(to_tsvector('english', content));
```
- Arrays, JSONB, full-text search
- `jsonb ? 'key'`, `@>`, `<@`, `@?`, `@@`

### BRIN (Block Range INdex)
```sql
CREATE INDEX idx_events_created ON events USING BRIN(created_at);
```
- Large tables with ordered insertions
- Low maintenance overhead

## Composite Index Strategy

### Column Ordering
```sql
-- For queries like: WHERE status = 'active' AND created_at > '2024-01-01'
CREATE INDEX idx_orders_status_created ON orders(status, created_at);
```

**Rule**: Order columns by selectivity (most selective first) for equality filters. For range queries, put range column last.

### Partial Indexes
```sql
-- Only index active users (saves space, speeds up hot queries)
CREATE INDEX idx_users_active ON users(email) WHERE active = true;
```

## Index Maintenance

### Monitor Unused Indexes
```sql
SELECT 
  schemaname,
  relname AS table,
  indexrelname AS index,
  idx_scan AS scans
FROM pg_stat_user_indexes
WHERE idx_scan = 0;
```

### Index Bloat Detection
```sql
SELECT 
  schemaname,
  relname,
  indexrelname,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
  idx_scan
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Reindex Strategy
```sql
-- Concurrent reindex (no locks)
REINDEX INDEX CONCURRENTLY idx_users_email;
```

## Performance Checklist

- [ ] Index foreign key columns
- [ ] Index columns in WHERE, JOIN, ORDER BY
- [ ] Use covering indexes for hot queries
- [ ] Consider partial indexes for filtered queries
- [ ] Monitor index usage with `pg_stat_user_indexes`
- [ ] Remove unused indexes
- [ ] Use `EXPLAIN ANALYZE` to verify index usage

## Anti-Patterns

- Indexing low-cardinality columns alone (e.g., boolean)
- Too many indexes on write-heavy tables
- Ignoring index-only scans opportunity
- Not using `CONCURRENTLY` for reindex on production


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
