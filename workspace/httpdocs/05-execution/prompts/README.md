# Prompts

## Agent Integration Guide

### Cursor

Create `.cursorrules` in project root:
```
# Load AI-EKOS context
@file /path/to/AI-EKOS/ai-context.md

# Role-specific context
@file /path/to/AI-EKOS/05-execution/prompts/developer.md
@file /path/to/AI-EKOS/05-execution/rules/nextjs/architecture.md

# Validate against checklists
@file /path/to/AI-EKOS/05-execution/checklists/code-review.md
```

### Claude Code

Use `CLAUDE.md` in project root:
```markdown
# AI-EKOS Context

Load the following files for context:
- ai-context.md — Master context
- prompts/[role].md — Your role prompt
- rules/[technology]/ — Relevant technology rules
- patterns/[pattern]/ — Relevant patterns
```

### Codex

Configure via `.codex/config.json`:
```json
{
  "context": {
    "files": [
      "AI-EKOS/ai-context.md",
      "AI-EKOS/05-execution/prompts/developer.md",
      "AI-EKOS/05-execution/rules/nextjs/architecture.md"
    ]
  }
}
```

### Windsurf

Use `.windsurfrules`:
```
# AI-EKOS Integration

## Context Files
ai-context.md — Master knowledge base
prompts/architect.md — Architecture decisions
rules/nextjs/ — Next.js standards
patterns/authentication/ — Auth patterns

## Validation
Before completing any task:
1. Check patterns/ directory for relevant patterns
2. Review checklists/ for completion criteria
3. Verify against rules/ for technology compliance
```

## Role Selection

| Task | Primary Prompt | Supporting Rules |
|------|---------------|------------------|
| Architecture review | architect.md | architecture/, patterns/ |
| Feature implementation | developer.md | rules/[technology]/ |
| Code review | reviewer.md | checklists/code-review.md |
| Security audit | security.md | rules/security/, patterns/authentication/ |
| UI/UX design | designer.md | rules/frontend/, patterns/dashboard/ |
| AI feature | ai-engineer.md | rules/ai/, patterns/rag/ |
| Product decision | product-manager.md | 03-products/, decision-engine/ |
| Strategic decision | cto.md | 01-foundation/, 06-decision-engine/ |

## Context Loading Strategy

1. **Always load**: ai-context.md
2. **Load by role**: prompts/[your-role].md
3. **Load by task**: rules/[technology]/, patterns/[pattern]/
4. **Validate**: checklists/[topic].md
