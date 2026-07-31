# Update Process

## Continuous Maintenance

### Technology Updates

**Trigger**: New version of dependency or technology

**Process**:
1. Identify affected files in `rules/` directory
2. Update version-specific content
3. Test code examples
4. Update cross-references
5. Mark old content as deprecated if needed

**Example**:
```
Next.js 15 released → Update nextjs/architecture.md → Update patterns → Update examples
```

### Pattern Evolution

**Trigger**: New pattern discovered or existing pattern improved

**Process**:
1. Document in `07-patterns/[pattern]/`
2. Add Problem, Solution, Anti-Patterns
3. Cross-reference from rules/
4. Add to decision engine

### Playbook Updates

**Trigger**: Process improvement or tool change

**Process**:
1. Update `04-playbooks/`
2. Test with team
3. Update automation if applicable

## Review Schedule

| Review Type | Frequency | Scope | Owner |
|-------------|-----------|-------|-------|
| Content freshness | Weekly | New PRs, updates | Maintainers |
| Technology audit | Monthly | Version updates | Domain experts |
| Pattern review | Quarterly | New patterns, anti-patterns | Architects |
| Full repository | Annually | Structure, completeness | CTO |

## Deprecation Process

1. Mark content with deprecation notice
2. Move to `archive/deprecated/` after 6 months
3. Update references to point to new content
4. Remove after 12 months

## Metrics

Track repository health:
- Files updated per month
- New patterns added
- Outdated content identified
- Review turnaround time
