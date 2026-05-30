# Squad Workshop — Copilot Instructions

This is the **squad-workshop** repository: a hands-on, self-contained workshop for learning **Squad CLI** — a tool that gives a Git repository a resident AI development team (Lead, Backend, Frontend, Tester, Scribe) with persistent memory, specialist roles, and automatic routing.

When answering questions in this repo, use this context to be accurate and immediately useful.

---

## What this repository is

A workshop in three self-contained modules (~3 hours total). Learners build a **Personal Reading List** app — a .NET 10 minimal API + React + TypeScript + SQLite full-stack app — entirely through Squad's team model.

- **Module 1 — Basic** (`modules/01-basic.md`): Build the app from scratch end-to-end. ~90–120 min.
- **Module 2 — Intermediate** (`modules/02-intermediate.md`): Add a second-wave feature, inspect whether Squad's memory compounded. ~45 min.
- **Module 3 — Advanced** (`modules/03-advanced.md`): .NET Aspire observability + Ralph autonomous mode. ~60 min.

The lab repo created *during* the workshop is called **`reading-list-squad-lab`** — it is separate from this repo. Steps 0a–0e in Module 1 create it.

---

## Key Squad concepts

### Team model
`squad init` scaffolds a resident team in `.squad/` and `.github/`. Each team member is an AI agent with a role, a name from a thematic cast, and persistent memory. The `copilot --agent squad` CLI invokes the whole system.

### Core commands
| Command | What it does |
|---|---|
| `squad init` | Scaffold the team workspace in a new repo |
| `squad doctor` | Health-check: validates `.squad/` structure, checks Node.js version, confirms everything is wired |
| `squad aspire` | Launch the .NET Aspire dashboard (via Docker) to receive OpenTelemetry traces from live Squad sessions |
| `squad watch` | Run Ralph in polling mode — reads GitHub Issues, labels/triages, optionally executes (alias: `squad triage`) |
| `squad loop` | Run Ralph on a schedule using a prompt file (`./loop.md`, repo root) for recurring housekeeping |
| `copilot --agent squad` | Start the Copilot CLI session with the Squad agent attached |
| `squad copilot --auto-assign` | Distinct from `copilot --agent squad` above: adds GitHub's `@copilot` coding agent to `.squad/team.md` and enables auto-assignment of `squad:copilot`-labeled issues to it (`--off` removes it). Used in Module 3 Step 11.6 |

### Decisions flow
Agents write draft decisions to `.squad/decisions/inbox/<agent>-<topic>.md`. The Scribe merges them into `.squad/decisions.md` and clears the inbox. The inbox being empty after a step is **expected and correct** — decisions live in `.squad/decisions.md`.

### Ralph
Ralph is the name for Squad's polling persona (`squad watch` / `squad loop`). He reads GitHub Issues as his queue. He does **not** read chat history, scan TODO comments, or invent work. To stop Ralph cleanly: `New-Item -Path .squad/ralph-stop -ItemType File`. Delete that file before the next run.

### `squad doctor` healthy output
The signal that matters is **`0 failed, 0 warnings`** — the `passed` / `info` counts vary by Squad CLI version and aren't something to match exactly. For example, on v0.9.4 a healthy run looks like:
```
Summary: 9 passed, 0 failed, 0 warnings, 2 info
```
The 2 `ℹ️` info lines about `vscode-jsonrpc` and `copilot-sdk session.js` are **expected** for global CLI installs — not warnings.

---

## Key files in this repo

| File | Purpose |
|---|---|
| `docs/prerequisites.md` | Authoritative tool requirements and install commands |
| `scripts/Verify-Prerequisites.ps1` | Standalone prereq checker — run from the repo root with `./scripts/Verify-Prerequisites.ps1` |
| `docs/troubleshooting.md` | Common failure patterns with exact error text and fixes |
| `modules/01-basic.md` | Workshop Module 1 — start here |
| `CONTRIBUTING.md` | How to file broken-step issues, fix content, propose modules |

---

## Minimum tool versions

| Tool | Minimum |
|---|---|
| Node.js | 22.5.0 |
| .NET SDK | 10.0.0 |
| GitHub CLI | 2.89.0 |
| GitHub Copilot CLI | 1.0.24 |
| Squad CLI | 0.9.4 |

---

## How to answer learner questions

- **"How do I install X?"** → Point to `docs/prerequisites.md` and the relevant section. Install commands are per-OS (`winget` on Windows, `brew` on macOS, `apt`/official feeds on Linux).
- **"I'm stuck on step N of module M"** → Help them diagnose by asking for the exact error output and their tool versions from `./scripts/Verify-Prerequisites.ps1`. Check `docs/troubleshooting.md` for known patterns.
- **"Why is the Aspire dashboard empty?"** → Three causes: Docker not running (most common — `✓ lies when Docker is down`), Squad version too old, or firewall blocking `localhost:4317`.
- **"The inbox under `.squad/decisions/inbox/` is empty"** → This is correct. The Scribe merged the decision into `.squad/decisions.md`.
- **"squad doctor shows warnings"** → If on v0.9.1, upgrade with `npm install -g @bradygaster/squad-cli@latest`. If on v0.9.4+ and still seeing warnings (not info), paste the full output.
- **"Should I use the coach agent?"** → Yes. Run `./scripts/Install-WorkshopAgents.ps1` once from the workshop repo root to install the coach into the lab repo's `.github/agents/`, then `copilot --agent squad-coach` from inside `reading-list-squad-lab` gives step-by-step help and Squad expertise on demand.

---

## Tone

This workshop is direct and honest about Squad's failure modes. Match that tone. Don't oversell Squad, don't hide gotchas, don't generate vague encouragement. When something can go wrong, say exactly how to check and fix it.
