# Solution: Model Context Protocol (MCP)

## Architecture

```
AI Client (Claude, GPT-4)
    │
    ▼
MCP Host (IDE, Chat Interface)
    │
    ├─── MCP Server: Filesystem
    ├─── MCP Server: Database
    ├─── MCP Server: Git
    └─── MCP Server: Custom API
```

## Server Implementation

```typescript
// server.ts
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: 'database-server',
  version: '1.0.0',
}, {
  capabilities: {
    tools: {},
  },
});

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'query_database',
        description: 'Execute a read-only SQL query',
        inputSchema: {
          type: 'object',
          properties: {
            query: {
              type: 'string',
              description: 'SQL SELECT statement',
            },
          },
          required: ['query'],
        },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === 'query_database') {
    const { query } = request.params.arguments as { query: string };
    
    // Security: Only allow SELECT
    if (!query.trim().toLowerCase().startsWith('select')) {
      throw new Error('Only SELECT queries allowed');
    }
    
    const result = await db.execute(query);
    return {
      content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
    };
  }
  throw new Error('Unknown tool');
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

## Client Integration

```typescript
// Client-side usage
import { Client } from '@modelcontextprotocol/sdk/client/index.js';

const client = new Client({ name: 'ai-assistant', version: '1.0.0' });

// Connect to MCP server
const transport = new StdioClientTransport({
  command: 'node',
  args: ['mcp-database-server.js'],
});

await client.connect(transport);

// Discover tools
const tools = await client.listTools();

// Use tool
const result = await client.callTool({
  name: 'query_database',
  arguments: {
    query: 'SELECT COUNT(*) FROM users',
  },
});
```

## Security Considerations

- **Input validation**: Validate all tool arguments
- **Scope limitation**: Each server has limited scope
- **Audit logging**: Log all tool invocations
- **Rate limiting**: Prevent abuse

## Anti-Patterns

- Granting write access without human confirmation
- Not validating tool inputs
- Exposing sensitive operations directly
- No logging of tool usage


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-mcp/` — Build recipes
- `09-boilerplates/mcp/` — Starter templates
