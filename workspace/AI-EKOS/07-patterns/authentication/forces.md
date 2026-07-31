---
tags:
  - auth
  - database
  - nextjs
  - performance
  - postgres
  - react
  - security
  - sql
summary: "Forces: Authentication Trade-offs"
read_when:
  - "Designing authentication architecture"
  - "Reviewing authentication implementation"
---

# Forces: Authentication Trade-offs

## Security vs Usability

| Force | High Security | High Usability |
|-------|------------|----------------|
| Password complexity | Complex rules, frequent changes | Simple, memorable |
| MFA | Mandatory for all | Optional, recommended |
| Session duration | Short (15 min) | Long (30 days) |
| Login attempts | Strict lockout | Flexible |

**Resolution**: Tiered approach based on sensitivity
- Standard operations: Password + optional MFA
- Sensitive operations: Password + mandatory MFA
- Admin operations: Password + hardware key

## Stateless vs Stateful Sessions

| Aspect | Stateless (JWT) | Stateful (Database) |
|--------|--------------|---------------------|
| Scalability | Easy (no DB lookup) | Requires session store |
| Revocation | Impossible (wait for expiry) | Instant |
| Bandwidth | Large tokens | Small tokens |
| Complexity | Simple implementation | More moving parts |

**Resolution**: Hybrid — JWT for access, database for refresh + revocation

## Build vs Buy

| Factor | Build | Buy (Auth0, Clerk, etc.) |
|--------|-------|------------------------|
| Time to market | 2-4 weeks | 2-4 days |
| Customization | Unlimited | Limited |
| Maintenance | Ongoing | Vendor handles |
| Cost | Engineering time | Per-user pricing |
| Security | Team expertise | Vendor expertise |

**Resolution**: Start with vendor, evaluate migration at scale


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-authentication/` — Build recipes
- `09-boilerplates/authentication/` — Starter templates
