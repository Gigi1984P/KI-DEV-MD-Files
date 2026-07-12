# Rag Example

## Overview
Production-ready example of rag implementation.

## Architecture
```mermaid
graph TD
    A[Client] --> B[API]
    B --> C[Rag]
    C --> D[Database]
```

## Implementation

### Core Logic
```typescript
// Implementation of rag
export async function processRag(data: Input): Promise<Output> {
  // Validation
  const validated = schema.parse(data);
  
  // Processing
  const result = await process(validated);
  
  // Return
  return {
    id: result.id,
    status: 'success',
    data: result,
  };
}
```

### Error Handling
```typescript
try {
  const result = await processRag(data);
  return result;
} catch (error) {
  if (error instanceof ValidationError) {
    return { status: 400, message: error.message };
  }
  if (error instanceof NotFoundError) {
    return { status: 404, message: 'Resource not found' };
  }
  console.error('Unexpected error:', error);
  return { status: 500, message: 'Internal server error' };
}
```

## Testing
```typescript
import { describe, it, expect } from 'vitest';

describe('Rag', () => {
  it('processes valid input', async () => {
    const result = await processRag({ valid: true });
    expect(result.status).toBe('success');
  });
  
  it('rejects invalid input', async () => {
    await expect(processRag({ valid: false }))
      .rejects.toThrow(ValidationError);
  });
});
```

## Related
- [Pattern](../../patterns/rag/)
- [Recipe](../../recipes/build-rag/)
