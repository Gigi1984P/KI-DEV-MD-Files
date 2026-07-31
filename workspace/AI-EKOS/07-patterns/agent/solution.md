---
tags:
  - anti-patterns
  - best-practices
  - database
  - nextjs
  - performance
  - postgres
  - react
  - sql
summary: "Solution: Agent Architecture"
read_when:
  - "Designing agent architecture"
  - "Reviewing agent implementation"
---

# Solution: Agent Architecture

## ReAct Pattern (Reason + Act)

```
Thought: I need to find the user's recent orders
Action: query_database({query: "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC LIMIT 5"})
Observation: [{id: 1, total: 99.99, status: 'shipped'}, ...]
Thought: The user has recent orders. Let me check shipping status.
Action: query_shipping_api({order_id: 1})
Observation: {status: 'in_transit', eta: '2024-01-15'}
Thought: I have enough information to answer the user.
Final Answer: Your order #1 ($99.99) is in transit and expected to arrive on January 15th.
```

## Implementation

```typescript
interface AgentStep {
  thought: string;
  action: string;
  observation: string;
}

class Agent {
  private tools: Map<string, Tool>;
  private memory: AgentStep[] = [];
  
  constructor(tools: Tool[]) {
    this.tools = new Map(tools.map(t => [t.name, t]));
  }
  
  async run(task: string): Promise<string> {
    let currentTask = task;
    
    for (let step = 0; step < 10; step++) {
      // Reason
      const thought = await this.think(currentTask);
      
      // Act
      const action = await this.decideAction(thought);
      if (action.type === 'complete') {
        return action.answer;
      }
      
      // Observe
      const observation = await this.execute(action);
      this.memory.push({ thought, action, observation });
      
      currentTask = `Previous: ${thought}\nResult: ${observation}\nNow: ${task}`;
    }
    
    throw new Error('Max steps exceeded');
  }
  
  private async think(context: string): Promise<string> {
    const prompt = `Given the task and previous steps, what should I do next?\n\n${context}`;
    return this.llm.complete(prompt);
  }
  
  private async decideAction(thought: string): Promise<Action> {
    const prompt = `Based on this thought, what action should I take?\n${thought}\n\nAvailable tools: ${Array.from(this.tools.keys()).join(', ')}`;
    return this.llm.complete(prompt);
  }
}
```

## Multi-Agent Orchestration

```typescript
class Orchestrator {
  private agents: Map<string, Agent>;
  
  async executeTask(task: string): Promise<Result> {
    // Decompose task
    const subtasks = await this.decompose(task);
    
    // Assign to agents
    const results = await Promise.all(
      subtasks.map(async (subtask) => {
        const agent = this.selectAgent(subtask);
        return agent.run(subtask);
      })
    );
    
    // Synthesize results
    return this.synthesize(results);
  }
  
  private async decompose(task: string): Promise<Subtask[]> {
    const prompt = `Break this task into subtasks: ${task}`;
    return this.llm.complete(prompt);
  }
}
```

## Anti-Patterns

- Infinite loops without step limits
- No error recovery mechanism
- Exposing all tools to all agents
- No human-in-the-loop for critical actions


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-agent/` — Build recipes
- `09-boilerplates/agent/` — Starter templates
