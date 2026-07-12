# PostgreSQL Performance

## Query Optimization

### EXPLAIN ANALYZE Deep Dive

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at > '2024-01-01'
GROUP BY u.name
HAVING COUNT(o.id) > 5
ORDER BY order_count DESC
LIMIT 10;
```

### Index Strategies

```sql
-- Composite index for filtered aggregations
CREATE INDEX idx_users_created_orders 
ON users(created_at) 
INCLUDE (name)
WHERE active = true;

-- Partial index for hot queries
CREATE INDEX idx_orders_recent 
ON orders(user_id, created_at)
WHERE status = 'pending';

-- Covering index (index-only scan)
CREATE INDEX idx_orders_covering 
ON orders(user_id, status, total)
INCLUDE (created_at);
```

### Partitioning

```sql
-- Range partitioning for time-series data
CREATE TABLE events (
    id UUID DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    data JSONB
) PARTITION BY RANGE (created_at);

-- Create partitions
CREATE TABLE events_2024q1 PARTITION OF events
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE events_2024q2 PARTITION OF events
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

-- Automatic partition creation with trigger
CREATE OR REPLACE FUNCTION create_event_partition()
RETURNS TRIGGER AS $$
DECLARE
    partition_date DATE;
    partition_name TEXT;
BEGIN
    partition_date := DATE_TRUNC('month', NEW.created_at);
    partition_name := 'events_' || TO_CHAR(partition_date, 'YYYY_MM');
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_tables 
        WHERE tablename = partition_name
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF events FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            partition_date,
            partition_date + INTERVAL '1 month'
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

## Connection Pooling

```typescript
// lib/db.ts
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,                    // Maximum connections
  idleTimeoutMillis: 30000,   // Close idle connections after 30s
  connectionTimeoutMillis: 2000, // Timeout after 2s
});

// Health check
export async function checkDatabaseHealth() {
  const client = await pool.connect();
  try {
    const start = Date.now();
    await client.query('SELECT 1');
    return { healthy: true, latency: Date.now() - start };
  } catch (error) {
    return { healthy: false, error };
  } finally {
    client.release();
  }
}
```

## Monitoring

```sql
-- Slow query log
SELECT 
  query,
  calls,
  total_exec_time,
  mean_exec_time,
  rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;

-- Table bloat
SELECT 
  schemaname,
  relname,
  n_live_tup,
  n_dead_tup,
  ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_pct
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;
```

## Anti-Patterns

- No connection pooling (connection exhaustion)
- Missing WHERE clause on large tables
- Functions on indexed columns (prevents index usage)
- Not vacuuming/autovacuum tuned


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
