# Module 1 — Basic: Build a Tiny Full-Stack App with Your Repo-Native AI Team

> A solo-dev workshop: build something with Squad, not just opinions.

← Back to [Workshop Index](../README.md)

---

## Goal

In one sitting, build a small but real app — a **Personal Reading List** — with:

- A .NET 10 minimal API backend
- A tiny React frontend
- Tests
- At least one architectural decision recorded by the team

The point is not to make the next unicorn. The point is to see whether Squad's team model genuinely reduces context friction.

---

## Prerequisites

See [docs/prerequisites.md](../docs/prerequisites.md) for full install instructions and version-specific notes.

**Quick check — run this before continuing:**

```powershell
.\scripts\Verify-Prerequisites.ps1
```

All lines should show `PASS`. Fix any that don't before proceeding.

| Tool | Minimum version |
|---|---|
| Node.js | 22.5.0 |
| .NET SDK | 10.0.0 |
| Git | any recent |
| GitHub CLI | 2.89.0 |
| GitHub Copilot CLI | 1.0.24 |
| Squad CLI | 0.9.4 |
| PowerShell exec policy | RemoteSigned |

---

## Step 0: Create the repo and initialize Squad

### 0a. Create a fresh project directory

```powershell
mkdir reading-list-squad-lab
cd reading-list-squad-lab
git init
```

### 0b. Create a minimal README and make the first commit

Before creating the remote repo, give git something to push:

```powershell
@"
# Reading List Squad Lab

A personal reading list app built as a Squad workshop exercise.

- .NET 10 minimal API backend
- React + TypeScript frontend
- SQLite or in-memory storage
"@ | Set-Content README.md

git add README.md
git commit -m "initial commit: project description"
```

### 0c. Create a GitHub repo and push

```powershell
gh repo create reading-list-squad-lab --public --source . --push
```

> This creates the GitHub repo, links it as `origin`, and pushes the initial commit in one command. `--push` uses your current branch name automatically — no need to specify `master` or `main`.
>
> If you'd rather not publish a workshop exercise, use `--private` instead of `--public`. No subsequent step depends on the repo being public.
>
> If the repo already exists on GitHub, link it manually and push:
> ```powershell
> git remote add origin https://github.com/<your-username>/reading-list-squad-lab.git
> git push -u origin HEAD
> ```

### 0d. Initialize Squad

```powershell
squad init
```

**Expected output:** A list of created files under `.squad/`, `.github/`, and `.copilot/`, ending with `Your team is ready. Run squad to start.`

> **Note on Squad's "Run squad to start" line:** ignore it. The interactive `squad` shell is deprecated. Use `copilot --agent squad` as shown in Step 1 below.

### 0e. Commit the Squad scaffolding

```powershell
git add -A
git commit -m "squad init: scaffold team workspace"
git push
```

### 0f. Verify everything is healthy

```powershell
squad doctor
```

**Expected (v0.9.4):** `9 passed, 0 failed, 0 warnings, 2 info` — no manual fixes needed.

#### Expected output (v0.9.4)

```
🩺 Squad Doctor
===============

Mode: local

✅  .squad/ directory exists — directory present
✅  config.json valid — parses as JSON, schema OK
✅  team.md found with ## Members header — file present, header found
✅  routing.md found — file present
✅  agents/ directory exists — directory present (2 agents)
✅  casting/registry.json exists — file present, valid JSON
✅  decisions.md exists — file present
✅  .github/agents/squad.agent.md — file present (Copilot agent discovery file)
✅  Node.js ≥22.5.0 (node:sqlite) — v22.5.0 — node:sqlite available
ℹ️  vscode-jsonrpc exports field — not found in node_modules (expected for global installs)
ℹ️  copilot-sdk session.js ESM patch — not found in node_modules (expected for global installs)

Summary: 9 passed, 0 failed, 0 warnings, 2 info
```

The two `ℹ️` info lines are not warnings — Squad explicitly tells you they're expected when the CLI is installed globally (which it is, in this workshop). Both packages are bundled inside the Squad CLI itself, not in your project's `node_modules/`. No action needed.

> The exact `v22.5.0` Node line will show your installed Node version — anything ≥22.5.0 is fine.

> **If you're stuck on v0.9.1:** `squad init` won't scaffold `casting/registry.json` and `squad doctor` will report two warnings instead of info. Either upgrade (`npm install -g @bradygaster/squad-cli@latest`) or check the [CHANGELOG](https://github.com/bradygaster/squad/blob/main/CHANGELOG.md) for your version.

> **If you're on a newer Squad CLI than this workshop targets** (see the version declared at the top of the [README](../README.md)) and the summary numbers differ — different `passed` count, different `info` count — that's expected. Squad CLI adds checks on minor bumps. The signal that matters is **`0 failed`**.

> **Optional — install the workshop coach now.** From a separate terminal in the workshop repo root:
> ```powershell
> .\scripts\Install-WorkshopAgents.ps1
> ```
> Then in your lab terminal, `copilot --agent squad-coach` is available any time you get stuck.

---

## Step 1: Launch Copilot CLI with the Squad agent

From inside the `reading-list-squad-lab` directory, start the Copilot CLI:

```powershell
copilot --agent squad
```

You should see the Copilot CLI banner with `GitHub Copilot v1.0.24`, a connected VS Code notification, and a prompt ready for input.

> **Why Copilot CLI and not the VS Code Chat panel?**
> The Squad README says it directly: *"The interactive shell (squad with no arguments) has been deprecated. For the best Squad experience, use the GitHub Copilot CLI instead."*
> Copilot CLI gives you tool execution, agent routing, MCP access, and full Squad integration from the terminal.

### Enabling auto-approve (optional but recommended)

Squad makes many tool calls per session. To avoid approving each one:

```
/allow-all
```

This is the equivalent of the `--yolo` flag. You can also start with:

```powershell
copilot --agent squad --yolo
```

### Selecting the right model

By default, Copilot CLI may start with a mid-tier model (e.g. `GPT-5.4 (medium)`). For a workshop that involves multi-agent coordination, code generation across .NET and React, architectural decisions, and code review — **use the strongest model available.**

Check the current model and available options:

```
/model
```

**Recommended models (in order of preference for this workshop):**

| Model | Why |
|---|---|
| **Claude Sonnet 4** or **Claude Opus** | Excellent at multi-step coding, nuanced review, and architectural reasoning |
| **GPT-5.4 (large)** | Stronger reasoning than medium; good all-rounder |
| **o3** or **o4-mini** | Strong reasoning models for complex planning |
| GPT-5.4 (medium) | Acceptable default, but may produce shallower reviews and weaker coordination |

Select the model you want from the list shown by `/model`. The model affects every agent in the session — Lead review quality, Tester edge-case detection, and Scribe memory all benefit from a more capable model.

> **Tip:** If you're unsure what's available, just run `/model` and pick the largest/most capable option. You can always switch mid-session.

---

## Step 2: Start with a lean solo-dev team

At the Copilot CLI prompt (`❯`), type:

```
I'm a solo developer building a small full-stack app called "Reading List."
Use a lean team: Lead, Backend, Frontend, Tester, and Scribe.
Stack: .NET 10 minimal API, React with TypeScript, and simple SQLite storage.
Keep architecture boring and maintainable.
Set up the team now.
```

**What to watch for:**
- Squad should propose team members, each with a name from a thematic cast
- Each member gets a role (Lead, Backend, Frontend, Tester, Scribe)
- You will be asked to confirm — type **yes**

### PRD / spec prompt

Squad may ask whether you have a PRD or spec document:

```
Do you have a PRD or spec document? (file path, paste it, or skip)
❯ 1. Skip — I'll give tasks directly
  2. Yes, let me provide one
  3. Other (type your answer)
```

**Select `1. Skip — I'll give tasks directly`.** In this workshop, we feed the team structured task prompts step by step instead of a single upfront document. Step 3 is our "spec" — giving the team the stack, folder structure, and architecture plan as a direct prompt.

**After confirmation, verify:**

```powershell
# In a separate terminal (not the copilot session):
dir .squad\agents\
```

You should see directories for each team member (e.g. `ralph/`, `scribe/`, and your newly cast agents).

> **Tip — add yourself as a human member.** Open `.squad/team.md` and add yourself to the `## Members` table with role `👤 Human — Project Owner` and no charter path. This tells every agent that you are the decision-maker and that notifications/escalations should reach you:
>
> ```markdown
> | Your Name | 👤 Human — Project Owner | — | 👤 Human |
> ```
>
> Agents read `team.md` at the start of each session. With you listed, they will address uncertainty to you instead of blocking or guessing.

---

## Step 3: Make the team explore first

Back in the Copilot CLI session, type:

```
Before building anything, explore the repo, propose the folder structure,
capture one architecture decision in decisions.md, and explain the
implementation plan. Don't write any code yet — just plan.
```

**What to watch for:**
- The Lead should propose a folder structure (e.g. `backend/`, `frontend/`, `tests/`)
- An architecture decision should be captured
- The Scribe should log the planning session and merge decisions

### How decisions flow in Squad

Squad uses a staging workflow for decisions:

1. **An agent writes a decision** to `.squad/decisions/inbox/<agent>-<topic>.md`
2. **The Scribe picks it up**, merges it into `.squad/decisions.md`, and clears the inbox file
3. The inbox ends up empty — this is normal

So after this step, the inbox will be empty:

```powershell
# This will be empty — that's expected:
Get-ChildItem .squad\decisions\inbox\
```

The merged decision lives in `.squad/decisions.md`:

```powershell
# This is where decisions end up:
Get-Content .squad\decisions.md
```

You should see a structured decision entry with rationale and alternatives considered — not just chat fluff.

> **Note:** The Scribe may also place a copy at the repo root (`decisions.md`). The authoritative file is always `.squad/decisions.md`.

---

## Step 4: Build the first vertical slice

Now give one bounded feature:

```
Build the first vertical slice:
- Backend: .NET 10 minimal API endpoint to add a book (POST /api/books)
- Backend: .NET 10 minimal API endpoint to list all books (GET /api/books)
- Frontend: React page that displays the book list
- Frontend: Simple form to add a book (title, author, status: unread/read)
- Tests: Unit tests for the API endpoints
Keep it minimal but production-clean. Use the folder structure from the plan.
```

**What to watch for:**
- Role separation: Backend agent writes API code, Frontend agent writes React code, Tester writes tests
- The Lead should coordinate and review
- The Scribe should log what happened

**After it completes, verify the code was created:**

```powershell
# In a separate terminal:
Get-ChildItem -Recurse -Name -Include *.cs,*.tsx,*.ts,*.json | Where-Object { $_ -notmatch 'node_modules|\.squad' }
```

You should see backend `.cs` files, frontend `.tsx`/`.ts` files, and test files.

**Try building and running:**

```powershell
# Backend
cd backend   # or wherever the API was placed
dotnet build
dotnet test

# Frontend
cd ../frontend  # or wherever the React app was placed
npm install
npm run build
```

> If paths differ from the above, check what the team actually created. The agents decide the exact structure.

---

## Step 5: Force an architectural decision

Ask the Lead directly:

```
Lead, decide whether we should use SQLite with Entity Framework or a simple
JSON file for storage in this workshop. Record the decision with rationale
in decisions.md. Consider: this is a workshop app, we want minimal setup
but realistic patterns.
```

**What to watch for:**
- A deliberate decision, not just "use SQLite because it's popular"
- The decision should appear in `.squad/decisions.md` with context and rationale
- Other agents should be able to reference this decision in future work

**Verify:**

```powershell
Get-Content .squad\decisions.md
```

Look for a new entry with a clear rationale section.

---

## Step 6: Use the reviewer on purpose

Now trigger the review cycle:

```
Lead, review all changes so far as if this were a real PR. Be specific
about what's good and what needs improvement.

Tester, look for edge cases we skipped — empty titles, duplicate books,
invalid status values. Add tests for them.

Scribe, capture any new skills or patterns we should preserve for future work.
```

**What to watch for:**
- The Lead should give concrete review feedback (not just "looks good")
- The Tester should find and write tests for edge cases you didn't think of
- The Scribe should update skills in `.copilot/skills/` or `.squad/identity/wisdom.md`

**Verify:**

```powershell
# Check for new test files or updated tests
Get-ChildItem -Recurse -Name -Include *test*,*Test*,*spec* | Where-Object { $_ -notmatch 'node_modules' }

# Check for skills
Get-ChildItem -Recurse .copilot\skills\

# Check wisdom
Get-Content .squad\identity\wisdom.md
```

This is where Squad is supposed to earn its keep. The solo-dev docs position the Lead as the safety net and the Tester as the discipline you would otherwise skip when tired, hungry, or overconfident. Usually all three.

---

## What to watch for

Success is not "the app compiles." A determined toaster can probably do that soon.

**Success looks like:**

- [ ] The Lead catches something useful during review
- [ ] The Tester adds test cases you would have skipped
- [ ] Decisions are actually preserved in `decisions.md` and referenced later
- [ ] The team structure reduces re-explaining context

**Failure looks like:**

- [ ] Too many agents for the task (overhead > value)
- [ ] Decorative memory (files exist but are never reused)
- [ ] Vague work splitting (agents duplicate effort or produce incoherent output)
- [ ] Endless agent theater with no measurable improvement over a single Copilot session

That is why this is a workshop and not a demo. Demos flatter tools. Workshops embarrass them. Which is healthy.

---

## You can stop here

If module 1 was useful, you have a working app, a working team, and enough exposure to decide whether Squad is worth keeping in your toolbelt.

If you want to test whether the persistent memory actually compounds — i.e., whether the *second* feature goes faster than the first — continue to **[Module 2 — Intermediate](02-intermediate.md)**.

---

## Learn more

- [Squad official guide](https://bradygaster.github.io/squad/docs/guide) — comprehensive reference for all Squad concepts
- [Sample prompts](https://bradygaster.github.io/squad/docs/sample-prompts) — vetted prompt patterns to copy and adapt
- [Squad FAQ](https://bradygaster.github.io/squad/docs/guide/faq) — common questions and gotchas

---

← Back to [Workshop Index](../README.md) | Next: [Module 2 — Intermediate →](02-intermediate.md)
