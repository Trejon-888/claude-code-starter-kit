# Claude Commands & Skills

**20 commands + 3 skills — composable autonomous development toolkit.**

---

## Command Architecture

Commands are standalone, composable building blocks. Use them independently or chain them together.

```
Standalone Commands          Skills (auto-invoked)
────────────────────         ─────────────────────
/plan                        continue (session start)
/execute                     done (session end)
/review                      piv (development loop)
/system-review
/validate
/prime
/worktree
/merge-worktrees
/worktree-cleanup
/fix-issue
/review-pr
/create-pr
/merge-pr
```

---

## PIV Loop Commands

| Command | Purpose | Input |
|---------|---------|-------|
| `/plan` | Deep codebase analysis → implementation plan | Feature description |
| `/execute` | Autonomous plan execution with branch setup | Path to plan file |
| `/review` | Technical code review on git diff | (none — reads git state) |
| `/system-review` | Plan vs reality → process improvements | Plan path + execution report |
| `/validate` | 5-level validation (types → lint → test → build) | (none) |
| `/prime` | Load project context, human-readable summary | (none) |

---

## Worktree Commands

| Command | Purpose | Input |
|---------|---------|-------|
| `/worktree` | Create 1-5 parallel worktrees with subagent spawning | Feature names |
| `/merge-worktrees` | Sequential merge with validation into integration branch | Worktree names |
| `/worktree-cleanup` | Safe removal with PR/commit awareness | Branch name, "all", or "merged" |

---

## GitHub Workflow Commands

| Command | Purpose | Input |
|---------|---------|-------|
| `/fix-issue` | Issue → branch → investigate → fix → validate → PR | Issue number |
| `/review-pr` | Comprehensive PR review with APPROVE/REQUEST CHANGES/BLOCK | PR number |
| `/create-pr` | Create PR from current branch | (none) |
| `/merge-pr` | Rebase, validate, merge, cleanup | PR number |

---

## Session Commands (Skills)

| Command/Skill | Purpose | Auto-Triggers |
|---------------|---------|---------------|
| `/continue` | Load context, alignment audit, status, next action | Session start, "resume", "what's next" |
| `/done` | Validate, sync, heal, evolve, report, commit | "finished", "wrap up", "ship it" |
| `/piv` | Full recursive development loop (10 phases) | "autopilot", "full validation" |

---

## Composition Patterns

```
Quick fix:      /fix-issue 42
Feature:        /plan → /execute → /review → /done
Parallel build: /worktree A B C → /merge-worktrees → /done
Audit only:     /validate + /review
PR workflow:    /create-pr → /review-pr → /merge-pr
Full PIV:       /piv (encompasses plan → execute → validate → done)
Context load:   /prime or /continue
Process review: /system-review (after plan execution)
```

---

## Design Principles

1. **Composable** — Every command works standalone AND chains with others
2. **Document-driven** — Commands read CLAUDE.md, PRD, plans — no hardcoded specifics
3. **Self-evolving** — Commands improve themselves when patterns emerge
4. **Parallel-aware** — Worktree commands enable true parallel development
5. **Autonomous** — End-to-end workflows (fix-issue, execute) complete without human intervention

---

**Version:** 3.0
