# AI-EKOS Multi-Agent Workflows v2.1

## Übersicht

Dieses Verzeichnis enthält Workflow-Definitionen für die Multi-Agent-Orchestrierung mit AI-EKOS.

**Version:** 2.1 (Enterprise)

**Neue Features:**
- ✅ Human-in-the-Loop (interaktive Genehmigung)
- ✅ Quality Gates (Test-Coverage, Security Score)
- ✅ Cost Tracking (pro Agent, Budget-Limits)
- ✅ Self-Healing (Retry, Fallback)
- ✅ Notifications (Slack, Discord)

## Verfügbare Workflows

### 1. Complete Project (`complete-project`) ⭐
**9 Agenten in 5 Phasen mit Quality Gates**

**Features:**
- Human approval zwischen Phasen
- Quality gates: test_coverage > 80%, security_score > 90
- Cost tracking: ~$3.51 für komplettes Projekt
- Self-healing: Retry bei Agenten-Fehlern

**Phasen:**
```
Phase 1: Requirements & Architecture (parallel)
  ├── Product Manager → PRD, User Stories
  └── Architect → ADR, Component Diagram
  🛡️ Quality Gates → 👤 Human Approval → Phase 2

Phase 2: Design & Development (parallel)  
  ├── Designer → Design System, UI Library
  └── Developer → Production Code, Tests
  🛡️ Quality Gates → 👤 Human Approval → Phase 3

Phase 3: Quality Assurance (parallel)
  ├── Tester → Unit, Integration, E2E
  └── Security → OWASP, Compliance
  🛡️ Quality Gates → 👤 Human Approval → Phase 4

Phase 4: Review & Deployment (parallel)
  ├── Reviewer → Code Quality, Approval
  └── DevOps → Docker, CI/CD, Monitoring
  🛡️ Quality Gates → 👤 Human Approval → Phase 5

Phase 5: Final Validation
  └── Performance → Metrics, Load Tests
```

**Ausführung:**
```bash
# Auto-approval (für CI/CD)
python scripts/orchestrator.py \
  --workflow complete-project \
  --task "Build a SaaS CRM" \
  --tech-stack nextjs,postgres,shadcn \
  --approval-mode auto \
  --max-cost 50.00

# Interactive approval (für Entwicklung)
python scripts/orchestrator.py \
  --workflow complete-project \
  --task "Build a SaaS CRM" \
  --approval-mode interactive

# File-based approval (für Review-Prozesse)
python scripts/orchestrator.py \
  --workflow complete-project \
  --task "Build a SaaS CRM" \
  --approval-mode file
```

### 2. Feature Implementation (`feature-implementation`)
**4 Agenten mit Abhängigkeiten**

```
Architect → Developer → Security → Reviewer
```

**Mit Quality Gates:**
- security_score > 90
- code_quality > 85

### 3. Security Review (`security-review`)
**2 Agenten parallel**

```
Security Analyzer + Compliance Checker (parallel)
```

### 4. Architecture Decision (`architecture-decision`)
**3 Agenten: Vergleich + Entscheidung**

```
Option A + Option B (parallel) → Decision Maker
```

## Enterprise Features

### Human-in-the-Loop

**Modi:**
- `interactive` — Fragt zwischen Phasen nach Genehmigung
- `auto` — Überspringt Genehmigung (für CI/CD)
- `file` — Speichert Anfragen in `.ai-workflows/pending_approvals.json`

**Beispiel (interactive):**
```
========================================
HUMAN APPROVAL REQUIRED: Phase 1 → 2
========================================
Task: Build a SaaS CRM
Completed agents:
  product: completed
  architect: completed

Approve Phase 1 → 2? [y/n]: 
```

### Quality Gates

**Standards:**
| Gate | Minimum | Prüfung |
|------|---------|---------|
| test_coverage | 80% | Unit + Integration Tests |
| security_score | 90/100 | OWASP + Compliance |
| code_quality | 85/100 | Clean Code + Patterns |
| no_critical_bugs | 0 | Bug Tracker |
| performance_score | 80/100 | Core Web Vitals |

**Bei FAIL:** Workflow stoppt oder fordert Human Approval

### Cost Tracking

**Preise (pro 1k Tokens):**
| Modell | Input | Output |
|--------|-------|--------|
| GPT-4 | $0.03 | $0.06 |
| GPT-4 Turbo | $0.01 | $0.03 |
| GPT-3.5 | $0.0015 | $0.002 |
| Claude Opus | $0.015 | $0.075 |

**Budget-Kontrolle:**
```bash
--max-cost 10.00    # Stop bei $10
--max-cost 50.00    # Stop bei $50 (Enterprise)
```

**Typische Kosten:**
- Feature Implementation: ~$1.56
- Complete Project: ~$3.51
- Security Review: ~$0.78

### Self-Healing

**Retry-Strategie:**
- Max 3 Versuche
- Exponentielles Backoff: 2s, 4s, 8s
- Fehler-Logging für Analyse

**Recovery Rate:**
```
Agent        | Attempts | Success
-------------|----------|--------
product      | 1        | 100%
architect    | 2        | 100%  ← Retry in 2s
developer    | 1        | 100%
security     | 3        | 100%  ← Retry in 2s + 4s
```

### Notifications

**Kanäle:**
```bash
--notify console    # Standard (Terminal)
--notify slack      # Slack Webhook
--notify discord    # Discord Webhook
--notify email      # SMTP
```

**Umgebungsvariablen:**
```bash
export SLACK_WEBHOOK="https://hooks.slack.com/..."
export DISCORD_WEBHOOK="https://discord.com/api/webhooks/..."
```

**Beispiel-Nachricht:**
```
Workflow Complete: complete-project

Task: Build a SaaS CRM
Status: completed
Duration: 0.0s
Agents: 9
Cost: $3.51

Next Steps:
- Review PRD and architecture
- Validate design system
- Run full test suite
```

## Workflow-Definitionen

Workflows sind JSON-Dateien mit folgender Struktur:

```json
{
  "name": "complete-project",
  "description": "Complete project with 8+ agents",
  "agents": [
    {
      "id": "product",
      "role": "product-manager",
      "prompt_file": "05-execution/prompts/product-manager.md",
      "task_template": "PRD: {task}",
      "priority": 1,
      "phase": 1,
      "depends_on": []
    }
  ],
  "merge_strategy": "phased",
  "output_format": "detailed",
  "quality_gates": {
    "test_coverage": {"min": 80},
    "security_score": {"min": 90},
    "code_quality": {"min": 85}
  }
}
```

### Merge Strategies

| Strategy | Beschreibung | Nutzung |
|----------|-------------|---------|
| **parallel** | Alle gleichzeitig | Security Review |
| **dependent** | Wartet auf Dependencies | Feature Implementation |
| **phased** | Phasen mit Gates + Approval | Complete Project |

## In OpenClaw nutzen

### Direkt im Chat:

```
"Baue ein komplettes Projekt mit AI-EKOS Multi-Agent Flow"
```

### Programmatisch:

```python
from scripts.orchestrator import AI_EKOS_Orchestrator

orchestrator = AI_EKOS_Orchestrator(
    ai_ekos_path=".",
    approval_mode="interactive",  # oder "auto", "file"
    max_cost=50.00,
    notify_config={
        'enabled': True,
        'channel': 'slack',
        'slack_webhook': os.environ.get('SLACK_WEBHOOK')
    }
)

workflow = orchestrator.load_workflow("complete-project")

result = orchestrator.execute_workflow(
    workflow=workflow,
    task="Build a SaaS CRM",
    tech_stack="nextjs,postgres,shadcn,stripe,ai"
)

print(f"Cost: ${result['cost_summary']['total_cost_usd']}")
print(f"Quality: {'PASS' if result['quality_gates']['overall_passed'] else 'FAIL'}")
```

## Ergebnisse

Nach Ausführung werden generiert:
- `output/orchestrator-report-{timestamp}.json` — Maschinenlesbar
- `output/orchestrator-report-{timestamp}.md` — Menschenlesbar (mit Cost, Quality Gates, Self-Healing)

## Vorteile

1. **Budget-Kontrolle** — Keine Überraschungen bei API-Kosten
2. **Qualitätsgarantie** — Gates verhindern schlechten Code
3. **Menschliche Kontrolle** — Pause zwischen kritischen Phasen
4. **Fehlertoleranz** — Retry bei Agenten-Fehlern
5. **Transparenz** — Notifications bei Start/Ende

## Agenten-Übersicht

| Agent | Rolle | Prompt | Nutzung |
|-------|-------|--------|---------|
| Product Manager | `product-manager` | `product-manager.md` | PRD, User Stories |
| Architect | `architect` | `architect.md` | System Design |
| Designer | `designer` | `designer.md` | UI/UX |
| Developer | `developer` | `developer.md` | Code |
| Tester | `developer` | `developer.md` | Tests |
| Security | `security` | `security.md` | Audit |
| Reviewer | `reviewer` | `reviewer.md` | Review |
| DevOps | `developer` | `developer.md` | Deploy |
| Performance | `developer` | `developer.md` | Optimierung |

## Version History

| Version | Datum | Features |
|---------|-------|----------|
| v1.0 | 2026-07-05 | 3 Workflows, basic orchestration |
| v2.0 | 2026-07-05 | 8 Workflows, 8+ agents, phased execution |
| v2.1 | 2026-07-05 | Human-in-the-Loop, Quality Gates, Cost Tracking, Self-Healing, Notifications |

## Enterprise Goals Status

| # | Ziel | Status |
|---|------|--------|
| 5 | Multi-Agent Flow | ✅ v2.1 mit 5 Enterprise Features |

## Weiterentwicklung

**Geplant für v2.2:**
- Workflow Chaining (complete-project → devops-deploy → performance-audit)
- Agent Performance Scoring
- Result Persistence (Datenbank)
- Parallel Execution Limits
- Agent Templates


## Verfügbare Workflows

### 1. Complete Project (`complete-project`) ⭐ NEU
**8+ Agenten in 5 Phasen**

**Phasen:**
```
Phase 1: Requirements & Architecture (parallel)
  ├── Product Manager → PRD, User Stories, MVP Scope
  └── Architect → Architecture Decision Record, Component Diagram

Phase 2: Design & Development (parallel)  
  ├── Designer → Design System, Component Library
  └── Developer → Production-Ready Code, Tests

Phase 3: Quality Assurance (parallel)
  ├── Tester → Unit, Integration, E2E Tests
  └── Security → OWASP Analysis, Vulnerability Report

Phase 4: Review & Deployment (parallel)
  ├── Reviewer → Code Quality, Approval
  └── DevOps → Docker, CI/CD, Monitoring

Phase 5: Final Validation
  └── Performance → Metrics, Optimization, Load Tests
```

**Ausführung:**
```bash
python scripts/orchestrator.py \
  --workflow complete-project \
  --task "Build a SaaS CRM" \
  --tech-stack nextjs,postgres,shadcn,stripe,ai
```

### 2. Feature Implementation (`feature-implementation`)
**4 Agenten mit Abhängigkeiten**

```
Architect → Developer → Security → Reviewer
```

**Ausführung:**
```bash
python scripts/orchestrator.py \
  --workflow feature-implementation \
  --task "Implement user authentication" \
  --tech-stack nextjs,postgres,shadcn
```

### 3. Security Review (`security-review`)
**2 Agenten parallel**

```
Security Analyzer + Compliance Checker (parallel)
```

### 4. Architecture Decision (`architecture-decision`)
**3 Agenten: Vergleich + Entscheidung**

```
Option A + Option B (parallel) → Decision Maker
```

### 5. Code Review (`code-review`) ⭐ NEU
**2 Agenten parallel**

```
Reviewer + Security (parallel)
```

### 6. Performance Audit (`performance-audit`) ⭐ NEU
**2 Agenten parallel**

```
Frontend Performance + Database Performance (parallel)
```

### 7. Accessibility Check (`accessibility-check`) ⭐ NEU
**1 Agent**

```
Accessibility Auditor → WCAG Compliance Report
```

### 8. DevOps Deploy (`devops-deploy`) ⭐ NEU
**2 Agenten parallel**

```
DevOps + Security (parallel)
```

## In OpenClaw nutzen

### Direkt in einem Chat:

```
"Baue ein komplettes Projekt mit AI-EKOS Multi-Agent Flow"
```

Der Orchestrator spawnt dann:
- Phase 1: Product Manager + Architect (parallel)
- Phase 2: Designer + Developer (parallel)
- Phase 3: Tester + Security (parallel)
- Phase 4: Reviewer + DevOps (parallel)
- Phase 5: Performance Auditor

### Programmatisch:

```python
from scripts.orchestrator import AI_EKOS_Orchestrator

orchestrator = AI_EKOS_Orchestrator(ai_ekos_path=".")
workflow = orchestrator.load_workflow("complete-project")

result = orchestrator.execute_workflow(
    workflow=workflow,
    task="Build a SaaS CRM",
    tech_stack="nextjs,postgres,shadcn,stripe,ai"
)

print(result['consolidated_output'])
```

## Workflow-Definitionen

Workflows sind JSON-Dateien mit folgender Struktur:

```json
{
  "name": "complete-project",
  "description": "Complete project with 8+ agents in phased execution",
  "agents": [
    {
      "id": "product",
      "role": "product-manager",
      "prompt_file": "05-execution/prompts/product-manager.md",
      "task_template": "Define requirements for: {task}",
      "priority": 1,
      "phase": 1,
      "depends_on": []
    }
  ],
  "merge_strategy": "phased",
  "output_format": "detailed"
}
```

### Merge Strategies

| Strategy | Beschreibung | Nutzung |
|----------|-------------|---------|
| **parallel** | Alle Agents gleichzeitig | Security Review |
| **dependent** | Wartet auf Abhängigkeiten | Feature Implementation |
| **phased** | Gruppiert in Phasen | Complete Project |

## Ergebnisse

Nach Ausführung werden generiert:
- `output/orchestrator-report-{timestamp}.json` — Maschinenlesbar
- `output/orchestrator-report-{timestamp}.md` — Menschenlesbar

## Vorteile

- **8x Experten-Wissen** — Jeder Agent ist Spezialist
- **Phasierte Ausführung** — Logische Reihenfolge, maximale Parallelisierung
- **Qualitätsgarantie** — Security, Review, Performance eingebaut
- **Spurbar** — Alle Entscheidungen dokumentiert
- **Skalierbar** — Neue Workflows einfach hinzufügen

## Agenten-Übersicht

| Agent | Rolle | Prompt | Nutzung |
|-------|-------|--------|---------|
| Product Manager | `product-manager` | `product-manager.md` | PRD, User Stories |
| Architect | `architect` | `architect.md` | System Design |
| Designer | `designer` | `designer.md` | UI/UX |
| Developer | `developer` | `developer.md` | Implementierung |
| Tester | `developer` | `developer.md` | Tests |
| Security | `security` | `security.md` | Security Audit |
| Reviewer | `reviewer` | `reviewer.md` | Code Review |
| DevOps | `developer` | `developer.md` | Deployment |
| Performance | `developer` | `developer.md` | Performance Audit |

## Erweiterung

Neue Workflows hinzufügen:

1. JSON-Datei in `.ai-workflows/` erstellen
2. Agent-Definitionen mit Rollen, Phasen und Abhängigkeiten
3. Merge-Strategie wählen (parallel, dependent, phased)
