---
description: "Rebase, validate, and merge a PR"
argument-hint: [pr-number]
---

# Merge PR #$ARGUMENTS

## Process

### 1. Check PR Status

```bash
gh pr view $ARGUMENTS --json state,mergeable,reviewDecision,statusCheckRollup
```

Verify:
- PR is open
- PR is mergeable (no conflicts)
- Reviews are approved (or no reviews required)
- CI checks passing (if any)

### 2. Checkout PR

```bash
gh pr checkout $ARGUMENTS
```

### 3. Rebase on Main

```bash
git fetch origin main
git rebase origin/main
```

If conflicts arise:
- Resolve conflicts
- `git rebase --continue`
- If too complex, abort and report to user

### 4. Re-validate After Rebase

```bash
npm run typecheck
npm run test -- --run
npm run lint
npm run compliance
```

All must pass. If any fail after rebase, report the issue.

### 5. Push Rebased Branch

```bash
git push --force-with-lease
```

### 6. Merge

```bash
gh pr merge $ARGUMENTS --rebase --delete-branch
```

### 7. Cleanup

```bash
git checkout main
git pull origin main
```

### 8. Report

```
PR #N merged successfully.
- Branch: {branch-name} (deleted)
- Commits: N
- Files changed: N
- Main is up to date.
```

## Important

- Always rebase before merging to keep history clean
- Always re-validate after rebase — conflicts can introduce subtle bugs
- Use `--force-with-lease` not `--force` when pushing rebased branches
- Delete the branch after merge to keep the repo clean
