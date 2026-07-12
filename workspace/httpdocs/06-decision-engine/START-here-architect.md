# Architect Quick Start

## Your Role
Design scalable, maintainable systems that balance short-term velocity with long-term health.

## Essential Reading (in order)

### 1. Context
- `ai-context.md` — Master knowledge map
- `05-execution/prompts/architect.md` — Your role definition

### 2. Decision Framework
- `06-decision-engine/architecture/README.md` — Tech selection
- `06-decision-engine/frontend/README.md` — UI framework decisions
- `06-decision-engine/backend/README.md` — API style decisions
- `06-decision-engine/database/README.md` — Database decisions

### 3. Patterns Catalog
- `07-patterns/service/Solution.md` — Service layer
- `07-patterns/repository/Solution.md` — Data access
- `07-patterns/cache/Solution.md` — Caching strategy
- `07-patterns/queue/Solution.md` — Async processing
- `07-patterns/authentication/Solution.md` — Auth architecture
- `07-patterns/rag/Solution.md` — AI retrieval

### 4. Rules Reference
- `05-execution/rules/nextjs/architecture.md` — Next.js decisions
- `05-execution/rules/postgres/query-planning.md` — Database design
- `05-execution/rules/ai/rag/README.md` — AI integration

### 5. Validation
- `05-execution/checklists/architecture.md` — Pre-deployment checks
- `05-execution/checklists/security.md` — Security review

## Quick Decision Tree

```
New Feature?
├── Frontend-heavy?
│   ├── Next.js App Router? ──▶ rules/nextjs/
│   └── Real-time? ──▶ patterns/cache/ + patterns/webhook/
├── Backend-heavy?
│   ├── API-first? ──▶ patterns/service/ + patterns/repository/
│   └── Background jobs? ──▶ patterns/queue/
├── AI-powered?
│   ├── RAG needed? ──▶ patterns/rag/
│   ├── Agents? ──▶ patterns/agent/
│   └── MCP tools? ──▶ patterns/mcp/
└── Payments?
    ├── Subscriptions? ──▶ rules/stripe/subscriptions.md
    └── Usage-based? ──▶ rules/stripe/usage.md
```

## Your Checklist

Before finalizing any architecture:
- [ ] Problem clearly defined
- [ ] 3+ alternatives considered
- [ ] Trade-offs documented
- [ ] Risk analysis complete
- [ ] Migration path defined
- [ ] Team aligned
