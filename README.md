# claude-code-starter-kit

> Give Claude Code a memory, a workflow, and the ability to improve itself.

---

You know that moment — you open Claude Code, and the first five minutes is spent re-explaining your project. What you built yesterday. What the architecture looks like. What you were about to do next.

Every session starts from zero. And every session, you lose a little momentum.

**What if Claude already knew?**

What if every session picked up exactly where you left off — your project context loaded, your plans tracked, your docs in sync, and your next step already suggested?

That's what this kit does.

**You stop managing Claude and start building with Claude.**

Your sessions get deeper. Your momentum compounds. Your documentation stays alive without you thinking about it. You ship faster because you're never starting from zero.

And here's the part nobody tells you: when your AI partner actually remembers your project, your decisions, your patterns — you start thinking bigger. You take on features you would've put off. You refactor things you've been tolerating. You move like a team, not a solo dev explaining things to a new hire every morning.

---

## See It

Here's what your session start looks like — every time, automatically:

```
═══ PROJECT CONTEXT LOADED ═══

Project: My SaaS App

--- Last Session ---
### Session 12 — 2026-02-04
- Context: Added user settings page with profile editing
- Completed: Settings UI, API endpoint, form validation
- Next: Add password change flow, connect notification preferences

Active plans: 2
  user-settings-flow
  notification-system

═══ END PROJECT CONTEXT ═══
```

And here's what happens when you say "done":

```
## Session Complete

Validation: All 4 gates passed (build, lint, test, typecheck)
Alignment Score: 94% (16/17 checks)
Documents Synced: HANDOVER.md, INDEX.md, PRD.md
Healing Applied: 1 auto-fix (INDEX.md count corrected)
Evolution Discoveries: 1 opportunity (missing reference doc for Stripe API)

Commit: a3f8b2c — feat: add user settings with profile editing

Ready to start something new? Use /continue to see what's next.
```

That's the loop. `/continue` → build → `/done`. Your project remembers everything.

---

## Get It

### Already using Claude Code?

Just tell Claude:

> "Create a new project from the Trejon-888/claude-code-starter-kit template, then open CLAUDE.md and help me fill it in for my project."

That's it. Claude handles the rest. Your first `/continue` will load your project context automatically.

### New to Claude Code?

Say this to Claude (or paste it into your terminal):

> "Help me get started with Claude Code. I want to install it, set up a new project using the claude-code-starter-kit template from Trejon-888 on GitHub, and configure it for my project."

Claude will walk you through:
1. Installing Claude Code (`npm install -g @anthropic-ai/claude-code`)
2. Getting your Anthropic API key
3. Cloning this template
4. Filling in your project details

Or if you prefer doing it yourself:

```bash
gh repo create my-project --template Trejon-888/claude-code-starter-kit --public
cd my-project
claude
```

Then just tell Claude: *"Help me fill in CLAUDE.md for my project"* — and you're in the loop.

---

## What's Inside

**20 commands** that compose like building blocks:

```
/plan → /execute → /review → /done
```

Plan a feature. Build it. Review the code. Ship it. Each one works alone or chains together.

**3 skills** that just happen when you need them:

Say *"continue"* — your context loads. Say *"done"* — everything syncs and commits. Say *"piv"* — full autopilot: plan, implement, validate, repeat until it's right.

**5 hooks** running in the background:

Your plans auto-save with descriptive names. Your types auto-check after every edit. Your context auto-preserves before compaction. Destructive commands get blocked before they run.

**3 rules** that teach Claude how to improve:

When something takes 3+ tries, Claude extracts the pattern into a rule. When you correct Claude, it updates itself so it doesn't happen again. Every 5 self-improvements, it checks in with you.

**A document structure** that gives your project a memory:

| File | What It Remembers |
|------|-------------------|
| `CLAUDE.md` | How your project works — tech stack, commands, conventions |
| `.agents/PRD.md` | What you're building — features, roles, requirements |
| `.agents/HANDOVER.md` | What happened — session history, decisions, next steps |
| `.agents/PROJECT-MEMORY.md` | What you've learned — solved problems, gotchas, decisions |
| `.agents/plans/` | What's planned — active, pending, and completed plans |

Claude reads all of this at the start of every session. That's how it knows your project.

---

## How It Works

<details>
<summary><strong>The session loop: /continue → build → /done</strong></summary>

### Starting a session

Every session starts with `/continue` (or just say "continue" or "what's next"):
- Reads your CLAUDE.md to understand the project
- Reads HANDOVER.md to know what happened last time
- Checks your plans to know what's active
- Runs an alignment audit — are your docs honest?
- Suggests what to work on next

### Ending a session

Every session ends with `/done` (or say "done", "wrap up", "ship it"):
- Validates your code (build, lint, test — whatever your stack needs)
- Syncs all your project documents automatically
- Runs an alignment audit and self-heals any drift
- Creates an execution report
- Commits with an alignment score

The loop compounds. Every session is smarter than the last.

</details>

<details>
<summary><strong>The document-driven architecture</strong></summary>

Every command reads your `CLAUDE.md` to understand your project. No hardcoded assumptions. No magic configuration. Your CLAUDE.md is the source of truth.

The `.agents/` directory is your project's institutional memory:
- **PRD.md** — what you're building (updated as features ship)
- **HANDOVER.md** — what happened each session (automatic)
- **PROJECT-MEMORY.md** — decisions, gotchas, solved problems (cumulative)
- **plans/** — your feature pipeline (active → completed with reports)

When Claude reads these at session start, it doesn't just know your codebase — it knows your *intent*, your *decisions*, your *history*. It knows that bug was already solved in Session 7. It knows you chose PostgreSQL over MongoDB and why. It knows the API refactor is blocked until the auth migration finishes.

That's the difference between an AI that reads your code and an AI that understands your project.

</details>

<details>
<summary><strong>Self-evolution: it gets better as you use it</strong></summary>

The self-evolution rule teaches Claude to improve its own configuration:

- **Something took 3+ attempts?** Claude extracts the pattern into a rule so it doesn't struggle again.
- **Workflow friction?** Claude creates a hook to prevent it next time.
- **You corrected Claude?** It updates the relevant rule immediately.

After every 5 self-modifications, Claude checks in: *"I've made 5 improvements this session. Want to review?"*

You stay in control. Claude gets sharper. Your workflow evolves with your project.

</details>

<details>
<summary><strong>Alignment scoring: how honest are your docs?</strong></summary>

Every time you run `/done` or `/continue`, Claude runs up to 19 alignment checks:

- Do the plan counts in INDEX.md match the actual folders?
- Does your PRD reflect what's actually built?
- Does your tech stack in CLAUDE.md match your package.json?
- Are your reference docs still current?
- Do your skills and commands match?

The result is a percentage: your **alignment score**. If it drops below 80%, Claude auto-heals what it can and flags the rest.

This means your project documentation is never a lie. It's always a living, accurate reflection of reality.

</details>

---

## Command Reference

| Category | Commands | What They Do |
|----------|----------|-------------|
| **Build** | `/plan` `/execute` `/review` `/validate` | Plan features, build them, review code, validate |
| **Session** | `/continue` `/done` `/piv` `/prime` | Resume, complete, autopilot, orient |
| **GitHub** | `/fix-issue` `/create-pr` `/review-pr` `/merge-pr` | Issue → fix → PR → merge |
| **Parallel** | `/worktree` `/merge-worktrees` `/worktree-cleanup` | Multiple features at once |
| **Health** | `/doctor` `/security-audit` `/system-review` | Diagnostics |
| **Other** | `/agent-browser` `/auto-research` | Browser testing, web research |

**Composition examples:**
- Quick fix: `/fix-issue 42` (handles everything: branch, fix, test, PR)
- Feature: `/plan` → `/execute` → `/review` → `/done`
- Full autopilot: `/piv` (plans, builds, validates, heals, commits)
- Parallel: `/worktree feature-a feature-b` → `/merge-worktrees` → `/done`

---

## What People Build With This

This isn't just for us. Here's what this workflow unlocks:

- **Solo devs** who want their AI to actually know their project across sessions
- **Side projects** that you pick up every few days — no more "where was I?"
- **Freelancers** juggling multiple client projects — each one has its own memory
- **Open source maintainers** who want contributors to have instant context
- **Teams** who want every developer's Claude to understand the shared architecture

The pattern is the same: give Claude context, let it compound, stay in the loop.

---

## Stay in the Loop

This kit evolves. We use it every day across 10 products, and when we discover a better pattern, we push it here.

**Watch this repo** to get updates when we add new commands, improve skills, or discover patterns worth sharing.

We also share what we learn about building with AI — workflows, patterns, mistakes, breakthroughs:

- **YouTube:** [@TréjonEdmonds](https://youtube.com/@TrejonEdmonds) — building in public, AI workflows, what's working
- **GitHub:** [Trejon-888](https://github.com/Trejon-888) — all our open source work

---

## What Happens Next

This kit gives you the workflow. The memory. The self-healing loop.

But what if you didn't just want to *build* faster — what if you wanted the *business* to run itself too?

**[IX-System](https://app.infinitxai.com)** is the upgrade. Same philosophy — give AI context, let it compound, stay in the loop — applied to growing your business. AI-managed client acquisition. Outreach, follow-ups, pipeline — handled while you focus on building.

You've already seen what happens when Claude remembers your project. Imagine what happens when AI remembers your customers too.

→ **[Get the IX-System upgrade](https://app.infinitxai.com)**

---

## Who Built This

We're **Tréjon & Enrique** at [INFINITX](https://app.infinitxai.com).

We build [Agentix](https://github.com/Trejon-888/agentix) — an open-source operating system for AI-native businesses. 77 services. 10 products. One AI entity (Finn) that builds and operates it all.

This starter kit is the exact workflow infrastructure we extracted from building with Claude Code every single day. It's the foundation everything else runs on.

We believe the developers who learn to build *with* AI — not just use AI — are the ones who'll shape what software becomes.

This kit is our way of saying: we see you building. Here's what we've learned. Go make something incredible.

Happy building.

— **Tréjon & Enrique** @ [INFINITX](https://app.infinitxai.com)

---

## License

MIT — use it however you want.

---

*Built with [Agentix](https://github.com/Trejon-888/agentix). Powered by [Claude Code](https://docs.anthropic.com/en/docs/claude-code).*
