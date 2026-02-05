---
name: piv
description: Self-recursive development loop with real auth testing, live DB research, 100% test pass requirements, and MANDATORY agent-browser production readiness tests. Auto-invoke when user says "piv", "autopilot", "ship it", "full validation", "test until done", "keep going until done", "recursive loop", "validate everything".
---

# /piv - Self-Recursive Development Loop v3.2

**The ultimate command for automated, validated, production-ready development.**

## Core Principle

**This command is document-driven.** It reads your project's key documents to understand context:
- `CLAUDE.md` → Tech stack, architecture, conventions
- `.agents/PRD.md` → Features, user roles, requirements
- `.agents/plans/INDEX.md` → Current plan status
- `.agents/HANDOVER.md` → Session context

**No hardcoded project specifics.** The command adapts to whatever project it's running in.

---

## 10-Phase Flow (0-9)

```
RESEARCH → PLAN & SAVE → PRIME → TODO CREATION → EXECUTE → VALIDATE → HEAL → CHECKPOINT → REPEAT → FINALIZE
   (0)        (1)         (2)        (3)           (4)       (5)       (6)       (7)        (8)       (9)
```

---

## PHASE 0A: PLAN CAPTURE (Pre-Research)

### Purpose
If a plan already exists from plan mode, capture it immediately.

### Actions
1. **Check for plan-mode plans:** Look in `~/.claude/plans/` for recently created/modified `.md` files
2. **If a plan exists:** Copy to `.agents/plans/active/{descriptive-name}.md`
3. **Update INDEX.md:** Add to Active Plans table, increment count
4. **Update HANDOVER.md:** Note plan captured

**RULE:** Plans from plan mode are first-class — they get documented to `.agents/plans/` just like piv-generated plans.

---

## PHASE 0: RESEARCH

### Purpose
Gather project context BEFORE planning.

### Actions
1. **Read project documents:**
   - `CLAUDE.md` - Tech stack, architecture
   - `.agents/PRD.md` - Features, user roles, requirements
   - `.agents/plans/INDEX.md` - Plan status
   - `.agents/HANDOVER.md` - Session context
   - **READ** `.agents/PROJECT-MEMORY.md` — Check Architecture Decisions for current patterns, Gotchas for relevant domains, Problems Solved for known issues in the area being worked on

2. **Query database** for current state

3. **Identify from PRD:**
   - What user roles exist?
   - What features need testing?
   - What are the success criteria?

4. **Web research** if external APIs involved

5. **Explore codebase** for patterns

---

## PHASE 1: PLAN & SAVE

### Purpose
Create plan WITH test specifications. Save BEFORE code.

### Actions
1. Create plan with goals, research, TODOs, validation gates
2. **SAVE plan** to `.agents/plans/active/[plan-name].md`
3. **UPDATE INDEX.md**
4. **UPDATE HANDOVER.md**

**RULE:** No code until plan is saved.

---

## PHASE 2: PRIME

Verify infrastructure is ready (.env.test, dev server, agent-browser, playwright, database).

---

## PHASE 3: TODO CREATION

Create TODOs with test requirements for EACH item.

---

## PHASE 4: EXECUTE

Implement code following patterns from CLAUDE.md. Quick validation after each change.

---

## PHASE 5: VALIDATE (5 MANDATORY GATES)

| Gate | What | Criteria |
|------|------|----------|
| 1 | Unit Tests | 100% pass |
| 2 | Build + Lint | 0 errors |
| 3 | E2E (Playwright) | 100% pass |
| 4 | **Production Readiness** | All role journeys pass |
| 5 | Database State | Data present |

---

### Gate 4: Production Readiness - DOCUMENT-DRIVEN MANUAL QA

**⚠️ CRITICAL: This gate CANNOT be skipped or substituted.**

#### Non-Negotiable Rules

- **DO NOT** skip agent-browser tests
- **DO NOT** substitute with Playwright (Gate 3 covers that)
- **DO NOT** just navigate and screenshot - PERFORM OPERATIONS
- **MUST** read PRD.md to identify user roles and features
- **MUST** test EVERY role defined in PRD
- **MUST** test EVERY feature defined in PRD
- **MUST** enter REAL data like a real user
- **MUST** iterate until everything works

#### Step 1: Read PRD to Identify What to Test

```markdown
Before testing, READ `.agents/PRD.md` to answer:
1. What user roles exist in this project?
2. What features does each role have access to?
3. What are the success criteria?
4. What CRUD operations should each role perform?
```

#### Step 2: Test Every Role (from PRD)

For EACH role identified in PRD:
```bash
agent-browser close 2>/dev/null || true
agent-browser open $APP_URL/login
agent-browser snapshot -i
agent-browser fill @email "$TEST_[ROLE]_EMAIL"
agent-browser fill @password "$TEST_[ROLE]_PASSWORD"
agent-browser click @submit
agent-browser wait --url "**/*"
agent-browser errors  # Must be empty
agent-browser screenshot /tmp/piv-[role]-dashboard.png
```

#### Step 3: Test Every Feature (from PRD)

For EACH feature marked as implemented in PRD:
```bash
agent-browser snapshot -i
agent-browser click @[feature-element]
agent-browser fill @[field] "Test data - $(date +%H%M%S)"
agent-browser click @save
agent-browser wait 2000
agent-browser errors
agent-browser screenshot /tmp/piv-[feature]-completed.png
```

---

#### Testing Principles

##### Principle 1: Document-Driven Testing
- Read PRD.md to know what roles exist
- Read PRD.md to know what features to test
- Read CLAUDE.md to know the tech stack
- Don't assume - verify from documents

##### Principle 2: Enter Real Data
- Don't just navigate and screenshot
- Fill forms with real data
- Save and verify persistence

##### Principle 3: Verify Data Persistence
- Refresh page
- Navigate away and back
- Log out and log in
- Data must survive

##### Principle 4: Test Cross-Role Data Flow
- Role A creates → Role B sees (per PRD)

##### Principle 5: Test Edge Cases
- Empty states
- Validation errors
- Loading states

##### Principle 6: Debug & Fix Loop

When ANY test fails:
1. `agent-browser errors` / `agent-browser console`
2. Add `console.log('PIV DEBUG:', ...)` to code
3. `npm run build && agent-browser reload`
4. Check database state
5. Fix issue
6. **RETEST ENTIRE flow**
7. Remove debug logs

**REPEAT until ALL tests pass.**

---

#### Dynamic Test Structure

```
Gate 4 (read from PRD)
│
├── For EACH role in PRD.md:
│   ├── Login
│   ├── Verify dashboard
│   ├── Test all features for role
│   └── Verify permissions
│
├── For EACH feature in PRD.md:
│   ├── Navigate to feature
│   ├── Perform CRUD with real data
│   ├── Verify persistence
│   └── Test edge cases
│
├── Cross-Role Verification (per PRD)
│
└── Debug & Fix Loop
```

---

#### Production Readiness Checklist

- [ ] Read PRD.md to identify roles and features
- [ ] Every role from PRD can login
- [ ] Every feature from PRD works
- [ ] CRUD operations work with real data
- [ ] Data persists
- [ ] Cross-role flow works
- [ ] No console errors
- [ ] No network errors
- [ ] Empty states handled
- [ ] Validation errors display

**If ANY fails → Debug & Fix → Retest ALL**

---

## PHASE 6: HEAL

Fix failures. Maximum 10 attempts.

1. **READ** `.agents/PROJECT-MEMORY.md` → Problems Solved → [relevant domain] — check if this issue has been solved before
2. Read FULL error
3. Web search
4. Add console logs
5. Query database
6. Find patterns in codebase
7. Rebuild and retest
8. **If new solution found:** Log to PROJECT-MEMORY.md via /done Phase 5 Step 5.3

---

## PHASE 7: CHECKPOINT

Document progress. ONLY after 100% gate pass.

---

## PHASE 8: REPEAT

Check PRD success criteria. Loop if needed.

---

## PHASE 9: FINALIZE (AUTO /done v3.0)

**AUTOMATIC.** No user confirmation.
1. Move plan to completed
2. Execute `/done` v3.0 full 9-phase workflow (discovery → validate → sync → alignment audit → evolution check → report → heal → commit → reflect)
3. `/done` handles all document sync, alignment scoring, healing, and git operations
4. Alignment score must be >= 80% before commit proceeds

---

## Key Documents (Always Read First)

| Document | What It Tells You |
|----------|-------------------|
| `CLAUDE.md` | Tech stack, architecture, conventions |
| `.agents/PRD.md` | Features, user roles, requirements |
| `.agents/plans/INDEX.md` | Plan status, priorities |
| `.agents/HANDOVER.md` | Session context |
| `.agents/PROJECT-MEMORY.md` | Solved problems, ADRs, gotchas |

---

## Auto-Trigger Patterns

- "piv", "/piv"
- "autopilot", "ship it"
- "full validation"
- "test until done"
- "keep going until done"
- "validate everything"
- "production readiness"

---

## Success Criteria

**The PIV loop is not done until:**
1. Every role in PRD works without errors
2. Every feature in PRD works as specified
3. All PRD success criteria are met
4. You would bet money a real user could use it bug-free

---

## Dependencies

- `agent-browser`
- `playwright`
- `.env.test` with credentials
- Dev server running
- Project docs: CLAUDE.md, PRD.md, INDEX.md

---

**Version:** 3.3
**Updated:** 2026-01-30
