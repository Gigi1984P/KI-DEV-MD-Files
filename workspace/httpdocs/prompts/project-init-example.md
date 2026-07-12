# AI-EKOS Projekt: CRM-Pro

## 🎯 PROJEKT DEFINITION

**Projektname:** CRM-Pro
**Beschreibung:** Ein modernes CRM-System für Mittelständler mit Kundenverwaltung, Pipeline-Management und automatisierten Workflows.
**Ziel:** Produktives CRM innerhalb von 2 Wochen
**Zielgruppe:** Mittelständische Unternehmen (50-500 Mitarbeiter)
**Zeitrahmen:** 2 Wochen MVP, 4 Wochen v1.0

---

## 🛠️ TECHNOLOGIE-STACK

**Frontend:** Next.js 14 (App Router) + TypeScript
**Backend:** Next.js API Routes + Server Actions
**Datenbank:** PostgreSQL (Hetzner)
**Styling:** Tailwind CSS + shadcn/ui
**State Management:** Zustand + React Query
**API-Format:** REST + tRPC
**Hosting:** Hetzner (Shared Hosting / Cloud)
**CI/CD:** GitHub Actions

---

## 📚 AI-EKOS KNOWLEDGE BASE

Das Repository befindet sich unter: `/data/.openclaw/workspace/AI-EKOS/`

### Für dieses Projekt relevant:
```
05-execution/rules/nextjs/
  - architecture.md
  - server-components.md
  - server-actions.md
  - patterns.md

05-execution/rules/postgres/
  - multi-tenancy.md
  - query-planning.md
  - transactions.md
  - indexes.md

05-execution/patterns/
  - authentication/
  - authorization/
  - service/

05-execution/checklists/
  - security.md
  - deployment.md
  - code-review.md
```

---

## 🎭 MULTI-AGENT ORCHESTRATION

**Workflow:** `complete-project`
**Agenten:** Product Manager → Architect → Designer → Developer → Security → Tester → Reviewer → DevOps

---

## ✅ QUALITÄTSANFORDERUNGEN

- [ ] Alle Features getestet (Jest + React Testing Library)
- [ ] Security Review (OWASP Top 10)
- [ ] Performance: LCP < 2.5s
- [ ] Accessibility: WCAG 2.1 AA
- [ ] Code Coverage > 80%
- [ ] API-Dokumentation (OpenAPI/Swagger)

---

## 🚀 DEPLOYMENT

**Ziel-Umgebung:** Hetzner Shared Hosting (plantone.de)
**Domain:** crm.plantone.de
**SSL:** Let's Encrypt (Auto-Renewal)
**Backup:** Täglich 03:00 Uhr (Hetzner Backup)

---

## 📊 DASHBOARD INTEGRATION

**URL:** https://ekos.plantone.de/

Erstelle automatisch:
1. Projekt "CRM-Pro" im Dashboard
2. Kanban-Tasks:
   - Setup Next.js + PostgreSQL
   - Auth-System (NextAuth.js)
   - Kunden-Datenbank Schema
   - UI Komponenten (shadcn/ui)
   - Pipeline Management
   - Dashboard/Reporting
   - Testing & Review
   - Deployment

---

## 📝 BESONDERE ANFORDERUNGEN

- Multi-Tenancy Support (mehrere Firmen)
- Deutsche Datenschutz-Compliance (DSGVO)
- Export nach Excel/PDF
- E-Mail-Integration (IMAP/SMTP)
- Rollen-basierte Berechtigungen

---

## 💰 BUDGET

**Geschätzte Kosten:** ~$50 (API Calls)
**Token-Limit:** 2M Tokens
**Zeit-Budget:** 40 Agent-Stunden

---

## 🔗 EXTERNE RESOURCEN

**Design-Mockups:** Figma (wird von Designer-Agent erstellt)
**API-Dokumentation:** OpenAPI Spec (auto-generiert)
**Third-Party:**
- Stripe (Zahlungen)
- Resend (E-Mail)
- Hetzner (Hosting)

---

## 🎬 STARTBEFEHLE

```bash
# Projekt initialisieren
mkdir crm-pro && cd crm-pro
git init

# AI-EKOS Context kopieren
cp /data/.openclaw/workspace/AI-EKOS/ai-context.md .
cp -r /data/.openclaw/workspace/AI-EKOS/05-execution/rules ./.rules

# Next.js initialisieren
npx create-next-app@latest . --typescript --tailwind --app --no-src-dir

# Datenbank
npx prisma init
# Schema in prisma/schema.prisma

# Dashboard API
# POST https://ekos.plantone.de/api/create-project
# Body: { "name": "CRM-Pro", "stack": "nextjs", "priority": "high" }

# Workflow starten
openclaw workflow start complete-project --project=crm-pro
```

---

**Erstellt am:** 2026-07-05
**Erstellt von:** OpenClaw Agent (AI-EKOS v3.7)
**Version:** 1.0
