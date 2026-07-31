---
tags:
  - product
  - crm
  - api
  - integration
summary: "API Reference: AI-Native CRM Platform REST API"
read_when:
  - "Integrating with crm"
  - "Building client applications"
  - "Debugging API issues"
---

# API: AI-Native CRM Platform

## Authentifizierung

Alle API-Calls benötigen einen API Key im Header:

```bash
curl -H "Authorization: Bearer <API_KEY>" \
     -H "Content-Type: application/json" \
     https://api.crm.example.com/v1/
```

## Rate Limits

- **Free Tier**: 100 Requests/min, 1.000 Runs/Tag
- **Pro Tier**: 1.000 Requests/min, 10.000 Runs/Tag
- **Enterprise**: Unlimited

## Core Endpoints

| Endpoint | Methode | Beschreibung |
|----------|---------|--------------|
| `/crm` | GET | Liste aller Ressourcen |
| `/crm/{id}` | GET | Einzel-Resource abrufen |
| `/crm` | POST | Neue Resource erstellen |
| `/crm/{id}` | PATCH | Resource aktualisieren |
| `/crm/{id}` | DELETE | Resource löschen (soft delete) |

## Webhooks

Konfigurierbar für Events: `created`, `updated`, `deleted`, `error`

## Fehler-Codes

- `400` — Validation Error (Body nicht konform zu Schema)
- `401` — Unauthorized (API Key ungültig/expired)
- `429` — Rate Limit überschritten (`Retry-After` Header beachten)
- `500` — Internal Error (kontaktiere Support mit Request-ID)
