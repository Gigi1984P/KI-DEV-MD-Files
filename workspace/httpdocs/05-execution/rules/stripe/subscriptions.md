# Stripe Subscriptions

## Pricing Models

### Flat Rate
```javascript
const price = await stripe.prices.create({
  unit_amount: 2000, // $20.00
  currency: 'usd',
  recurring: { interval: 'month' },
  product_data: { name: 'Pro Plan' },
});
```

### Per-Seat
```javascript
const price = await stripe.prices.create({
  currency: 'usd',
  recurring: { interval: 'month', usage_type: 'licensed' },
  product_data: { name: 'Team Plan' },
  transform_quantity: {
    divide_by: 1,
    round: 'up',
  },
  unit_amount: 1000, // $10 per seat
});
```

### Usage-Based (Metered)
```javascript
const price = await stripe.prices.create({
  currency: 'usd',
  recurring: { interval: 'month', usage_type: 'metered' },
  product_data: { name: 'API Calls' },
  tiers: [
    { up_to: 1000, unit_amount: 0 },       // Free tier
    { up_to: 10000, unit_amount: 5 },      // $0.05 per call
    { unit_amount: 3 },                   // $0.03 per call above
  ],
  tier_mode: 'graduated',
});
```

## Subscription Lifecycle

### Create Subscription
```javascript
const subscription = await stripe.subscriptions.create({
  customer: 'cus_xxx',
  items: [{ price: 'price_xxx' }],
  payment_behavior: 'default_incomplete', // Wait for payment
  expand: ['latest_invoice.payment_intent'],
});

// Return client_secret for frontend confirmation
return {
  subscriptionId: subscription.id,
  clientSecret: subscription.latest_invoice.payment_intent.client_secret,
};
```

### Update Subscription
```javascript
// Upgrade: Change items immediately, prorate
const subscription = await stripe.subscriptions.update(
  'sub_xxx',
  {
    items: [
      { id: 'si_xxx', price: 'price_new' }
    ],
    proration_behavior: 'create_prorations',
  }
);
```

### Cancel Subscription
```javascript
// At period end (graceful)
await stripe.subscriptions.update('sub_xxx', {
  cancel_at_period_end: true,
});

// Immediately (with refund logic)
const subscription = await stripe.subscriptions.cancel('sub_xxx', {
  refund: 'prorate', // or 'none', 'full'
});
```

## Trial Management

### Free Trial
```javascript
const subscription = await stripe.subscriptions.create({
  customer: 'cus_xxx',
  items: [{ price: 'price_xxx' }],
  trial_period_days: 14,
  trial_settings: {
    end_behavior: {
      missing_payment_method: 'cancel', // or 'pause'
    },
  },
  payment_settings: {
    save_default_payment_method: 'on_subscription',
  },
});
```

### Trial Without Payment Method
```javascript
const subscription = await stripe.subscriptions.create({
  customer: 'cus_xxx',
  items: [{ price: 'price_xxx' }],
  trial_from_plan: true, // Use trial from price object
});
```

## Pause and Resume
```javascript
// Pause (maintain state)
await stripe.subscriptions.update('sub_xxx', {
  pause_collection: {
    behavior: 'mark_uncollectible', // or 'void', 'keep_as_draft'
    resumes_at: Math.floor(Date.now() / 1000) + 30 * 24 * 60 * 60,
  },
});

// Resume
await stripe.subscriptions.update('sub_xxx', {
  pause_collection: '',
});
```

## State Machine

```
    ┌─────────────┐
    │  trialing   │
    └──────┬──────┘
           │ payment method added
           ▼
    ┌─────────────┐     ┌─────────────┐
    │   active    │────▶│ past_due    │
    └──────┬──────│     └──────┬──────┘
           │ cancel │           │ paid
           ▼        │           ▼
    ┌─────────────┐  │    ┌─────────────┐
    │  canceled   │  └───▶│  active     │
    └─────────────┘       └─────────────┘
           │
           │ reactivate
           ▼
    ┌─────────────┐
    │   active    │
    └─────────────┘
```

## Anti-Patterns
- Charging immediately without collecting payment method first
- Not handling `invoice.payment_failed` webhook events
- Ignoring subscription status changes in webhooks
- Hard-coding trial lengths without plan flexibility
- Not implementing idempotency keys for retries


## Related
- `05-execution/rules/stripe/subscriptions.md` — Subscription management
- `05-execution/rules/stripe/webhooks.md` — Webhook handling
- `04-playbooks/build/create-saas.md` — SaaS build playbook
- `07-patterns/billing/` — Billing patterns
