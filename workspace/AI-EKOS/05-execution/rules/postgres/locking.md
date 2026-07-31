---
tags:
  - anti-patterns
  - best-practices
  - database
  - performance
  - postgres
  - sql
summary: "PostgreSQL Locking"
read_when:
  - "Implementing postgres features"
  - "Troubleshooting postgres issues"
---

# PostgreSQL Locking

## Lock Types

### Row-Level Locks

| Lock Mode | Conflicts With | Use Case |
|-----------|---------------|----------|
| `FOR UPDATE` | `FOR UPDATE`, `FOR SHARE` | Modify row |
| `FOR SHARE` | `FOR UPDATE` | Read but prevent modification |
| `FOR NO KEY UPDATE` | `FOR UPDATE` | Update non-key columns |
| `FOR KEY SHARE` | `FOR UPDATE` | Foreign key checks |

```sql
-- Pessimistic locking
BEGIN;
SELECT * FROM inventory WHERE id = 1 FOR UPDATE;
UPDATE inventory SET quantity = quantity - 1 WHERE id = 1;
COMMIT;
```

### Table-Level Locks

| Lock Mode | Conflicts With | Use Case |
|-----------|---------------|----------|
| `ACCESS EXCLUSIVE` | All | `DROP TABLE`, `ALTER TABLE` |
| `ACCESS SHARE` | `ACCESS EXCLUSIVE` | `SELECT` |
| `ROW SHARE` | `EXCLUSIVE`, `ACCESS EXCLUSIVE` | `SELECT FOR UPDATE` |
| `SHARE` | `ROW EXCLUSIVE`, `EXCLUSIVE` | `CREATE INDEX` |

## Lock Monitoring

```sql
-- Active locks
SELECT 
  l.locktype,
  l.relation::regclass,
  l.mode,
  l.granted,
  a.usename,
  a.query,
  a.pid
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;

-- Deadlock detection
SELECT 
  blocked_locks.pid AS blocked_pid,
  blocked_activity.usename AS blocked_user,
  blocking_locks.pid AS blocking_pid,
  blocking_activity.usename AS blocking_user
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE blocking_locks.pid != blocked_locks.pid;
```

## Strategies

### Optimistic Locking
```sql
ALTER TABLE products ADD COLUMN version INTEGER DEFAULT 1;

UPDATE products 
SET name = 'New Name', version = version + 1
WHERE id = 1 AND version = 5;

-- Check rows affected. If 0, conflict detected.
```

### Advisory Locks
```sql
-- Application-level locking
SELECT pg_try_advisory_lock(42);  -- Returns true/false

-- Release
SELECT pg_advisory_unlock(42);
```

## Anti-Patterns

- Long transactions holding locks
- Not handling lock timeouts
- Missing deadlock detection
- Over-locking (table lock when row lock suffices)


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
