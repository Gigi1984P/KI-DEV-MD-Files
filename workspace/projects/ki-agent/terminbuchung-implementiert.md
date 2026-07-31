# ✅ Terminbuchung + Lead-Magnet Tracking implementiert

## Neue Funktionen:

### 1. Terminbuchung-System
- **URL:** https://plantone.de/termin-buchen
- **Funktion:** Kalender-Ansicht mit verfuegbaren Slots
- **Verfuegbarkeit:** Di-Do, 9:00 / 11:00 / 14:00 / 16:00 Uhr
- **Features:**
  - Name, E-Mail, Unternehmen, Telefon
  - Termin-Typ waehlen (Potenzialanalyse 30min / Strategiegespraech 60min)
  - Anmerkungsfeld
  - Automatische Bestaetigung per E-Mail (vorbereitet)
  - Dankesseite nach Buchung

### 2. Lead-Magnet Tracking
- **Komponente:** `<x-lead-magnet-form />`
- **Funktion:** E-Mail-Erfassung vor Download
- **Tracking:**
  - E-Mail, Vorname, Unternehmen
  - Download-Zeitpunkt
  - IP-Adresse & User-Agent
  - Magnet-Typ & Titel
  - Conversion-Status

### 3. Newsletter-Liste
- **Tabelle:** `newsletter_subscribers`
- **Funktion:** Automatische Eintragung bei Lead-Download
- **Quellen-Tracking:** Woher kam der Lead?

### 4. Conversion-Tracking
- **GTM Events:** `lead_magnet_download` und `appointment_booked`
- **dataLayer:** Fuer Google Tag Manager / Google Ads Conversion-Tracking

## Neue Datenbank-Tabellen:
- `appointments` - Terminbuchungen
- `lead_downloads` - Lead-Magnet Downloads
- `newsletter_subscribers` - Newsletter-Abonnenten

## Geaenderte CTA-Links (Homepage):
- Hero: "Kostenlose Potenzialanalyse" → /termin-buchen
- Problem-Sektion: "Termin buchen" → /termin-buchen
- Charts: "Aehnliche Ergebnisse?" → /termin-buchen
- Sekundaer: "Kontakt aufnehmen" bleibt auf /kontakt

## Admin-Dashboard:
Bereits vorbereitet fuer Erweiterung:
- Neue Tabellen sind im Dashboard sichtbar
- Termin- und Lead-Statistiken koennen hinzugefuegt werden

## Naechste Schritte empfohlen:
1. **E-Mail-Versand:** Bestaetigungsmail fuer Termine einrichten (SMTP)
2. **Kalender-Integration:** Google Calendar / Calendly-API
3. **Lead-Nurturing:** Automatisierte E-Mail-Sequenz nach Download