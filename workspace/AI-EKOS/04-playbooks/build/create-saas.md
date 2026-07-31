---
tags:
  - auth
  - billing
  - nextjs
  - payments
  - react
  - stripe
summary: "Create SaaS Playbook"
read_when:
  - "Running build operations"
---

# Create SaaS Playbook

## Objective
Build a production-ready SaaS application from scratch.

## Prerequisites
- [ ] Domain name purchased
- [ ] SSL certificate ready
- [ ] Cloud provider account (AWS/GCP/Azure)
- [ ] Stripe account for payments

## Steps

### Step 1: Project Setup
```bash
# Initialize Next.js with TypeScript
npx create-next-app@latest my-saas --typescript --tailwind --app

# Install dependencies
cd my-saas
npm install @prisma/client prisma @auth/nextjs zod stripe @stripe/stripe-js
npm install -D @types/node typescript

# Initialize Prisma
npx prisma init
```

### Step 2: Database Schema
```prisma
// prisma/schema.prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  subscriptions Subscription[]
}

model Subscription {
  id        String   @id @default(uuid())
  userId    String
  status    String   // active, canceled, past_due
  priceId   String
  currentPeriodEnd DateTime
  
  user User @relation(fields: [userId], references: [id])
}
```

### Step 3: Authentication
```typescript
// lib/auth.ts
import NextAuth from 'next-auth';
import { PrismaAdapter } from '@auth/prisma-adapter';
import { prisma } from './db';

export const { handlers, auth } = NextAuth({
  adapter: PrismaAdapter(prisma),
  providers: [
    // Configure providers
  ],
  callbacks: {
    async session({ session, user }) {
      session.user.id = user.id;
      return session;
    },
  },
});
```

### Step 4: Stripe Integration
```typescript
// lib/stripe.ts
import Stripe from 'stripe';

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
});

// Create checkout session
export async function createCheckoutSession({
  priceId,
  userId,
}: {
  priceId: string;
  userId: string;
}) {
  const session = await stripe.checkout.sessions.create({
    customer_email: user.email,
    line_items: [{ price: priceId, quantity: 1 }],
    mode: 'subscription',
    success_url: `${process.env.NEXT_PUBLIC_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.NEXT_PUBLIC_URL}/pricing`,
  });
  
  return session;
}
```

### Step 5: Deployment
```bash
# Build and deploy
npm run build

# Deploy to Vercel
vercel --prod

# Or deploy to AWS
aws s3 sync out/ s3://my-saas-bucket
```

## Validation
- [ ] User can sign up
- [ ] User can subscribe
- [ ] Webhooks are handled
- [ ] Emails are sent

## Troubleshooting
| Problem | Solution |
|---------|----------|
| Stripe webhook fails | Check endpoint URL and signature verification |
| Database connection error | Verify DATABASE_URL and network access |
| Build fails | Check for TypeScript errors and missing env vars |
