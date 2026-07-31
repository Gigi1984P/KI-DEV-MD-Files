# Problem: Business Logic Organization

## Context

Applications need to execute business rules, validate data, and coordinate between repositories and external services. Without clear patterns, business logic leaks into controllers and becomes untestable.

## Common Failures

### Fat Controllers
```javascript
// ❌ Business logic in controller
app.post('/orders', async (req, res) => {
  const { userId, items } = req.body;
  
  // Validation
  if (!userId || !items?.length) {
    return res.status(400).json({ error: 'Invalid input' });
  }
  
  // Pricing logic
  let total = 0;
  for (const item of items) {
    const product = await db.products.findById(item.productId);
    if (product.stock < item.quantity) {
      return res.status(400).json({ error: 'Out of stock' });
    }
    total += product.price * item.quantity;
  }
  
  // Discount logic
  if (total > 100) {
    total *= 0.9; // 10% discount
  }
  
  // Create order
  const order = await db.orders.create({
    userId,
    items,
    total,
    status: 'pending'
  });
  
  // Send notification
  await sendEmail(userId, 'Order confirmed');
  
  res.json(order);
});
```

**Why it fails:**
- Untestable — requires HTTP request
- Duplicated logic across routes
- Violates Single Responsibility Principle
- Hard to reason about side effects

### Leaky Abstractions
```javascript
// ❌ Service knows too much about database
class OrderService {
  async create(data) {
    // Direct SQL, no abstraction
    await db.raw('INSERT INTO orders ...');
    
    // Direct external call
    await fetch('https://api.stripe.com/v1/charges', {...});
  }
}
```

**Why it fails:**
- Tight coupling to database schema
- Can't mock external dependencies
- Hard to switch providers

## Requirements

- Isolate business logic from transport layer
- Make rules explicit and testable
- Coordinate multiple repositories
- Handle transactions and side effects
- Support dependency injection


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-service/` — Build recipes
- `09-boilerplates/service/` — Starter templates
