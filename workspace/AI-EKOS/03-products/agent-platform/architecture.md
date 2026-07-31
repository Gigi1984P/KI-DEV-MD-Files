---
tags:
  - product
  - agent-platform
  - architecture
  - system-design
summary: "System Architecture: Multi-Tenant Agent Platform"
read_when:
  - "Designing system components"
  - "Scaling agent-platform"
  - "Security reviews"
---

# Architecture: Agent Platform

## High-Level

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Next.js   │────▶│   Fastify    │────▶│   PostgreSQL    │
│   (UI)      │     │   (API)      │     │   (Metadata)    │
└─────────────┘     └──────────────┘     └─────────────────┘
                            │
                            ▼
                    ┌──────────────┐
                    │   Agent      │
                    │   Runtime    │
                    │   (Worker)   │
                    └──────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
  ┌──────────┐      ┌──────────┐        ┌──────────┐
  │  Redis   │      │  S3/Minio │        │  LLM     │
  │ (Queue)  │      │ (Traces) │        │ Providers│
  └──────────┘      └──────────┘        └──────────┘
```

---

## Komponenten

### 1. Next.js Frontend

- **App Router** mit React Server Components
- **Real-time Updates** über Server-Sent Events (kein WebSocket nötig für Runs)
- **Feature Flags**: PostHog für A/B Testing von UI-Änderungen
- **i18n**: next-intl (Deutsch/Englisch)

### 2. Fastify API Layer

- **REST + Webhooks** (kein GraphQL — Overkill für interne API)
- **Auth**: JWT (15min) + Refresh Token (30d, Redis)
- **Rate Limiting**: Bucket pro API Key (Redis-Backed)
- **Validation**: Zod Schemas (shared mit Frontend via Monorepo)

### 3. Agent Runtime

- **Isolated Execution**: Jeder Run in eigenem Node.js Worker Thread
- **Timeout**: 5min default, 15min max (konfigurierbar)
- **Sandboxing**: 
  - Kein `fs` Zugriff außer `/tmp/run-{id}/`
  - Kein `net` außer whitelistete Domains (Skill-Config)
  - Memory Limit: 512MB pro Run
- **Retry Policy**: Exponentielles Backoff bei Skill-Failures (max 3x)

### 4. PostgreSQL (Metadata)

**Tabellen**:
- `agents` (id, workspace_id, name, prompt, skills, config, version, created_by)
- `agent_versions` (id, agent_id, version, prompt, config, deployed_at)
- `runs` (id, agent_id, status, input, output, error, cost_usd, tokens, duration_ms, created_at)
- `workspaces` (id, name, plan, api_keys, settings)
- `skills` (id, name, version, schema, is_marketplace)
- `webhooks` (id, workspace_id, url, events, secret)

**Partitioning**: `runs` nach `created_at` (monthly partitions) — ältere Runs in S3 archiviert.

### 5. Redis (Queue + State)

- **Queue**: BullMQ für Run-Scheduling (Prioritäten: high, default, low)
- **State**: Session-Context für Stateful Agents (Conversation Memory)
- **Cache**: Agent Config (5min TTL), Skill Registry (1h TTL)

### 6. Object Storage (Traces)

- **S3-kompatibel** (AWS S3 oder Minio self-hosted)
- **Trace Format**: JSONL — eine Zeile pro Event (LLM Call, Skill Call, Error)
- **Retention**: 90 Tage hot, dann Glacier (oder Minio Lifecycle Policy)

---

## Sicherheit

### API Security

- **API Keys**: SHA-256 gehasht in DB, Prefix `sk_live_` / `sk_test_`
- **Secrets**: In AWS Secrets Manager / Doppler, nie in Code/DB plaintext
- **Rotation**: API Keys automatisch alle 90 Tage rotiert (alte bleiben 7d gültig)

### Runtime Security

- **Prompt Injection**: Input Sanitization (LLM Guardrails: keine PII in Logs, Blocklist für System-Prompts)
- **Skill Permissions**: Jeder Skill definiert eigene Permissions (z.B. `crm.read`, `crm.write`)
- **Audit Log**: Jeder Run mit User-ID + IP (compliance)

### Data Privacy

- **GDPR**: EU Region deployment option (Frankfurt)
- **Data Residency**: Workspace-Level (US/EU) konfigurierbar
- **Deletion**: Workspace-Deletion löscht alle Runs + Traces (async Job, 30d Backup dann permanent)

---

## Skalierung

| Komponente | Skalierungsstrategie | Bottleneck |
|---|---|---|
| Frontend | Vercel Edge Network | — |
| API | Horizontal (mehr Pods) | DB Connections (Pool: max 100) |
| Runtime | Horizontal (Worker Autoscaler) | LLM Rate Limits |
| PostgreSQL | Read Replicas + Partitioning | Writes (batched inserts) |
| Redis | Cluster Mode (3 Nodes) | Memory |
| Queue | BullMQ mit Redis Cluster | — |

**Kritische Metriken**:
- Queue Depth > 1000 → Alert
- Runtime CPU > 80% → Autoscale
- DB Connections > 80% → Alert
- LLM API Errors > 5% → Fallback Model

---

## Deployment

- **Frontend**: Vercel
- **API + Runtime**: Fly.io (EU Region) oder AWS ECS
- **PostgreSQL**: Supabase (managed) oder AWS RDS
- **Redis**: Upstash (managed) oder AWS ElastiCache
- **S3**: AWS S3 + CloudFront für Traces

**Environments**: `development`, `staging`, `production` (identische Config, nur andere Secrets)
