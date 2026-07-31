# Problem: AI Tool Integration

## Context

LLMs need access to external systems — databases, APIs, file systems — to perform useful tasks. Traditional approaches require manual API integration for each tool.

## Common Failures

### Manual Integration
- Each tool requires custom prompt engineering
- No standardization across different AI systems
- Brittle parsing of LLM outputs into API calls

### Tool Confusion
- LLM doesn't know which tool to use when
- Wrong tool selected for the task
- Parameters incorrectly formatted

### Context Loss
- Tool results not properly fed back into context
- Multiple tool calls lose state between invocations

## Requirements

- Standard protocol for tool discovery and invocation
- Type-safe parameter passing
- Automatic error handling and retries
- Transparent to both AI and human users


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-mcp/` — Build recipes
- `09-boilerplates/mcp/` — Starter templates
