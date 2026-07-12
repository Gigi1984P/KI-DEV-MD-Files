# Deploy to Production Playbook

## Objective
Deploy application to production safely with zero downtime.

## Prerequisites
- [ ] All tests passing (unit, integration, e2e)
- [ ] Security scan clean
- [ ] Database migrations tested
- [ ] Rollback plan documented

## Steps

### Step 1: Pre-Deployment Checks
```bash
# Run tests
npm test

# Security scan
npm audit
snyk test

# Build verification
npm run build

# Database migration dry-run
npx prisma migrate diff --from-url $DATABASE_URL --to-schema prisma/schema.prisma
```

### Step 2: Database Migration
```bash
# Backup database first
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d-%H%M%S).sql

# Run migrations
npx prisma migrate deploy

# Verify migration
npx prisma migrate status
```

### Step 3: Blue-Green Deployment
```bash
# Build new version
docker build -t myapp:v2 .

# Deploy to green environment
kubectl apply -f k8s/green-deployment.yaml

# Wait for health checks
kubectl rollout status deployment/myapp-green

# Switch traffic to green
kubectl patch service myapp -p '{"spec":{"selector":{"version":"v2"}}}'

# Monitor for errors
kubectl logs -l app=myapp,version=v2 --tail=100
```

### Step 4: Smoke Tests
```bash
# Health check
curl https://api.myapp.com/health

# Critical path test
curl https://api.myapp.com/api/users | jq '.users | length'

# Database connectivity
curl https://api.myapp.com/api/health/db
```

### Step 5: Monitoring
- [ ] Error rates < 0.1%
- [ ] Response times < 500ms (p95)
- [ ] CPU usage < 70%
- [ ] Memory usage < 80%

## Rollback
```bash
# If issues detected, rollback immediately
kubectl patch service myapp -p '{"spec":{"selector":{"version":"v1"}}}'

# Verify rollback
kubectl get pods -l app=myapp
```

## Validation
- [ ] Application accessible
- [ ] Critical features working
- [ ] No error spikes in monitoring
- [ ] Database connections stable
