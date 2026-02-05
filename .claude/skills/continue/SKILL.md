---
name: continue
description: "Load project context, alignment audit, status check, suggest next action. Auto-invoke at session start, after context switches, or when user says 'continue', 'pick up where we left off', 'resume', 'what's next', 'status check', 'what now'."
---

# /continue v2.0 — Session Resume with Alignment Audit

**Load context, audit alignment, check status, suggest next action.**

---

## Core Principle

**This command is document-driven and cross-project portable.** It reads your project's key documents to understand context — no hardcoded project specifics. It discovers what exists, audits alignment, and suggests the highest-priority next action.

---

## 6-Step Flow

```
LOAD CONTEXT → CHECK ACTIVE → UNDERSTAND STATE → ALIGNMENT AUDIT → STATUS OUTPUT → SELF-PROMPT
     (1)           (2)             (3)                (3.8)             (4)           (5)
```

---

## Step 1: Load Context

Read these files in order (skip any that don't exist):

1. **CLAUDE.md** — Project conventions and how we work together
2. **.agents/PRD.md** — What we're building (note version AND Implementation Status table)
3. **.agents/plans/INDEX.md** — Plan status and priorities
4. **.agents/HANDOVER.md** — Session context and decisions
5. **READ** `.agents/PROJECT-MEMORY.md` — Institutional memory. Scan Architecture Decisions for current state. Check Problems Solved for domains relevant to today's work. Review Breaking Changes for recent migrations. Note Gotchas for technologies being used today.

---

## Step 2: Check What's Active

**Read the Plans INDEX:**
```bash
cat .agents/plans/INDEX.md | head -50
```

**List active plans:**
```bash
ls .agents/plans/active/ 2>/dev/null || echo "No active plans"
```

**List pending plans (priority order):**
```bash
ls .agents/plans/pending/ 2>/dev/null || echo "No pending plans"
```

**Check recent activity:**
```bash
ls -lt .agents/execution-reports/ 2>/dev/null | head -3 || echo "No execution reports yet"
```

**Check for undocumented plans:**
```bash
ls ~/.claude/plans/*.md 2>/dev/null
```

If plan-mode plans exist that are NOT in `.agents/plans/active/` or `.agents/plans/completed/`:
- **Flag:** "Found undocumented plan: [filename]. Capturing to `.agents/plans/`."
- Copy active plans to `.agents/plans/active/`
- Update INDEX.md counts and tables

**Rule:** Every plan gets documented. Undocumented plans are lost context.

---

## Step 3: Understand Current State

**What exists in the codebase:**
```bash
ls src/ 2>/dev/null || ls app/ 2>/dev/null || echo "No src directory found"
```

**Check active plan details:**
- Read the first 50 lines of each file in `.agents/plans/active/` (if exists)
- Identify which are "Ready", "In Progress", or "Planning"

### Step 3.5: Research Check (IMPORTANT)

**Before suggesting next work, check if external services are involved:**

1. **Identify external services** in the next task (APIs, platforms, libraries)
2. **Check for existing reference docs:**
```bash
ls .agents/reference/ 2>/dev/null
```
3. **If external service AND no reference doc:** Flag for research first
4. **If reference doc exists but is old (>30 days):** Consider refreshing

5. **Before investigating any bug:**
   **READ** `.agents/PROJECT-MEMORY.md` → Problems Solved → [relevant domain]
   Check if this exact issue or a similar one has been solved before.

---

## Step 3.8: Full Alignment Audit

### 10 Alignment Checks

Each check: PASS or FAIL.

**CHECK 1: INDEX.md Counts Match Reality**
```bash
ACTIVE=$(ls .agents/plans/active/ 2>/dev/null | grep -c '.md$' || echo 0)
PENDING=$(ls .agents/plans/pending/ 2>/dev/null | grep -c '.md$' || echo 0)
COMPLETED=$(ls .agents/plans/completed/ 2>/dev/null | grep -c '.md$' || echo 0)
```
Compare to INDEX.md Quick Stats.

**CHECK 2: INDEX.md Tables Match Folders**
Every file in `plans/active/` appears in Active Plans table.
Every file in `plans/completed/` appears in Completed Plans table.

**CHECK 3: PRD.md Implementation Status Matches Completed Plans**
Each completed plan has a corresponding row in PRD.md Implementation Status.

**CHECK 4: HANDOVER.md Is Current**
HANDOVER.md has a recent session log entry.
Active Plans list matches `plans/active/` contents.

**CHECK 5: CLAUDE.md Tech Stack Matches Dependencies**
Compare CLAUDE.md tech stack to `package.json` dependencies.

**CHECK 6: Reference Docs Are Current**
No reference doc has "Last Verified" date >30 days old.

**CHECK 7: Skills and Commands Are Version-Synced**
For each skill, matching command exists with same version.

**CHECK 8: Execution Reports Exist for Completed Plans**
Each completed plan has at least one execution report.

**CHECK 9: No Empty .agents/ Directories**
```bash
find .agents -type d -empty 2>/dev/null
```

**CHECK 10: HANDOVER.md Session Log Is Sequential**
Session numbers are consecutive. Dates monotonically increasing.

### Deep Document Audits

**DEEP AUDIT A: PRD.md Content Accuracy**
1. Implementation Status table has rows for ALL completed plans
2. No "Planned" features that actually exist in code (should be "Implemented")
3. Version number reflects recent changes

**DEEP AUDIT B: CLAUDE.md Content Accuracy**
1. Tech stack matches package.json dependencies
2. Commands/skills table matches actual `.claude/` contents
3. Architecture section matches actual folder structure
4. References table points to existing files

### Alignment Score

```
ALIGNMENT_SCORE = (checks_passed / TOTAL_APPLICABLE) * 100%
```

| Score | Meaning | Action |
|-------|---------|--------|
| 100% | Perfect alignment | Continue normally |
| 80-99% | Minor drift | Note, continue |
| 60-79% | Significant drift | Recommend `/done` to heal |
| <60% | Critical | Strongly recommend `/done` immediately |

---

## Step 3.9: Quick Housekeeping Scan

```bash
# Empty directories
find .agents -type d -empty 2>/dev/null

# Stale reference docs (>30 days)
find .agents/reference -name "*.md" -mtime +30 2>/dev/null

# Old execution reports (>30 days, candidates for archival)
find .agents/execution-reports -name "*.md" -mtime +30 2>/dev/null
```

**IF issues found:** Report with recommendation to run `/done` for cleanup.

---

## Step 4: Provide Status

```markdown
## Session Resumed

**Last Session:** [Date from most recent execution report or HANDOVER]
**PRD Version:** [Version from PRD.md header]
**Alignment Score:** [X]% ([N]/[TOTAL] checks passing)

---

### Active Plans
| Plan | Status |
|------|--------|
| [Name from folder] | [Status from reading the file] |

### Document Sync Status
| Document | Status |
|----------|--------|
| INDEX.md | [In Sync / Needs Update] |
| CLAUDE.md | [Current / Needs Update] |
| PRD.md | [Current / Needs Update] |
| HANDOVER.md | [Current / Needs Update] |

### Folder Status
- [Clean / Needs cleanup]

### What's Next
Based on plan statuses and priorities, I recommend: [specific action]

---

**What would you like to work on?**

When we finish, remember to run `/done` to validate, sync, and commit.
```

---

## Step 5: Self-Prompt for Commands

- **Starting work:** "Let's get started. When we finish, we'll use `/done` to validate, sync, and commit."
- **After completing something:** "Ready to run `/done`?"
- **Things feel messy:** "Want me to run `/done` with healing to clean up?"

---

## Cross-Project Portability

1. **Read CLAUDE.md** to understand tech stack + structure
2. **Scan `.agents/` dynamically** — don't assume specific files exist
3. **Skip checks** for missing documents gracefully (don't fail)
4. **No hardcoded paths** except conventions: `CLAUDE.md`, `.agents/`, `.claude/`

---

## Auto-Trigger Patterns

- "continue", "pick up where we left off", "resume", "what's next"
- "what's happening", "where are we", "status check"
- "what now", "what should I do"
- New conversation start, context switch

---

**Version:** 2.0
