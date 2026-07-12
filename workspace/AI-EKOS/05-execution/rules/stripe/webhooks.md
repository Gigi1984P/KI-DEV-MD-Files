# Stripe Webhooks

## Security: Verify Signatures

```typescript
import Stripe from 'stripe';
import { buffer } from 'micro';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

export async function POST(req: Request) {
  const buf = await buffer(req);
  const sig = req.headers.get('stripe-signature')!;
  
  let event: Stripe.Event;
  
  try {
    event = stripe.webhooks.constructEvent(buf, sig, webhookSecret);
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    return new Response('Invalid signature', { status: 400 });
  }
  
  // Process the event
  switch (event.type) {
    case 'invoice.payment_succeeded':
      await handlePaymentSucceeded(event.data.object);
      break;
    case 'invoice.payment_failed':
      await handlePaymentFailed(event.data.object);
      break;
    case 'customer.subscription.updated':
      await handleSubscriptionUpdated(event.data.object);
      break;
    case 'customer.subscription.deleted':
      await handleSubscriptionDeleted(event.data.object);
      break;
  }
  
  return new Response('OK', { status: 200 });
}
```

## Critical Events

### Payment Success
```typescript
async function handlePaymentSucceeded(invoice: Stripe.Invoice) {
  const subscriptionId = invoice.subscription as string;
  const customerId = invoice.customer as string;
  
  await db.update(subscriptions)
    .set({
      status: 'active',
      lastPaymentAt: new Date(),
      paymentFailedCount: 0,
    })
    .where(eq(subscriptions.stripeSubscriptionId, subscriptionId));
  
  // Grant entitlements
  await grantEntitlements(customerId, invoice.lines.data);
}
```

### Payment Failure
```typescript
async function handlePaymentFailed(invoice: Stripe.Invoice) {
  const subscriptionId = invoice.subscription as string;
  
  // Retry logic: Stripe handles 3 automatic retries
  // We track and notify at thresholds
  await db.update(subscriptions)
    .set({
      status: 'past_due',
      paymentFailedCount: sql`${subscriptions.paymentFailedCount} + 1`,
    })
    .where(eq(subscriptions.stripeSubscriptionId, subscriptionId));
  
  // Notify customer after first failure
  await notifyPaymentFailure(invoice.customer_email);
}
```

### Subscription Cancellation
```typescript
async function handleSubscriptionDeleted(subscription: Stripe.Subscription) {
  await db.update(subscriptions)
    .set({
      status: 'canceled',
      canceledAt: new Date(),
      // Keep entitlements until period end
      currentPeriodEnd: new Date(subscription.current_period_end * 1000),
    })
    .where(eq(subscriptions.stripeSubscriptionId, subscription.id));
}
```

## Idempotency

```typescript
// Prevent duplicate processing
async function processWebhook(event: Stripe.Event) {
  const eventId = event.id;
  
  // Check if already processed
  const existing = await db.select()
    .from(processedWebhooks)
    .where(eq(processedWebhooks.stripeEventId, eventId))
    .get();
  
  if (existing) {
    console.log(`Webhook ${eventId} already processed`);
    return;
  }
  
  // Process within transaction
  await db.transaction(async (tx) => {
    await processEvent(event);
    await tx.insert(processedWebhooks).values({
      stripeEventId: eventId,
      processedAt: new Date(),
    });
  });
}
```

## Anti-Patterns
- Trusting webhook payload without signature verification
- Processing webhooks synchronously (timeout risk)
- Not handling duplicate events
- Updating database without transactions
- Ignoring webhook delivery failures (retry 3 times then dead letter)


## Related
- `05-execution/rules/stripe/subscriptions.md` — Subscription management
- `05-execution/rules/stripe/webhooks.md` — Webhook handling
- `04-playbooks/build/create-saas.md` — SaaS build playbook
- `07-patterns/billing/` — Billing patterns
