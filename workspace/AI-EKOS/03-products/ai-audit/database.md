---
tags:
  - product
  - ai-audit
  - database
  - schema
summary: "Database Schema: KI-System Audit & Compliance Platform Data Model"
read_when:
  - "Database design for ai-audit"
  - "Writing migrations"
  - "Data privacy reviews"
---

# Database: KI-System Audit & Compliance Platform

## Schema-Übersicht

- **users** (id, email, name, created_at)
- **workspaces** (id, name, owner_id, plan, created_at)
- **ai-audit_resources** (id, workspace_id, name, config, created_at, updated_at)

## Indizes

- `idx_ai-audit_resources_workspace_id` auf `workspace_id`
- `idx_ai-audit_resources_created_at` auf `created_at` ( für Time-Range Queries)

## Migrations

- Format: SQL (Plain SQL in `migrations/` Verzeichnis)
- Naming: `YYYYMMDDHHMMSS_description.sql`
- Rollback: Separate `YYYYMMDDHHMMSS_description.down.sql` Datei
- Tool: `node-pg-migrate` oder `drizzle-kit`

## Data Privacy (GDPR)

- **Personenbezogene Daten**: users.email, users.name
- **Löschung**: Soft Delete mit `deleted_at`, permanent nach 30 Tagen
- **Export**: JSON-Export aller User-Daten auf Anfrage (Art. 20 GDPR)
