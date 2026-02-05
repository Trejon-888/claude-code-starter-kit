# /auto-research — Automated Research Tasks

Run research tasks for your project. Checks dependencies, security, codebase health, and ecosystem updates.

---

## Tasks

Run these sequentially:

### 1. Dependency Watch

```
Read package.json (or equivalent) to get current dependency versions.
Check for newer versions and summarize:
- Breaking changes
- New features relevant to this project
- Security fixes

Write findings to .agents/reference/research-deps.md
```

### 2. Security Audit

```
Run: npm audit (or equivalent)
Check for known vulnerabilities in dependencies.
Scan for potential hardcoded secrets or API keys
(look for patterns like API_KEY=, SECRET=, password= in non-.env files).

Write findings to .agents/reference/research-security.md
```

### 3. Codebase Health

```
Run validation commands from CLAUDE.md (typecheck, lint, test).

Check alignment:
- Count files in .agents/plans/active/, pending/, completed/
- Compare to INDEX.md counts
- Check for empty directories in .agents/
- Check for stale reference docs (>30 days)

Write report to .agents/reference/research-health.md
```

### 4. Ecosystem Watch

```
Search the web for updates relevant to your tech stack:
- Framework updates and new features
- Claude Code updates and new features
- New patterns in AI-assisted development

Compare against your .claude/ configuration — identify features you're not using.

Write to .agents/reference/research-ecosystem.md
```

---

## After All Tasks

- Commit reports to git
- Output a summary of key findings

---

**Version:** 2.0
