---
description: "Merge parallel worktrees into integration branch"
argument-hint: [worktree-1] [worktree-2] ...
---

# Merge Worktrees

Merge completed worktrees into an integration branch with sequential validation.

## Arguments

Space-separated worktree feature names to merge: $ARGUMENTS

If no arguments provided, discover all worktrees:
```bash
git worktree list
```

## Process

### 1. Create Integration Branch

```bash
git checkout -b integrate/$(date +%Y%m%d) main
```

### 2. Sequential Merge with Validation

For each worktree **in order**:

#### a. Verify worktree is ready
```bash
cd ../agentix-wt-{feature-name}
git status --porcelain  # Must be clean
git log main..HEAD --oneline  # Show commits to merge
```

#### b. Merge into integration branch
```bash
cd /Users/infinit/agentix
git merge feature/{feature-name} --no-ff -m "integrate: merge {feature-name}"
```

#### c. Validate after each merge
```bash
npm run typecheck
npm run test -- --run
npm run lint
```

#### d. Handle conflicts
If merge conflicts occur:
1. List conflicted files
2. Resolve conflicts (prefer the feature branch for new code, preserve main for shared code)
3. Run validation again after resolution

#### e. Rollback on failure
If validation fails after merge and cannot be fixed:
```bash
git merge --abort
# or if already committed:
git revert HEAD
```

Skip this worktree and continue with the next. Report the failure.

### 3. Final Validation

After all merges:

```bash
npm run typecheck
npm run test -- --run
npm run lint
npm run compliance
npm run build
```

### 4. Summary

```
Merge Results:
┌──────────────┬────────┬──────────┐
│ Feature      │ Status │ Commits  │
├──────────────┼────────┼──────────┤
│ feature-1    │ ✅/❌  │ N        │
│ feature-2    │ ✅/❌  │ N        │
│ feature-3    │ ✅/❌  │ N        │
├──────────────┼────────┼──────────┤
│ Integration  │ ✅/❌  │ Total    │
└──────────────┴────────┴──────────┘
```

### 5. Next Steps

If all passed:
- Merge integration branch to main: `git checkout main && git merge integrate/YYYYMMDD --no-ff`
- Run `/worktree-cleanup` to remove worktrees

If some failed:
- Fix failures in the worktree, then retry
- Or proceed without the failed features

## Important

- Merge order matters — merge foundational features first
- Always validate after EACH merge, not just at the end
- Never force-push integration branches
- Keep the integration branch until all features are confirmed working
