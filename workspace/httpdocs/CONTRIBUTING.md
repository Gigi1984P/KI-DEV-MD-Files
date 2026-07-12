# Contributing to AI-EKOS

## How to Contribute

### Adding New Content

1. **Identify the right location**
   - `01-foundation/` — Principles and standards
   - `02-platform/` — Technology documentation
   - `03-products/` — Product specifications
   - `04-playbooks/` — Operational procedures
   - `05-execution/` — Prompts, rules, templates
   - `06-decision-engine/` — Decision frameworks
   - `07-patterns/` — Design patterns
   - `08-recipes/` — Build recipes
   - `09-boilerplates/` — Starter templates

2. **Follow the naming convention**
   - kebab-case for filenames
   - Use descriptive names
   - Add README.md to every new directory

3. **Content standards**
   - Include code examples (TypeScript, SQL, React)
   - Add anti-patterns with before/after comparisons
   - Include Mermaid diagrams where applicable
   - Cross-reference related files

### Review Process

1. **Self-review checklist**
   - [ ] Content is accurate and up-to-date
   - [ ] Code examples compile and work
   - [ ] Links to related files are correct
   - [ ] No placeholder text remains

2. **Submit for review**
   - Create a PR with clear description
   - Reference related issues or patterns
   - Tag relevant maintainers

3. **Approval criteria**
   - Technical accuracy verified
   - Cross-references complete
   - Consistent with existing content

### Content Update Cycle

| Frequency | Action | Owner |
|-----------|--------|-------|
| Weekly | Review new PRs | Maintainers |
| Monthly | Technology updates | Domain experts |
| Quarterly | Architecture review | Architects |
| Annually | Full audit | CTO |

## Quality Levels

| Level | Description | Requirement |
|-------|-------------|-------------|
| **Draft** | Initial content | Structure present |
| **Review** | Peer reviewed | Technical accuracy |
| **Approved** | Production ready | Complete examples |
| **Archived** | Outdated | Move to `archive/` |

## Anti-Patterns

- Copy-paste without attribution
- Generic templates without examples
- Missing cross-references
- No testing of code examples

## Contact

- Issues: GitHub Issues
- Discussions: GitHub Discussions
- Direct: maintainers@ai-ekos.dev
