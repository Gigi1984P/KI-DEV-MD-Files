# AI-EKOS Projekt-Initiierungs-Prompt

Dieses Prompt-Template wird verwendet, wenn ein neues Projekt über das Dashboard oder per Chat gestartet wird. Es wird automatisch an den OpenClaw Agenten weitergegeben.

---

## 🎯 PROJEKT DEFINITION

**Projektname:** {PROJECT_NAME}
**Beschreibung:** {PROJECT_DESCRIPTION}
**Ziel:** {PROJECT_GOAL}
**Zielgruppe:** {TARGET_AUDIENCE}
**Zeitrahmen:** {TIMEFRAME}

---

## 🛠️ TECHNOLOGIE-STACK

**Frontend:** {FRONTEND}
**Backend:** {BACKEND}
**Datenbank:** {DATABASE}
**Styling:** {STYLING}
**State Management:** {STATE_MANAGEMENT}
**API-Format:** {API_FORMAT}
**Hosting:** {HOSTING}
**CI/CD:** {CI_CD}

---

## 📚 AI-EKOS KNOWLEDGE BASE

Das Repository befindet sich unter: `/data/.openclaw/workspace/AI-EKOS/`

### Wichtige Dateien:
- **ai-context.md** — Master Prompt mit allen Regeln
- **05-execution/rules/** — Coding Standards pro Technologie
- **05-execution/patterns/** — Wiederverwendbare Patterns
- **05-execution/checklists/** — Qualitäts-Checklisten
- **07-patterns/** — Architektur-Patterns

### Für dieses Projekt relevant:
```
{RELEVANT_RULES}
```

---

## 🎭 MULTI-AGENT ORCHESTRATION

Verwende folgende Agenten für das Projekt:

1. **Product Manager** — Erstellt User Stories & Requirements
2. **Architect** — Definiert Architektur & Datenbankschema
3. **Designer** — Erstellt Mockups & Design-System
4. **Developer** — Implementiert Features
5. **Security** — Prüft Security & Auth
6. **Tester** — Schreibt Tests
7. **Reviewer** — Code Review
8. **DevOps** — Deployment

**Workflow:** `complete-project` oder `feature-implementation`

---

## ✅ QUALITÄTSANFORDERUNGEN

- [ ] Alle Features getestet (Unit + Integration)
- [ ] Security Review bestanden
- [ ] Performance Budget eingehalten (< 3s LCP)
- [ ] Accessibility Score > 90
- [ ] Code Coverage > 80%
- [ ] Dokumentation vollständig

---

## 🚀 DEPLOYMENT

**Ziel-Umgebung:** {DEPLOYMENT_TARGET}
**Domain:** {DOMAIN}
**SSL:** {SSL_CONFIG}
**Backup-Strategie:** {BACKUP_STRATEGY}

---

## 📊 DASHBOARD INTEGRATION

Erstelle das Projekt im AI-EKOS Dashboard:
- **URL:** https://ekos.plantone.de/
- **Projekt anlegen** über die API oder manuell
- **Tasks automatisch im Kanban** anlegen
- **Freigaben** über das Dashboard abwickeln

---

## 📝 BESONDERE ANFORDERUNGEN

{SPECIAL_REQUIREMENTS}

---

## 💰 BUDGET

**Geschätzte Kosten:** {ESTIMATED_COST}
**Token-Limit:** {TOKEN_LIMIT}
**Zeit-Budget:** {TIME_BUDGET}

---

## 🔗 EXTERNE RESOURCEN

**Design-Mockups:** {DESIGN_LINK}
**API-Dokumentation:** {API_DOCS}
**Third-Party Services:** {THIRD_PARTY}

---

## 🎬 STARTBEFEHLE

```bash
# Projekt initialisieren
mkdir {PROJECT_NAME} && cd {PROJECT_NAME}
git init

# AI-EKOS Context kopieren
cp /data/.openclaw/workspace/AI-EKOS/ai-context.md .
cp -r /data/.openclaw/workspace/AI-EKOS/05-execution/rules ./.rules

# Projekt nach Tech-Stack initialisieren
{INIT_COMMANDS}

# Erste Agenten starten
openclaw workflow start complete-project --project={PROJECT_NAME}
```

---

**Erstellt am:** {DATE}
**Erstellt von:** {CREATOR}
**Version:** 1.0
