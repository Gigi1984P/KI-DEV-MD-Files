---
tags:
  - product
  - agent-platform
  - api
  - rest
  - webhooks
summary: "API Reference: Agent Platform REST API + Webhooks"
read_when:
  - "Integrating with agent-platform"
  - "Building client applications"
  - "Debugging API issues"
---

# API: Agent Platform

## Base URL

```
https://api.agent-platform.example.com/v1
```

## Authentication

```bash
curl -H "Authorization: Bearer <API_KEY>" \
     -H "X-Workspace-ID: <WORKSPACE_ID>" \
     https://api.agent-platform.example.com/v1/agents
```

API Keys haben Scopes: `agents:read`, `agents:write`, `runs:read`, `skills:manage`.

---

## Core Resources

### Agents

| Endpoint | Method | Beschreibung |
|---|---|---|
| `/agents` | GET | Liste aller Agents im Workspace |
| `/agents` | POST | Neuen Agent erstellen |
| `/agents/{id}` | GET | Agent Details (inkl. Prompt, Skills, Config) |
| `/agents/{id}` | PATCH | Agent updaten (Prompt, Skills, Limits) |
| `/agents/{id}` | DELETE | Agent archivieren (soft delete) |

#### Beispiel: Agent erstellen

```json
POST /agents
{
  "name": "support-ticket-classifier",
  "description": "Klassifiziert eingehende Support-Tickets nach Kategorie + Priorität",
  "prompt": "Du bist ein Support-Ticket-Klassifizierer...",
  "skills": ["email.read", "ticket.create", "crm.lookup"],
  "config": {
    "model": "claude-sonnet-4",
    "max_tokens": 4096,
    "temperature": 0.1,
    "cost_limit_daily": 5.00
  }
}
```

Response: `201 Created` mit `{"id": "agt_abc123", ...}`

---

### Runs (Executions)

| Endpoint | Method | Beschreibung |
|---|---|---|
| `/runs` | GET | Liste von Runs (filterbar nach Agent, Status, Datum) |
| `/runs` | POST | Agent manuell triggeren (synchronous oder async) |
| `/runs/{id}` | GET | Run Details mit Trace |
| `/runs/{id}/replay` | POST | Run mit modifiziertem Input wiederholen |

#### Beispiel: Run listen (filterbar)

```bash
GET /runs?agent_id=agt_abc123&status=failed&limit=50&cursor=xyz
```

Response:
```json
{
  "data": [
    {
      "id": "run_xyz789",
      "agent_id": "agt_abc123",
      "status": "failed",
      "input": {"subject": "Bug in checkout", "body": "..."},
      "output": null,
      "error": "Skill 'crm.lookup' timeout after 30s",
      "cost_usd": 0.0234,
      "tokens": {"input": 1250, "output": 0},
      "duration_ms": 32000,
      "created_at": "2026-07-31T12:34:56Z"
    }
  ],
  "has_more": false
}
```

---

### Skills

| Endpoint | Method | Beschreibung |
|---|---|---|
| `/skills` | GET | Liste verfügbarer Skills (eigene + Marketplace) |
| `/skills/{id}` | GET | Skill Details (Parameter, Requirements) |
| `/agents/{id}/skills` | PUT | Skills für einen Agent konfigurieren |

#### Skill-Konfiguration

```json
PUT /agents/agt_abc123/skills
{
  "skills": [
    {
      "skill_id": "crm.lookup",
      "config": {
        "base_url": "https://crm.example.com",
        "api_key": "${CRM_API_KEY}",
        "timeout_ms": 5000
      }
    }
  ]
}
```

---

## Webhooks

| Event | Payload | Beschreibung |
|---|---|---|
| `run.completed` | `{run_id, status, output, cost_usd}` | Run erfolgreich abgeschlossen |
| `run.failed` | `{run_id, error, input}` | Run fehlgeschlagen |
| `agent.deployed` | `{agent_id, version, deployed_by}` | Neue Agent-Version live |

### Webhook Registration

```json
POST /webhooks
{
  "url": "https://your-app.com/webhooks/agent-platform",
  "events": ["run.completed", "run.failed"],
  "secret": "whsec_..."
}
```

---

## Rate Limits

| Tier | Requests/minute | Runs/day | Concurrent Agents |
|---|---|---|---|
| Free | 60 | 100 | 2 |
| Pro | 600 | 10,000 | 50 |
| Enterprise | Unlimited | Unlimited | Unlimited |

Überschreitung → `429 Too Many Requests` mit `Retry-After` Header.

---

## Error Handling

Standard: [RFC 7807 (Problem Details)](https://tools.ietf.org/html/rfc7807)

```json
{
  "type": "https://api.agent-platform.example.com/errors/skill-timeout",
  "title": "Skill execution timeout",
  "status": 504,
  "detail": "Skill 'crm.lookup' exceeded 30s timeout",
  "instance": "/runs/run_xyz789"
}
```

Fehler-Codes: `400` (Validation), `401` (Auth), `403` (Scope), `404` (Not Found), `429` (Rate Limit), `500` (Internal), `504` (Skill Timeout)
