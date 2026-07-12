# Installationsanleitung: Language Switcher

## Voraussetzungen

Du brauchst Zugriff auf den Webserver, um diese Dateien hochzuladen.

## Schritt 1: Dateien hochladen

Lade diese Dateien in dein Webroot-Verzeichnis (z.B. `/var/www/plantone.de/public/`):

```
/translations.js
/language-switcher.js
```

## Schritt 2: In die Homepage einbinden

### 2a) Skripte im `<head>` laden

Öffne deine `index.html` (oder das Template deines CMS/Generators) und füge vor dem schließenden `</head>` hinzu:

```html
<!-- Sprachwechsler -->
<script src="/translations.js"></script>
<script src="/language-switcher.js" defer></script>
<style>
/* Minimal-CSS für den Switcher */
.lang-switcher {
  position: relative;
  display: inline-flex;
  align-items: center;
  margin-right: 8px;
}
.lang-switcher-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  border-radius: 8px;
  border: 1px solid rgba(148,163,184,0.3);
  background: rgba(30,41,59,0.6);
  color: #cbd5e1;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  backdrop-filter: blur(8px);
}
.lang-switcher-btn:hover {
  border-color: rgba(62,207,142,0.5);
  color: #3ECF8E;
  background: rgba(62,207,142,0.1);
}
.lang-switcher-dropdown {
  position: absolute;
  top: calc(100% + 6px);
  right: 0;
  min-width: 170px;
  background: #1e293b;
  border: 1px solid rgba(148,163,184,0.2);
  border-radius: 10px;
  padding: 6px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.4);
  opacity: 0;
  visibility: hidden;
  transform: translateY(-8px);
  transition: all 0.2s ease;
}
.lang-switcher.open .lang-switcher-dropdown {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}
.lang-switcher-item {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  padding: 10px 14px;
  border: none;
  border-radius: 6px;
  background: transparent;
  color: #cbd5e1;
  font-size: 14px;
  cursor: pointer;
  text-align: left;
}
.lang-switcher-item:hover {
  background: rgba(62,207,142,0.15);
  color: #3ECF8E;
}
@media (max-width: 768px) {
  .lang-switcher.header-switcher { display: none !important; }
  .lang-switcher.floating-switcher {
    position: fixed !important;
    bottom: 20px;
    right: 20px;
    z-index: 9999;
  }
}
@media (min-width: 769px) {
  .lang-switcher.floating-switcher { display: none !important; }
}
</style>
```

### 2b) HTML-Attribute hinzufügen

Deine Website muss die Texte mit `data-i18n` Attributen versehen. Hier ist ein Beispiel für den Hero-Bereich:

```html
<!-- Vorher: -->
<h1>Mehr Produktivitaet.<br>Bessere Prozesse.<br><span>Sinnvoll eingesetzte KI.</span></h1>
<p>Ich helfe mittelstaendischen Unternehmen...</p>

<!-- Nachher: -->
<h1>
  <span data-i18n="heroTitle1">Mehr Produktivitaet.</span><br>
  <span data-i18n="heroTitle2">Bessere Prozesse.</span><br>
  <span data-i18n="heroTitle3" class="text-[#3ECF8E]">Sinnvoll eingesetzte KI.</span>
</h1>
<p data-i18n="heroDesc1">Ich helfe mittelstaendischen Unternehmen...</p>
```

### 2c) Der Language Switcher wird automatisch eingefügt

Das Script erkennt den Header und fügt den Switcher automatisch ein. **Kein manuelles HTML nötig!**

## Schritt 3: Testen

1. Seite neu laden
2. Auf "DE ▼" klicken → Dropdown öffnet
3. "English" wählen → Seite wird auf Englisch umgeschaltet
4. Seite neu laden → Englisch bleibt erhalten (localStorage)

## Schritt 4: Anpassen (optional)

### URL-Struktur für SEO

Für bessere SEO empfehle ich Unterordner statt URL-Parameter:

```
/plantone.de/de/
/plantone.de/en/
/plantone.de/it/
```

Das erfordert Server-seitiges Routing (htaccess/nginx) oder einen Static Site Generator.

### hreflang Tags

Füge im `<head>` hinzu:

```html
<link rel="alternate" hreflang="de" href="https://plantone.de/" />
<link rel="alternate" hreflang="en" href="https://plantone.de/?lang=en" />
<link rel="alternate" hreflang="it" href="https://plantone.de/?lang=it" />
<link rel="alternate" hreflang="x-default" href="https://plantone.de/" />
```

## Fehlerbehebung

| Problem | Lösung |
|---------|--------|
| Switcher erscheint nicht | Prüfe Browser Console für JS-Fehler |
| Übersetzungen laden nicht | `translations.js` muss VOR `language-switcher.js` geladen werden |
| Mobile: Switcher verdeckt Inhalt | CSS `z-index` anpassen oder Position ändern |
| SEO: Google indexiert nur Deutsch | hreflang Tags + Sitemap mit allen Sprachen |

## Support

Bei Fragen: Erstelle ein Backup vorher, dann teste auf einer Staging-URL.
