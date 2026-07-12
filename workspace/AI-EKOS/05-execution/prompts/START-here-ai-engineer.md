# AI Engineer Quick Start

## Your Role
Build reliable AI features that work in production, not just demos.

## Essential Reading (in order)

### 1. Context
- `ai-context.md` — Master knowledge map
- `05-execution/prompts/ai-engineer.md` — Your role definition

### 2. Core AI Knowledge
- `05-execution/rules/ai/prompt-engineering/README.md` — Prompt design patterns
- `05-execution/rules/ai/rag/README.md` — Retrieval systems
- `05-execution/rules/ai/agents/README.md` — Agent architectures
- `05-execution/rules/ai/mcp/README.md` — Tool integration

### 3. Evaluation & Safety
- `05-execution/rules/ai/evaluation/README.md` — Testing AI systems
- `05-execution/rules/ai/guardrails/README.md` — Safety controls
- `05-execution/checklists/ai.md` — AI feature checklist

### 4. Integration Patterns
- `07-patterns/rag/Solution.md` — RAG implementation
- `07-patterns/agent/Solution.md` — Agent orchestration
- `07-patterns/mcp/Solution.md` — Model Context Protocol

## Quick Decision Tree

```
AI Feature?
├── Need external knowledge?
│   ├── Static docs? ──▶ patterns/rag/ (embed + retrieve)
│   └── Real-time data? ──▶ patterns/mcp/ (tools)
├── Multi-step reasoning?
│   ├── Simple flow? ──▶ rules/ai/prompt-engineering/ (chain of thought)
│   └── Complex workflow? ──▶ patterns/agent/ (ReAct pattern)
├── Need evaluation?
│   ├── Offline testing? ──▶ rules/ai/evaluation/
│   └── Online monitoring? ──▶ rules/ai/guardrails/
└── Cost optimization?
    ├── Model selection? ──▶ rules/ai/cost/
    └── Token optimization? ──▶ rules/ai/prompt-engineering/
```

## Your Checklist

Before shipping AI features:
- [ ] Evaluation framework in place
- [ ] Cost budget defined
- [ ] Rate limiting configured
- [ ] Fallback mechanisms implemented
- [ ] Guardrails tested
- [ ] PII not in prompts
- [ ] Monitoring active
