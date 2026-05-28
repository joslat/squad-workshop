# Squad Workshop

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Check links](https://github.com/joslat/squad-workshop/actions/workflows/check-links.yml/badge.svg)](https://github.com/joslat/squad-workshop/actions/workflows/check-links.yml)
[![Verify script](https://github.com/joslat/squad-workshop/actions/workflows/verify-script.yml/badge.svg)](https://github.com/joslat/squad-workshop/actions/workflows/verify-script.yml)

> Workshop: assemble your AI dev team with Squad and ship a full-stack app in minutes.

> **Targets Squad CLI `0.9.4`.** Newer Squad CLI versions should work — if `squad doctor` reports `0 failed`, you're fine even if the `passed` / `info` counts differ from what the workshop shows. The minimums for every other tool are in the [prerequisites table](#prerequisites) below.

You've used AI assistants. You've pasted context fifty times. You've re-explained the architecture to a new chat window.

**Squad is different.** It gives your repo a resident team — Lead, Backend Engineer, Frontend Engineer, Tester — with persistent memory, specialist roles, and a routing layer that sends work to the right agent automatically. One session, real decisions, compounding context.

This workshop is the fastest honest way to find out whether it actually changes how you work. You build a real .NET 10 + React app from scratch using the team, record architectural decisions through them, run a regression-aware second feature, and — if you want to go further — observe live telemetry with .NET Aspire and hand autonomous issue triage to Ralph.

---

## What you'll build

A **Personal Reading List** app — a complete, tested, full-stack application:

- .NET 10 minimal API backend
- React + TypeScript frontend
- SQLite storage
- At least one architectural decision recorded by the team

The app is a vehicle. The point is to experience the team model, not to ship the next unicorn.

---

## Modules

| # | Module | What you build | Time | Extra prerequisites |
|---|---|---|---|---|
| 1 | [Basic](modules/01-basic.md) | A working .NET 10 + React reading list app, built by the team end-to-end with one architectural decision and a real review pass. | ~90 min | None beyond the prereqs below. |
| 2 | [Intermediate](modules/02-intermediate.md) | A second-wave feature on the same app — filtering, validation, regression-aware tests — to see whether persistent memory actually compounds. Inspect the team's artifacts. | ~45 min | Completed module 1. |
| 3 | [Advanced](modules/03-advanced.md) | Observe Squad with .NET Aspire, then graduate to autonomous mode with **Ralph** — `squad triage` (polling and `--execute`), plus prompt-driven `squad loop`. | ~60 min | Completed module 1 (module 2 recommended). **Docker Desktop running** for Aspire. |

> **Honest about scope:** modules 1 and 2 are the workshop. Module 3 is more of a guided tour of the riskier corners — autonomous execution, observability — and it deliberately doesn't ask you to leave Ralph running on your repo unsupervised.

---

## Quick start

### Prerequisites

> **Windows only:** This workshop uses `winget` for package installation. macOS and Linux users will need to use equivalent package managers (`brew`, `apt`, etc.) for the install commands in [docs/prerequisites.md](docs/prerequisites.md).

| Tool | Minimum version | Check command |
|---|---|---|
| Node.js | 22.5.0 | `node --version` |
| .NET SDK | 10.0.0 | `dotnet --version` |
| Git | any recent | `git --version` |
| GitHub CLI | 2.89.0 | `gh version` |
| GitHub CLI auth | logged in | `gh auth status` |
| GitHub Copilot CLI | 1.0.24 | `copilot --version` |
| Squad CLI | 0.9.4 | `squad --version` |
| PowerShell exec policy | RemoteSigned | `Get-ExecutionPolicy -Scope CurrentUser` |

See [docs/prerequisites.md](docs/prerequisites.md) for full install instructions and version-specific troubleshooting.

### Verify everything in one pass

```powershell
.\scripts\Verify-Prerequisites.ps1
```

All lines should show `PASS`. Fix any that don't before opening Module 1.

### Start

```powershell
git clone https://github.com/joslat/squad-workshop.git
cd squad-workshop
.\scripts\Verify-Prerequisites.ps1
```

Then open [modules/01-basic.md](modules/01-basic.md) and follow from Step 0.

---

## Getting help

**Stuck on a step?** Use the Squad Coach agent — it knows every module step, every troubleshooting pattern, and the failure modes of Squad itself.

One-time setup (from the workshop repo root):

```powershell
.\scripts\Install-WorkshopAgents.ps1
```

This copies the coach agent and the two helper prompts into `reading-list-squad-lab\.github\` so Copilot CLI can discover them. Then from inside the lab repo:

```powershell
copilot --agent squad-coach
```

Then ask anything: "I'm on Module 1 Step 4 and the team isn't generating tests" or "squad doctor is showing warnings" or "explain what decisions.md should look like."

**Using VS Code?** GitHub Copilot in this repo is pre-configured with Squad context — ask questions in Chat and it will give Squad-aware answers without any setup.

**Structured help.** The two `.prompt.md` files below are GitHub Copilot Chat reusable prompts (front-matter `mode: ask`) — in VS Code with Copilot Chat, invoke them by name from the Chat prompt picker, or open the file and copy its templated content into any Copilot CLI session.

- [Prompt: debug a stuck step](.github/prompts/debug-step.prompt.md) — paste your error, get a diagnosis
- [Prompt: inspect Squad artifacts](.github/prompts/inspect-squad-artifacts.prompt.md) — honest evaluation of your `.squad/` files after Module 2
- [docs/troubleshooting.md](docs/troubleshooting.md) — known failure patterns with exact fixes

---

## Contributing

Spotted a broken step? Tool version changed? Want to propose a new module?

See [CONTRIBUTING.md](CONTRIBUTING.md) or [open an issue](https://github.com/joslat/squad-workshop/issues/new/choose).

---

## License

This workshop is licensed under the [Apache License 2.0](LICENSE).  
Copyright © 2026 joslat
