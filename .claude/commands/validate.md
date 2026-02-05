---
description: "Run comprehensive 5-level validation"
---

# Validate

Run comprehensive validation of the project to ensure all tests, type checks, linting, and compliance are passing.

Execute the following in sequence and report results:

## Level 1: Type Checking

```bash
npm run typecheck
```

**Expected:** No type errors

## Level 2: Linting

```bash
npm run lint
```

**Expected:** No lint errors

## Level 3: Unit Tests

```bash
npm run test -- --run
```

**Expected:** All tests pass

## Level 4: Compliance Suite

```bash
npm run compliance
```

**Expected:** All services pass 6-contract compliance checks

## Level 5: Build

```bash
npm run build
```

**Expected:** Clean build with no errors

## Summary Report

After all validations complete, provide:

```
Level 1 — TypeCheck:   ✅ PASS | ❌ FAIL (N errors)
Level 2 — Lint:        ✅ PASS | ❌ FAIL (N errors)
Level 3 — Tests:       ✅ PASS | ❌ FAIL (N/M passed)
Level 4 — Compliance:  ✅ PASS | ❌ FAIL (N services non-compliant)
Level 5 — Build:       ✅ PASS | ❌ FAIL

Overall: PASS | FAIL
```

If any level fails:
1. Report the specific errors
2. Suggest fixes
3. After fixing, re-run that level before continuing

**Do not skip levels.** A failure at Level 1 must be fixed before proceeding to Level 2.
