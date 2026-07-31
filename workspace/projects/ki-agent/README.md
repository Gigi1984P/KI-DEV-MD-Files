---
tags:
  - agent
  - core
  - index
summary: "KI-Agent Identity & Configuration: projektunabhängige Verhaltensregeln, Soul, User, Tools, Konfliktprüfung"
read_when:
  - "Session boot"
  - "New agent initialization"
  - "Bootstrapping a workspace manually"
---

# KI-Agent Identity & Configuration

Dieser Ordner enthält die **Kern-Persona** des AI-Agenten sowie seine Konfiguration. Er wird bei jedem Session-Start gelesen und definiert, wer der Agent ist und wie er handelt.

## Dateien

### Identität & Persona

| Datei | Zweck | Frontmatter-Tags |
|-------|-------|------------------|
| `agents.md` | Verhaltensregeln, Safety, Group-Chat-Etikette | `agent`, `core`, `boot` |
| `soul.md` | Kernwerte, Persönlichkeit, Vibe | `agent`, `core`, `personality` |
| `user.md` | User-Profil, Präferenzen, Kontext | `agent`, `core`, `user-context` |

### Arbeitsweise

| Datei | Zweck | Frontmatter-Tags |
|-------|-------|------------------|
| `tools.md` | Tool-Konfiguration (Kamera, SSH, Voice) | `agent`, `core`, `tools` |
| `heartbeat.md` | Proaktive Checkliste (wann handeln, wann warten) | `agent`, `core`, `proactive` |
| `conflict-check.md` | **Neu:** Konfliktprüfung bei KB-Abweichungen | `agent`, `workflow`, `conflict-resolution` |

### Projekt-Notizen

| Datei | Zweck |
|-------|-------|
| `memory.md` | Welche Erinnerungen persistent gespeichert werden |
| `fiktive-namen-firmen.md` | Fiktive Namen für Demos und Testdaten |
| `supabase-ci-implementiert.md` | Implementierungsnotizen zu Supabase CI |
| `terminbuchung-implementiert.md` | Implementierungsnotizen zur Terminbuchung |

## Boot-Sequenz

Beim Start einer Session muss der Agent folgende Dateien in dieser Reihenfolge lesen:

1. **`soul.md`** — Wer bin ich?
2. **`user.md`** — Wem helfe ich?
3. **`memory.md`** — Was habe ich vergangene Sessions gelernt?
4. **`agents.md`** — Wie verhalte ich mich?
5. **`heartbeat.md`** — Was muss ich proaktiv prüfen?
6. **`tools.md`** — Welche Tools stehen zur Verfügung?
7. **`conflict-check.md`** — Wann muss ich die KB prüfen? *(optional, aber empfohlen)*

## Konfliktprüfung aktivieren

Damit der Agent **vor Änderungen an etablierten Mustern** (z.B. "Statt Next.js soll ich Svelte nutzen") automatische die KB prüft:

1. Sicherstellen, dass `conflict-check.md` gelesen wird (Boot-Sequenz)
2. Der Agent wird bei potenziellen KB-Konflikten automatisch den Nutzer rückfragen
3. Falls der Konflikt signifikant ist, wird er empfehlen, ob `MEMORY.md` aktualisiert werden soll

**Beispiel-Konflikt:**
```
User: "Verwende Svelte statt Next.js für das Projekt"
Agent: "Ich sehe, dass du Svelte statt Next.js verwenden möchtest. Die Knowledge Base 
empfiehlt Next.js mit folgender Begründung: [Zitat aus 05-execution/rules/nextjs/]. 
Konfliktpotenzial: Performance-Optimierungen für Next.js sind nicht für Svelte adaptierbar. 
Meine Lösung: Ich erstelle ein neues Rule-File für Svelte mit adaptierten Best Practices 
und dokumentiere die Abweichung explizit. Soll ich so vorgehen?"
```

## Maintenance

- **`memory.md`**: Periodisch (alle 30 Tage) prüfen, ob die Einträge noch relevant sind
- **`heartbeat.md`**: Nach Bedarf aktualisieren (z.B. neue Checks hinzufügen)
- **`conflict-check.md`**: Nur bei signifikanten KB-Änderungen (z.B. neue Technologien) aktualisieren

---

Diese Dateien sind die **Persönlichkeit** des Agenten. Änderungen daran sollten bewusst und dokumentiert erfolgen.
