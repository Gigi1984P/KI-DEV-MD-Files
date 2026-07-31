---
tags:
  - anti-patterns
  - best-practices
  - billing
  - payments
  - stripe
summary: "Stripe Checkout"
read_when:
  - "Implementing stripe features"
  - "Troubleshooting stripe issues"
---

# Stripe Checkout

## Overview
Stripe Checkout is a pre-built, hosted payment page optimized for conversion. It handles PCI compliance, mobile optimization, and local payment methods automatically.

## Implementation

### Basic Checkout Session

```typescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
});

export async function createCheckoutSession({
  priceId,
  customerId,
  successUrl,
  cancelUrl,
}: CheckoutParams) {
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    line_items: [
      {
        price: priceId,
        quantity: 1,
      },
    ],
    mode: 'subscription',
    success_url: successUrl,
    cancel_url: cancelUrl,
    // Enable tax calculation
    automatic_tax: { enabled: true },
    // Collect billing address
    billing_address_collection: 'required',
    // Custom branding
    custom_text: {
      submit: { message: 'Start your subscription' },
    },
  });

  return { sessionId: session.id, url: session.url };
}
```

### Embedded Checkout

```tsx
'use client';

import { loadStripe } from '@stripe/stripe-js';
import { EmbeddedCheckout } from '@stripe/react-stripe-js';

const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!);

export default function CheckoutPage({ clientSecret }: { clientSecret: string }) {
  return (
    <EmbeddedCheckoutProvider
      stripe={stripePromise}
      options={{ clientSecret }}
    >
      <EmbeddedCheckout />
    </EmbeddedCheckoutProvider>
  );
}
```

## Configuration

### Price Setup
```typescript
// Create a price for your product
const price = await stripe.prices.create({
  unit_amount: 2000, // $20.00
  currency: 'usd',
  recurring: { interval: 'month' },
  product_data: {
    name: 'Pro Plan',
    description: 'Everything you need to scale',
  },
});
```

### Session Retrieval
```typescript
export async function getSession(sessionId: string) {
  const session = await stripe.checkout.sessions.retrieve(sessionId, {
    expand: ['line_items', 'customer'],
  });

  return {
    status: session.status,
    paymentStatus: session.payment_status,
    customer: session.customer,
    lineItems: session.line_items,
  };
}
```

## Webhook Handling

```typescript
// app/api/webhooks/stripe/route.ts
export async function POST(req: Request) {
  const event = await validateWebhook(req);

  switch (event.type) {
    case 'checkout.session.completed':
      await handleCheckoutComplete(event.data.object);
      break;
    case 'checkout.session.expired':
      await handleCheckoutExpired(event.data.object);
      break;
  }

  return new Response('OK', { status: 200 });
}

async function handleCheckoutComplete(session: Stripe.Checkout.Session) {
  // Activate subscription
  await db.subscriptions.create({
    stripeSessionId: session.id,
    stripeSubscriptionId: session.subscription as string,
    customerId: session.customer as string,
    status: 'active',
  });
}
```

## Anti-Patterns

- Creating checkout sessions without idempotency keys
- Not handling `checkout.session.expired` events
- Storing full card details (let Stripe handle PCI)
- Redirecting to Stripe without proper success/cancel URLs


## Related
- `05-execution/rules/stripe/subscriptions.md` — Subscription management
- `05-execution/rules/stripe/webhooks.md` — Webhook handling
- `04-playbooks/build/create-saas.md` — SaaS build playbook
- `07-patterns/billing/` — Billing patterns
