# Billing Example

## Overview
Production-ready example of billing implementation.

## Architecture
```mermaid
graph TD
    A[Client] --> B[API]
    B --> C[Billing]
    C --> D[Database]
```

## Implementation

### Core Logic
```typescript
// Implementation of billing
export async function processBilling(data: Input): Promise<Output> {
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
  const result = await processBilling(data);
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

describe('Billing', () => {
  it('processes valid input', async () => {
    const result = await processBilling({ valid: true });
    expect(result.status).toBe('success');
  });
  
  it('rejects invalid input', async () => {
    await expect(processBilling({ valid: false }))
      .rejects.toThrow(ValidationError);
  });
});
```

## Related
- [Pattern](../../patterns/billing/)
- [Recipe](../../recipes/build-billing/)
