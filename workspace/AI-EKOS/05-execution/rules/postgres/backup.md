---
tags:
  - anti-patterns
  - best-practices
  - database
  - performance
  - postgres
  - sql
summary: "PostgreSQL Backup Strategies"
read_when:
  - "Implementing postgres features"
  - "Troubleshooting postgres issues"
---

# PostgreSQL Backup Strategies

## pg_dump (Logical Backups)

### Full Database
```bash
pg_dump -h localhost -U postgres -d mydb --format=custom --file=mydb-$(date +%Y%m%d).dump
```

### Specific Tables
```bash
pg_dump -h localhost -U postgres -d mydb --table=users --table=orders --file=users-orders.dump
```

### Compression
```bash
pg_dump -h localhost -U postgres -d mydb | gzip > mydb-$(date +%Y%m%d).sql.gz
```

## Continuous Archiving (WAL)

### Configuration
```ini
# postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'cp %p /backups/wal/%f'
archive_timeout = 300
```

### Point-in-Time Recovery
```bash
# Restore base backup
pg_basebackup -h localhost -D /backups/base

# Restore WAL
# Recovery targets specific point in time
```

## Automated Backups

### pgBackRest
```bash
# Full backup weekly, incremental daily
pgbackrest --stanza=mydb backup --type=full
pgbackrest --stanza=mydb backup --type=incr
```

### Cron Job
```bash
# Daily backup at 2 AM
0 2 * * * pg_dump mydb | gzip > /backups/mydb-$(date +\%Y\%m\%d).sql.gz

# Cleanup old backups (keep 7 days)
0 3 * * * find /backups -name "*.gz" -mtime +7 -delete
```

## Restore Procedures

### From pg_dump
```bash
# Create database first
createdb mydb_restore

# Restore
pg_restore -d mydb_restore mydb-20240115.dump

# Or with psql for plain SQL
psql -d mydb_restore < mydb-20240115.sql
```

### Verification
```sql
-- After restore, verify row counts
SELECT schemaname, relname, n_live_tup
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
```

## Anti-Patterns
- No backup verification (restore untested)
- Single backup location
- No encryption for sensitive data
- Missing WAL archiving for point-in-time recovery


## Related
- `05-execution/rules/postgres/query-planning.md` — Query optimization
- `05-execution/rules/postgres/indexes.md` — Index strategies
- `05-execution/checklists/performance.md` — Performance checklist
- `07-patterns/repository/` — Repository patterns
