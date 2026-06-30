# Squad — Quick Reference Cheat Sheet

> A compact list of the most useful prompt patterns and CLI commands from this workshop. Print it, tape it, come back to it after the workshop. Commands verified against Squad CLI **v0.11.0**.

← Back to [Workshop Index](../README.md)

---

## Prompts you'll say to your team

| What you want | What to say |
|---|---|
| Hire the team | "I'm a solo developer building X. Use a lean team: Lead, Backend, Frontend, Tester, Scribe. Stack: Y. Set up the team now." |
| Plan before coding | "Before building anything, explore the repo, propose a folder structure, capture one architecture decision, and explain the implementation plan. No code yet." |
| Build a feature | "Build the first vertical slice: backend X, frontend Y, tests Z. Keep it minimal but production-clean." |
| Force a decision | "Lead, decide whether we should use A or B. Record the decision with rationale in `decisions.md`." |
| Run a code review | "Lead, review all changes as if this were a real PR. Be specific about what's good and what needs improvement." |
| Add edge-case tests | "Tester, look for edge cases we skipped. Add tests for them." |
| Capture a standing rule | "Always use X" / "Never do Y" — Squad promotes it to a decision automatically. |
| Get unstuck | Ask the coach: `copilot --agent squad-coach` (after `./scripts/Install-WorkshopAgents.ps1`). |

## CLI commands

| Command | What it does |
|---|---|
| `squad init` | Initialize the team in the current repo |
| `squad doctor` | Health-check `.squad/` structure, Node.js, `node:sqlite` |
| `copilot --agent squad` | Start an interactive Copilot CLI session with the Squad agent — the primary interface |
| `copilot --agent squad --yolo` | Same, auto-approving tool calls (`--yolo` = `--allow-all`) — for autopilot / scripted runs |
| `copilot --agent squad-coach` | Launch the workshop coach (install first with `Install-WorkshopAgents.ps1`) |
| `squad watch` | Run Ralph in polling mode — reads GitHub Issues, labels / triages (alias: `squad triage`) |
| `squad watch --interval N` | Poll every N minutes (default 10) |
| `squad watch --execute` | Let Ralph autonomously work issues — pair with `--max-concurrent 1 --timeout 20` (`--max-concurrent 1` is already the default; `--timeout 20` intentionally tightens the 30-min default) |
| `squad watch --health` | Show the watch instance status and exit |
| `squad loop --init` | Create a starter `./loop.md` at the repo root |
| `squad loop` | Run the `./loop.md` prompt on a schedule (fire-and-forget — no chat) |
| `squad aspire` | Launch the .NET Aspire OTLP dashboard (requires Docker running, or the .NET Aspire workload) |
| `squad config model` | Show / set the model for the team (writes `.squad/config.json`) — see [budget-and-models.md](budget-and-models.md) |
| `squad economy [on\|off]` | One-shot cost-saving toggle — biases the team toward cheaper models |
| `squad copilot` | Add GitHub's `@copilot` coding agent to the team |

> Stop Ralph cleanly: `New-Item -Path .squad/ralph-stop -ItemType File` (he exits after the current round); delete that file before the next run. `Ctrl+C` also stops the watch loop.

## Files you should know

| Path | What it holds |
|---|---|
| `.squad/team.md` | Team roster — add yourself as `👤 Human — Project Owner` |
| `.squad/decisions.md` | Merged architectural decisions (the team's memory) |
| `.squad/decisions/inbox/` | Draft decisions before the Scribe merges them (empty = expected) |
| `.squad/agents/{name}/history.md` | Per-agent working memory |
| `./loop.md` | The prompt `squad loop` runs each cycle — repo root, **not** `.squad/` |
| `.squad/ralph-stop` | Sentinel file that stops Ralph after the current round |
| `ralph.log` | Ralph's run log (when you pass `--log-file ./ralph.log`) |

---

← Back to [Workshop Index](../README.md)
