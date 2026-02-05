---
description: "Create a PR from the current branch"
---

# Create PR

Create a pull request from the current branch.

## Process

### 1. Gather Context

```bash
git branch --show-current
git log main..HEAD --oneline
git diff main..HEAD --stat
```

Verify:
- Not on main (refuse to create PR from main)
- Branch has commits ahead of main
- No uncommitted changes

### 2. Run Validation

```bash
npm run typecheck
npm run test -- --run
npm run lint
```

If any fail, fix before creating PR.

### 3. Push Branch

```bash
git push -u origin $(git branch --show-current)
```

### 4. Create PR

Analyze the commits to determine:
- PR title (short, descriptive, under 70 chars)
- Summary of changes
- Testing done

```bash
gh pr create --title "{title}" --body "$(cat <<'EOF'
## Summary

{1-3 bullet points describing what this PR does}

## Changes

{List of key changes by file/area}

## Testing

{Tests added or existing tests that cover changes}

## Validation

```
npm run typecheck  ✅
npm run lint       ✅
npm run test       ✅
```

---
Generated with Claude Code
EOF
)"
```

### 5. Report

Output the PR URL and summary.
