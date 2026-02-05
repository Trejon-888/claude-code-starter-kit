---
name: continue
description: "Load project context, alignment audit, status check, suggest next action. Absorbs /what. Auto-invoke at session start, after context switches, or when user says \"continue\", \"pick up where we left off\", \"resume\", \"what's next\", \"what's happening\", \"where are we\", \"status check\", \"what now\", \"what should I do\"."
---

# /continue v2.0 — Session Resume with Alignment Audit

**Load context, audit alignment, check status, suggest next action.**

Absorbs `/what` (status check, alignment verification, folder audit). No separate what command needed.

---

## Core Principle

**This command is document-driven and cross-project portable.** It reads your project's key documents to understand context — no hardcoded project specifics. It discovers what exists, audits alignment, and suggests the highest-priority next action.

---

## 7-Step Flow

```
LOAD CONTEXT → CHECK ACTIVE → UNDERSTAND STATE → ALIGNMENT AUDIT → HOUSEKEEPING SCAN → STATUS OUTPUT → SELF-PROMPT
     (1)           (2)             (3)                (3.8)              (3.9)             (4)           (5)
```

---

## Step 1: Load Context

Read these files in order (skip any that don't exist):

1. **CLAUDE.md** — Project conventions and how we work together
2. **AGENTIX-OPERATING-SYSTEM.md** — Framework for how we build (skim TOC, read relevant sections)
3. **.agents/PRD.md** — What we're building (note version AND Implementation Status table)
4. **.agents/plans/INDEX.md** — Plan status and priorities
5. **.agents/HANDOVER.md** — Session context and decisions
6. **READ** `.agents/PROJECT-MEMORY.md` — Institutional memory. Scan Architecture Decisions for current state. Check Problems Solved for domains relevant to today's work. Review Breaking Changes for recent migrations. Note Gotchas for technologies being used today.

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

**Check for TODO files (may or may not exist):**
```bash
ls .agents/TODO*.md 2>/dev/null || echo "No TODO files found"
```

If TODO files exist, read the first 80 lines to understand priorities.

**Check for undocumented plans:**
```bash
ls ~/.claude/plans/*.md 2>/dev/null
```

If plan-mode plans exist that are NOT in `.agents/plans/active/` or `.agents/plans/completed/`:
- **Flag:** "Found undocumented plan: [filename]. Capturing to `.agents/plans/`."
- Copy active plans to `.agents/plans/active/`
- Copy completed plans to `.agents/plans/completed/`
- Update INDEX.md counts and tables

**Rule:** Every plan gets documented. Undocumented plans are lost context.

---

## Step 3: Understand Current State

**What exists in the codebase:**
```bash
ls src/pages/ 2>/dev/null
ls src/components/ 2>/dev/null
ls backend/app/ 2>/dev/null || echo "No backend yet"
```

**Check active plan details:**
- Read the first 50 lines of each file in `.agents/plans/active/` (if exists)
- Identify which are "Ready", "In Progress", or "Planning"

### Step 3.5: Research Check (IMPORTANT)

**Before suggesting next work, check if external services are involved:**

1. **Identify external services** in the next task:
   - APIs (Stripe, Unipile, etc.)
   - Deployment platforms (Railway, Fly.io, etc.)
   - New libraries/frameworks

2. **Check for existing reference docs:**
```bash
ls .agents/reference/ 2>/dev/null
```

3. **If external service AND no reference doc exists:**
   - Flag: "This task involves [service]. I'll do research first."
   - Do NOT proceed to implementation without research
   - **READ** `.agents/reference/research-first-pattern.md` — follow the research-first workflow before implementing

4. **If reference doc exists but is old (>30 days):**
   - Consider refreshing with current docs/best practices

5. **Before investigating any bug:**
   **READ** `.agents/PROJECT-MEMORY.md` → Problems Solved → [relevant domain]
   Check if this exact issue or a similar one has been solved before.
   If match found: Apply known solution instead of re-investigating.

### Step 3.6: AI Agent Observability Check

**If the next task involves AI agent features:**

1. **Remind about required components:**
   - Activity logging (to database, not just stdout)
   - Tool execution tracking
   - Hallucination detection
   - Self-correction loop
   - Admin endpoints

2. **Flag:** "This involves AI agent features. I'll ensure observability is built-in."

3. **READ** `AGENTIX-OPERATING-SYSTEM.md` Section 16 (Production AI Agent Requirements) — verify all 4 observability components are planned

**Rule:** Observability is not optional for AI agent features.

### Step 3.7: Planning Checklist Reminder

**If the next task requires planning a new feature:**

1. **Document References (MANDATORY):**
   - Every plan MUST start with a Document References section
   - Include: methodology docs, pattern sources, external API docs, test patterns

2. **7-Point Planning Checklist** (AOS Section 21):
   - External API research (verify endpoints!)
   - Database migrations (schema changes?)
   - Testing strategy (file paths, patterns)
   - Observability requirements (log events)
   - Reusable patterns (search codebase first)
   - Types and schemas (dataclasses, models)
   - Success criteria (validation steps)

3. **Flag:** "This requires planning. I'll follow the 7-Point Checklist from AOS Section 21."

**Rule:** No plan approval without Document References + all 7 checklist items + full code.

---

## Step 3.8: Full Alignment Audit (Absorbed from /what)

### Purpose
Run the same 10 alignment checks from `/done` Phase 3 at session start to detect drift.

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

### Deep Document Audits (Run These Every Session)

These go beyond existence checks — they verify content accuracy.

**DEEP AUDIT A: PRD.md Content Accuracy**
1. Implementation Status table has rows for ALL completed plans
2. No "Planned" features that actually exist in code (should be "Implemented")
3. Version number reflects recent changes
4. Out of Scope section is current

**DEEP AUDIT B: CLAUDE.md Content Accuracy**
1. Tech stack matches package.json dependencies
2. Database schema table matches actual migrations
3. Commands/skills table matches actual `.claude/` contents
4. Architecture section matches actual folder structure
5. References table points to existing files

### Alignment Timestamp Check

Read HANDOVER.md "Last Alignment Check" section:
- **IF no alignment check recorded in >3 sessions:** Auto-run full audit and flag: "No alignment check in [N] sessions. Running full audit."
- **IF last alignment score was < 80%:** Flag: "Previous session ended with [X]% alignment. Running healing audit."

### Alignment Score

```
ALIGNMENT_SCORE = (checks_passed / TOTAL_APPLICABLE) * 100%
```

Base checks (10) + Deep Audit A (4) + Deep Audit B (5) = up to 19 checks.
Skip N/A items (e.g., backend checks if no backend).

**IF score < 80%:** "Significant drift detected ([X]%). Running `/done` to heal is recommended before starting new work."
**IF score >= 80%:** Report score and continue normally.
**IF score < 60%:** "Critical misalignment ([X]%). Strongly recommend running `/done` immediately."

---

## Step 3.9: Quick Housekeeping Scan (Absorbed from /housekeeping)

### Purpose
Detect cleanup needs at session start. Report but don't auto-fix (that's `/done`'s job).

### Checks

```bash
# Empty directories
find .agents -type d -empty 2>/dev/null

# Stale reference docs (>30 days)
find .agents/reference -name "*.md" -mtime +30 2>/dev/null

# Old execution reports (>30 days, candidates for archival)
find .agents/execution-reports -name "*.md" -mtime +30 2>/dev/null

# Verify folder structure exists
ls -d .agents/plans/active .agents/plans/pending .agents/plans/completed .agents/reference .agents/execution-reports 2>/dev/null
```

**IF issues found:** Report in status output with recommendation to run `/done` for cleanup.

---

## Step 4: Provide Status & Ask (Enhanced — Absorbs /what)

After loading context and running audits, provide this summary:

```markdown
## Session Resumed

**Last Session:** [Date from most recent execution report or HANDOVER]
**PRD Version:** [Version from PRD.md header]
**Alignment Score:** [X]% ([N]/10 checks passing)

---

### PIV Loop Status (if applicable)
- **Current Phase:** [Prime / Plan / Execute / Validate / Report]
- **Current Feature:** [What's being worked on]
- **Progress:** [What's complete vs pending]
- **Blockers:** [Any issues]

### Active Plans
| Plan | Status |
|------|--------|
| [Name from folder] | [Status from reading the file] |

### Priority Work (if TODO file exists)
- P0: [Count] items
- P1: [Count] items

### Document Sync Status
| Document | Status |
|----------|--------|
| INDEX.md | [In Sync / Needs Update — counts don't match] |
| CLAUDE.md | [Current / Needs Update] |
| PRD.md | [Current / Needs Update] |
| HANDOVER.md | [Current / Needs Update] |

### Folder Status
- [Clean / Needs cleanup (X empty directories, Y stale docs)]

### Code Quality
- Build: [Pass / Fail / Unknown]
- Dev Server: [Running / Not running]

### What's Next
Based on plan statuses and priorities, I recommend: [specific action based on what you found]

### Planning Reminder
If planning new features:

**Document References (MANDATORY):**
Every plan needs a Document References section linking to methodology docs, pattern sources, external APIs, and test patterns.

**7-Point Checklist** (AOS Section 21):
- External API research (verify endpoints!)
- Database migrations needed?
- Test patterns from existing code
- Observability requirements
- Reusable patterns search
- Types and schemas
- Success criteria

**Full plan with all code** — no summaries pointing elsewhere.

---

**What would you like to work on?**

When we finish, remember to run `/done` to validate, sync, and commit.
```

---

## Step 5: Self-Prompt for Commands

**IMPORTANT — Remind about commands at key moments:**

- **Starting work:** "Let's get started. When we finish, we'll use `/done` to validate, sync, and commit."
- **After completing something:** "Ready to run `/done`?"
- **Things feel messy:** "Want me to run `/done` with healing to clean up?"
- **Confused about state:** "Let me re-run `/continue` to check our status."

### Step 5.1: Evolution Awareness

**Run lightweight Self-Discovery check:**
- Scan for stale docs (>30 days)
- Check for skill/command version drift
- Check for empty directories

**IF evolution opportunities detected:**
- "I noticed [N] potential evolution opportunities (stale docs, missing references, etc.). Run `/done` when ready to address them."

---

## Quick Reference

**Key Files (always exist):**
- `CLAUDE.md` — How we build
- `.agents/PRD.md` — What we're building
- `.agents/plans/INDEX.md` — Plan status and priorities

**Key Folders:**
- `.agents/plans/active/` — Currently implementing
- `.agents/plans/pending/` — Ready to implement
- `.agents/plans/completed/` — Done
- `.agents/reference/` — Pattern documentation
- `.agents/execution-reports/` — Session reports

---

## Document Cascade Rule (IMPORTANT)

**When any key document changes, others may need updates:**

```
AGENTIX-OPERATING-SYSTEM.md changes →
  ├── CLAUDE.md (if patterns/conventions affected)
  ├── Commands (if workflows changed)
  └── Reference docs (if new patterns documented)

PRD.md changes →
  ├── INDEX.md (if features/plans affected)
  ├── HANDOVER.md (session context)
  └── CLAUDE.md (if tech stack changed)

Plan completes →
  ├── PRD.md (Implementation Status table)
  ├── INDEX.md (move plan, update counts)
  ├── HANDOVER.md (session context)
  └── Execution report (document what happened)
```

**Trigger this cascade automatically whenever making significant changes.**

---

## Cross-Project Portability

1. **Read CLAUDE.md** to understand tech stack + structure
2. **Read AGENTIX-OPERATING-SYSTEM.md** (if exists) for framework rules
3. **Scan `.agents/` dynamically** — don't assume specific files exist
4. **Skip checks** for missing documents gracefully (don't fail)
5. **No hardcoded paths** except conventions: `CLAUDE.md`, `.agents/`, `.claude/`

---

## Auto-Trigger Patterns

- "continue", "pick up where we left off", "resume", "what's next"
- "what's happening", "where are we", "status check" (formerly /what)
- "what now", "what should I do"
- New conversation start, context switch

---

**Version:** 2.0
**Updated:** 2026-01-30
**Absorbs:** /what v1.0
**Note:** This skill dynamically reads current project state — no hardcoded plan names or versions.
