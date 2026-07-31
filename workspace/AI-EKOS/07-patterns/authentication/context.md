# Context: When to Apply Authentication Patterns

## Prerequisites

Before implementing authentication, determine:

1. **User Identity Source**
   - Self-hosted (email/password)
   - Social (Google, GitHub, etc.)
   - Enterprise (SAML, OIDC)
   - Mixed (multiple sources)

2. **Session Requirements**
   - Web app (cookies)
   - Mobile app (tokens)
   - API (JWT)
   - Mixed (all of above)

3. **Security Level**
   - Low: Personal project, demo
   - Medium: SaaS with paid tiers
   - High: Financial, healthcare, regulated

## Decision Matrix

| Scenario | Recommended Pattern | See Also |
|----------|---------------------|----------|
| New SaaS | JWT + Refresh Token + OAuth | `07-patterns/authorization/` |
| Existing app migration | Gradual OAuth integration | `04-playbooks/build/create-authentication.md` |
| Mobile-first | OAuth + PKCE | `05-execution/rules/security.md` |
| Enterprise | SAML 2.0 + OIDC | `06-decision-engine/security/` |

## Constraints

- **GDPR**: Right to deletion requires audit trail
- **SOC 2**: MFA for admin accounts
- **PCI DSS**: No card data in auth system
- **HIPAA**: Audit logging mandatory

## Related Patterns

- `07-patterns/authorization/` — After authentication, control access
- `07-patterns/cache/` — Session caching strategies
- `05-execution/checklists/security.md` — Pre-deployment verification
