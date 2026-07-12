# AI-EKOS — AI Engineering Knowledge Operating System

**Version 2.1.0** | **Production-Ready** | **8/8 Enterprise Goals**

> Ein Enterprise-Grade, rollenbasiertes Wissens-Repository für KI-Agenten (Cursor, Claude, Codex, Windsurf, OpenClaw) und Entwicklerteams.

---

## 🚀 Quick Start

```bash
# 1. Repository klonen
git clone https://github.com/plantone/ai-ekos.git
cd ai-ekos

# 2. Für dein Projekt: Agent-Konfiguration kopieren
cp 05-execution/prompts/.cursorrules.example ../mein-projekt/.cursorrules

# 3. Multi-Agent Workflow starten
python scripts/orchestrator.py \
  --workflow complete-project \
  --task "Baue ein SaaS CRM mit Auth und Analytics" \
  --approval-mode interactive \
  --notify email
```

---

## 📊 Enterprise Goals — 8/8 Complete ✅

| # | Ziel | Status | File |
|---|------|--------|------|
| 1 | **Code-Validierung** | ✅ | `scripts/validate-code.py` |
| 2 | **Automatisierung** | ✅ | `.github/workflows/validate-content.yml` |
| 3 | **Versionierung** | ✅ | `VERSION.md` (SemVer) |
| 4 | **Qualitätsmetriken** | ✅ | `scripts/usage-analytics.py` |
| 5 | **Multi-Agent Flow** | ✅ | `scripts/orchestrator.py` |
| 6 | **Integration** | ✅ | `docs/INTEGRATION.md` |
| 7 | **Rollen-Sichten** | ✅ | `START-here-*.md` |
| 8 | **Feedback-Loop** | ✅ | `scripts/feedback-loop.py` |

---

## 🏗️ Architektur

```
AI-EKOS/
├── 01-identity/           # Identität, Vision, Prinzipien
├── 02-communication/      # Kommunikationsstandards, Prompts
├── 03-knowledge-base/     # Tech-Stack Docs (Next.js, Postgres, Stripe, AI)
├── 04-strategy/           # Strategie, Roadmap, KPIs
├── 05-execution/          # Prompts, Rules, Checklists für Agenten
│   ├── prompts/           # Rollen-Spezifische Prompts
│   │   ├── architect.md
│   │   ├── developer.md
│   │   ├── security.md
│   │   └── ...
│   ├── rules/             # Technologie-Regeln
│   │   ├── nextjs/
│   │   ├── postgres/
│   │   ├── stripe/
│   │   └── ai/
│   └── checklists/        # Deployment, Security, Code Review
├── 06-decision-engine/    # Architekturentscheidungen, ADRs
├── 07-patterns/           # Design Patterns (14 vollständige Patterns)
├── 08-growth/             # Analytics, SEO, Performance
└── scripts/               # Automatisierung
    ├── orchestrator.py      # Multi-Agent Orchestrator
    ├── feedback-loop.py     # Code-Qualitätsanalyse
    ├── validate-code.py     # Syntax-Validierung
    ├── usage-analytics.py   # Nutzungsanalyse
    └── ...
```

---

## 🤖 Multi-Agent Flow

### Workflows

| Workflow | Agenten | Beschreibung |
|----------|---------|-------------|
| `complete-project` | 9 | Vollständige Software-Entwicklung (5 Phasen) |
| `feature-implementation` | 4 | Feature mit Design + Dev + Test + Security |
| `security-review` | 2 | Paralleler Security-Audit |
| `architecture-decision` | 3 | ADR mit Research + Review |
| `code-review` | 2 | Paralleler Code-Review |
| `performance-audit` | 2 | Performance + DB-Optimierung |
| `accessibility-check` | 1 | A11y-Compliance |
| `devops-deploy` | 2 | Deployment + Monitoring |

### Agenten-Rollen

| Rolle | Prompt File | Aufgabe |
|-------|-------------|---------|
| Product Manager | `product-manager.md` | Requirements, User Stories |
| Architect | `architect.md` | System Design, ADRs |
| Designer | `designer.md` | UX/UI, Komponenten |
| Developer | `developer.md` | Code, Tests |
| Tester | `developer.md` | QA, Testpläne |
| Security | `security.md` | OWASP, Audit |
| Reviewer | `reviewer.md` | Code Review |
| DevOps | `developer.md` | CI/CD, Deploy |
| Performance | `developer.md` | Optimierung |

---

## ✨ Enterprise Features

### 1. Human-in-the-Loop
- **interactive**: Nutzer muss jede Phase bestätigen
- **auto**: Automatisch für CI/CD
- **file**: Asynchron über Datei

### 2. Quality Gates
- Min. 80% Test Coverage
- Min. 90/100 Security Score
- Min. 85/100 Code Quality
- 0 Critical Bugs
- Min. 80/100 Performance Score

### 3. Cost Tracking
- Pro-Agent Token-Schätzung
- Budget-Limits (`--max-cost 50.00`)
- Modell-spezifische Preise (GPT-4, GPT-3.5, Claude)

### 4. Self-Healing
- 3 Retry-Versuche
- Exponentielles Backoff (2s, 4s, 8s)
- Failure-Logging mit Recovery-Rate

### 5. Notifications
- **Console** (Default)
- **Email** via Hetzner SMTP (live)
- **Slack** Webhook
- **Discord** Webhook

---

## 📧 Email Notifications

**Status:** ✅ Live (getestet 05.07.2026)

```bash
python scripts/test-email.py gianluigi.plantone@gmail.com
```

**Konfiguration:** `scripts/config/notifications.env`
```
SMTP_HOST=mail.plantone.de
SMTP_PORT=587
SMTP_USER=ki-dev@plantone.de
SMTP_PASS=***
SMTP_FROM=AI-EKOS Orchestrator <ki-dev@plantone.de>
```

---

## 🔧 Integration

### Unterstützte Tools

| Tool | Konfiguration | Status |
|------|--------------|--------|
| **Cursor** | `.cursorrules` | ✅ Getestet |
| **OpenClaw** | `ai-context.md` | ✅ Live |
| **Claude Code** | `CLAUDE.md` | 🔄 Erstellt |
| **Codex** | `.codex/config.json` | 🔄 Erstellt |
| **Windsurf** | `.windsurfrules` | 🔄 Erstellt |

**Setup:** Siehe `docs/INTEGRATION.md`

---

## 📈 Feedback-Loop

```bash
# Code-Qualität analysieren
python scripts/feedback-loop.py --project-path ./mein-projekt

# Ergebnis: Quality Score + Grade + Empfehlungen
```

**Ergebnis:**
- Overall Score: 0-100
- Grade: A (90+), B (80+), C (70+), D (60+), F (<60)
- Suggestions: Critical / Warning / Info
- Trends: Über Zeit tracken

---

## 📋 Nutzung

### Für Entwickler

```bash
# 1. START-here lesen
cat 05-execution/prompts/START-here-developer.md

# 2. Rules laden
source 05-execution/rules/nextjs/architecture.md

# 3. Checkliste vor Deploy
cat 05-execution/checklists/deployment.md
```

### Für Architekten

```bash
# 1. START-here lesen
cat 06-decision-engine/START-here-architect.md

# 2. Pattern auswählen
cat 07-patterns/authentication/Solution.md

# 3. ADR erstellen
cat 06-decision-engine/adr/template.md
```

### Für AI Engineers

```bash
# 1. START-here lesen
cat 05-execution/prompts/START-here-ai-engineer.md

# 2. Multi-Agent Flow starten
python scripts/orchestrator.py \
  --workflow feature-implementation \
  --task "Implementiere OAuth2 mit Next.js"
```

---

## 🔄 Automatisierung

### CI/CD Pipeline

```yaml
# .github/workflows/validate-content.yml
name: Validate AI-EKOS Content
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate Code
        run: python scripts/validate-code.py
      - name: Check Links
        run: python scripts/check-links.py
      - name: Analytics
        run: python scripts/usage-analytics.py
```

### Daily Tasks

```bash
# Code validieren
python scripts/validate-code.py

# Links prüfen
python scripts/check-links.py

# Nutzung analysieren
python scripts/usage-analytics.py

# Code-Qualität checken
python scripts/feedback-loop.py --project-path ./projekt

# Tech-Versionen checken
python scripts/tech-version-tracker.py
```

---

## 📊 Statistiken

```
Files:          422+ Markdown
Directories:    130+
Prompts:        8 Agenten-Rollen
Rules:          60+ Tech-Regeln
Patterns:       14 vollständige Patterns
Checklists:     8
Boilerplates:   8
Build Recipes:  10
Document Templates: 10
```

---

## 🛠️ Entwicklung

### Requirements
- Python 3.8+ (nur Standard-Library)
- Git
- Optional: Node.js (für Next.js/TypeScript Projekte)

### Tests

```bash
# Orchestrator testen
python scripts/orchestrator.py --workflow feature-implementation \
  --task "Test feature" --approval-mode auto

# Email testen
python scripts/test-email.py deine@email.de

# Feedback-Loop testen
python scripts/feedback-loop.py --project-path ./test-ai-ekos
```

---

## 🤝 Contribution

Siehe `CONTRIBUTING.md`

1. Fork erstellen
2. Branch: `feature/deine-änderung`
3. Änderungen committen
4. Pull Request erstellen
5. CI/CD Pipeline prüft automatisch

---

## 📚 Weiterführende Links

| Dokument | Zweck |
|----------|-------|
| `ai-context.md` | Master Context für alle Agenten |
| `SUMMARY.md` | Master Index (408 Dateien) |
| `VERSION.md` | Changelog & Release History |
| `MANIFEST.md` | Repository Statistiken |
| `docs/INTEGRATION.md` | Tool-Integrationsanleitung |
| `docs/EMAIL_SETUP.md` | Email-Konfiguration |
| `UPDATE_PROCESS.md` | Wartung & Updates |
| `AI-EKOS-PROJECT-SUMMARY.md` | Gesamtprojekt-Übersicht |

---

## 🎯 Nächste Schritte

1. **Integration testen**: Claude, Codex, Windsurf (Accounts/API Keys nötig)
2. **Feedback-Loop**: Täglich für Trend-Analyse
3. **Patterns erweitern**: Event Sourcing, CQRS
4. **Community**: Contributions annehmen

---

## 📄 Lizenz

MIT License — Siehe `LICENSE`

---

**Entwickelt von:** [Gianluigi Plantone](https://plantone.de)  
**Version:** 2.1.0  
**Letztes Update:** 2026-07-05  
**Status:** Production-Ready ✅

---

*Für Fragen oder Support: ki-dev@plantone.de*
