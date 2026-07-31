# Plantone.de - Multilanguage (DE / EN / IT)

## Übersicht

Vollständige Übersetzung der Homepage mit Language Switcher Dropdown (🇩🇪 DE / 🇬🇧 EN / 🇮🇹 IT).

---

## Dateien

| Datei | Beschreibung |
|-------|-------------|
| `translations.js` | Alle Übersetzungen als JS-Objekt |
| `language-switcher.js` | Language Switcher UI + Logik |
| `INSTALL.md` | Schritt-für-Schritt Anleitung |
| `demo.html` | Standalone-Demo |

---

## Quick Start

### Option 1: Minimal (nur Header einfügen)

In deine bestehende `index.html` den Switcher im Header einfügen:

```html
<!-- Im <head> -->
<script src="translations.js"></script>
<script src="language-switcher.js"></script>
```

### Option 2: Vollständige Integration

Alle Texte mit `data-i18n` Attributen versehen (siehe INSTALL.md).

---

## Sprachen

| Sprache | Locale | Status |
|---------|--------|--------|
| Deutsch | `de_DE` | ✅ Original |
| Englisch | `en_US` | ✅ Vollständig |
| Italienisch | `it_IT` | ✅ Vollständig |

---

## Funktionen

- ✅ Dropdown-Switcher im Header (Desktop) / Fixed Bottom-Right (Mobile)
- ✅ Automatische Browser-Spracherkennung
- ✅ Speichert Präferenz in localStorage
- ✅ URL-Parameter-Unterstützung (`?lang=en`)
- ✅ Meta-Tags werden aktualisiert
- ✅ Barrierefrei (ARIA Labels, Keyboard Navigation)
- ✅ SEO-freundlich (hreflang Tags möglich)

---

## Lizenz

© 2026 Gianluigi Plantone. Alle Rechte vorbehalten.
