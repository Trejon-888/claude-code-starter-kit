---
name: done
description: "Self-evolving session completion: validate, sync, heal, evolve, report, commit. Absorbs housekeeping. Auto-invoke after completing features, fixing bugs, or when user says \"done\", \"finished\", \"wrap up\", \"commit this\", \"push it\", \"let's ship it\", \"cleanup\", \"organize\", \"tidy up\"."
---

# /done v3.0 — Self-Evolving Session Completion

**9-phase engine for validated, synchronized, self-healing session completion.**

Absorbs `/housekeeping` (cleanup, archive, folder audit). No separate housekeeping command needed.

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

### Purpose
Build a runtime understanding of the project. Discover — don't assume.

### Step 0.1: Build Document Registry

Scan for key documents dynamically:

```bash
# Root-level docs
ls CLAUDE.md AGENTIX-OPERATING-SYSTEM.md 2>/dev/null

# .agents/ structure
find .agents -type f -name "*.md" -maxdepth 1 2>/dev/null
find .agents/plans -type f -name "*.md" 2>/dev/null
find .agents/reference -type f -name "*.md" 2>/dev/null
find .agents/execution-reports -type f -name "*.md" 2>/dev/null | tail -5

# Skills and commands
find .claude/skills -name "SKILL.md" 2>/dev/null
find .claude/commands -name "*.md" 2>/dev/null
```

Build the **Document Registry** — a runtime catalog:
```
REGISTRY = {
  root_docs: [discovered root .md files],
  agents_docs: [discovered .agents/*.md files],
  plan_index: .agents/plans/INDEX.md (if exists),
  active_plans: [files in plans/active/],
  completed_plans: [files in plans/completed/],
  pending_plans: [files in plans/pending/],
  reference_docs: [files in reference/],
  recent_reports: [last 5 execution reports],
  project_memory: .agents/PROJECT-MEMORY.md (if exists),
  skills: [.claude/skills/*/SKILL.md files],
  commands: [.claude/commands/*.md files]
}
```

### Step 0.2: Build Sync Map

Detect what changed this session:

```bash
git diff --name-only HEAD~1..HEAD 2>/dev/null   # Last commit
git diff --name-only 2>/dev/null                  # Uncommitted changes
git diff --cached --name-only 2>/dev/null         # Staged changes
git log --oneline -5 2>/dev/null                  # Recent context
```

Classify changes into **areas affected**:
```
SYNC_MAP = {
  changed_files: [all changed files],
  areas_affected: {
    frontend: (any src/ files changed),
    backend: (any backend/ files changed),
    database: (any supabase/migrations/ or migration files changed),
    plans: (any .agents/plans/ changed),
    docs: (any .agents/*.md or CLAUDE.md changed),
    skills: (any .claude/ files changed),
    tests: (any test files changed)
  },
  documents_needing_sync: [
    // Derived from areas_affected:
    // plans changed → INDEX.md
    // features completed → PRD.md
    // tech stack changed → CLAUDE.md
    // skills changed → matching commands
    // ALWAYS → HANDOVER.md
  ]
}
```

### Step 0.3: Auto-Classify Session Type

Based on changes, classify as one of:
- **Feature Implementation**: New src/ files, new routes, new components
- **Bug Fix**: Modifications to existing files, no new features
- **Planning Session**: New/modified plan files primarily
- **Housekeeping**: Doc updates, reorganization, cleanup
- **Infrastructure**: Config changes, dependency updates, migrations
- **Testing**: New/modified test files primarily

This determines which validation gates apply and what the report emphasizes.

---

## PHASE 1: VALIDATE — Tech-Stack-Aware Gates

### Purpose
Run validation appropriate to what changed. Parse commands from CLAUDE.md, not hardcoded.

### Step 1.1: Read Validation Commands

Parse CLAUDE.md "Essential Commands" section for:
- Frontend build/lint commands
- Backend test/lint commands
- Database migration commands

**Fallback** if CLAUDE.md doesn't specify:
- `package.json` exists → `npm run build`
- `pyproject.toml` exists → `pytest`
- `Makefile` exists → `make test`

### Step 1.2: Run Conditional Gates

**IF areas_affected.frontend:**
```bash
# Build gate (must pass)
npm run build
# Lint gate (must pass)
npm run lint
```

**IF areas_affected.backend:**
```bash
# Test gate (must pass)
cd backend && uv run pytest -v
# Lint gate (must pass)
uv run ruff check . --fix && uv run ruff format .
```

**IF areas_affected.database:**
```bash
# Migration status
npx supabase migration list
```

**IF areas_affected.tests:**
```bash
# Full test suite
npm run test:run 2>/dev/null || npm test 2>/dev/null
```

### Step 1.3: AI Observability Check (Conditional)

**IF session involved AI agent features** (detected from changed files):
- Verify activity logging exists (to database, not just stdout)
- Verify tool execution tracking
- Verify hallucination detection
- Verify admin endpoints for monitoring
- **READ** `AGENTIX-OPERATING-SYSTEM.md` Section 16 (Production AI Agent Requirements) — verify all 4 observability components exist

**Rule:** No AI agent feature ships without observability.

### Step 1.4: Planning Validation (Conditional)

**IF session_type == "Planning Session":**
- Verify Document References section in new plans
- Verify 7-Point Planning Checklist (AOS Section 21):
  1. External API research (endpoints verified)
  2. Database/Migrations (schema changes documented)
  3. Testing Strategy (test file paths specified)
  4. Observability (log events enumerated)
  5. Reusable Patterns (codebase searched)
  6. Types/Schemas (models defined)
  7. Success Criteria (validation steps documented)
- Verify full plan with code (not summary pointing elsewhere)

### Step 1.5: Stale Reference Detection

```bash
# Find reference docs not modified in 30+ days
find .agents/reference -name "*.md" -mtime +30 2>/dev/null
```

Also check "Last Verified:" headers in reference docs. Flag any >30 days.

### Validation Result

```
VALIDATION = {
  gates_passed: N,
  gates_total: N,
  details: [{ name, status, output }],
  stale_references: [...],
  warnings: [...]
}
```

**IF ANY GATE FAILS:** Stop. Fix before continuing. No sync, no commit, no report.

---

## PHASE 2: SYNC — Dynamic Document Synchronization

### Purpose
Update every document in the Sync Map to reflect current state.

### Step 2.0: Plan Documentation Sync (MANDATORY)

**Check if a plan was executed this session:**
- Was plan mode used? Check for plan files in `~/.claude/plans/` modified today
- If yes: copy the plan to `.agents/plans/completed/{descriptive-name}.md` with `Status: Completed`
- Add execution date and summary of what was done
- This is NOT optional — undocumented plans are lost context

### Step 2.1: INDEX.md Sync

**IF plans changed or features completed:**
```bash
# Count actual folder contents
ACTIVE=$(ls .agents/plans/active/ 2>/dev/null | grep -c '.md$' || echo 0)
PENDING=$(ls .agents/plans/pending/ 2>/dev/null | grep -c '.md$' || echo 0)
COMPLETED=$(ls .agents/plans/completed/ 2>/dev/null | grep -c '.md$' || echo 0)
```

Update:
- Quick Stats table (plan counts)
- Move plans between tables (Pending → Active → Completed)
- Add execution report links for completed plans
- Update "Last Updated" date

### Step 2.2: CLAUDE.md Sync

**IF tech stack or architecture changed:**
- Check package.json for new dependencies → update tech stack
- Check for new patterns established → update architecture section
- Check for new reference docs → update references table
- Check for skill/command changes → update commands/skills tables

### Step 2.3: PRD.md Sync

**IF features completed or scope changed:**
- Add row to Implementation Status table for completed feature
- Update feature status (planned → implemented)
- Consider version bump if significant changes
- Move items from "Out of Scope" if now implemented

### Step 2.4: HANDOVER.md Sync

**ALWAYS update (every session):**
- Add session log entry with:
  - Session number (next in sequence)
  - Date
  - Context (what was worked on)
  - Completed items
  - Validation results
  - Execution report link
  - Next steps
- Update "Active Plans" list
- Update "Current Status"
- Update "What's Next"

### Step 2.5: Skill/Command Sync

**IF any .claude/ files changed:**
- For each skill, verify matching command exists with same version
- For each command, verify matching skill exists with same version
- Flag any pairs where content has drifted

### Step 2.6: Research Capture

**IF session involved web research or external service interaction:**
- Check if reference doc exists: `.agents/reference/[service]-patterns.md`
- If not → create one using template:
  ```markdown
  # [Service/Topic] Patterns

  **Last Verified:** YYYY-MM-DD
  **Official Docs:** [URL]

  ## Key Endpoints/Features
  - [What we use and why]

  ## Working Examples
  [Actual code from this project]

  ## Gotchas & Lessons Learned
  - [Issue]: [Solution]

  ## Environment Variables
  - `VAR_NAME`: [Description]
  ```
- If exists → update "Last Verified" date and add new learnings

---

## PHASE 3: ALIGNMENT AUDIT — Drift Detection

### Purpose
Cross-reference all key documents for consistency. Score alignment quantitatively.

### 10 Alignment Checks

Each check: PASS (1 point) or FAIL (0 points).

**CHECK 1: INDEX.md Counts Match Reality**
```bash
ACTIVE=$(ls .agents/plans/active/ 2>/dev/null | grep -c '.md$' || echo 0)
PENDING=$(ls .agents/plans/pending/ 2>/dev/null | grep -c '.md$' || echo 0)
COMPLETED=$(ls .agents/plans/completed/ 2>/dev/null | grep -c '.md$' || echo 0)
```
Compare to INDEX.md Quick Stats. PASS if all match.

**CHECK 2: INDEX.md Tables Match Folders**
Every file in `plans/active/` appears in Active Plans table.
Every file in `plans/completed/` appears in Completed Plans table.
No file in wrong table. PASS if all match.

**CHECK 3: PRD.md Implementation Status Matches Completed Plans**
Each completed plan has a corresponding row in PRD.md Implementation Status.
PASS if all completed plans are reflected.

**CHECK 4: HANDOVER.md Reflects Current Session**
HANDOVER.md has a session log entry for today (or this session).
Active Plans list matches `plans/active/` contents.
PASS if current.

**CHECK 5: CLAUDE.md Tech Stack Matches Dependencies**
Compare CLAUDE.md tech stack to `package.json` dependencies.
Flag listed tech not in dependencies or major dependency not in tech stack.
PASS if no significant mismatches.

**CHECK 6: Reference Docs Are Current**
No reference doc has "Last Verified" date >30 days old.
No reference doc in `.agents/reference/` is unmodified for >30 days.
PASS if all current or undated.

**CHECK 7: Skills and Commands Are Version-Synced**
For each skill in `.claude/skills/*/SKILL.md`:
  - Matching `.claude/commands/[name].md` exists
  - Version numbers match
  - Description/purpose match
PASS if all pairs synchronized.

**CHECK 8: Execution Reports Exist for Completed Plans**
Each plan in `plans/completed/` has at least one execution report.
PASS if all have reports.

**CHECK 9: No Empty .agents/ Directories**
```bash
find .agents -type d -empty 2>/dev/null
```
PASS if none found.

**CHECK 10: HANDOVER.md Session Log Is Sequential**
Session numbers are consecutive. Dates are monotonically increasing.
PASS if consistent.

### Deep Document Audits (CRITICAL — These Prevent Drift)

These are the audits that catch the "PRD is out of alignment" problem. They go deeper than existence checks — they verify content accuracy.

**DEEP AUDIT A: PRD.md Content Accuracy**
1. **Implementation Status table completeness:**
   - Read all plans in `plans/completed/` — each MUST have a row in PRD.md Implementation Status
   - Read all plans in `plans/active/` — each MUST be listed as "In Progress" or similar
   - No "phantom" entries (rows for plans that don't exist or were superseded)
2. **Version number reflects reality:**
   - If significant features shipped since last version bump, flag for bump
3. **Feature lists match codebase:**
   - Cross-reference PRD features against actual `src/pages/`, `src/components/`, routes
   - Flag features listed as "Planned" that actually exist in code (should be "Implemented")
   - Flag features listed as "Implemented" that don't exist in code (removed or renamed?)
4. **Out of Scope section is current:**
   - Check if any "Out of Scope" items were actually implemented

**DEEP AUDIT B: CLAUDE.md Content Accuracy**
1. **Tech stack matches package.json:**
   ```bash
   cat package.json | grep -A 100 '"dependencies"' | head -50
   cat package.json | grep -A 50 '"devDependencies"' | head -30
   ```
   - Every major dependency in package.json should be in CLAUDE.md tech stack
   - Every tech listed in CLAUDE.md should actually be in package.json
2. **Database schema table matches migrations:**
   - Count tables listed in CLAUDE.md vs actual tables from latest migration
   - Flag any tables in migrations not listed in CLAUDE.md
3. **Commands table matches actual skills/commands:**
   - Every skill in `.claude/skills/` should be in the Commands table
   - Every command in `.claude/commands/` should be in the Commands table
   - No entries for deleted skills/commands
4. **Architecture section matches actual folder structure:**
   ```bash
   ls -d src/*/ 2>/dev/null
   ```
   - Compare to architecture section in CLAUDE.md
5. **References table points to existing files:**
   - Every file path in References table should exist on disk
   - Flag broken references

### Alignment Timestamp Tracking

**Add to HANDOVER.md after every alignment audit:**

```markdown
### Last Alignment Check
- **Date:** YYYY-MM-DD
- **Score:** [X]% ([N]/[TOTAL] checks)
- **Triggered by:** /done | /continue
- **Issues Found:** [N] (auto-fixed: [N], manual: [N])
- **Deep Audit Results:**
  - PRD.md: [Aligned / [N] issues found]
  - CLAUDE.md: [Aligned / [N] issues found]
```

**Rule:** If HANDOVER.md shows no alignment check in >3 sessions, `/continue` should auto-run the full audit and flag: "No alignment check in [N] sessions. Running full audit."

### Alignment Score

```
ALIGNMENT_SCORE = (checks_passed / TOTAL_CHECKS) * 100%
```

Base checks (10) + Deep Audit A items (4) + Deep Audit B items (5) = up to 19 checks.
Score is always based on total applicable checks (skip N/A items like backend checks if no backend exists).

| Score | Meaning | Action |
|-------|---------|--------|
| 100% | Perfect alignment | Proceed to commit |
| 80-99% | Minor drift | Auto-fix in Phase 6, proceed |
| 60-79% | Significant drift | Fix + warnings, proceed with caution |
| <60% | Critical misalignment | Block commit until resolved |

```
ALIGNMENT_RESULT = {
  score: percentage,
  total_checks: N,
  checks_passed: N,
  checks: [{ name, status, details, auto_fixable }],
  deep_audit_prd: { status, issues: [...] },
  deep_audit_claude: { status, issues: [...] },
  last_alignment_date: "YYYY-MM-DD",
  sessions_since_last_audit: N
}
```

---

## PHASE 4: EVOLUTION CHECK — Self-Discovery Engine

### Purpose
Detect patterns that should trigger system evolution. Evolve without being prompted.

### Trigger 1: Missing Reference Docs

```bash
# Find external service imports
grep -r "from '@supabase'" src/ --include="*.ts" --include="*.tsx" -l 2>/dev/null
grep -r "import.*stripe\|import.*twilio\|import.*sendgrid" src/ -l 2>/dev/null
grep -r "fetch(" src/ --include="*.ts" --include="*.tsx" -l 2>/dev/null
```

For each external service detected: check if `.agents/reference/[service]-patterns.md` exists.
**IF NOT:** Flag `missing_reference` — "External service [service] used but has no reference doc."

### Trigger 2: Repeated Patterns in Git History

```bash
# Find repeated commit message patterns (3+ occurrences = automation opportunity)
git log --oneline -50 | awk '{$1=""; print}' | sort | uniq -c | sort -rn | head -10
```

**IF any pattern appears 3+ times:** Flag `repeated_pattern` — "Consider creating a skill for: [pattern]"

### Trigger 3: Stale Documentation

From Phase 1 stale reference detection, plus:
```bash
# Find any .agents/ docs not modified in 30+ days (excluding archive/completed/superseded)
find .agents -name "*.md" -mtime +30 \
  -not -path "*/completed/*" \
  -not -path "*/superseded/*" \
  -not -path "*/archive/*" 2>/dev/null
```

**IF found:** Flag `stale_doc` — "[file] not updated in 30+ days."

### Trigger 4: Missing Skills for Repeated Workflows

Analyze recent git log for workflow patterns that lack matching skills:
- Migration + type generation + push (3+ times → suggest `db-migration` skill)
- Similar test fixes repeating (3+ times → suggest `test-fix` skill)
- Auth-related fixes repeating (3+ times → suggest `auth-fix` skill)

Cross-reference with existing skills in `.claude/skills/`.
**IF workflow has no matching skill:** Flag `missing_skill`.

### Trigger 5: Skill/Command Version Drift

From Phase 3 Check 7: any skill/command pair with mismatched versions.
**IF found:** Flag `version_drift` — auto-fixable.

### Trigger 6: Document Cascade Gaps

Check recent commits for cascade completeness:
- Did plan completions trigger PRD + INDEX + HANDOVER updates in the same commit?
- Did tech stack changes trigger CLAUDE.md updates?

**IF cascades frequently incomplete:** Flag `cascade_gap`.

### Evolution Output

```
EVOLUTION_RESULT = {
  triggers_fired: N,
  opportunities: [
    {
      type: "missing_reference" | "repeated_pattern" | "stale_doc" | "missing_skill" | "version_drift" | "cascade_gap",
      description: "...",
      suggested_action: "...",
      priority: "high" | "medium" | "low",
      auto_actionable: boolean
    }
  ]
}
```

---

## PHASE 5: REPORT — Enhanced Execution Report

### Purpose
Create comprehensive execution report with sync audit and evolution discoveries.

### File Location
`.agents/execution-reports/YYYY-MM-DD-[feature-name].md`

### Template

```markdown
# [Feature/Session Name] - Execution Report

**Date:** YYYY-MM-DD
**Type:** [auto-detected session type]
**Alignment Score:** [X]% ([N]/10 checks passing)

---

## Summary
[2-3 sentences: What was done, current status]

## What Was Built/Changed
- [List main changes]
- [Files created/modified]

## Validation Results
| Gate | Status | Details |
|------|--------|---------|
| Build | Pass/Fail | [output summary] |
| Lint | Pass/Fail | [output summary] |
| Tests | Pass/Fail | [count] |
| Database | Pass/Fail/N/A | [status] |

## Document Sync Audit
| Document | Status | Action Taken |
|----------|--------|--------------|
| INDEX.md | In Sync / Updated | [what changed] |
| CLAUDE.md | In Sync / Updated / N/A | [what changed] |
| PRD.md | In Sync / Updated / N/A | [what changed] |
| HANDOVER.md | Updated | [session entry added] |

## Alignment Score: [X]%
| Check | Status |
|-------|--------|
| INDEX counts match | Pass/Fail |
| INDEX tables match | Pass/Fail |
| PRD status current | Pass/Fail |
| HANDOVER current | Pass/Fail |
| CLAUDE.md tech stack | Pass/Fail |
| Reference docs current | Pass/Fail |
| Skills/commands synced | Pass/Fail |
| Execution reports exist | Pass/Fail |
| No empty directories | Pass/Fail |
| Session log sequential | Pass/Fail |

## Evolution Discoveries
[If any triggers fired:]
| # | Type | Description | Suggested Action | Priority |
|---|------|-------------|------------------|----------|
| 1 | [type] | [desc] | [action] | [H/M/L] |

## Issues & Fixes
- [Problems encountered and resolutions]

## Next Steps
- [What should happen next]

---
*Report generated: YYYY-MM-DD*
*Alignment Score: [X]% | Evolution Triggers: [N]*
```

### Step 5.3: Distill to PROJECT-MEMORY.md

**READ** `.agents/PROJECT-MEMORY.md` before adding entries.

After creating the execution report, extract durable knowledge:

1. **Architecture decisions made this session?**
   → Append to Architecture Decisions table (with rationale + what it supersedes)

2. **Bugs fixed with non-obvious root causes?**
   → Append to Problems Solved under the appropriate domain section

3. **Breaking changes introduced?**
   → Append to Breaking Changes Log with migration path

4. **Patterns superseded?**
   → Append to Superseded Patterns

5. **Domain-specific gotchas discovered?**
   → Append to Gotchas under the appropriate domain

**Rule:** If any of these happened during the session, PROJECT-MEMORY.md MUST be updated. This is not optional. See `AGENTIX-OPERATING-SYSTEM.md` Section 15 (Institutional Memory & Durability) for distillation rules.

---

## PHASE 6: HEAL — Self-Healing Engine

### Purpose
Auto-fix drift detected in Phase 3. Absorbs /housekeeping cleanup capabilities.

### What HEAL Can Auto-Fix

| Issue | Fix |
|-------|-----|
| INDEX.md count mismatch | Recalculate from folder contents |
| INDEX.md table mismatch | Add/remove entries to match folders |
| HANDOVER.md not current | Add session entry |
| Empty directories | Remove them |
| Skill/command version drift | Update version numbers to match |
| Missing execution report links | Add links to INDEX.md |
| Stale "Last Verified" dates | Update to today if doc was reviewed this session |
| Old content (>30 days) | Archive to `.agents/archive/YYYY-MM/` |
| Duplicate files | Flag for review (don't auto-delete) |
| CLAUDE.md commands table outdated | Rebuild from actual `.claude/skills/` and `.claude/commands/` contents |
| CLAUDE.md broken references | Remove or update file paths that no longer exist |
| PRD.md "Planned" features that exist in code | Update status to "Implemented" |
| HANDOVER.md missing alignment timestamp | Add "Last Alignment Check" section |

### What HEAL Flags for Human

| Issue | Why |
|-------|-----|
| PRD.md feature completion judgment | Needs verification that feature is truly complete |
| PRD.md version bump decision | Needs judgment on significance |
| CLAUDE.md tech stack additions | Needs verification of accuracy |
| CLAUDE.md architecture changes | Needs judgment on structure |
| Missing reference docs | Needs research first |
| Missing skills | Needs design |
| Database schema drift | Needs migration review |

### Recursive Healing Loop

```
iteration = 0
MAX_ITERATIONS = 3

WHILE alignment_score < 100% AND iteration < MAX_ITERATIONS:
  FOR EACH failing check in ALIGNMENT_RESULT:
    IF auto_fixable:
      Apply fix
      Log to HEALING_LOG

  Re-run Phase 3 (Alignment Audit)
  iteration++

IF alignment_score >= 80%:
  Proceed to Phase 7
ELSE IF iteration == MAX_ITERATIONS:
  Log remaining issues as manual_required
  IF alignment_score >= 60%:
    Proceed with warnings
  ELSE:
    BLOCK commit: "Critical misalignment. [N] issues require manual attention."
```

### Healing Log

```markdown
| # | Issue | Auto-Fix Applied | Result |
|---|-------|-----------------|--------|
| 1 | INDEX.md Active count: 3, actual: 2 | Updated Quick Stats | Pass |
| 2 | Empty dir: .agents/old/ | Removed | Pass |
| 3 | PRD.md missing completed plan row | MANUAL REQUIRED | Pending |
```

---

## PHASE 7: COMMIT — Git Operations

### Step 7.1: Stage Changes

```bash
git add -A
```

Or stage specific files based on what was changed/fixed.

### Step 7.2: Commit with Alignment Score

```bash
git commit -m "$(cat <<'EOF'
[type]: [Brief description]

- [Change 1]
- [Change 2]
- Alignment Score: [X]% ([N]/10)
- Created execution report

Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 7.3: Push

```bash
git push origin main
```

---

## PHASE 8: REFLECT — Learning & Meta-Evolution

### Purpose
Evaluate the session, log learnings, and check if this skill itself needs updating.

### Step 8.1: Session Learnings

Ensure HANDOVER.md has:
- What was built/fixed
- Key decisions made
- Issues encountered
- Alignment score achieved
- Evolution opportunities discovered

### Step 8.2: Evolution Action

**IF evolution triggers fired:**
- List all opportunities in execution report
- IF any have `priority == "high" AND auto_actionable`:
  - Auto-apply (e.g., fix version drift)
- IF any have `priority == "high" AND NOT auto_actionable`:
  - Prompt: "I discovered evolution opportunities this session:
    [list with descriptions and suggested actions]
    Would you like me to act on any of these now?"

### Step 8.3: Self-Evaluation

Ask internally:
- Did Discovery find all relevant documents?
- Did the Sync Map correctly identify affected documents?
- Did the Alignment Audit catch real issues?
- Did the Evolution Check find meaningful patterns?
- Were there false positives or missed issues?

**IF this skill should be updated** (new doc type discovered, new check needed):
- Flag: "/done v3.0 should be updated: [reason]"
- Log to HANDOVER.md for next session

### Step 8.4: Final Output

```markdown
## Session Complete

**Validation:** [All N gates passed]
**Alignment Score:** [X]% ([N]/10 checks)
**Documents Synced:** [list]
**Healing Applied:** [N] auto-fixes, [N] manual flagged
**Evolution Discoveries:** [N] opportunities

[If evolution opportunities:]
### Evolution Opportunities
| # | Type | Description | Suggested Action | Priority |
|---|------|-------------|------------------|----------|
| 1 | [type] | [desc] | [action] | [H/M/L] |

**Commit:** [hash] — [message]

Ready to start something new? Use `/continue` to see what's next.
```

---

## Auto-Trigger Patterns

- "done", "/done", "finished"
- "wrap up", "commit this", "push it", "let's ship it"
- "cleanup", "organize", "tidy up" (formerly /housekeeping)
- "archive old stuff"

---

## Document Cascade Rule

```
Feature/Plan completes →
  ├── PRD.md (Implementation Status table)
  ├── INDEX.md (move plan, update counts)
  ├── HANDOVER.md (session context)
  ├── PROJECT-MEMORY.md (distill ADRs, solutions, gotchas)
  └── Execution report

New patterns discovered →
  ├── .agents/reference/[pattern].md
  ├── AGENTIX-OPERATING-SYSTEM.md (if universal)
  └── CLAUDE.md (if project-specific)

Skills/commands changed →
  ├── Mirror skill ↔ command
  └── Update CLAUDE.md tables
```

**This cascade is automatic — always follow it.**

---

## Cross-Project Portability

1. **Read CLAUDE.md** to understand tech stack + validation commands
2. **Read AGENTIX-OPERATING-SYSTEM.md** (if exists) for evolution rules + quality gates
3. **Scan `.agents/` dynamically** — don't assume any specific files exist
4. **Skip checks** for missing documents gracefully (don't fail)
5. **No hardcoded paths** except conventions: `CLAUDE.md`, `.agents/`, `.claude/`
6. **Adapt validation** based on tech stack discovered in CLAUDE.md

---

## Dependencies

- Git (for diff, log, commit)
- Project-specific build tools (discovered from CLAUDE.md)
- `.agents/` directory structure (discovered dynamically)

---

**Version:** 3.0
**Updated:** 2026-01-30
**Absorbs:** /housekeeping v1.0
