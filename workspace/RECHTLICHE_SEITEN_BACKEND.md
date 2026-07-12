# ✅ Rechtliche Seiten aus dem Backend bearbeiten

## Was wurde umgesetzt:

### Neue Admin-Funktion:
- **URL:** https://plantone.de/admin/legal
- **Zugang:** Login erforderlich (admin/admin123)

### Bearbeitbare Seiten:
1. **Impressum** (/impressum)
   - Anschrift, Kontaktdaten, rechtliche Angaben
   - Vorschau-Link direkt zur Seite
   
2. **Datenschutzerklärung** (/datenschutz)
   - DSGVO-Texte, Cookie-Hinweise, Datenschutzinfo
   - Vorschau-Link direkt zur Seite

### Technische Umsetzung:
- CMS-Blöcke: `imprint_content` und `privacy_content`
- Quill.js WYSIWYG-Editor für einfache Formatierung
- Automatische Speicherung in Datenbank
- Sofortige Sichtbarkeit auf der Website

### Aktueller Status:
- ✅ Impressum-Block erstellt mit Standard-Inhalt
- ✅ Datenschutz-Block erstellt mit Grundgerüst
- ✅ Admin-Interface mit Editor
- ✅ Frontend lädt Inhalte dynamisch aus DB

## Nächste Schritte:
1. Einloggen unter /admin/login
2. "Rechtliche Seiten" im Menü wählen
3. Vollständige Impressum-Daten eintragen (Anschrift, USt-IdNr., etc.)
4. DSGVO-konforme Datenschutzerklärung einfügen

## Hinweis:
Die Standard-Inhalte enthalten Platzhalter. Bitte vor Livegang durch vollständige, rechtlich korrekte Texte ersetzen!