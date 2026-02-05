<p align="center">
  <img src=".github/assets/ai-agent.png" alt="Claude Code Starter Kit" width="180" />
</p>

<h1 align="center">claude-code-starter-kit</h1>

<p align="center">
  <strong>Give Claude Code a memory, a workflow, and the ability to improve itself.</strong>
</p>

<p align="center">
  <a href="#-get-it"><img src="https://img.shields.io/badge/Get_Started-30s_setup-10b981?style=for-the-badge" alt="Get Started" /></a>
  <a href="https://github.com/Trejon-888/claude-code-starter-kit/stargazers"><img src="https://img.shields.io/github/stars/Trejon-888/claude-code-starter-kit?style=for-the-badge&color=fbbf24" alt="Stars" /></a>
  <a href="https://app.infinitxai.com"><img src="https://img.shields.io/badge/IX_System-Upgrade-6366f1?style=for-the-badge" alt="IX System" /></a>
</p>

<p align="center">
  <a href="#-see-it">See It</a> •
  <a href="#-get-it">Get It</a> •
  <a href="#-whats-inside">What's Inside</a> •
  <a href="#-how-it-works">How It Works</a> •
  <a href="#-commands">Commands</a> •
  <a href="#%EF%B8%8F-who-built-this">Who Built This</a>
</p>

---

<br/>

You know that moment — you open Claude Code, and the first five minutes is spent re-explaining your project. What you built yesterday. What the architecture looks like. What you were about to do next.

Every session starts from zero. And every session, you lose a little momentum.

**What if Claude already knew?**

What if every session picked up exactly where you left off — your project context loaded, your plans tracked, your docs in sync, and your next step already suggested?

That's what this kit does.

**You stop managing Claude and start building with Claude.**

You become a better person too, it's true.

Your sessions get deeper. Your momentum compounds. Your documentation stays alive without you thinking about it. You ship faster because you're never starting from zero.

And here's the part nobody tells you: when your AI partner actually remembers your project, your decisions, your patterns — you start thinking bigger. You take on features you would've put off. You refactor things you've been tolerating. You move like a team, not a solo dev explaining things to a new hire every morning.

<br/>

---

<br/>

## 👀 See It

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

And here's what happens when you say **"done"**:

```
✅ Session Complete

  Validation:    All 4 gates passed (build, lint, test, typecheck)
  Alignment:     94% (16/17 checks)
  Docs Synced:   HANDOVER.md, INDEX.md, PRD.md
  Auto-Healed:   1 fix (INDEX.md count corrected)
  Discovered:    1 evolution opportunity (missing Stripe reference doc)

  Commit: a3f8b2c — feat: add user settings with profile editing

  Ready for more? Say "continue" to see what's next.
```

That's the loop. **`/continue` → build → `/done`.** Your project remembers everything.

<br/>

---

<br/>

## 🚀 Get It

### Already using Claude Code?

Just tell Claude:

> *"Create a new project from the Trejon-888/claude-code-starter-kit template, then open CLAUDE.md and help me fill it in for my project."*

That's it. Claude handles the rest. Your first `/continue` loads your project context automatically.

### New to Claude Code?

Say this to Claude:

> *"Help me get started with Claude Code. I want to install it, set up a new project using the claude-code-starter-kit template from Trejon-888 on GitHub, and configure it for my project."*

Claude will walk you through everything — installing, cloning, configuring. Or do it yourself:

```bash
gh repo create my-project --template Trejon-888/claude-code-starter-kit --public
cd my-project
claude
```

Then just say: *"Help me fill in CLAUDE.md for my project"* — and you're in the loop.

<br/>

---

<br/>

## 📦 What's Inside

<table>
<tr>
<td width="50%" valign="top">

### 🔧 20 Commands
Composable building blocks:

```
/plan → /execute → /review → /done
```

Plan features. Build them. Review the code. Ship it. Each works alone or chains together.

</td>
<td width="50%" valign="top">

### ⚡ 3 Skills
Auto-invoke when you need them:

- Say **"continue"** → context loads
- Say **"done"** → everything syncs
- Say **"piv"** → full autopilot

</td>
</tr>
<tr>
<td width="50%" valign="top">

### 🪝 5 Hooks
Running in the background:

- Plans auto-save with real names
- Types auto-check after edits
- Context preserved before compaction
- Destructive commands blocked

</td>
<td width="50%" valign="top">

### 🧠 Project Memory
Your project gets a brain:

| File | Remembers |
|------|-----------|
| `CLAUDE.md` | How it works |
| `PRD.md` | What you're building |
| `HANDOVER.md` | What happened |
| `PROJECT-MEMORY.md` | What you learned |

</td>
</tr>
</table>

Claude reads all of this at the start of every session. That's how it knows your project.

<br/>

---

<br/>

## ⚙️ How It Works

<details>
<summary><strong>🔄 The Session Loop: /continue → build → /done</strong></summary>
<br/>

**Starting a session** — `/continue` (or just say "continue"):
- Reads CLAUDE.md to understand the project
- Reads HANDOVER.md to know what happened last time
- Checks plans to know what's active
- Runs an alignment audit — are your docs honest?
- Suggests what to work on next

**Ending a session** — `/done` (or say "done", "wrap up", "ship it"):
- Validates your code (build, lint, test — whatever your stack needs)
- Syncs all project documents automatically
- Runs alignment audit and self-heals any drift
- Creates an execution report
- Commits with an alignment score

**The loop compounds.** Every session is smarter than the last.

</details>

<details>
<summary><strong>📄 The Document-Driven Architecture</strong></summary>
<br/>

Every command reads your `CLAUDE.md` to understand your project. No hardcoded assumptions. Your CLAUDE.md is the source of truth.

The `.agents/` directory is your project's institutional memory:
- **PRD.md** — what you're building (updated as features ship)
- **HANDOVER.md** — what happened each session (automatic)
- **PROJECT-MEMORY.md** — decisions, gotchas, solved problems (cumulative)
- **plans/** — your feature pipeline (active → completed with reports)

When Claude reads these at session start, it doesn't just know your codebase — it knows your *intent*, your *decisions*, your *history*. It knows that bug was already solved in Session 7. It knows you chose PostgreSQL over MongoDB and why.

That's the difference between an AI that reads your code and an AI that **understands your project**.

</details>

<details>
<summary><strong>🧬 Self-Evolution: It Gets Better As You Use It</strong></summary>
<br/>

The self-evolution rule teaches Claude to improve its own configuration:

- **Something took 3+ attempts?** Claude extracts the pattern into a rule.
- **Workflow friction?** Claude creates a hook to prevent it.
- **You corrected Claude?** It updates the relevant rule immediately.

After every 5 self-modifications, Claude checks in with you. You stay in control. Claude gets sharper.

</details>

<details>
<summary><strong>📊 Alignment Scoring: How Honest Are Your Docs?</strong></summary>
<br/>

Every `/done` and `/continue` runs up to 19 alignment checks:

- Do plan counts in INDEX.md match actual folders?
- Does PRD reflect what's actually built?
- Does CLAUDE.md tech stack match package.json?
- Are reference docs still current?

Result: your **alignment score**. Below 80%? Claude auto-heals what it can, flags the rest.

Your project documentation is never a lie. It's a living, accurate reflection of reality.

</details>

<br/>

---

<br/>

## 📋 Commands

| Category | Commands | What They Do |
|:---------|:---------|:-------------|
| **Build** | `/plan` `/execute` `/review` `/validate` | Plan features, build them, review code, validate |
| **Session** | `/continue` `/done` `/piv` `/prime` | Resume, complete, autopilot, orient |
| **GitHub** | `/fix-issue` `/create-pr` `/review-pr` `/merge-pr` | Issue → fix → PR → merge |
| **Parallel** | `/worktree` `/merge-worktrees` `/worktree-cleanup` | Multiple features at once |
| **Health** | `/doctor` `/security-audit` `/system-review` | Diagnostics and security |

**Composition:**
```
Quick fix:      /fix-issue 42
Feature:        /plan → /execute → /review → /done
Full autopilot: /piv
Parallel:       /worktree feature-a feature-b → /merge-worktrees → /done
```

<br/>

---

<br/>

## 💡 What People Build With This

<table>
<tr>
<td align="center" width="20%">👤<br/><strong>Solo devs</strong></td>
<td align="center" width="20%">🌙<br/><strong>Side projects</strong></td>
<td align="center" width="20%">💼<br/><strong>Freelancers</strong></td>
<td align="center" width="20%">🌍<br/><strong>Open source</strong></td>
<td align="center" width="20%">👥<br/><strong>Teams</strong></td>
</tr>
<tr>
<td align="center"><sub>AI that knows your project across sessions</sub></td>
<td align="center"><sub>No more "where was I?"</sub></td>
<td align="center"><sub>Each client project has its own memory</sub></td>
<td align="center"><sub>Contributors get instant context</sub></td>
<td align="center"><sub>Shared architecture understanding</sub></td>
</tr>
</table>

The pattern is the same: give Claude context, let it compound, stay in the loop.

<br/>

---

<br/>

## 🔔 Stay in the Loop

This kit evolves. We use it every day across 10 products, and when we discover a better pattern, we push it here.

**⭐ Star this repo** to get updates when we add new commands, improve skills, or discover patterns worth sharing.

We also share what we learn about building with AI:

- **YouTube:** [@TréjonEdmonds](https://youtube.com/@TrejonEdmonds) — building in public, AI workflows, what's working
- **GitHub:** [Trejon-888](https://github.com/Trejon-888) — all our open source work

<br/>

---

<br/>

## 🔮 What Happens Next

This kit gives you the workflow. The memory. The self-healing loop.

But what if you didn't just want to *build* faster — what if you wanted the *business* to run itself too?

<p align="center">
  <a href="https://app.infinitxai.com">
    <img src="https://img.shields.io/badge/IX_System-AI_Managed_Client_Acquisition-10b981?style=for-the-badge" alt="IX System" />
  </a>
</p>

**[IX-System](https://app.infinitxai.com)** is the upgrade. Same philosophy — give AI context, let it compound, stay in the loop — applied to growing your business. AI-managed client acquisition. Outreach, follow-ups, pipeline — handled while you focus on building.

You've already seen what happens when Claude remembers your project. Imagine what happens when AI remembers your customers too.

<p align="center">
  <a href="https://app.infinitxai.com"><strong>→ Get the IX-System upgrade</strong></a>
</p>

<br/>

---

<br/>

## 🏗️ Who Built This

<p align="center">
  <img src=".github/assets/infinitx-logo.png" alt="INFINITX" width="60" />
</p>

<p align="center">
  <strong>Tréjon & Enrique</strong> @ <a href="https://app.infinitxai.com">INFINITX</a>
</p>

We build [Agentix](https://github.com/Trejon-888/agentix) — an open-source operating system for AI-native businesses. 77 services. 10 products. One AI entity (Finn) that builds and operates it all.

This starter kit is the exact workflow infrastructure we extracted from building with Claude Code every single day. It's the foundation everything else runs on.

We believe the developers who learn to build *with* AI — not just use AI — are the ones who'll shape what software becomes.

This kit is our way of saying: **we see you building.** Here's what we've learned. Go make something incredible.

Happy building. 🚀

<p align="center">
  — <strong>Tréjon & Enrique</strong> @ <a href="https://app.infinitxai.com">INFINITX</a>
</p>

<br/>

---

<p align="center">
  <sub>MIT License — use it however you want.</sub>
</p>

<p align="center">
  <sub>Built with <a href="https://github.com/Trejon-888/agentix">Agentix</a> · Powered by <a href="https://docs.anthropic.com/en/docs/claude-code">Claude Code</a></sub>
</p>
