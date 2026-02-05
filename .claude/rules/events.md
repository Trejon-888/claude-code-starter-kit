# Event Rules

## Naming Convention

All events follow: `{service}.{entity}.{action}`

- **service**: lowercase, matches module name
- **entity**: lowercase, singular noun (e.g., `user`, `invoice`, `message`)
- **action**: past tense verb (e.g., `created`, `updated`, `deleted`, `sent`)

### Examples
```
auth.session.created
billing.invoice.sent
messaging.message.delivered
```

## Event Payload

Every event includes a standard envelope:

```typescript
interface EventPayload<T> {
  id: string              // Unique event ID
  type: string            // {service}.{entity}.{action}
  timestamp: string       // ISO 8601
  actor: {
    type: 'user' | 'ai' | 'system'
    id: string
  }
  data: T                 // Event-specific payload
}
```

## Rules

1. Events are immutable — never modify a published event
2. Events are past tense — they describe what happened
3. Services publish their own events — never for another service
4. Event handlers must be idempotent — duplicate delivery is possible
5. Side effects go in event handlers, not in the method that publishes
