# AI-EKOS Integration Guide

## Status: 🔄 IMPLEMENTIERT — Test erforderlich

## Unterstützte Tools

| Tool | Integration | Status | Datei |
|------|-------------|--------|-------|
| **Cursor** | `.cursorrules` | ✅ Getestet | `test-ai-ekos/.cursorrules` |
| **Claude Code** | `CLAUDE.md` | ✅ Erstellt | `05-execution/prompts/CLAUDE.md` |
| **Codex** | `.codex/config.json` | ✅ Erstellt | `.codex/config.json` |
| **Windsurf** | `.windsurfrules` | ✅ Erstellt | `.windsurfrules` |
| **OpenClaw** | Native | ✅ Live | `ai-context.md` |

---

## 1. Cursor ✅

### Setup
```bash
# Im Projekt-Root
cp AI-EKOS/05-execution/prompts/.cursorrules.example .cursorrules
```

### Funktionsweise
- Lädt AI-EKOS `ai-context.md` beim Start
- Verwendet Role-Specific Prompts aus `05-execution/prompts/`
- Nutzt Rules aus `05-execution/rules/`

### Getestet
- ✅ Next.js App mit Server Components
- ✅ Drizzle ORM Schema
- ✅ Zod Validierung
- ✅ shadcn/ui Komponenten

---

## 2. Claude Code

### Setup
```bash
# Claude Code CLI installieren
npm install -g @anthropic-ai/claude-code

# Im Projekt-Root
cp AI-EKOS/05-execution/prompts/CLAUDE.md CLAUDE.md
```

### Funktionsweise
- Claude liest `CLAUDE.md` beim Start
- Lädt Role-Prompts und Rules automatisch
- Nutzt `/agent` für Multi-Agent Flow

### CLAUDE.md Inhalt
```markdown
# AI-EKOS Context for Claude Code

Load: ai-context.md
Load: 05-execution/prompts/architect.md (for design tasks)
Load: 05-execution/prompts/developer.md (for coding tasks)
Load: 05-execution/prompts/security.md (for security tasks)

## Commands
- `/arch` → Load architect prompt
- `/dev` → Load developer prompt  
- `/sec` → Load security prompt
- `/multi` → Start multi-agent workflow
```

---

## 3. Codex (OpenAI)

### Setup
```bash
# Im Projekt-Root
mkdir -p .codex
cp AI-EKOS/05-execution/prompts/codex-config.json .codex/config.json
```

### Funktionsweise
- Codex liest `.codex/config.json` beim Start
- Lädt AI-EKOS Context automatisch
- Nutzt `openclaw-agent-runtime` für Multi-Agent

### .codex/config.json Inhalt
```json
{
  "context": {
    "ai_ekos": {
      "path": "./AI-EKOS",
      "auto_load": true,
      "role_prompts": "05-execution/prompts/",
      "rules": "05-execution/rules/"
    }
  },
  "commands": {
    "architect": "Load AI-EKOS architect prompt",
    "developer": "Load AI-EKOS developer prompt",
    "security": "Load AI-EKOS security prompt",
    "multi": "Start multi-agent workflow"
  }
}
```

---

## 4. Windsurf (Codeium)

### Setup
```bash
# Im Projekt-Root
cp AI-EKOS/05-execution/prompts/.windsurfrules.example .windsurfrules
```

### Funktionsweise
- Windsurf liest `.windsurfrules` beim Start
- Ähnlich wie `.cursorrules`
- Lädt AI-EKOS Context und Rules

### .windsurfrules Inhalt
```markdown
# AI-EKOS Context for Windsurf

## System
Load: AI-EKOS/ai-context.md

## Roles
- Architect: AI-EKOS/05-execution/prompts/architect.md
- Developer: AI-EKOS/05-execution/prompts/developer.md
- Security: AI-EKOS/05-execution/prompts/security.md

## Rules
- Next.js: AI-EKOS/05-execution/rules/nextjs/
- PostgreSQL: AI-EKOS/05-execution/rules/postgres/
- Stripe: AI-EKOS/05-execution/rules/stripe/
```

---

## 5. OpenClaw ✅ (Native)

Bereits vollständig integriert:
- `ai-context.md` wird bei jedem Start geladen
- Multi-Agent Flow mit `sessions_spawn`
- Email Notifications
- Quality Gates

---

## Multi-Agent Flow Integration

### Für alle Tools gleich:

```
User: "Implementiere Auth-System"
    ↓
Orchestrator lädt Workflow-Definition
    ↓
Phase 1: Architect + Product Manager (parallel)
    ↓
Phase 2: Designer + Developer (parallel)
    ↓
Phase 3: Tester + Security (parallel)
    ↓
Phase 4: Reviewer + DevOps (parallel)
    ↓
Phase 5: Performance Auditor
    ↓
Consolidated Report + Email Notification
```

---

## Test-Checkliste

| Tool | Getestet | Funktioniert | Notizen |
|------|----------|-------------|---------|
| Cursor | ✅ | ✅ | Test-Projekt gebaut |
| Claude Code | 🔄 | - | Warte auf Claude Account |
| Codex | 🔄 | - | Warte auf API Key |
| Windsurf | 🔄 | - | Warte auf Installation |
| OpenClaw | ✅ | ✅ | Vollständig |

---

## Nächste Schritte

1. **Claude Code** testen (Account erforderlich)
2. **Codex** testen (API Key erforderlich)
3. **Windsurf** testen (Installation erforderlich)

---

*Erstellt: 2026-07-05*
