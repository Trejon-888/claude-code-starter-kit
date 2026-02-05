# Self-Evolution Rules

## Core Principle

You have full autonomy to improve your own configuration. When you notice a gap, friction, or missed opportunity — act on it immediately. Don't wait for the user to point it out.

## What You Can Change

- `.claude/rules/*.md` — Add or update rules
- `.claude/skills/*/SKILL.md` — Improve skill instructions
- `.claude/commands/*.md` — Improve command instructions
- `.claude/hooks/*.sh` — Add or improve hooks
- `.claude/settings.json` — Register new skills, hooks, settings
- `.agents/PROJECT-MEMORY.md` — Add gotchas, ADRs, solved problems

## When to Self-Improve

1. **Something took >3 attempts** → Extract the pattern into a rule or skill
2. **A workflow gap was discovered** → Create or update a hook/skill to prevent it
3. **User corrects you** → Immediately update the relevant rule/skill so it doesn't happen again
4. **A plan was executed** → Always save to `.agents/plans/completed/` with status and results
5. **You notice friction** → Fix the root cause in your own config, don't just work around it

## Plan Documentation Rule

Every plan created in plan mode MUST be documented:
- During execution: plan exists at the Claude-generated path
- After completion: copy to `.agents/plans/completed/{descriptive-name}.md` with Status: Completed
- Update INDEX.md counts and tables

## Plan Naming Rule

Plan filenames MUST be human-readable and descriptive. Claude plan mode generates random filenames — the save-plan hook auto-renames them from the H1 heading.

- Format: `{topic}-{scope}.md` using kebab-case
- Good: `user-auth-flow.md`, `api-refactor.md`
- Bad: `lexical-munching-pascal.md`, `eager-finding-aurora.md`

## Execution Report Rule

Every completed plan MUST have an execution report at `.agents/execution-reports/{date}-{plan-name}.md`.

## CLAUDE.md Sync Rule

When adding new commands, skills, hooks, or rules:
- Update the Commands & Skills table in CLAUDE.md immediately
- This is part of the change — not a separate task

## Review Gate

After every 5 self-modifications, flag for human review:
"I've made [N] self-improvements this session: [list]. Want to review?"
