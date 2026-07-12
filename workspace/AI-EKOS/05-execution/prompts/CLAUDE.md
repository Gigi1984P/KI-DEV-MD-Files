# AI-EKOS Context for Claude Code

## Quick Start

```bash
# Claude Code startet in einem Projekt
cd mein-projekt
claude

# Claude lädt automatisch CLAUDE.md
```

## AI-EKOS Integration

### Context Loading

Claude Code lädt diese Dateien automatisch:

1. **Global Context:** `AI-EKOS/ai-context.md`
2. **Role Prompts:** `AI-EKOS/05-execution/prompts/{role}.md`
3. **Rules:** `AI-EKOS/05-execution/rules/{tech}/`
4. **Patterns:** `AI-EKOS/07-patterns/{pattern}/`

### Slash Commands

| Command | Beschreibung | Lädt |
|---------|-------------|------|
| `/arch` | Architektur-Modus | `architect.md` + `patterns/` |
| `/dev` | Entwickler-Modus | `developer.md` + `rules/` |
| `/sec` | Security-Modus | `security.md` + `security-rules/` |
| `/review` | Review-Modus | `reviewer.md` + `checklists/` |
| `/multi` | Multi-Agent Flow | Startet vollständigen Workflow |

### Beispiele

```bash
# Feature implementieren
/dev
> Implementiere ein Login-System mit Next.js und PostgreSQL

# Security Review
/sec
> Reviewe die Authentication für OWASP Compliance

# Multi-Agent Flow
/multi
> Baue ein komplettes CRM mit AI-EKOS

# Architecture Decision
/arch
> Soll ich Microservices oder Monolith verwenden?
```

## Rollen

### Architect
```
Role: AI-EKOS Architect
Knowledge: ai-context.md → patterns/ → decision-engine/
Output: Architecture Decision Records, Component Diagrams
```

### Developer
```
Role: AI-EKOS Developer
Knowledge: ai-context.md → rules/ → examples/
Output: Production Code, Tests, Documentation
```

### Security
```
Role: AI-EKOS Security Engineer
Knowledge: ai-context.md → security-rules/ → patterns/auth/
Output: Security Audit, Vulnerability Report
```

## Multi-Agent Flow

Claude Code unterstützt Multi-Agent Flow via `agent` command:

```bash
# Startet parallele Agenten
claude agent start architect developer security

# Konsolidiert Ergebnisse
claude agent consolidate
```

**Status:** 🔄 Warte auf Claude Code Multi-Agent Support

## Konfiguration

```json
{
  "ai_ekos": {
    "path": "./AI-EKOS",
    "auto_load": true,
    "default_role": "developer",
    "multi_agent": {
      "enabled": true,
      "max_agents": 4,
      "approval_mode": "interactive"
    }
  }
}
```

## Troubleshooting

### Problem: Context zu lang
**Lösung:** Nutze Role-Specific Prompts statt ai-context.md

```bash
# Statt
claude --load AI-EKOS/ai-context.md

# Besser
claude --role developer --task "Implement feature"
```

### Problem: Rules nicht gefunden
**Lösung:** Prüfe AI-EKOS Pfad

```bash
# Teste Pfad
ls AI-EKOS/05-execution/prompts/developer.md

# Falls nicht vorhanden, klone Repository
git clone https://github.com/plantone/ai-ekos.git
```

## Ressourcen

- AI-EKOS Repository: `AI-EKOS/`
- Integration Guide: `AI-EKOS/docs/INTEGRATION.md`
- Multi-Agent Flow: `AI-EKOS/.ai-workflows/README.md`

---

*Für Claude Code v0.5+*
