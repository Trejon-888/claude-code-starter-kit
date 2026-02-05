---
description: "Comprehensive PR review with structured feedback"
argument-hint: [pr-number]
---

# Review PR #$ARGUMENTS

## Phase 1: Fetch PR

```bash
gh pr view $ARGUMENTS --json title,body,headRefName,baseRefName,files,additions,deletions,commits
gh pr diff $ARGUMENTS
```

## Phase 2: Understand Context

- What is this PR trying to accomplish?
- What issue does it reference?
- Read the PR description and linked issues
- Understand the scope of changes

## Phase 3: Code Review

Read each changed file **in its entirety** (not just the diff).

### Checklist

**Architecture:**
- [ ] Service boundaries respected
- [ ] No direct external API calls (uses provider adapters)
- [ ] No cross-service internal imports
- [ ] Events follow `{service}.{entity}.{action}` naming

**Type Safety:**
- [ ] No `any` types
- [ ] Proper TypeScript strict mode compliance
- [ ] Return types explicit on public functions

**Security:**
- [ ] No injection vulnerabilities
- [ ] No exposed secrets
- [ ] Auth checks present on new endpoints
- [ ] Tenant isolation maintained

**Testing:**
- [ ] New code has tests
- [ ] Edge cases covered
- [ ] Tests assert behavior, not implementation

**Performance:**
- [ ] No N+1 queries
- [ ] No unbounded list returns
- [ ] No unnecessary computation

**Project Standards:**
- [ ] Follows patterns documented in CLAUDE.md
- [ ] Structured logging (not console.log)
- [ ] Clean separation of concerns

## Phase 4: Run Validation

```bash
gh pr checkout $ARGUMENTS
npm run typecheck
npm run test -- --run
npm run lint
# Run project-specific validation from CLAUDE.md
```

## Phase 5: Generate Review

### Decision

- **APPROVE** — Code is correct, well-tested, follows standards
- **REQUEST CHANGES** — Issues found that must be fixed before merge
- **BLOCK** — Critical issues (security, data loss, architecture violation)

### Publish Review

```bash
gh pr review $ARGUMENTS --{approve|request-changes} --body "$(cat <<'EOF'
## Review Summary

**Decision:** {APPROVE | REQUEST CHANGES | BLOCK}

### What's Good
- {positive observations}

### Issues Found

{For each issue:}
**[severity]** `file:line` — {description}
Suggestion: {how to fix}

### Validation Results
- TypeCheck: ✅/❌
- Tests: ✅/❌
- Lint: ✅/❌
- Compliance: ✅/❌
EOF
)"
```

## Output

Save review to `.agents/pr-reviews/pr-{number}-review.md`

Include:
- PR summary
- Decision with rationale
- All issues found with severity
- Validation results
- Checklist results
