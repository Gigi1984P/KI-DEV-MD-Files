# Deployment Checklist

## Pre-Deployment

- [ ] All tests passing (unit, integration, e2e)
- [ ] Security scan clean (Snyk, Trivy)
- [ ] No console.logs or debug code
- [ ] Environment variables documented
- [ ] Database migrations tested
- [ ] Rollback plan ready

## Infrastructure

- [ ] DNS configured
- [ ] SSL certificates valid
- [ ] Load balancer health checks
- [ ] Auto-scaling configured
- [ ] Database backups scheduled
- [ ] Log aggregation active

## Post-Deployment

- [ ] Smoke tests pass
- [ ] Error rates normal
- [ ] Response times acceptable
- [ ] Monitoring alerts working
- [ ] Rollback tested
