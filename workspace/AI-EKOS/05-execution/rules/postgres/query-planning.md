---
tags:
  - anti-patterns
  - best-practices
  - database
  - performance
  - postgres
  - sql
summary: "PostgreSQL Query Planning"
read_when:
  - "Implementing postgres features"
  - "Troubleshooting postgres issues"
---

# PostgreSQL Query Planning

## EXPLAIN ANALYZE

### Basic Usage
```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT u.name, COUNT(o.id)
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at > '2024-01-01'
GROUP BY u.name
ORDER BY COUNT(o.id) DESC
LIMIT 10;
```

### Output Interpretation
```
Limit  (cost=1000.00..1000.10 rows=10 width=20) (actual time=10.234..10.245 rows=10 loops=1)
  -> Sort  (cost=1000.00..1050.00 rows=5000 width=20) (actual time=10.200..10.220 rows=10 loops=1)
        Sort Key: (count(o.id)) DESC
        Sort Method: top-N heapsort  Memory: 25kB
        -> GroupAggregate  (cost=500.00..800.00 rows=5000 width=20) (actual time=5.100..8.900 rows=5000 loops=1)
              Group Key: u.name
              -> Nested Loop Left Join  (cost=100.00..400.00 rows=10000 width=20) (actual time=0.800..3.200 rows=10000 loops=1)
                    -> Seq Scan on users u  (cost=0.00..50.00 rows=5000 width=20) (actual time=0.200..0.500 rows=5000 loops=1)
                          Filter: (created_at > '2024-01-01'::date)
                          Rows Removed by Filter: 1000
                    -> Index Scan using orders_user_id_idx on orders o  (cost=0.42..0.06 rows=2 width=8) (actual time=0.000..0.000 rows=2 loops=5000)
                          Index Cond: (user_id = u.id)
Planning Time: 0.500 ms
Execution Time: 10.500 ms
```

### Key Metrics

| Metric | Meaning | Target |
|--------|---------|--------|
| `cost` | Planner's estimated cost | Lower is better |
| `actual time` | Real execution time | Lower is better |
| `rows` | Estimated vs actual rows | Should be close |
| `loops` | How many times node executed | 1 = ideal |
| `Buffers: shared hit/read` | Cache efficiency | High hit = good |

## Common Plan Nodes

### Sequential Scan
```
Seq Scan on users  (cost=0.00..50.00 rows=5000 width=20)
```
- Reads entire table
- OK for small tables (<1000 rows)
- **Fix**: Add index if filtering large tables

### Index Scan
```
Index Scan using users_email_idx  (cost=0.42..8.50 rows=1 width=20)
```
- Uses index to find rows, then fetches table data
- Good for selective queries returning few rows

### Index Only Scan
```
Index Only Scan using users_email_idx  (cost=0.42..4.20 rows=1 width=20)
```
- All data in index, no table access
- Fastest option — requires covering index

### Bitmap Index Scan
```
Bitmap Index Scan on users_status_idx
Bitmap Heap Scan on users
```
- Collects row IDs from index, sorts, then accesses table in batch
- Good for moderate selectivity

### Nested Loop Join
```
Nested Loop  (cost=0.42..100.00 rows=100 width=40)
```
- For each row in outer table, scan inner table
- Good when outer table is small and inner has index

### Hash Join
```
Hash Join  (cost=50.00..150.00 rows=1000 width=40)
```
- Build hash table from smaller table, probe with larger
- Good for large datasets without index

### Merge Join
```
Merge Join  (cost=100.00..200.00 rows=1000 width=40)
```
- Both tables sorted, merged like merge sort
- Good when both tables are sorted or can be sorted efficiently

## Optimization Strategies

### 1. Add Missing Indexes
```sql
-- Find sequential scans on large tables
SELECT 
  schemaname,
  relname AS table,
  seq_scan,
  seq_tup_read,
  idx_scan,
  n_live_tup AS estimated_rows
FROM pg_stat_user_tables
WHERE seq_scan > 0 
  AND n_live_tup > 10000
ORDER BY seq_tup_read DESC;
```

### 2. Fix Inefficient Queries
```sql
-- ❌ OR conditions prevent index usage
WHERE status = 'active' OR status = 'pending'

-- ✅ Use IN or UNION
WHERE status IN ('active', 'pending')

-- ❌ Functions on columns prevent index usage
WHERE YEAR(created_at) = 2024

-- ✅ Range query
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'

-- ❌ Leading wildcard prevents index
WHERE email LIKE '%@gmail.com'

-- ✅ Trailing wildcard
WHERE email LIKE 'user@%'
```

### 3. Analyze and Vacuum
```sql
-- Update statistics for query planner
ANALYZE users;

-- Reclaim space and update visibility map
VACUUM ANALYZE users;

-- Full vacuum (locks table)
VACUUM FULL users;
```

### 4. Partition Large Tables
```sql
CREATE TABLE events (
    id SERIAL,
    created_at TIMESTAMP,
    data JSONB
) PARTITION BY RANGE (created_at);

CREATE TABLE events_2024_q1 PARTITION OF events
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
```

## Anti-Patterns

- Not running ANALYZE after bulk loads
- Using `SELECT *` when only few columns needed
- Missing `LIMIT` on large result sets
- Joining without indexes on join keys
- Using `OFFSET` for pagination (use cursor/keyset pagination)


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
