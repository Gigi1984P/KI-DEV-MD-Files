---
tags:
  - anti-patterns
  - best-practices
  - billing
  - payments
  - stripe
summary: "Stripe Billing"
read_when:
  - "Implementing stripe features"
  - "Troubleshooting stripe issues"
---

# Stripe Billing

## Overview
Stripe Billing provides subscription management, invoicing, and revenue recognition for SaaS businesses.

## Subscription Lifecycle

### Create with Trial
```typescript
const subscription = await stripe.subscriptions.create({
  customer: 'cus_xxx',
  items: [{ price: 'price_xxx' }],
  trial_period_days: 14,
  trial_settings: {
    end_behavior: {
      missing_payment_method: 'pause', // or 'cancel'
    },
  },
  payment_settings: {
    save_default_payment_method: 'on_subscription',
  },
  // Proration behavior
  proration_behavior: 'create_prorations',
});
```

### Update Subscription
```typescript
// Upgrade: Add items
const subscription = await stripe.subscriptions.update('sub_xxx', {
  items: [
    { id: 'si_xxx', price: 'price_new' }
  ],
  proration_behavior: 'create_prorations',
});

// Downgrade: Remove items
const subscription = await stripe.subscriptions.update('sub_xxx', {
  items: [
    { id: 'si_xxx', deleted: true }
  ],
});
```

### Cancel
```typescript
// Cancel at period end
await stripe.subscriptions.update('sub_xxx', {
  cancel_at_period_end: true,
});

// Cancel immediately with refund
await stripe.subscriptions.cancel('sub_xxx', {
  prorate: true,
});
```

## Invoicing

### Generate Invoice
```typescript
const invoice = await stripe.invoices.create({
  customer: 'cus_xxx',
  auto_advance: true, // Auto-finalize
  collection_method: 'charge_automatically',
});

await stripe.invoiceItems.create({
  customer: 'cus_xxx',
  invoice: invoice.id,
  amount: 5000, // $50.00
  currency: 'usd',
  description: 'One-time fee',
});

await stripe.invoices.finalizeInvoice(invoice.id);
```

## Metered Billing

```typescript
// Report usage
await stripe.subscriptionItems.createUsageRecord(
  'si_xxx',
  {
    quantity: 100,
    timestamp: Math.floor(Date.now() / 1000),
    action: 'increment', // or 'set'
  }
);
```

## Revenue Recognition

```typescript
// Set up revenue recognition
const revenueRecognition = await stripe.billing.meterEvents.create({
  event_name: 'api_request',
  payload: {
    value: '1',
    stripe_customer_id: 'cus_xxx',
  },
});
```

## Anti-Patterns

- Not handling invoice payment failures
- Ignoring subscription status changes
- No idempotency on billing operations
- Missing webhook event handling


## Related
- `05-execution/rules/stripe/subscriptions.md` — Subscription management
- `05-execution/rules/stripe/webhooks.md` — Webhook handling
- `04-playbooks/build/create-saas.md` — SaaS build playbook
- `07-patterns/billing/` — Billing patterns
