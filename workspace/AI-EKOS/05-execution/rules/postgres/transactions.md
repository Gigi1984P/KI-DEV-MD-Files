# PostgreSQL Transactions

## ACID in Practice

### Atomicity
All operations succeed or all fail. No partial states.

### Consistency
Data remains valid according to defined constraints.

### Isolation
Concurrent transactions don't interfere with each other.

### Durability
Committed transactions survive system crashes.

## Isolation Levels

| Level | Dirty Read | Non-Repeatable | Phantom Read | Use Case |
|-------|-----------|---------------|--------------|----------|
| READ UNCOMMITTED | Possible | Possible | Possible | Rarely used |
| READ COMMITTED | No | Possible | Possible | Default, general purpose |
| REPEATABLE READ | No | No | Possible | Complex reports |
| SERIALIZABLE | No | No | No | Critical financial data |

```sql
-- Set isolation level
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- ... operations ...
COMMIT;
```

## Savepoints

```sql
BEGIN;
INSERT INTO accounts (name) VALUES ('Alice');

SAVEPOINT before_transfer;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

-- Oops, something went wrong
ROLLBACK TO SAVEPOINT before_transfer;

-- Continue with other operations
INSERT INTO audit_log (message) VALUES ('Transfer failed');
COMMIT;
```

## Common Patterns

### Optimistic Locking
```sql
-- Add version column
ALTER TABLE products ADD COLUMN version INTEGER DEFAULT 1;

-- Update with version check
UPDATE products 
SET price = 99.99, version = version + 1
WHERE id = 123 AND version = 5;

-- Check rows affected — if 0, conflict detected
```

### Pessimistic Locking
```sql
BEGIN;
SELECT * FROM inventory WHERE id = 1 FOR UPDATE;
-- Row is locked until commit/rollback
UPDATE inventory SET quantity = quantity - 1 WHERE id = 1;
COMMIT;
```

### Advisory Locks
```sql
-- Application-level locking (no table lock)
SELECT pg_try_advisory_lock(42);

-- Check if lock obtained
SELECT pg_try_advisory_lock_shared(42);

-- Release
SELECT pg_advisory_unlock(42);
```

## Deadlocks

### Prevention Strategies
1. **Consistent ordering**: Always lock tables/resources in the same order
2. **Short transactions**: Keep transactions as brief as possible
3. **Timeouts**: Set `lock_timeout` and `statement_timeout`

```sql
-- Detect deadlocks
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

## Anti-Patterns

- Long-running transactions holding locks
- Transactions that depend on user input
- Not handling serialization failures (retry required)
- Nested transactions without savepoints
- Implicit transactions in loops (batch instead)


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
