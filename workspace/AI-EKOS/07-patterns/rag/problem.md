---
tags:
  - ai
  - database
  - embeddings
  - nextjs
  - performance
  - postgres
  - rag
  - react
  - sql
summary: "Problem: LLM Knowledge Limitations"
read_when:
  - "Designing rag architecture"
  - "Reviewing rag implementation"
---

# Problem: LLM Knowledge Limitations

## Context

Large Language Models (LLMs) have a knowledge cutoff, no access to private data, and hallucinate when asked about specific facts not in their training data.

## Common Failures

### Hallucination
- Model generates plausible but false information
- No source attribution — user can't verify
- Confidence doesn't correlate with accuracy

### Outdated Knowledge
- Training data has a cutoff date (e.g., April 2024)
- Can't access real-time information
- Product changes, pricing updates, policy changes are unknown

### No Private Data Access
- Customer-specific data not in training
- Internal documentation inaccessible
- Personal data can't be embedded in model weights

### Context Window Limitations
- GPT-4: 128k tokens (but effective ~32k)
- Claude 3: 200k tokens
- Cost scales with context length
- Can't dump entire knowledge base into prompt

## Why Fine-Tuning is Not Enough

| Limitation | Fine-Tuning | RAG |
|-----------|-------------|-----|
| Dynamic data | Requires retraining | Real-time updates |
| Multiple sources | Single model | Multiple sources |
| Source attribution | None | Full traceability |
| Cost | High (training) | Low (inference) |
| Domain adaptation | Requires data | Works with any docs |

## Requirements

- Retrieve only relevant documents per query
- Include source references in answers
- Update knowledge without model retraining
- Control costs (token usage)
- Evaluate retrieval quality before shipping


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-rag/` — Build recipes
- `09-boilerplates/rag/` — Starter templates
