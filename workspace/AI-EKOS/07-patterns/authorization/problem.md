---
tags:
  - auth
  - database
  - nextjs
  - performance
  - postgres
  - react
  - sql
summary: "Problem: Access Control"
read_when:
  - "Designing authorization architecture"
  - "Reviewing authorization implementation"
---

# Problem: Access Control

## Context

After authentication (who are you?), authorization controls what you can do. Poor authorization leads to data breaches and privilege escalation.

## Common Failures

### Missing Authorization Checks
```javascript
// ❌ No authorization — any logged-in user can access
app.get('/api/admin/users', (req, res) => {
  const users = await db.users.findAll();
  res.json(users);
});
```

### Role-Based Gaps
```javascript
// ❌ Route-level only, not resource-level
app.get('/api/documents/:id', authenticate, (req, res) => {
  // Any authenticated user can access any document
  const doc = await db.documents.findById(req.params.id);
  res.json(doc);
});
```

### Horizontal Privilege Escalation
```javascript
// ❌ User can access other users' data by changing ID
app.get('/api/orders/:id', (req, res) => {
  const order = await db.orders.findById(req.params.id);
  // Missing check: does this order belong to current user?
  res.json(order);
});
```

## Requirements

- Verify permissions on every resource access
- Support role-based and attribute-based access
- Audit all authorization decisions
- Handle edge cases (shared resources, public content)


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-authorization/` — Build recipes
- `09-boilerplates/authorization/` — Starter templates
