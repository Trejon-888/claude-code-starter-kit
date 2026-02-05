---
description: "Create comprehensive feature plan with deep codebase analysis"
argument-hint: [feature description]
---

# Plan: $ARGUMENTS

## Mission

Transform a feature request into a **comprehensive implementation plan** through systematic codebase analysis, external research, and strategic planning.

**Core Principle:** No code in this phase. Create a context-rich plan that enables one-pass implementation success.

**Key Philosophy:** Context is King. The plan must contain ALL information needed — patterns, mandatory reading, documentation, validation commands — so the execution agent succeeds on the first attempt.

## Planning Process

### Phase 1: Feature Understanding

- Extract the core problem being solved
- Identify user value and business impact
- Determine feature type: New Capability / Enhancement / Refactor / Bug Fix
- Assess complexity: Low / Medium / High
- Map affected systems and components

Create or refine a user story:

```
As a <type of user>
I want to <action/goal>
So that <benefit/value>
```

### Phase 2: Codebase Intelligence Gathering

Use specialized subagents and parallel analysis:

**1. Project Structure** — Detect languages, frameworks, directory layout, service boundaries, config files

**2. Pattern Recognition** — Search for similar implementations, extract naming conventions, error handling approaches, logging patterns. Check CLAUDE.md for project rules.

**3. Dependency Analysis** — Catalog relevant libraries, understand integration patterns, find docs in `.agents/reference/`

**4. Testing Patterns** — Identify test framework (Vitest), find similar test examples, understand coverage requirements

**5. Integration Points** — Map files to update, new files to create, router registration, database patterns

**Clarify Ambiguities:** If requirements are unclear, ask the user before continuing.

### Phase 3: External Research

- Research latest library versions and best practices
- Find official documentation with specific section anchors
- Identify common gotchas and known issues
- Document security considerations

### Phase 4: Strategic Thinking

- How does this fit the existing architecture?
- What are critical dependencies and order of operations?
- What could go wrong? (edge cases, race conditions, errors)
- How will this be tested?
- Are there performance or security implications?

### Phase 5: Generate Plan

Create a plan with this structure:

```markdown
# Feature: <feature-name>

## Feature Description
## User Story
## Problem Statement
## Solution Statement

## Feature Metadata
**Type**: [New Capability/Enhancement/Refactor/Bug Fix]
**Complexity**: [Low/Medium/High]
**Systems Affected**: [list]
**Dependencies**: [list]

## CONTEXT REFERENCES

### Files to Read Before Implementing
- `path/to/file.ts` (lines X-Y) — Why: pattern to follow

### New Files to Create
- `path/to/new.ts` — Purpose

### Relevant Documentation
- [Link](url#section) — Why needed

### Patterns to Follow
(Include actual code examples from the project)

## IMPLEMENTATION PLAN

### Phase 1: Foundation
### Phase 2: Core Implementation
### Phase 3: Integration
### Phase 4: Testing & Validation

## STEP-BY-STEP TASKS

Use keywords: CREATE, UPDATE, ADD, REMOVE, REFACTOR, MIRROR

### {ACTION} {target_file}
- **IMPLEMENT**: Specific detail
- **PATTERN**: Reference to existing pattern (file:line)
- **IMPORTS**: Required imports
- **GOTCHA**: Known issues to avoid
- **VALIDATE**: `executable validation command`

## TESTING STRATEGY
### Unit Tests
### Integration Tests
### Edge Cases

## VALIDATION COMMANDS
### Level 1: Syntax & Style
npm run typecheck
npm run lint

### Level 2: Unit Tests
npm run test -- --run

### Level 3: Compliance
npm run compliance

## ACCEPTANCE CRITERIA
- [ ] All functionality implemented
- [ ] All validation commands pass
- [ ] Tests cover happy path + edge cases + errors
- [ ] Follows project conventions
- [ ] No regressions
```

## Output

**Filename:** `.agents/plans/{kebab-case-name}.md`

Create `.agents/plans/` subdirectories as needed (active/, pending/).

## Quality Criteria

- [ ] Another developer could execute without additional context
- [ ] Tasks ordered by dependency (top-to-bottom)
- [ ] Each task is atomic and independently testable
- [ ] Pattern references include specific file:line numbers
- [ ] No generic references — everything specific and actionable
- [ ] Validation commands are non-interactive and executable
