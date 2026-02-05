---
description: "Create parallel worktrees with subagent spawning"
argument-hint: [feature-1] [feature-2] [feature-3...]
---

# Worktree: Parallel Development

Create 1-5 parallel git worktrees, each with its own branch, and spawn subagents to work on them simultaneously.

## Arguments

Space-separated feature names (1-5): $ARGUMENTS

## Process

### 1. Validate

```bash
# Ensure clean state
git status --porcelain
# Ensure we're on main
git branch --show-current
```

If there are uncommitted changes, stall and ask the user to commit or stash first.

### 2. Create Worktrees

For each feature argument, create a worktree:

```bash
# Pattern: ../agentix-wt-{feature-name}
git worktree add ../agentix-wt-{feature-name} -b feature/{feature-name} main
```

**Port allocation** (if any worktree needs a dev server):
- Worktree 1: port 8124
- Worktree 2: port 8125
- Worktree 3: port 8126
- Worktree 4: port 8127
- Worktree 5: port 8128

### 3. Install Dependencies

For each worktree:

```bash
cd ../agentix-wt-{feature-name} && npm install
```

### 4. Spawn Subagents

**CRITICAL: Spawn ALL agents in a SINGLE message** for true parallel execution.

For each worktree, use the Task tool to spawn a subagent:

```
Task: "Implement {feature-name} in worktree"
subagent_type: general-purpose
prompt: |
  You are working in the Agentix worktree at: ../agentix-wt-{feature-name}
  Branch: feature/{feature-name}

  Your task: [specific implementation instructions]

  When done:
  1. Run npm run typecheck
  2. Run npm run test -- --run
  3. Run npm run lint
  4. Commit your changes with a descriptive message
  5. Report: files created, files modified, tests added, validation results
```

### 5. Collect Results

After all subagents complete, summarize:

```
Worktree Results:
┌──────────────┬────────┬───────┬───────┐
│ Feature      │ Status │ Tests │ Files │
├──────────────┼────────┼───────┼───────┤
│ feature-1    │ ✅/❌  │ N/M   │ N     │
│ feature-2    │ ✅/❌  │ N/M   │ N     │
│ feature-3    │ ✅/❌  │ N/M   │ N     │
└──────────────┴────────┴───────┴───────┘
```

### 6. Next Steps

Suggest:
- `/merge-worktrees` to integrate all features
- `/worktree-cleanup` to remove worktrees after merge

## Limits

- Maximum 5 parallel worktrees
- Each worktree gets its own branch from main
- Worktrees are created as siblings of the project directory
- Never create worktrees inside the project directory

## Important

- Always validate each worktree independently before merging
- Worktrees share the git history but have isolated working directories
- If a subagent fails, the others continue — report failures at the end
