---
tags:
  - ai
  - auth
  - database
  - embeddings
  - nextjs
  - performance
  - postgres
  - rag
  - react
  - security
  - sql
summary: "Problem: Secure User Authentication"
read_when:
  - "Designing authentication architecture"
  - "Reviewing authentication implementation"
---

# Problem: Secure User Authentication

## Context

Every SaaS application needs to identify users, verify their identity, and control access to resources. Authentication is the foundation of security but is frequently implemented incorrectly.

## Common Failures

### Credential Storage
- Plaintext passwords (breach = total compromise)
- Weak hashing (MD5, SHA1 without salt)
- Insufficient iteration counts (PBKDF2 with 1000 iterations)

### Session Management
- Session tokens in URL parameters (leaked in browser history)
- No token expiration (stolen token valid forever)
- Predictable session IDs (sequential numbers)
- No token rotation after sensitive actions

### Password Policies
- Overly complex rules (users write passwords down)
- No breach checking (known compromised passwords accepted)
- No rate limiting (brute force possible)

### Multi-Factor Authentication
- Optional MFA (most users don't enable)
- SMS-based 2FA (vulnerable to SIM swapping)
- No backup codes (account lockout)

## Security Impact

| Failure | Impact | Likelihood |
|---------|--------|-----------|
| Weak password storage | Mass credential compromise | High |
| Session fixation | Account takeover | Medium |
| Missing rate limits | Brute force attacks | High |
| No MFA | Single-point-of-failure | Medium |

## Requirements

- Passwords must be hashed with bcrypt, Argon2, or PBKDF2
- Sessions must expire and rotate
- Rate limiting on authentication endpoints
- MFA should be enforced for sensitive operations
- Audit logging for all authentication events


## Related
- `05-execution/rules/nextjs/patterns.md` — Next.js patterns
- `05-execution/rules/postgres/performance.md` — Database patterns
- `08-recipes/build-authentication/` — Build recipes
- `09-boilerplates/authentication/` — Starter templates
