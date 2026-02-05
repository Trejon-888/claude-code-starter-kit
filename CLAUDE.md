# [Your Project Name]

**One-line description of what you're building.**

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | <!-- e.g. TypeScript, Python, Go --> |
| Runtime | <!-- e.g. Node.js, Deno, Python 3.12 --> |
| Framework | <!-- e.g. React, Next.js, FastAPI, Express --> |
| Database | <!-- e.g. PostgreSQL, SQLite, Supabase --> |
| Auth | <!-- e.g. Supabase Auth, NextAuth, Clerk --> |
| Hosting | <!-- e.g. Vercel, Railway, Fly.io --> |
| Testing | <!-- e.g. Vitest, Jest, Pytest --> |

---

## Architecture Overview

<!-- Describe your project structure. Example: -->

```
your-project/
├── src/
│   ├── components/     # UI components
│   ├── pages/          # Page routes
│   ├── services/       # Business logic
│   ├── types/          # TypeScript types
│   └── utils/          # Shared utilities
├── tests/              # Test files
├── .agents/            # Project memory & plans
├── .claude/            # Claude Code configuration
└── CLAUDE.md           # This file
```

---

## Essential Commands

```bash
npm run dev          # Start development server
npm run build        # Production build
npm run test         # Run tests
npm run lint         # Lint source code
```

<!-- Update these to match your project's actual scripts -->

---

## Commands & Skills

Your Claude Code workflow toolkit. Use independently or chain together.

| Category | Commands |
|----------|----------|
| Build Loop | `/plan`, `/execute`, `/review`, `/system-review`, `/validate`, `/prime` |
| Worktrees | `/worktree`, `/merge-worktrees`, `/worktree-cleanup` |
| GitHub | `/fix-issue`, `/review-pr`, `/create-pr`, `/merge-pr` |
| Session | `/continue`, `/done`, `/piv` |
| Diagnostics | `/doctor`, `/security-audit` |
| Other | `/agent-browser`, `/auto-research` |

**Composition examples:**
- Feature: `/plan` → `/execute` → `/review` → `/done`
- Bug fix: `/fix-issue 42`
- Full autopilot: `/piv`

---

## Guidelines

<!-- Add your project-specific guidelines here. Examples: -->

- All business logic goes through the service layer
- Tests are required for new features
- No direct database calls from UI components

---

## Source of Truth

| Concept | File | What It Owns |
|---------|------|-------------|
| How we build | `CLAUDE.md` (this file) | Tech stack, commands, conventions |
| What we're building | `.agents/PRD.md` | Features, roles, requirements, status |
| Session context | `.agents/HANDOVER.md` | What happened, what's next |
| Lessons learned | `.agents/PROJECT-MEMORY.md` | Decisions, gotchas, solved problems |
| Plan tracking | `.agents/plans/INDEX.md` | Active, pending, completed plans |

---

*Powered by [claude-code-starter-kit](https://github.com/Trejon-888/claude-code-starter-kit) from [INFINITX](https://app.infinitxai.com) — AI-native business infrastructure.*
