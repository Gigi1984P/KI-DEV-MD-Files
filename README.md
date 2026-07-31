# KI-DEV MD-Files

Zentrale Markdown-Dokumentation für AI-Agenten und Engineering-Workflows.

## Struktur

```
workspace/
  AI-EKOS/                    # Haupt-Knowledge-Base
    01-foundation/            # Identity, Principles, Standards
    02-platform/              # Technical Platform
    03-products/              # Product Specs & Architecture
    04-playbooks/             # Operational Playbooks
    05-execution/             # Prompts, Rules, Patterns, Templates, Boilerplates
    06-decision-engine/       # Decision Frameworks
    07-patterns/              # Design Patterns (Problem, Solution, Context)
      _templates/             # Einmalige Templates für neue Patterns
    08-recipes/               # Step-by-Step Guides
    09-boilerplates/          # Starter Code
    archive/                  # Deprecated & Legacy
  memory/                     # Tägliche Logs (YYYY-MM-DD.md)
  projects/                   # Projekt-spezifische Docs
    plantone-website/
    plantone-multilang/
  archive/                    # Archivierte Systeme
    AI-CTO-OS-deprecated/
  agents.md                   # Verhaltensregeln für AI-Agenten
  soul.md                     # Kernwerte & Persönlichkeit
  user.md                     # User-Kontext
  tools.md                    # Tool-Konfiguration
  heartbeat.md                # Proaktive Checkliste
```

## Konventionen

- **Naming:** kebab-case (klein, Bindestriche)
- **Encoding:** UTF-8
- **Line Endings:** Unix (LF)
- **Format:** Markdown (.md)

### Ausnahmen (Standard-Dateien)

- `README.md` — Verzeichnis-Beschreibung
- `CHANGELOG.md` — Versions-Historie
- `LICENSE.md` — Lizenz
- `CONTRIBUTING.md` — Contribution Guidelines
- `CODE_OF_CONDUCT.md` — Verhaltensregeln

## History

- **2026-07-31:** Major Cleanup — httpdocs/ entfernt (Duplikat), AI-CTO-OS/ archiviert, Naming-Konventionen vereinheitlicht, Pattern-Boilerplate konsolidiert
- **2026-07-12:** OpenClaw-Dateien entfernt
- **2026-06:** Initialer Export aus produktivem Workspace

## Letzter Sync

2026-07-31
