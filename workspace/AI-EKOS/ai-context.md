---
summary: "AI Kontext und Agent-Konfiguration"
---

# AI Context

## AI Engineering Knowledge Operating System (AI-EKOS)

This file provides the global context for all AI agents working with this repository.

## System Architecture

AI-EKOS is organized into 9 phases:

| Phase | Directory | Purpose |
|-------|-----------|---------|
| 1 | `01-foundation/` | Identity, principles, governance |
| 2 | `02-platform/` | Technical platform documentation |
| 3 | `03-products/` | Product specifications |
| 4 | `04-playbooks/` | Operational procedures |
| 5 | `05-execution/` | Prompts, rules, templates, examples, checklists |
| 6 | `06-decision-engine/` | Decision trees and frameworks |
| 7 | `07-patterns/` | Enterprise pattern catalog |
| 8 | `08-recipes/` | Step-by-step build recipes |
| 9 | `09-boilerplates/` | Starter scaffolding |

## Agent Roles & Knowledge Mapping

| Role | Prompt | Rules | Decision Engine | Patterns |
|------|--------|-------|-----------------|----------|
| **Architect** | `05-execution/prompts/architect.md` | `05-execution/rules/architecture/` | `06-decision-engine/architecture/` | `07-patterns/*` |
| **Developer** | `05-execution/prompts/developer.md` | `05-execution/rules/{frontend,backend,database}/` | `06-decision-engine/{frontend,backend,database}/` | `07-patterns/{repository,service,controller}/` |
| **Reviewer** | `05-execution/prompts/reviewer.md` | `05-execution/checklists/` | — | `07-patterns/*/Anti-Patterns.md` |
| **Security** | `05-execution/prompts/security.md` | `05-execution/rules/security/` | `06-decision-engine/security/` | `07-patterns/{authentication,authorization}/` |
| **Designer** | `05-execution/prompts/designer.md` | `05-execution/rules/frontend/` | `06-decision-engine/frontend/` | `07-patterns/dashboard/` |
| **CTO** | `05-execution/prompts/cto.md` | `01-foundation/` | `06-decision-engine/` | All |
| **Product Manager** | `05-execution/prompts/product-manager.md` | `05-execution/rules/product/` | `06-decision-engine/product/` | `03-products/` |
| **AI Engineer** | `05-execution/prompts/ai-engineer.md` | `05-execution/rules/ai/` | `06-decision-engine/ai/` | `07-patterns/{rag,mcp,agent}/` |

## Knowledge Retrieval Protocol

When answering questions or making decisions:

1. **Identify role** → Load corresponding prompt
2. **Identify domain** → Load relevant rules
3. **Check patterns** → Reference `07-patterns/`
4. **Validate** → Run checklist from `05-execution/checklists/`
5. **Decide** → Use `06-decision-engine/` if uncertain

## Content Standards

- All files: kebab-case, UTF-8, Markdown, Unix line endings
- Every folder has a README.md with Purpose/Contents/Naming/Usage/Related
- Patterns follow: Problem → Context → Forces → Solution → Diagram → Example → Pros/Cons → Anti-Patterns → Checklist → Related
- Rules are role-specific and deep (not surface-level)

## Usage for AI Agents

Load this file first, then navigate to:
- Your role prompt: `05-execution/prompts/<role>.md`
- Your domain rules: `05-execution/rules/<domain>/`
- Relevant patterns: `07-patterns/<pattern>/`
- Validation: `05-execution/checklists/<topic>.md`


## Quick Reference

### By Task
| Task | Start Here |
|------|-----------|
| Build Next.js app | `05-execution/rules/nextjs/architecture.md` → `patterns.md` |
| Design database | `05-execution/rules/postgres/indexes.md` → `query-planning.md` |
| Add payments | `05-execution/rules/stripe/subscriptions.md` → `webhooks.md` |
| Build AI feature | `05-execution/rules/ai/rag/` → `agents/` |
| Review code | `05-execution/prompts/reviewer.md` + `checklists/code-review.md` |

### By Role
| Role | Primary Knowledge |
|------|-------------------|
| Architect | `ai-context.md` → `patterns/` → `decision-engine/` |
| Developer | `rules/` → `examples/` → `checklists/` |
| Reviewer | `checklists/` → `patterns/*/Anti-Patterns.md` |
| Security | `rules/security/` → `patterns/authentication/` |
