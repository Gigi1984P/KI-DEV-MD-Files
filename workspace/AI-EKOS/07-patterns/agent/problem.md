# Problem: Complex Task Execution

## Context

Single AI agents struggle with complex, multi-step tasks that require planning, tool use, and error recovery. They lack persistence and coordination.

## Common Failures

### No Planning
- Agent starts executing without a plan
- Gets stuck in loops
- Wastes tokens on irrelevant actions

### Tool Misuse
- Wrong tool for the task
- Incorrect parameters
- Ignoring tool errors

### State Loss
- No memory between steps
- Forgets previous context
- Can't handle long-running tasks

## Requirements

- Break complex tasks into subtasks
- Select appropriate tools
- Maintain state across steps
- Recover from errors


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-agent/` — Build recipes
- `09-boilerplates/agent/` — Starter templates
