# Testing Rules

## Framework

Configure your test framework in CLAUDE.md under "Essential Commands". The patterns below are universal.

## Structure

```
describe('module.entity.action', () => {
  it('describes expected behavior in plain English', () => {
    // Arrange → Act → Assert
  })
})
```

## Requirements

- Happy path + edge cases + error cases for each public function
- Mock external services, never call real APIs in unit tests
- Tests are colocated with source files or in `__tests__/` directories

## AI Assertion Warning

Never use AI-generated assertions without verifying them against actual behavior. AI agents tend to assert what they *think* the code does rather than what it *actually* does. Run the test and confirm it passes for the right reasons.
