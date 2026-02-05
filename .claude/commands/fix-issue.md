---
description: "End-to-end GitHub issue fix: investigate, fix, validate, PR"
argument-hint: [issue-number]
---

# Fix Issue #$ARGUMENTS

**Philosophy:** Complete the entire workflow. The human reviews the PR, not your intermediate steps.

## Phase 1: Fetch Issue

```bash
gh issue view $ARGUMENTS --json title,body,labels,assignees,comments
```

Read and understand:
- What is the reported problem?
- Are there reproduction steps?
- What labels/priority are assigned?
- Any useful context in comments?

## Phase 2: Create Branch

```bash
git checkout -b fix/$ARGUMENTS main
```

## Phase 3: Investigate

- Search the codebase for relevant code
- Read the files involved
- Identify the root cause (not just symptoms)
- Check if there are existing tests that should have caught this

## Phase 4: Root Cause Analysis

Document:
- **Symptom:** What the user sees
- **Root Cause:** Why it happens
- **Impact:** What else is affected
- **Fix Strategy:** How to fix it properly (not just patch the symptom)

## Phase 5: Implement Fix

- Fix the root cause, not just the symptom
- Follow existing code patterns
- Add/update types as needed
- Add structured logging if the area lacked observability

## Phase 6: Add Tests

- Add a test that reproduces the bug (should fail without the fix)
- Add regression tests for related edge cases
- Ensure existing tests still pass

## Phase 7: Validate

Run full validation:

```bash
npm run typecheck
npm run lint
npm run test -- --run
npm run compliance
```

All must pass. Fix any failures before proceeding.

## Phase 8: Create PR

```bash
git add -A
git commit -m "fix: resolve #{issue-number} - {brief description}

Root cause: {one-line root cause}
Fix: {one-line fix description}

Closes #{issue-number}"
git push -u origin fix/$ARGUMENTS
```

Create PR:

```bash
gh pr create --title "fix: {brief description}" --body "$(cat <<'EOF'
## Summary

Fixes #{issue-number}

**Root Cause:** {description}
**Fix:** {description}

## Changes
- {file changes}

## Testing
- {tests added}
- All validation passing

## Validation
```
npm run typecheck  ✅
npm run lint       ✅
npm run test       ✅
npm run compliance ✅
```
EOF
)"
```

## Output

Report:
- Issue summary
- Root cause analysis
- Files changed
- Tests added
- PR URL
- Validation results
