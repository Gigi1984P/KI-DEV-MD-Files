---
tags:
  - product
  - knowledge-base
  - api
  - integration
summary: "API Reference: RAG-basierte Enterprise Knowledge Base REST API"
read_when:
  - "Integrating with knowledge-base"
  - "Building client applications"
  - "Debugging API issues"
---

# API: RAG-basierte Enterprise Knowledge Base

## Authentifizierung

Alle API-Calls benötigen einen API Key im Header:

```bash
curl -H "Authorization: Bearer <API_KEY>" \
     -H "Content-Type: application/json" \
     https://api.knowledge-base.example.com/v1/
```

## Rate Limits

- **Free Tier**: 100 Requests/min, 1.000 Runs/Tag
- **Pro Tier**: 1.000 Requests/min, 10.000 Runs/Tag
- **Enterprise**: Unlimited

## Core Endpoints

| Endpoint | Methode | Beschreibung |
|----------|---------|--------------|
| `/knowledge-base` | GET | Liste aller Ressourcen |
| `/knowledge-base/{id}` | GET | Einzel-Resource abrufen |
| `/knowledge-base` | POST | Neue Resource erstellen |
| `/knowledge-base/{id}` | PATCH | Resource aktualisieren |
| `/knowledge-base/{id}` | DELETE | Resource löschen (soft delete) |

## Webhooks

Konfigurierbar für Events: `created`, `updated`, `deleted`, `error`

## Fehler-Codes

- `400` — Validation Error (Body nicht konform zu Schema)
- `401` — Unauthorized (API Key ungültig/expired)
- `429` — Rate Limit überschritten (`Retry-After` Header beachten)
- `500` — Internal Error (kontaktiere Support mit Request-ID)
