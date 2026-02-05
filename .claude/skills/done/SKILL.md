---
name: done
description: "Self-evolving session completion: validate, sync, heal, evolve, report, commit. Auto-invoke when user says 'done', 'finished', 'wrap up', 'commit this', 'push it', 'ship it', 'cleanup', 'tidy up'."
---

# /done v3.0 — Self-Evolving Session Completion

**9-phase engine for validated, synchronized, self-healing session completion.**

---

## Core Principle

**This command is document-driven and cross-project portable.** It reads your project's key documents to understand context — no hardcoded project specifics. It discovers, validates, syncs, heals, evolves, and commits in a single recursive flow.

---

## 9-Phase Architecture

```
DISCOVERY → VALIDATE → SYNC → ALIGNMENT AUDIT → EVOLUTION CHECK → REPORT → HEAL → COMMIT → REFLECT
   (0)         (1)       (2)        (3)               (4)           (5)      (6)     (7)      (8)
```

**Recursive loop:** Phases 3→6 repeat up to 3 iterations until alignment passes.

**Rule:** No commit until alignment score >= 80%. No exceptions.

---

## PHASE 0: DISCOVERY — Dynamic Project Scan

### Step 0.1: Build Document Registry

Scan for key documents dynamically:

```bash
# Root-level docs
ls CLAUDE.md 2>/dev/null

# .agents/ structure
find .agents -type f -name "*.md" -maxdepth 1 2>/dev/null
find .agents/plans -type f -name "*.md" 2>/dev/null
find .agents/reference -type f -name "*.md" 2>/dev/null
find .agents/execution-reports -type f -name "*.md" 2>/dev/null | tail -5

# Skills and commands
find .claude/skills -name "SKILL.md" 2>/dev/null
find .claude/commands -name "*.md" 2>/dev/null
```

### Step 0.2: Build Sync Map

Detect what changed this session:

```bash
git diff --name-only HEAD~1..HEAD 2>/dev/null
git diff --name-only 2>/dev/null
git diff --cached --name-only 2>/dev/null
git log --oneline -5 2>/dev/null
```

Classify changes into areas affected (frontend, backend, database, plans, docs, skills, tests).

### Step 0.3: Auto-Classify Session Type

Based on changes:
- **Feature Implementation**: New src/ files, new routes
- **Bug Fix**: Modifications to existing files
- **Planning Session**: New/modified plan files
- **Housekeeping**: Doc updates, cleanup
- **Infrastructure**: Config changes, dependency updates
- **Testing**: New/modified test files

---

## PHASE 1: VALIDATE — Tech-Stack-Aware Gates

### Step 1.1: Read Validation Commands

Parse CLAUDE.md "Essential Commands" section. Fallback if not specified:
- `package.json` exists → `npm run build`
- `pyproject.toml` exists → `pytest`
- `Makefile` exists → `make test`

### Step 1.2: Run Conditional Gates

Run validation based on what changed (build, lint, test). Skip gates for areas that didn't change.

### Step 1.3: Stale Reference Detection

```bash
find .agents/reference -name "*.md" -mtime +30 2>/dev/null
```

**IF ANY GATE FAILS:** Stop. Fix before continuing.

---

## PHASE 2: SYNC — Dynamic Document Synchronization

### Step 2.0: Plan Documentation Sync (MANDATORY)

Check if a plan was executed this session. If yes:
- Copy to `.agents/plans/completed/{descriptive-name}.md` with `Status: Completed`
- This is NOT optional — undocumented plans are lost context

### Step 2.1: INDEX.md Sync

Count actual folder contents, update Quick Stats and tables.

### Step 2.2: CLAUDE.md Sync

If tech stack or architecture changed, update CLAUDE.md.

### Step 2.3: PRD.md Sync

If features completed, add row to Implementation Status table.

### Step 2.4: HANDOVER.md Sync

**ALWAYS update:**
- Add session log entry (session number, date, context, completed items, next steps)
- Update Active Plans list
- Update Current Status

### Step 2.5: Skill/Command Sync

Verify matching commands and skills exist with same versions.

### Step 2.6: Research Capture

If session involved web research or external services:
- Check for reference doc: `.agents/reference/[service]-patterns.md`
- Create or update as needed

---

## PHASE 3: ALIGNMENT AUDIT — Drift Detection

### 10 Alignment Checks

Each check: PASS (1 point) or FAIL (0 points).

1. INDEX.md counts match reality
2. INDEX.md tables match folders
3. PRD.md status matches completed plans
4. HANDOVER.md reflects current session
5. CLAUDE.md tech stack matches dependencies
6. Reference docs are current (<30 days)
7. Skills and commands are version-synced
8. Execution reports exist for completed plans
9. No empty .agents/ directories
10. HANDOVER.md session log is sequential

### Deep Audits

**DEEP AUDIT A: PRD.md Content Accuracy**
- Implementation Status completeness
- No "Planned" features that exist in code
- Version reflects reality

**DEEP AUDIT B: CLAUDE.md Content Accuracy**
- Tech stack matches package.json
- Commands table matches actual `.claude/` contents
- Architecture matches folder structure

### Alignment Score

```
ALIGNMENT_SCORE = (checks_passed / TOTAL_CHECKS) * 100%
```

| Score | Action |
|-------|--------|
| 100% | Commit |
| 80-99% | Auto-fix, commit |
| 60-79% | Fix + warnings |
| <60% | Block commit |

---

## PHASE 4: EVOLUTION CHECK — Self-Discovery Engine

### Trigger 1: Missing Reference Docs
External services in code without reference docs in `.agents/reference/`.

### Trigger 2: Repeated Patterns
```bash
git log --oneline -50 | awk '{$1=""; print}' | sort | uniq -c | sort -rn | head -10
```
3+ repetitions = automation opportunity.

### Trigger 3: Stale Documentation
Docs not modified in 30+ days.

### Trigger 4: Missing Skills for Repeated Workflows
Workflow patterns without matching skills.

### Trigger 5: Skill/Command Version Drift
Mismatched versions between skill and command pairs.

### Trigger 6: Document Cascade Gaps
Incomplete cascades in recent commits.

---

## PHASE 5: REPORT — Execution Report

### File Location
`.agents/execution-reports/YYYY-MM-DD-[feature-name].md`

### Template

```markdown
# [Feature/Session Name] - Execution Report

**Date:** YYYY-MM-DD
**Type:** [auto-detected session type]
**Alignment Score:** [X]%

## Summary
[2-3 sentences]

## What Was Built/Changed
- [List main changes]

## Validation Results
| Gate | Status | Details |
|------|--------|---------|
| Build | Pass/Fail | [output] |
| Lint | Pass/Fail | [output] |
| Tests | Pass/Fail | [count] |

## Alignment Score: [X]%
[Check results table]

## Evolution Discoveries
[If any triggers fired]

## Next Steps
- [What should happen next]

---
*Generated by claude-code-starter-kit | [INFINITX](https://app.infinitxai.com)*
```

### Step 5.3: Distill to PROJECT-MEMORY.md

After creating the execution report, extract durable knowledge:
1. Architecture decisions → Architecture Decisions table
2. Bugs with non-obvious root causes → Problems Solved
3. Breaking changes → Breaking Changes Log
4. Domain-specific gotchas → Gotchas

---

## PHASE 6: HEAL — Self-Healing Engine

### What HEAL Can Auto-Fix

| Issue | Fix |
|-------|-----|
| INDEX.md count mismatch | Recalculate from folders |
| INDEX.md table mismatch | Add/remove entries |
| HANDOVER.md not current | Add session entry |
| Empty directories | Remove them |
| Skill/command version drift | Update versions |
| Missing execution report links | Add links |
| Stale "Last Verified" dates | Update if reviewed |
| CLAUDE.md commands table outdated | Rebuild from `.claude/` |
| PRD.md "Planned" features in code | Update to "Implemented" |

### What HEAL Flags for Human

| Issue | Why |
|-------|-----|
| PRD.md feature completion | Needs verification |
| CLAUDE.md tech stack additions | Needs accuracy check |
| Missing reference docs | Needs research |
| Missing skills | Needs design |

### Recursive Loop

```
WHILE alignment_score < 100% AND iteration < 3:
  Apply auto-fixes → Re-run alignment audit
IF alignment_score >= 80%: Proceed to commit
ELSE: Block commit with manual issues listed
```

---

## PHASE 7: COMMIT

```bash
git add -A
git commit -m "[type]: [description]

- Alignment Score: [X]%
- Created execution report

Co-Authored-By: Claude <noreply@anthropic.com>"

git push origin [branch]
```

---

## PHASE 8: REFLECT — Learning

### Step 8.1: Session Learnings

Ensure HANDOVER.md has:
- What was built/fixed
- Key decisions made
- Issues encountered
- Alignment score
- Evolution opportunities

### Step 8.2: Evolution Action

If high-priority, auto-actionable evolution triggers fired: apply them.
If high-priority but not auto-actionable: prompt the user.

### Step 8.3: Final Output

```markdown
## Session Complete

**Validation:** [All N gates passed]
**Alignment Score:** [X]%
**Documents Synced:** [list]
**Healing Applied:** [N] auto-fixes
**Evolution Discoveries:** [N] opportunities

**Commit:** [hash] — [message]

Ready to start something new? Use `/continue` to see what's next.
```

---

## Document Cascade Rule

```
Feature/Plan completes →
  ├── PRD.md (Implementation Status)
  ├── INDEX.md (move plan, update counts)
  ├── HANDOVER.md (session context)
  ├── PROJECT-MEMORY.md (distill learnings)
  └── Execution report

Skills/commands changed →
  ├── Mirror skill ↔ command
  └── Update CLAUDE.md tables
```

---

## Cross-Project Portability

1. Read CLAUDE.md for tech stack + validation commands
2. Scan `.agents/` dynamically
3. Skip checks for missing documents gracefully
4. No hardcoded paths except: `CLAUDE.md`, `.agents/`, `.claude/`

---

## Auto-Trigger Patterns

- "done", "finished", "wrap up"
- "commit this", "push it", "ship it"
- "cleanup", "tidy up"

---

**Version:** 3.0
