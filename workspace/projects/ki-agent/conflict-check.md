---
tags:
  - agent
  - workflow
  - conflict-resolution
  - knowledge-base
summary: "Konfliktprüfung vor Änderungen an etablierten Mustern der Knowledge Base"
read_when:
  - "Before changing established patterns"
  - "When user explicitly requests pattern change"
  - "Before implementing features that contradict KB rules"
---

# Konfliktprüfung vor Änderungen

Bevor du etablierte Muster in `AI-EKOS/` änderst (z.B. Framework-Empfehlungen, Architektur-Patterns, Sicherheits-Regeln), du **musst** diese Prozedur befolgen:

## 1. Prüfen

Suche in `AI-EKOS/` nach relevanten Regeln zu deinem Thema:

```bash
# Beispiel: Next.js-Regeln prüfen
find workspace/AI-EKOS/05-execution/rules/nextjs -name "*.md" | head -5
find workspace/AI-EKOS/07-patterns -name "*nextjs*" -o -name "*react*" | head -5
find workspace/AI-EKOS/08-recipes -name "*nextjs*" -o -name "*react*" | head -5
```

Oder allgemein für jede Technologie/Pattern:

```bash
# Suche nach Keywords in frontmatter und Inhalt
grep -l "nextjs\|react\|svelte\|vue" workspace/AI-EKOS/**/*.md 2>/dev/null | head -10
```

**Wichtig:** Es ist nicht ausreichend, nur in `05-execution/` zu suchen. Die Knowledge Base ist vernetzt — `07-patterns/` und `08-recipes/` können ebenfalls Konflikte aufweisen.

## 2. Kategorisieren

Ordne deine Anfrage in eine dieser Kategorien ein:

| Kategorie | Beispiele | Regel |
|-----------|-----------|-------|
| **Technologiewechsel** | "Statt Next.js soll ich Svelte nutzen" | `05-execution/rules/nextjs/` prüfen |
| **Pattern-Override** | "Ich will kein Repository Pattern" | `07-patterns/repository/` prüfen |
| **Regel-Abweichung** | "Ich will die Security-Checkliste ignorieren" | `05-execution/rules/security/` prüfen |
| **Neues Pattern einführen** | "Wir nutzen ein neues Caching-Schema" | `07-patterns/cache/` prüfen |
| **Tooling-Wechsel** | "Statt PostgreSQL will ich MongoDB" | `05-execution/rules/postgres/` und `05-execution/rules/database/` prüfen |

## 3. Konflikt dokumentieren

Wenn ein Konflikt besteht (die KB hat eine gängige Regel, das Nutzeranliegen widerspricht ihr):

1. **Lies die KB-Datei(en)** vollständig — nicht nur die Überschriften
2. **Notiere** warum die KB eine bestimmte Regel empfiehlt (z.B. Performance, Sicherheit, Skalierbarkeit)
3. **Dokumentiere** dein Anliegen und warum du abweichen möchtest

## 4. Rückmeldung an Nutzer

**Pflicht-Text bei Konflikten** (du musst diesen Text generieren):

```
Ich sehe, dass du [X] verwenden möchtest. Die Knowledge Base empfiehlt jedoch [Y] mit folgender Begründung:

[Zitieren aus KB-Datei: 1-2 Sätze]

Konfliktpotenzial:
- [Spezifischer Konflikt 1, z.B. "Performance-Optimierung für SSR wird nicht genutzt"]
- [Spezifischer Konflikt 2, z.B. "Auth-Checklisten müssen manuell angepasst werden"]

Meine Lösung:
- [Was du stattdessen tun wirst, z.B. "Ich erstelle ein neues Rule-File für Svelte mit adaptierten Best Practices"]
- [Wie du die Konflikte mitigierst, z.B. "Ich dokumentiere die Abweichung explizit in der neuen Datei"]

Soll ich so vorgehen?
```

**Beispiel:**

```
Ich sehe, dass du Svelte statt Next.js für das Projekt verwenden möchtest. 
Die Knowledge Base empfiehlt Next.js mit folgender Begründung:

"Next.js bietet integrierte SSR-Optimierung, App Router für moderne Architekturen, 
und ist der Standard für Enterprise-React-Projekte in unserer Dokumentation."

Konfliktpotenzial:
- Performance-Regeln für Next.js (Code-Splitting, Image-Optimierung) gelten nicht direkt für Svelte
- Die `05-execution/rules/nextjs/` Checklisten müssen manuell adaptiert werden
- `07-patterns/` Patterns sind React-spezifisch (Context API, Hooks)

Meine Lösung:
- Ich erstelle ein neues Rule-File `05-execution/rules/svelte/best-practices.md` mit Svelte-spezifischen Regeln
- Ich dokumentiere die Abweichung explizit: "Dieses Projekt nutzt Svelte statt Next.js. Begründung: [User-Input]."
- Ich referenziere die Next.js-Regeln als Vergleichsmaßstab, wo sinnvoll (z.B. für Performance-Metriken)

Soll ich so vorgehen?
```

## 5. Umsetzung

Nach Bestätigung:

- **Neue Regel-Dateien erstellen**: Wenn du eine neue Technologie/Pattern einführen sollst, dokumentiere sie konsequent (kein "quick hack")
- **Referenzen behalten**: Wenn die alte Regel noch relevant ist (z.B. für andere Projekte), verlinke sie in der neuen Datei
- **Changelog pflegen**: Trage die Änderung in `CHANGELOG.md` ein (siehe unten)
- **MEMORY.md prüfen**: Wenn die Änderung signifikant ist, könnte sie auch für die agent Identity relevant sein (dann sollte der Nutzer `MEMORY.md` aktualisieren lassen)

## 6. Sonderfall: Explizite "Override"-Anfrage

Wenn der Nutzer **explizit** sagt: "Ignoriere die KB, verwende X trotzdem":

1. **Notiere** die explizite Anweisung (z.B. in `memory/YYYY-MM-DD.md`)
2. **Dokumentiere** in der neuen Datei: "Diese Lösung weicht von der KB-Empfehlung ab. Begründung: [User-Input]. Datum: [Datum]"
3. **Verlinke** auf die überschriebene KB-Datei (z.B. "Vergleiche: AI-EKOS/05-execution/rules/nextjs/best-practices.md")

Dies schützt dich vor späteren Rückfragen, wenn jemand anders das Projekt übernimmt oder die KB aktualisiert wird.

## Changelog-Format

Nach einer KB-Änderung aufgrund einer User-Anfrage (nicht routinemäßige Updates):

```markdown
## [YYYY-MM-DD]

### Changed
- [KB-Datei]: [Änderung beschreiben] — **Begründung:** [User-Input, z.B. "User wünscht Svelte statt Next.js"]

### Added  
- [Neue Datei]: [Beschreibung der neuen Regel/Dokumentation]
```

## Was passiert bei uneindeutiger KB?

Wenn die KB **keine klare Regel** hat (mehrere konkurrierende Patterns, keine explizite Empfehlung):

1. **Suche** in `archive/` ob es historische Entscheidungen gab
2. **Dokumentiere** die Uneindeutigkeit
3. **Empfehle** eine Lösung auf Basis aktueller Best Practices (z.B. Community-Standard, offizielle Docs)
4. **Frage** den Nutzer, ob er eine spezifische Präferenz hat

## Verhältnis zu MEMORY.md

- **Routine-Änderungen** (Bugfixes, neue Features innerhalb bestehender Patterns): Keine Änderung an `MEMORY.md` nötig
- **Signifikante Pattern-Overrides** (neue Frameworks, Architektur-Änderungen): Der Nutzer sollte `MEMORY.md` aktualisieren lassen, wenn die Entscheidung langfristig gilt

---

**Zusammenfassung:** Diese Prozedur schützt die Integrität der Knowledge Base, während sie dir die Flexibilität gibt, auf individuelle Anfragen einzugehen. Wenn du unsicher bist, ob ein Konflikt besteht, frage lieber zuerst nach — es ist besser, einmal zu viel zu dokumentieren als später unerklärliche Widersprüche zu haben.
