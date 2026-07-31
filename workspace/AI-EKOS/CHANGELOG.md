---
summary: "Änderungshistorie im Keep a Changelog Format"
---

# Changelog

Alle Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und das Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

## [2026-07-31]

### Added
- Frontmatter für 183 Dateien (tags, summary, read_when)
- Konfliktprüfung für Agent-Verhalten (`conflict-check.md`)
- Projektspezifische Dokumentation für 6 Produkte (03-products/)
- GitHub Actions Workflow für automatische MANIFEST.md Regenerierung

### Changed
- Kebab-case-Konvention für alle Dateinamen (259 Umbenennungen)
- Workspace-Struktur: Projekte in `projects/`, Agenten in `projects/ki-agent/`
- Knowledge Base projektunabhängig gemacht (plantone/AI-CTO-OS archiviert)
- Jahreszahlen von 2024 → 2026 aktualisiert

### Removed
- `httpdocs/` — komplette 1:1-Kopie von AI-EKOS (416 Dateien)
- 82 generische Pattern-Boilerplate-Dateien in `07-patterns/`
- 36 generische Template-Dateien in `03-products/` (vision, api, architecture, roadmap, kpis, database)
- 173 leere Meta-Dateien in archive/AI-CTO-OS-deprecated/
- `test-ai-ekos/` und `backups/` temporäre Verzeichnisse
- Leere Meta-Dateien: LICENSE.md, CODE_OF_CONDUCT.md, CONTRIBUTING.md, ROADMAP.md, SUMMARY.md, MANIFEST.md, consistency-report.md, update-process.md

### Fixed
- Broken Links in `05-execution/examples/` korrigiert
- Naming-Konvention (kebab-case) durchgesetzt
- Pattern-Überschreibungen dokumentiert

## [2026-06-05] - OpenClaw Bereinigung

### Removed
- Alle OpenClaw-bezogenen Dateien entfernt
