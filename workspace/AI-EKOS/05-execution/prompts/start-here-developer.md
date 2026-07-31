# Developer Quick Start

## Your Role
Build production-grade features that are clean, tested, and maintainable.

## Essential Reading (in order)

### 1. Setup
- `ai-context.md` — Master knowledge map
- `05-execution/prompts/developer.md` — Your role definition

### 2. Technology Stack
- `05-execution/rules/nextjs/` — Next.js standards
  - `architecture.md` — App Router vs Pages Router
  - `server-components.md` — When to use Server Components
  - `server-actions.md` — Form handling and mutations
  - `patterns.md` — Common patterns
- `05-execution/rules/postgres/` — Database standards
  - `indexes.md` — Index strategies
  - `transactions.md` — Transaction handling
  - `query-planning.md` — Performance optimization

### 3. Working with AI
- `05-execution/rules/ai/prompt-engineering/README.md` — Prompt design
- `05-execution/rules/ai/rag/README.md` — RAG implementation
- `05-execution/rules/ai/agents/README.md` — Agent development

### 4. Validation
- `05-execution/checklists/code-review.md` — Before submitting code
- `05-execution/checklists/security.md` — Security checks
- `05-execution/checklists/performance.md` — Performance checks

## Quick Workflow

```
New Feature?
├── UI component? ──▶ rules/nextjs/server-components.md
├── Form? ──▶ rules/nextjs/server-actions.md
├── API endpoint? ──▶ patterns/service/ + patterns/repository/
├── Database change? ──▶ rules/postgres/indexes.md
├── Auth? ──▶ patterns/authentication/ + patterns/authorization/
├── AI feature? ──▶ rules/ai/rag/ + rules/ai/agents/
└── Payment? ──▶ rules/stripe/
```

## Your Checklist

Before submitting PR:
- [ ] TypeScript strict mode passes
- [ ] Tests written (happy path + edge cases)
- [ ] Error handling implemented
- [ ] Loading states added
- [ ] No console.logs or debug code
- [ ] Cross-browser tested
- [ ] Accessibility checked
