---
description: "Clean up git worktrees safely"
argument-hint: [branch-name | "all" | "merged"]
---

# Worktree Cleanup

Safely remove git worktrees with PR status awareness.

## Arguments

- `{branch-name}` — Remove a specific worktree
- `all` — Remove all worktrees
- `merged` — Remove only worktrees whose branches are merged to main

## Process

### 1. Discover Worktrees

```bash
git worktree list
```

### 2. Safety Checks

For each worktree to remove:

#### a. Check for uncommitted changes
```bash
cd {worktree-path}
git status --porcelain
```

If changes exist: **WARN and skip** unless user confirms.

#### b. Check PR status (if applicable)
```bash
gh pr list --head feature/{name} --json state,mergedAt
```

- If PR is open: **WARN** — worktree has an active PR
- If PR is merged: Safe to remove
- If no PR: Safe to remove

#### c. Check if branch is merged
```bash
git branch --merged main | grep feature/{name}
```

- If merged: Safe to remove
- If not merged: **WARN** — branch has unmerged commits

### 3. Remove Worktrees

For each worktree that passed safety checks:

```bash
# Remove worktree
git worktree remove ../agentix-wt-{name}

# Optionally delete the branch
git branch -d feature/{name}
```

If the branch can't be deleted with `-d` (has unmerged commits), report it but don't force delete.

### 4. Prune

```bash
git worktree prune
```

### 5. Summary

```
Cleanup Results:
┌──────────────┬─────────┬────────────────┐
│ Worktree     │ Action  │ Note           │
├──────────────┼─────────┼────────────────┤
│ wt-feature-1 │ Removed │ Branch deleted  │
│ wt-feature-2 │ Skipped │ Uncommitted     │
│ wt-feature-3 │ Removed │ Branch kept     │
└──────────────┴─────────┴────────────────┘
```

## Modes

### Single Branch
```
/worktree-cleanup feature-name
```
Removes only the specified worktree.

### All
```
/worktree-cleanup all
```
Removes all worktrees (with safety checks on each).

### Merged Only (Smart Cleanup)
```
/worktree-cleanup merged
```
Only removes worktrees whose branches are fully merged to main. Safest option.

## Important

- Never force-delete branches with unmerged commits without explicit user confirmation
- Always check for uncommitted changes before removing
- Always prune after removing worktrees
- If current directory is inside a worktree being removed, switch to main repo first
