---
tags:
  - product
  - internal-tools
  - api
  - integration
summary: "API Reference: AI-Powered Internal Tool Generator REST API"
read_when:
  - "Integrating with internal-tools"
  - "Building client applications"
  - "Debugging API issues"
---

# API: AI-Powered Internal Tool Generator

## Authentifizierung

Alle API-Calls benötigen einen API Key im Header:

```bash
curl -H "Authorization: Bearer <API_KEY>" \
     -H "Content-Type: application/json" \
     https://api.internal-tools.example.com/v1/
```

## Rate Limits

- **Free Tier**: 100 Requests/min, 1.000 Runs/Tag
- **Pro Tier**: 1.000 Requests/min, 10.000 Runs/Tag
- **Enterprise**: Unlimited

## Core Endpoints

| Endpoint | Methode | Beschreibung |
|----------|---------|--------------|
| `/internal-tools` | GET | Liste aller Ressourcen |
| `/internal-tools/{id}` | GET | Einzel-Resource abrufen |
| `/internal-tools` | POST | Neue Resource erstellen |
| `/internal-tools/{id}` | PATCH | Resource aktualisieren |
| `/internal-tools/{id}` | DELETE | Resource löschen (soft delete) |

## Webhooks

Konfigurierbar für Events: `created`, `updated`, `deleted`, `error`

## Fehler-Codes

- `400` — Validation Error (Body nicht konform zu Schema)
- `401` — Unauthorized (API Key ungültig/expired)
- `429` — Rate Limit überschritten (`Retry-After` Header beachten)
- `500` — Internal Error (kontaktiere Support mit Request-ID)
