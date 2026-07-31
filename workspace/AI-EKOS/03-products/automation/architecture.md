---
tags:
  - product
  - automation
  - architecture
  - system-design
summary: "System Architecture: No-Code Business Process Automation"
read_when:
  - "Designing automation components"
  - "Infrastructure planning"
  - "Security reviews"
---

# Architecture: No-Code Business Process Automation

## Tech Stack

- **Frontend**: Next.js 14+ (App Router, RSC)
- **Backend**: Fastify (Node.js 20+)
- **Datenbank**: PostgreSQL 15+ (Supabase oder RDS)
- **Cache/Queue**: Redis 7+ (BullMQ für Jobs)
- **AI**: claude-haiku-4 (schnell/günstig)
- **Storage**: S3-kompatibel (AWS S3 oder Minio)

## Sicherheit

- API Keys: SHA-256 gehasht, Prefix `sk_`
- Secrets: AWS Secrets Manager / Doppler, nie im Code
- Audit Logging: Jede Aktion mit User-ID + Timestamp
- GDPR: EU-Region Deployment Option

## Monitoring

- **Metrics**: Prometheus + Grafana
- **Error Tracking**: Sentry
- **APM**: OpenTelemetry Tracing
- **Alerts**: PagerDuty bei kritischen Fehlern (p95 latency > 2s, error rate > 5%)
