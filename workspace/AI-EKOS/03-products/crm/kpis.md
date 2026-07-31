---
tags:
  - product
  - crm
  - kpis
  - metrics
summary: "KPIs: AI-Native CRM Platform Success Metrics"
read_when:
  - "Quarterly business reviews"
  - "Investor updates"
  - "Product performance analysis"
---

# KPIs: AI-Native CRM Platform

## Business KPIs

| KPI | Definition | Ziel | Messung |
|-----|-----------|------|---------|
| ARR | Annual Recurring Revenue | €500k Year 1 | Stripe + Contracts |
| MRR Growth | Month-over-Month | >10% | (MRR_t - MRR_t-1) / MRR_t-1 |
| NRR | Net Revenue Retention | >120% | (MRR_start + Expansion - Churn) / MRR_start |
| CAC | Customer Acquisition Cost | <€5.000 | Marketing + Sales / New Customers |
| LTV | Lifetime Value | >€50.000 | ARPU × Gross Margin × Lifetime (months) |

## Product KPIs

| KPI | Definition | Ziel | Messung |
|-----|-----------|------|---------|
| MAU | Monthly Active Users | >500 | Workspace-Members mit Login letzte 30d |
| WAU/MAU | Ratio of Weekly to Monthly Actives | >60% | Stickiness |
| Time-to-Value | Zeit bis erstem erfolgreichem Use | <1 Stunde | Onboarding-Analytics |
| Feature Adoption | % Nutzer, die Feature X mindestens 1x/Woche nutzen | >40% | PostHog Feature Flags |

## Technical KPIs

| KPI | Definition | Ziel | Messung |
|-----|-----------|------|---------|
| Uptime | Verfügbarkeit | >99.9% | Pingdom / UptimeRobot |
| p95 Latency | API Response Time | <500ms | APM (OpenTelemetry) |
| Error Rate | 5xx Errors / Total Requests | <0.5% | API Gateway Logs |
| MTTR | Mean Time To Recovery | <30min | Incident-Tracking |
