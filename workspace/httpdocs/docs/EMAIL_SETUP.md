# 📧 Email Notifications Setup Guide

## Status: ✅ AKTIV (Hetzner konsoleH)

AI-EKOS sendet E-Mail-Benachrichtigungen über deinen Hetzner-Mailserver.

---

## Konfiguration

Die Einstellungen sind in `scripts/config/notifications.env` hinterlegt (nicht im Git-Repo):

```
SMTP_HOST=mail.plantone.de
SMTP_PORT=587
SMTP_USER=ki-dev@plantone.de
SMTP_PASS=p5*LVBox/B6F
SMTP_FROM=AI-EKOS Orchestrator <ki-dev@plantone.de>
SMTP_TLS=true
```

---

## Test

Erfolgreich getestet am 2026-07-05:
- ✅ Verbindung zu mail.plantone.de:587
- ✅ TLS-Verschlüsselung
- ✅ Login als ki-dev@plantone.de
- ✅ E-Mail gesendet an gianluigi.plantone@gmail.com

---

## Verwendung

### Per CLI:
```bash
python scripts/orchestrator.py \
  --workflow complete-project \
  --task "Build SaaS CRM" \
  --notify email
```

### Test-E-Mail senden:
```bash
python scripts/test-email.py gianluigi.plantone@gmail.com
```

### In OpenClaw Chat:
```
"Baue ein Projekt und sende mir den Report per E-Mail"
```

---

## Was wird benachrichtigt?

- Workflow gestartet
- Phase abgeschlossen (mit Quality Gate Ergebnis)
- Workflow fertig (mit Cost, Duration, Agenten-Übersicht)
- Fehler (mit Retry-Informationen)

---

## HTML-E-Mail Template

Die E-Mails enthalten:
- Status-Farben (grün/orange/rot)
- Cost Breakdown pro Agent
- Quality Gate Ergebnisse
- Next Steps Checkliste

---

*Letzte Aktualisierung: 2026-07-05*
