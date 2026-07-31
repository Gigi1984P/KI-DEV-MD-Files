---
tags:
  - product
  - ai-audit
  - api
  - integration
summary: "API Reference: KI-System Audit & Compliance Platform REST API"
read_when:
  - "Integrating with ai-audit"
  - "Building client applications"
  - "Debugging API issues"
---

# API: KI-System Audit & Compliance Platform

## Authentifizierung

Alle API-Calls benötigen einen API Key im Header:

```bash
curl -H "Authorization: Bearer <API_KEY>" \
     -H "Content-Type: application/json" \
     https://api.ai-audit.example.com/v1/
```

## Rate Limits

- **Free Tier**: 100 Requests/min, 1.000 Runs/Tag
- **Pro Tier**: 1.000 Requests/min, 10.000 Runs/Tag
- **Enterprise**: Unlimited

## Core Endpoints

| Endpoint | Methode | Beschreibung |
|----------|---------|--------------|
| `/ai-audit` | GET | Liste aller Ressourcen |
| `/ai-audit/{id}` | GET | Einzel-Resource abrufen |
| `/ai-audit` | POST | Neue Resource erstellen |
| `/ai-audit/{id}` | PATCH | Resource aktualisieren |
| `/ai-audit/{id}` | DELETE | Resource löschen (soft delete) |

## Webhooks

Konfigurierbar für Events: `created`, `updated`, `deleted`, `error`

## Fehler-Codes

- `400` — Validation Error (Body nicht konform zu Schema)
- `401` — Unauthorized (API Key ungültig/expired)
- `429` — Rate Limit überschritten (`Retry-After` Header beachten)
- `500` — Internal Error (kontaktiere Support mit Request-ID)
