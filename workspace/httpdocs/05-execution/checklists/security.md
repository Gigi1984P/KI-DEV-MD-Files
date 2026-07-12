# Security Review Checklist

## Input Validation

- [ ] All user inputs validated (type, length, format)
- [ ] SQL injection prevented (prepared statements ORM)
- [ ] XSS prevented (output encoding, CSP headers)
- [ ] CSRF tokens on state-changing operations
- [ ] File uploads validated (type, size, content)

## Authentication

- [ ] Passwords hashed with bcrypt/Argon2 (12+ rounds)
- [ ] JWTs have expiration (access: 15min, refresh: 7 days)
- [ ] Sessions invalidated on logout
- [ ] Rate limiting on login (5 attempts/minute)
- [ ] MFA enforced for admin accounts

## Authorization

- [ ] RBAC implemented correctly
- [ ] Resource-level checks (not just route-level)
- [ ] Principle of least privilege
- [ ] No horizontal privilege escalation
- [ ] Audit logging for sensitive actions

## Data Protection

- [ ] PII encrypted at rest
- [ ] TLS 1.3 for all connections
- [ ] Secrets in environment variables (never in code)
- [ ] Database credentials rotated regularly
- [ ] Backup encryption verified

## AI Security

- [ ] Prompt injection defenses
- [ ] Output sanitization
- [ ] Rate limiting on AI endpoints
- [ ] Cost controls (max tokens per request)
- [ ] No PII in prompts sent to third-party LLMs

## Infrastructure

- [ ] Security headers (CSP, HSTS, X-Frame-Options)
- [ ] Container scanning (Trivy, Snyk)
- [ ] Dependency vulnerabilities checked
- [ ] Network segmentation
- [ ] WAF configured

## Incident Response

- [ ] Logging strategy defined
- [ ] Alert thresholds set
- [ ] Response playbook documented
- [ ] Contact list current
- [ ] Last drill date recorded
