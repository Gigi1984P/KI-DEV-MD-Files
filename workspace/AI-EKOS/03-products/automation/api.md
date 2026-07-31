---
tags:
  - product
  - automation
  - api
  - integration
summary: "API Reference: No-Code Business Process Automation REST API"
read_when:
  - "Integrating with automation"
  - "Building client applications"
  - "Debugging API issues"
---

# API: No-Code Business Process Automation

## Authentifizierung

Alle API-Calls benötigen einen API Key im Header:

```bash
curl -H "Authorization: Bearer <API_KEY>" \
     -H "Content-Type: application/json" \
     https://api.automation.example.com/v1/
```

## Rate Limits

- **Free Tier**: 100 Requests/min, 1.000 Runs/Tag
- **Pro Tier**: 1.000 Requests/min, 10.000 Runs/Tag
- **Enterprise**: Unlimited

## Core Endpoints

| Endpoint | Methode | Beschreibung |
|----------|---------|--------------|
| `/automation` | GET | Liste aller Ressourcen |
| `/automation/{id}` | GET | Einzel-Resource abrufen |
| `/automation` | POST | Neue Resource erstellen |
| `/automation/{id}` | PATCH | Resource aktualisieren |
| `/automation/{id}` | DELETE | Resource löschen (soft delete) |

## Webhooks

Konfigurierbar für Events: `created`, `updated`, `deleted`, `error`

## Fehler-Codes

- `400` — Validation Error (Body nicht konform zu Schema)
- `401` — Unauthorized (API Key ungültig/expired)
- `429` — Rate Limit überschritten (`Retry-After` Header beachten)
- `500` — Internal Error (kontaktiere Support mit Request-ID)
