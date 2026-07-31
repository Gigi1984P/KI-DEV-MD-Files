# MEMORY.md - Langfristige Erinnerungen

## Projekte

### Website: plantone.de (Gianluigi Plantone)
- **Status:** Live seit 24.06.2026, WordPress + Divi 5
- **Hosting:** Hetzner konsoleH Shared Hosting
- **URL:** https://plantone.de
- **Letzter Check:** 06.07.2026 — stabil erreichbar
- **Hinweis:** Am 26.06. kurzzeitig 500er, seitdem wieder stabil. Website seitdem kontinuierlich online.

## Wichtige Entscheidungen
- Laravel auf Shared Hosting → gescheitert → WordPress als pragmatische Lösung
- Emoji-freie Content-Strategie wegen utf8 DB-Encoding
- Divi 5 als Theme, Yoast SEO

## Technische Lektionen
- Hetzner Shared Hosting = keine Frameworks (Laravel etc.)
- DB-Encoding checken vor Content-Erstellung (utf8 vs utf8mb4)
- `post_content_filtered` Default-Wert beachten bei manuellen INSERTs

## Nächste Schritte (warten auf User)
- Impressum: Echte Adresse eintragen
- Profilbild auf "Über mich"
- Blog-Artikel schreiben
- SMTP-Plugin für zuverlässige E-Mails
- Google Analytics (optional)
