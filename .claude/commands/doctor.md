# /doctor — Diagnostic Command

**Source:** OpenClaw Pattern 16 (.agents/reference/openclaw-patterns-adoption.md)
**Version:** 1.0

## Purpose

Validate project configuration, detect issues, and optionally auto-repair.

## Checks

1. **Environment Variables** — Required env vars are set
2. **Provider Connections** — All configured providers are reachable
3. **Database** — Supabase connection works
4. **Event Bus** — Event infrastructure healthy
5. **Service Health** — All registered services pass health checks
6. **Dependencies** — No security vulnerabilities in npm audit
7. **TypeScript** — Project compiles without errors
8. **Tests** — All tests pass
9. **Documentation** — Key docs exist and are current

## Usage

```bash
npm run doctor       # Run diagnostics
npm run doctor --fix # Run diagnostics and attempt auto-repair
```

## Output

Report with OK / WARN / FAIL per check, plus suggested fixes.

## Implementation

To be implemented as infrastructure tooling.
Currently outputs a placeholder message.
