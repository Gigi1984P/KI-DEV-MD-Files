---
tags:
  - product
  - agent-platform
  - saas
  - multi-tenant
summary: "Vision: Multi-Tenant AI Agent Platform für Enterprise-Kunden"
read_when:
  - "Product planning for agent-platform"
  - "Stakeholder communication"
  - "Feature prioritization"
---

# Vision: AI Agent Platform

## Problem

Enterprises können ihre wiederholbaren Wissensarbeits-Prozesse nicht skalieren, weil:
- Jeder Prozess manuelles Routing, Kontext-Sammlung und Follow-up erfordert
- Bestehende Automation-Tools (Zapier, Make) keine echte Reasoning-Fähigkeit haben
- Custom-Lösungen pro Use-Case entwickelt werden müssen → keine Wiederverwendbarkeit

## Ziel

Eine Plattform, wo jeder Entwickler/Consultant in <1 Stunde einen produktiven AI-Agenten für einen spezifischen Business-Prozess deployen kann — ohne Machine-Learning-Kenntnisse.

## Kern-Differenzierung

| Feature | Wir | Konkurrenz (LangChain, n8n) |
|---|---|---|
| Deployment | One-Click Production | Self-Hosted DIY |
| Observability | Trace + Replay eingebaut | Logging selbst bauen |
| Business Metriken | ROI Dashboard pro Agent | Keine Business Layer |
| Compliance | EU AI Act ready (Dokumentation) | Keine Compliance Tools |

## Zielgruppe

- **Primär**: Mittelständische Unternehmen (50-500 Mitarbeiter) mit wiederkehrenden Support/Backoffice-Prozessen
- **Sekundär**: AI-Agenturen, die für Kunden deployen (White-Label)

## Success Metrics (KPIs)

- Time-to-Production: < 1 Stunde (vs. 2 Wochen DIY)
- Agent Success Rate: > 95% (Task completion ohne menschliche Eskalation)
- Platform NRR: > 120% (Expansion durch neue Agents)

## Phase 1 Scope (MVP)

- Agent Builder (UI): Prompt + Tool-Konfiguration
- 5 Production-Ready Skills: Email, Database, HTTP, File, Calendar
- Tracing Dashboard: Jeder Agent-Run mit Input/Output/Token/Cost
- Multi-Tenant: Isolierung pro Workspace

## Phase 2 Scope

- Agent Marketplace (Community Agents)
- A/B Testing für Prompts
- On-Prem Deployment Option
- EU AI Act Conformity Package (Dokumentation + Risk Assessment)
