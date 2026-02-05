---
description: "Execute an implementation plan autonomously"
argument-hint: [path-to-plan]
---

# Execute: $ARGUMENTS

## Golden Rule

**Finish the job. Adapt when needed. Document divergences.**

You are an autonomous execution agent. Your job is to implement the plan completely, handle obstacles, and deliver working code.

## Process

### 1. Read and Understand

- Read the ENTIRE plan carefully
- Understand all tasks and their dependencies
- Note the validation commands to run
- Review the testing strategy
- Read all files listed under "Context References" BEFORE implementing

### 2. Set Up Branch

```bash
# Create feature branch from main
git checkout -b feature/<descriptive-name> main
```

### 3. Execute Tasks in Order

For EACH task in the plan:

#### a. Navigate
- Identify the file and action required
- Read existing related files if modifying

#### b. Implement
- Follow the detailed specifications exactly
- Maintain consistency with existing code patterns
- Include proper TypeScript types
- Add structured logging where appropriate

#### c. Verify as you go
- After each file change, run `npm run typecheck`
- Ensure imports are correct
- Verify types are properly defined

### 4. Implement Tests

After completing implementation tasks:
- Create all test files specified in the plan
- Implement all test cases mentioned
- Follow existing testing patterns (Vitest)
- Cover happy path + edge cases + errors

### 5. Run All Validation

Execute ALL validation commands from the plan in order:

```bash
npm run typecheck
npm run lint
npm run test -- --run
npm run compliance
```

If any command fails:
- Fix the issue
- Re-run the command
- Continue only when it passes

### 6. Final Verification

- [ ] All tasks from plan completed
- [ ] All tests created and passing
- [ ] All validation commands pass
- [ ] Code follows project conventions
- [ ] No regressions introduced

## Handling Obstacles

When the plan doesn't match reality:

1. **Missing file/function referenced in plan** — Search for the correct location, adapt, document the divergence
2. **Better pattern discovered** — Use the better pattern, document why
3. **Dependency issue** — Resolve it, document the fix
4. **Plan is ambiguous** — Make the best judgment call, document your reasoning

**Never:** Silently skip tasks. Never ignore validation failures. Never cut corners on tests.

## Output Report

When complete, provide:

### Completed Tasks
- List of all tasks completed
- Files created (with paths)
- Files modified (with paths)

### Divergences from Plan
For each divergence:
- What was planned vs what was implemented
- Why the change was made
- Impact assessment

### Test Results
- Test files created
- Test cases implemented
- All test output

### Validation Results
```bash
# Output from each validation command
```

### Ready for Review
- Confirm all changes are complete
- Confirm all validations pass
- Ready for `/review` then `/commit`
