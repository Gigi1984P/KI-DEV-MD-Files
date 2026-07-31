---
tags:
  - ai
  - ai-agents
  - anti-patterns
  - best-practices
  - embeddings
  - mcp
  - rag
summary: "AI Agents"
read_when:
  - "Implementing ai features"
  - "Troubleshooting ai issues"
---

# AI Agents

## Architecture

```
User Request → Planner → Executor → Observer → Response
                    │         │
                    ▼         ▼
               Tools    Memory/State
```

## Implementation

### Basic Agent

```typescript
import { OpenAI } from 'openai';

class SimpleAgent {
  private client: OpenAI;
  private tools: Map<string, Tool>;
  
  constructor() {
    this.client = new OpenAI();
    this.tools = new Map();
  }
  
  async execute(task: string): Promise<string> {
    const messages = [
      { role: 'system' as const, content: 'You are a helpful assistant with tools.' },
      { role: 'user' as const, content: task }
    ];
    
    // Get plan from LLM
    const plan = await this.client.chat.completions.create({
      model: 'gpt-4',
      messages,
      tools: Array.from(this.tools.values()).map(t => t.definition),
    });
    
    // Execute tool calls
    const toolCalls = plan.choices[0].message.tool_calls || [];
    for (const call of toolCalls) {
      const tool = this.tools.get(call.function.name);
      if (tool) {
        const result = await tool.execute(JSON.parse(call.function.arguments));
        messages.push({
          role: 'tool',
          tool_call_id: call.id,
          content: JSON.stringify(result),
        });
      }
    }
    
    // Get final response
    const response = await this.client.chat.completions.create({
      model: 'gpt-4',
      messages,
    });
    
    return response.choices[0].message.content || '';
  }
}
```

### Multi-Agent System

```typescript
class Orchestrator {
  private agents: Map<string, Agent>;
  
  async delegate(task: Task): Promise<Result> {
    // Analyze task
    const analysis = await this.analyze(task);
    
    // Select agents
    const selectedAgents = this.selectAgents(analysis);
    
    // Execute in parallel
    const results = await Promise.all(
      selectedAgents.map(agent => agent.execute(task.subtask))
    );
    
    // Synthesize
    return this.synthesize(results);
  }
  
  private async analyze(task: Task): Promise<Analysis> {
    // Use LLM to understand task complexity
    const prompt = `Analyze this task and determine required capabilities:
    ${task.description}`;
    
    return this.llm.complete(prompt);
  }
}
```

## Tools

### Database Query Tool
```typescript
const queryTool = {
  definition: {
    type: 'function',
    function: {
      name: 'query_database',
      description: 'Execute read-only SQL query',
      parameters: {
        type: 'object',
        properties: {
          query: { type: 'string', description: 'SQL SELECT statement' }
        },
        required: ['query']
      }
    }
  },
  execute: async (args: { query: string }) => {
    // Validate: only SELECT allowed
    if (!args.query.trim().toLowerCase().startsWith('select')) {
      throw new Error('Only SELECT queries allowed');
    }
    return db.execute(args.query);
  }
};
```

## Memory Management

```typescript
class AgentMemory {
  private shortTerm: Message[] = [];
  private longTerm: VectorStore;
  
  async add(message: Message) {
    this.shortTerm.push(message);
    
    // Summarize when buffer gets full
    if (this.shortTerm.length > 20) {
      const summary = await this.summarize(this.shortTerm);
      await this.longTerm.add(summary);
      this.shortTerm = [];
    }
  }
  
  async retrieve(query: string): Promise<Context> {
    const recent = this.shortTerm.slice(-5);
    const relevant = await this.longTerm.similaritySearch(query, 3);
    return { recent, relevant };
  }
}
```

## Anti-Patterns

- No tool validation (agent can execute anything)
- Infinite loops without max steps
- No human oversight for critical actions
- Storing all context in prompt (token limit)
- Single-agent for complex multi-domain tasks

## Related
- `07-patterns/agent/` — Agent patterns
- `07-patterns/mcp/` — Model Context Protocol
- `05-execution/rules/ai/rag/` — RAG for agent memory
