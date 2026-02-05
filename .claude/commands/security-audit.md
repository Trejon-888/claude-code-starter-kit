# /security-audit — Security Configuration Audit

**Source:** OpenClaw Pattern 10 (.agents/reference/openclaw-patterns-adoption.md)
**Version:** 1.0

## Purpose

Validate security configuration, detect vulnerabilities, and optionally auto-fix.

## Checks

1. **Credential Storage** — Provider API keys in env vars, not in code
2. **Audit Logging** — Enabled per service
3. **AI Trust Levels** — Configured and enforced
4. **Tenant Isolation** — Per-org database isolation verified
5. **Trust Level Compliance** — No services operating above authorized trust level
6. **Log Redaction** — Sensitive data redaction enabled in all loggers
7. **Webhook Signatures** — All webhook endpoints verify signatures

## Usage

```bash
npm run security-audit       # Run audit
npm run security-audit --fix # Run audit and apply fixes
```

## Output

Report with PASS / FAIL / WARN per check, plus remediation suggestions.

## Implementation

To be implemented as part of Security (#3) service in Tier 0.
Currently outputs a placeholder message.
