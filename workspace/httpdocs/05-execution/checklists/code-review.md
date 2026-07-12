# Code Review Checklist

## Pre-Review

- [ ] PR description explains what and why
- [ ] Tests included and passing
- [ ] No merge conflicts
- [ ] CI/CD checks passing

## Architecture

- [ ] Follows established patterns
- [ ] No unnecessary complexity
- [ ] Appropriate abstraction level
- [ ] Backward compatibility considered

## Security

- [ ] Input validation present
- [ ] No secrets in code
- [ ] Authorization checks
- [ ] No injection vulnerabilities

## Performance

- [ ] No N+1 queries
- [ ] Efficient data structures
- [ ] No unnecessary re-renders
- [ ] Bundle size considered

## TypeScript

- [ ] No `any` types
- [ ] Proper error handling
- [ ] Null checks
- [ ] Generic types used correctly

## Testing

- [ ] Unit tests for business logic
- [ ] Integration tests for APIs
- [ ] Edge cases covered
- [ ] Error paths tested

## Documentation

- [ ] Code comments explain why
- [ ] README updated if needed
- [ ] API docs updated
- [ ] Breaking changes documented
