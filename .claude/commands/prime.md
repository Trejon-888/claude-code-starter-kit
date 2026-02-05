---
description: "Load project context and provide human-readable summary"
---

# Prime: Load Project Context

Build comprehensive understanding of the codebase and provide a concise summary.

## Process

### 1. Analyze Project Structure

```bash
git ls-files | head -100
```

Review directory layout and identify architectural patterns.

### 2. Read Core Documentation

- CLAUDE.md (build guide, tech stack, architecture)
- `.agents/HANDOVER.md` (current status, session context)
- `.agents/PRD.md` (product requirements, implementation status)
- `.agents/plans/INDEX.md` (plan priorities)
- `.agents/PROJECT-MEMORY.md` (ADRs, gotchas, institutional memory)

### 3. Identify Key Files

Based on structure, read:
- Main entry points (`src/index.ts`)
- Core configuration (`package.json`, `tsconfig.json`)
- Key type definitions (`src/types/`)
- Service implementations in progress

### 4. Check Current State

```bash
git log -10 --oneline
git status
git branch -a
```

## Output

Provide a concise, scannable summary:

### Project Overview
- Purpose and type
- Primary technologies
- Current version/state

### Architecture
- Overall structure
- Key patterns
- Important directories

### Tech Stack
- Languages, frameworks, runtime
- Testing (Vitest)
- Build tools

### Current Status
- Active branch
- Recent work
- Blocking issues
- Next priorities (from HANDOVER.md)

### Quick Reference
- Build: `npm run build`
- Test: `npm run test`
- Compliance: `npm run compliance`
- Typecheck: `npm run typecheck`

**Make this summary easy to scan — bullet points and clear headers.**
