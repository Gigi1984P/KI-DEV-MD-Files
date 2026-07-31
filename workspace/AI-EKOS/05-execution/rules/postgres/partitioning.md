---
tags:
  - anti-patterns
  - best-practices
  - database
  - performance
  - postgres
  - sql
summary: "PostgreSQL Partitioning"
read_when:
  - "Implementing postgres features"
  - "Troubleshooting postgres issues"
---

# PostgreSQL Partitioning

## Overview
Partitioning splits large tables into smaller, manageable pieces. Improves query performance and maintenance.

## Range Partitioning

```sql
-- Create partitioned table
CREATE TABLE events (
    id UUID DEFAULT gen_random_uuid(),
    created_at TIMESTAMP NOT NULL,
    user_id UUID NOT NULL,
    event_type VARCHAR(50),
    data JSONB,
    PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

-- Create partitions
CREATE TABLE events_2024q1 PARTITION OF events
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE events_2024q2 PARTITION OF events
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

-- Indexes on partitions
CREATE INDEX idx_events_2024q1_user ON events_2024q1(user_id);
CREATE INDEX idx_events_2024q1_type ON events_2024q1(event_type);
```

## Automatic Partitioning

```sql
-- Function to create partitions automatically
CREATE OR REPLACE FUNCTION create_monthly_partition()
RETURNS TRIGGER AS $$
DECLARE
    partition_date DATE;
    partition_name TEXT;
    start_date DATE;
    end_date DATE;
BEGIN
    partition_date := DATE_TRUNC('month', NEW.created_at);
    partition_name := 'events_' || TO_CHAR(partition_date, 'YYYY_MM');
    start_date := partition_date;
    end_date := partition_date + INTERVAL '1 month';
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_tables 
        WHERE tablename = partition_name
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF events FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            start_date,
            end_date
        );
        
        -- Create indexes
        EXECUTE format(
            'CREATE INDEX idx_%s_user ON %I(user_id)',
            partition_name,
            partition_name
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_partition
    BEFORE INSERT ON events
    FOR EACH ROW
    EXECUTE FUNCTION create_monthly_partition();
```

## Partition Maintenance

```sql
-- Detach old partition
ALTER TABLE events DETACH PARTITION events_2023q1;

-- Archive old data
CREATE TABLE events_2023q1_archive AS 
SELECT * FROM events_2023q1;

-- Drop old partition
DROP TABLE events_2023q1;

-- Vacuum parent table
VACUUM ANALYZE events;
```

## Query Optimization

```sql
-- Partition pruning: Only scans relevant partitions
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM events 
WHERE created_at BETWEEN '2024-01-01' AND '2024-01-31';
-- Output: Only scans events_2024_01 partition
```

## Monitoring

```sql
-- Check partition sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE tablename LIKE 'events_%'
ORDER BY tablename;
```

## Anti-Patterns

- Too many partitions (>1000)
- No indexes on partitions
- Not archiving old partitions
- Queries without partition key in WHERE


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
