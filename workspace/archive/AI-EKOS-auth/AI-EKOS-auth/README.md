# AI-EKOS Authentication Implementation

## Übersicht

Vollständige User Authentication mit Next.js App Router, PostgreSQL (Drizzle ORM), und shadcn/ui.

## Features

- **Email/Password Auth**: Registrierung und Login mit sicherem Passwort-Hashing
- **Session Management**: Server-seitige Sessions mit cryptographisch sicheren Tokens
- **Passwort-Validierung**: Echtzeit-Stärke-Check mit visuellem Feedback
- **Geschützte Routen**: Middleware für Authentifizierung
- **Server Components**: Daten-Fetching direkt auf dem Server
- **Progressive Enhancement**: Funktioniert auch ohne JavaScript
- **Accessibility**: ARIA-Labels, Keyboard-Navigation, Screenreader-Unterstützung

## Tech Stack

- **Next.js 15** mit App Router
- **TypeScript** (strict mode)
- **Drizzle ORM** mit PostgreSQL
- **shadcn/ui** Komponenten
- **bcryptjs** für Passwort-Hashing
- **Zod** für Validierung
- **Vitest** für Tests

## Projektstruktur

```
├── app/
│   ├── login/page.tsx              # Login Seite (Server Component)
│   ├── register/page.tsx           # Registrierung (Server Component)
│   └── (protected)/
│       └── dashboard/page.tsx      # Geschützte Seite
├── components/
│   └── auth/
│       ├── login-form.tsx          # Login Form (Client Component)
│       ├── register-form.tsx       # Registrierung Form (Client Component)
│       ├── logout-button.tsx       # Logout Button
│       └── user-nav.tsx            # User Navigation
├── lib/
│   ├── auth/
│   │   ├── actions.ts              # Server Actions (register, login, logout)
│   │   ├── cookies.ts              # Cookie Management
│   │   ├── password.ts             # Password Hashing
│   │   ├── session.ts              # Session Token Generation
│   │   └── validation.ts           # Zod Schemas
│   └── db/
│       ├── schema.ts               # Drizzle ORM Schema
│       └── index.ts                # Database Client
├── middleware.ts                    # Auth Middleware
├── __tests__/                       # Tests
│   ├── auth/
│   │   ├── validation.test.ts
│   │   ├── password.test.ts
│   │   ├── session.test.ts
│   │   └── actions.test.ts
│   ├── components/
│   │   └── login-form.test.tsx
│   └── setup.ts
├── vitest.config.ts
└── package.json
```

## Datenbank Schema

### Tables

- **users**: Core User Daten (email, name, password_hash, is_active)
- **sessions**: Server-seitige Sessions (token_hash, expires_at, user_id)
- **accounts**: OAuth Account Linking (future-proof)
- **password_reset_tokens**: Sichere Passwort-Reset Tokens

### Security Features

- Passwörter werden mit bcrypt (salt rounds 12) gehasht
- Session Tokens sind 32-Byte Zufallswerte, SHA-256 gehasht in DB
- Cookies sind httpOnly, secure (Production), sameSite=lax
- Sessions laufen nach 30 Tagen ab
- Generische Fehlermeldungen verhindern User Enumeration

## API

### Server Actions

| Action | Description |
|--------|-------------|
| `register(input)` | Erstellt neuen User + Session |
| `login(input)` | Authentifiziert User + erstellt Session |
| `logout()` | Löscht Session + Cookie |
| `getSession()` | Validiert Session und gibt User zurück |
| `getCurrentUser()` | Gibt aktuellen User (oder null) |
| `requireAuth()` | Wirft Error wenn nicht authentifiziert |

## Tests

```bash
# Unit Tests
npm test

# Mit Coverage
npm run test:coverage
```

### Test-Kategorien

- **Validation**: Zod Schema Tests
- **Password**: bcrypt Hashing/Verification
- **Session**: Token Generation und Expiration
- **Actions**: Auth Flows mit Mocked DB
- **Components**: React Component Rendering

## Middleware Konfiguration

```typescript
// middleware.ts
export const config = {
  matcher: ['/((?!_next/static|_next/image|api).*)'],
};
```

## Umgebungsvariablen

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=app
DB_USER=postgres
DB_PASSWORD=your-password

# Node Environment
NODE_ENV=production
```

## Installation

```bash
# Dependencies installieren
npm install

# Datenbank Schema generieren
npm run db:generate

# Migrationen ausführen
npm run db:migrate

# Entwicklungsserver starten
npm run dev
```

## Lizenz

MIT
