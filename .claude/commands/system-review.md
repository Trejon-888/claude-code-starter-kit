---
description: "Analyze implementation vs plan for process improvements"
argument-hint: [plan-path] [execution-report-path]
---

# System Review

**System review is NOT code review.** You're looking for bugs in the process, not bugs in the code.

## Purpose

- Analyze plan adherence and divergence patterns
- Identify which divergences were justified vs problematic
- Surface process improvements that prevent future issues
- Suggest updates to CLAUDE.md, commands, rules, skills

## Philosophy

- Good divergence reveals plan limitations → improve planning
- Bad divergence reveals unclear requirements → improve communication
- Repeated issues reveal missing automation → create commands or rules

## Inputs

Read these artifacts:

1. **Plan command:** `.claude/commands/plan.md` (understand planning instructions)
2. **Generated plan:** $ARGUMENTS (first arg — what agent was SUPPOSED to do)
3. **Execute command:** `.claude/commands/execute.md` (understand execution instructions)
4. **Execution report:** $ARGUMENTS (second arg — what agent ACTUALLY did)

## Analysis Workflow

### Step 1: Understand Planned Approach

From the plan, extract: features planned, architecture specified, validation steps, patterns referenced.

### Step 2: Understand Actual Implementation

From the execution report, extract: what was implemented, what diverged, challenges encountered, what was skipped.

### Step 3: Classify Each Divergence

**Good Divergence** — Plan assumed something that didn't exist, better pattern discovered, performance/security issue required different approach.

**Bad Divergence** — Ignored explicit constraints, created new architecture instead of following existing patterns, took shortcuts introducing tech debt, misunderstood requirements.

### Step 4: Trace Root Causes

For each problematic divergence: Was the plan unclear (where, why)? Was context missing? Was validation missing? Was a manual step repeated?

### Step 5: Generate Process Improvements

Based on patterns, suggest:

- **CLAUDE.md updates:** Universal patterns or anti-patterns to document
- **Plan command updates:** Missing instructions or steps
- **New rules:** Behavioral constraints to enforce
- **New commands:** Manual processes to automate
- **Validation additions:** Checks that would catch issues earlier

## Output

Save to `.agents/system-reviews/{feature-name}-review.md`

### Report Structure

#### Meta Information
- Plan reviewed: [path]
- Execution report: [path]
- Date: [current date]

#### Overall Alignment Score: __/10
- 10: Perfect adherence, all divergences justified
- 7-9: Minor justified divergences
- 4-6: Mix of justified and problematic
- 1-3: Major problematic divergences

#### Divergence Analysis

For each divergence:
```yaml
divergence: what changed
planned: what plan specified
actual: what was implemented
reason: agent's stated reason
classification: good | bad
root_cause: unclear plan | missing context | etc
```

#### System Improvement Actions

**Update CLAUDE.md:**
- [ ] Document [pattern] discovered during implementation
- [ ] Add anti-pattern warning for [X]

**Update Commands:**
- [ ] Add [step] to plan command
- [ ] Add [validation] to execute command

**Create New Rule:**
- [ ] `.claude/rules/{name}.md` for [repeated issue]

#### Key Learnings
- What worked well
- What needs improvement
- Concrete improvements for next implementation

## Important

- Be specific — "plan didn't specify which auth pattern to use" not "plan was unclear"
- Focus on patterns — one-off issues aren't actionable
- Action-oriented — every finding has a concrete update suggestion
- Suggest the actual text to add to CLAUDE.md or commands
