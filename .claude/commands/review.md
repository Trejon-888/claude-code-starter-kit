---
description: "Technical code review on recent changes"
---

# Code Review

Perform technical code review on recently changed files.

## Philosophy

- Simplicity is the ultimate sophistication — every line should justify its existence
- Code is read far more often than it's written — optimize for readability
- The best code is often the code you don't write

## Step 1: Gather Context

Read codebase standards:
- CLAUDE.md
- Key files in the relevant service module
- `.agents/reference/shared-types.md` for contract shapes

## Step 2: Examine Changes

```bash
git status
git diff HEAD
git diff --stat HEAD
git ls-files --others --exclude-standard
```

Read each changed file **in its entirety** (not just the diff) to understand full context.
Read each new file in its entirety.

## Step 3: Analyze

For each changed or new file, check:

1. **Logic Errors** — Off-by-one, incorrect conditionals, missing error handling, race conditions
2. **Security Issues** — Injection vulnerabilities, insecure data handling, exposed secrets
3. **Performance** — N+1 queries, inefficient algorithms, memory leaks, unbounded lists
4. **Code Quality** — DRY violations, overly complex functions, poor naming, missing types
5. **Project Standards** — compliance with patterns documented in CLAUDE.md
6. **Testing** — Missing tests, tests that assert implementation not behavior, uncovered edge cases

## Step 4: Verify Issues

- Run `npm run typecheck` to confirm type errors
- Run `npm run test -- --run` to confirm test issues
- Validate security concerns with context

## Output

Save to `.agents/code-reviews/{descriptive-name}.md`

**Stats:**
- Files Modified: N
- Files Added: N
- Files Deleted: N
- Lines Added: N
- Lines Removed: N

**For each issue:**

```yaml
severity: critical | high | medium | low
file: path/to/file.ts
line: 42
issue: One-line description
detail: Why this is a problem
suggestion: How to fix it
```

If no issues: "Code review passed. No technical issues detected."

## Important

- Be specific (line numbers, not vague complaints)
- Focus on real bugs, not style
- Suggest fixes, don't just complain
- Flag security issues as CRITICAL
- Flag project standard violations as HIGH
