# Module 3 — Advanced: Observe with Aspire, Then Hand the Wheel to Ralph

> Two optional capabilities — both worth knowing about, neither needed for daily work. The Aspire section was rough on at least one machine in the wild, so it's documented here honestly rather than glossed over. The Ralph section is your introduction to autonomous mode without giving up your Saturday.

← Back to [Workshop Index](../README.md) · [← Module 2 (Intermediate)](02-intermediate.md)

---

## At a glance

**⏱️ ~60 min** · two optional capabilities — observability, then autonomous mode.

| Step | What you do |
|---|---|
| 10 | Observe Squad with .NET Aspire (optional) |
| 11 | Try Ralph — watch mode (`squad watch`), safe in triage-only |
| 12 | Prompt-driven loops (`squad loop`) — optional |

---

## Prerequisites

- You completed [Module 1](01-basic.md) (module 2 strongly recommended) and have a working `reading-list-squad-lab/` repo with a populated `.squad/` directory.
- For step 10 (Aspire): **Docker Desktop installed and running** before you start. The single most common reason `squad aspire` "silently fails" is that Docker isn't running.
- For steps 11–12 (Ralph): a GitHub repo with `gh auth status` healthy, and a willingness to read what an autonomous agent does to your code.

> If you only have time for one of these, do **step 11 in triage-only mode** — it's the most useful and the lowest risk. Aspire is a "nice to know it exists" capability.

---

## Step 10: Observe it with .NET Aspire (optional)

Squad emits OpenTelemetry traces for agent spawns, model calls, token usage, and durations. `squad aspire` runs the .NET Aspire dashboard — *via Docker* — to render those traces in real time.

> **Important #1:** the Aspire dashboard is a **live telemetry collector** — it shows traces from active Squad sessions, not historical data. An empty dashboard means nothing is sending telemetry to it yet.
>
> **Important #2:** `squad aspire` runs the dashboard in a Docker container. If Docker is not running, the command will print a Docker error and *then* misleadingly say `✓ Aspire dashboard launching` before failing. This is a known gotcha — start Docker first.

### 10a. Start Docker Desktop and confirm it's healthy

```powershell
docker info | Select-String "Server Version"
```

You should see a `Server Version: <something>` line. If you get an error like `error during connect: ... open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.`, Docker Desktop is **not** running. Start it from the Start menu, wait for the whale icon to stop animating, and re-run the check.

If you don't have Docker Desktop:

```powershell
winget install Docker.DockerDesktop
```

Restart, sign in, and wait for it to be ready. Then come back to step 10b.

### 10b. Exit any active Copilot CLI session

Aspire works best when you start it *before* the Copilot CLI session that will produce the telemetry. If a session is running, stop it:

```
/quit
```

### 10c. Launch the Aspire dashboard

```powershell
squad aspire
```

**Expected output (Docker running):**

```
🔭 Squad Aspire — OpenTelemetry Dashboard

OTLP endpoint: http://localhost:4317
Starting Aspire dashboard via Docker...
[aspire] Container started: <id>
✓ Aspire dashboard launching
  Dashboard:  http://localhost:18888
  OTLP gRPC:  localhost:4317

Squad OTel will automatically export to this endpoint.
Press Ctrl+C to stop.
```

**If Docker is not running, you'll see this misleading output instead:**

```
[aspire] docker: error during connect: Head "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/_ping": ...
✓ Aspire dashboard launching
  Dashboard:  http://localhost:18888
  ...
```

The `✓` line is a lie when there's a Docker error above it. The dashboard will not actually be available at `http://localhost:18888`. Stop the command (`Ctrl+C`), start Docker, and try again.

Keep the Aspire terminal running and open the dashboard in your browser:

```
http://localhost:18888
```

It will be empty at first — that's expected. Telemetry shows up as soon as a Squad session runs.

### 10d. Start a new Copilot CLI session in a separate terminal

```powershell
copilot --agent squad
```

### 10e. Do some work and watch the dashboard populate

Give the team a small task so telemetry starts flowing:

```
Lead, give me a brief status summary of the project so far.
```

Now switch back to the Aspire dashboard. You should start seeing:

- Traces (one per agent spawn / model call)
- Token usage
- Time to first token (TTFT)
- Durations
- Tool calls inside each span

If the dashboard stays empty after the agent has obviously done work, the most likely causes are:

1. **Aspire wasn't actually running** (see the Docker note above — the `✓` line lies if Docker isn't up).
2. **Telemetry not auto-wired** — older Squad versions required manual `initSquadTelemetry()` calls. v0.9.0+ auto-wires it, so this is unlikely on 0.9.4 but possible on weird upgrades. Try `squad upgrade` and restart the session.
3. **Firewall** is blocking `localhost:4317`. Allow it once and move on.

### 10f. When done, exit both

Exit the Copilot CLI:

```
/quit
```

Then stop Aspire with `Ctrl+C` in its terminal. The Docker container will be cleaned up.

> If you're going to trust multi-agent coding, at least let it be observed instead of accepted on faith like a prophecy.

> **Try if interested** — pick one if curious:
> - **Compare traces between agents.** During a multi-agent task, open the dashboard and find which agent burned the most tokens. Does the Lead's review pass cost more than the Backend's implementation?
> - **Trace a tool call.** Find a shell or MCP tool call in the trace tree and read its arguments and result — what did the agent actually see?

---

## Step 11: Try Ralph — Watch Mode (optional, safe in triage-only)

Ralph is Squad's polling agent. He's the named persona for `squad watch` (also available as `squad triage`) — a daemon that polls **GitHub Issues**, builds a context snapshot, and either triages them (labels + comments) or dispatches a Copilot session to actually do the work.

### What Ralph reads — and what he doesn't

Ralph's queue is **GitHub Issues**, full stop. He does not:

- Read your `copilot --agent squad` chat history
- Scan code for `TODO` comments
- Invent work for himself
- Take instructions from `decisions.md` as work items

He *does* read team state (`decisions.md`, `routing.md`, agent histories) as **context** for the LLM that decides which issue to pick. But the queue is the issue tracker.

### 11a. Set up the labels Ralph expects

```powershell
gh label create squad --color "0E8A16" --description "Squad inbox — Lead will triage"
gh label create "squad:lead" --color "1D76DB"
gh label create "squad:backend" --color "1D76DB"
gh label create "squad:frontend" --color "1D76DB"
gh label create "squad:tester" --color "1D76DB"
```

> If a label already exists, `gh` will tell you and skip it. That's fine.

### 11b. File a real issue against the Reading List app

```powershell
gh issue create --title "Add a 'notes' field to books" `
  --body "Users should be able to add personal notes to each book in their reading list. Update the API model, validation, persistence, and UI form. Add tests." `
  --label squad
```

The `squad` label puts it in Ralph's inbox.

### 11c. Run Ralph in triage-only mode first

This is the safe one — Ralph polls, reads issues, applies `squad:{member}` labels, and comments triage notes. **No code is written.** Use it to verify routing works the way you expect *before* you let him execute.

```powershell
squad watch --interval 1
```

`--interval 1` polls every minute (default is 10). Watch the output — Ralph should pick up your issue, decide which member should own it, apply a `squad:{member}` label, and add a comment.

When you've seen what you needed:

```powershell
# In another terminal — clean shutdown:
New-Item -Path .squad\ralph-stop -ItemType File
```

Ralph finishes the current round and exits. Delete `ralph-stop` afterward so the next run isn't immediately blocked.

### 11d. Run Ralph with execution (fully autonomous)

Now the real thing — Ralph will spawn a Copilot session to actually work on issues he finds.

**Pre-flight:**

- Confirm `gh auth status` is green.
- Confirm `main` is protected on GitHub (Settings → Branches → require review). Ralph will push branches and open PRs; branch protection is your last safety net.
- Plan to walk away. Watch mode is meant to run while you're doing something else; sitting and staring at it defeats the point.
- Cap the cost: `--max-concurrent 1`, `--timeout 20`, and `--overnight-start/--overnight-end` if relevant.

**Run it:**

```powershell
squad watch --execute --interval 5 `
  --copilot-flags "--yolo --agent squad" `
  --max-concurrent 1 `
  --timeout 20 `
  --log-file .\ralph.log
```

> **Known limitation — specialists don't act like specialists in `--execute` mode** (upstream [issue #1081](https://github.com/bradygaster/squad/issues/1081), closed — routing behaviour is by design): When Ralph spawns a session for a `squad:bishop`-labeled issue, the spawned agent receives a **generic Ralph prompt**, not Bishop's actual charter. The `squad:{member}` label is used only as a routing filter — it is never injected into the spawn prompt as a role assignment. The spawned agent has no specialist knowledge of who it's supposed to be. For quality specialist work, use interactive `copilot --agent squad` sessions instead. `--execute` is most useful for small, well-defined tasks where specialist nuance doesn't matter much.

What happens each round:

1. Ralph polls GitHub for triage-eligible issues.
2. Builds a context snapshot (issue list + decisions + team state).
3. Writes the snapshot to a temp file.
4. Invokes `copilot -p <context-file>` with the flags you passed.
5. The agent picks an issue and works on it — code, tests, branch, PR.
6. Ralph monitors execution, updates issue labels/status, and logs everything to `ralph.log`.

If something fails, Ralph applies the **4-tier escalation**: circuit-breaker reset → auth reprobe → git pull → 30-min back-off. He won't spam the same failure endlessly.

### 11e. Monitor a running Ralph

```powershell
squad watch --health
```

Shows PID, uptime, last poll time, auth state, and which round he's on.

### 11f. Stop Ralph cleanly

```powershell
New-Item -Path .squad\ralph-stop -ItemType File
```

He finishes the current round and exits. `Ctrl+C` also works but may leave scratch directories around.

### 11g. Teams notifications (optional)

If your team uses Microsoft Teams, you can wire Ralph to send alerts when he hits consecutive failures (>3 rounds) or when a round completes. Create a file at `~/.squad/teams-webhook.url` containing an incoming webhook URL for your Teams channel:

```powershell
# Create the .squad directory if it doesn't exist:
$squadDir = Join-Path $env:USERPROFILE ".squad"
New-Item -ItemType Directory -Path $squadDir -Force | Out-Null

# Write your Teams incoming webhook URL:
"https://your-tenant.webhook.office.com/webhookb2/..." | Set-Content "$squadDir\teams-webhook.url"
```

To get a webhook URL: in Teams, go to your channel → **Manage channel** → **Connectors** → **Incoming Webhook** → **Configure**. Copy the URL and paste it above.

Ralph reads this file at startup. No code changes needed — if the file exists and is non-empty, Teams alerts are enabled automatically.

### 11h. "Ralph, Go!" — running Ralph with a custom prompt script

The built-in `squad watch --execute` is a solid starting point, but for real-project use you may want more control: structured prompts, Teams heartbeats, PowerShell 7+ enforcement, and lockfile-based deduplication. The community pattern for this is a PowerShell script that wraps the Copilot CLI directly — sometimes called the **"Ralph, Go!"** pattern after the prompt it sends.

A minimal version looks like this:

```powershell
# ralph-watch.ps1 — minimal example
# Require PowerShell 7+
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "ERROR: Requires pwsh (PowerShell 7+). Launch with: pwsh ralph-watch.ps1"
    exit 1
}

$prompt = @'
Ralph, Go! Read .squad/ralph-instructions.md for your full instructions.
Follow ALL sections there. MAXIMIZE PARALLELISM — spawn agents for ALL
actionable issues simultaneously.
'@

while ($true) {
    $start = Get-Date
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Ralph round starting..."
    copilot -p "$prompt" --agent squad --yolo
    $elapsed = ((Get-Date) - $start).TotalSeconds
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Round complete in $([math]::Round($elapsed))s. Waiting 5 min..."
    Start-Sleep -Seconds 300
}
```

Place it at the repo root and run with `pwsh ralph-watch.ps1`. Stop with `Ctrl+C` or create `.squad/ralph-stop`.

> **Why not just `squad watch --execute`?** You can and should start there. The custom script pattern makes sense once you want: a structured multi-section prompt (`.squad/ralph-instructions.md`), Teams failure alerts, heartbeat files for a monitoring dashboard, or different intervals per repo. Copy the script and adapt it. Don't start here — graduate to it.

> **Honest tradeoff:** Ralph is most useful when you have a backlog of small, well-scoped issues that you'd file anyway. He's least useful — and most expensive — when issues are vague, when the repo doesn't have a strong test suite to give him a "did it work?" signal, or when you sit and watch him work. If you find yourself watching, you should be running `copilot --agent squad` instead.

> **Try if interested** — pick one if curious:
> - **Read `ralph.log` line by line.** For one round, can you reconstruct exactly which issue Ralph picked, why, and what he did? Where would you have decided differently?
> - **Mislabel an issue on purpose.** Apply `squad:frontend` to a backend task and watch how Ralph routes it. Does the label filter help, or get in the way?

---

## Step 12: Prompt-driven loops (`squad loop`) — optional

`squad loop` is a different beast: instead of polling issues, it reads a single prompt file (`./loop.md`) and runs that instruction every N minutes. Useful for **standing housekeeping jobs** — docs hygiene, dependency updates, lint sweeps — that you want done on a schedule, no issue tracker required.

> **Important:** `squad loop` is fire-and-forget — there is no chat. The terminal shows status logs only; you cannot type at it. To change Ralph's instructions, edit `./loop.md`. He re-reads it at the start of every cycle, so edits take effect on the next round automatically.

### 12a. Generate the boilerplate

```powershell
squad loop --init
```

This creates `./loop.md` with placeholders.

### 12b. Write a narrow, idempotent loop instruction

Open `./loop.md` and replace the placeholder with something specific:

```markdown
# Loop: Test coverage hygiene

Every cycle:

1. Run the test suite (`dotnet test` and `npm test`) and capture failures.
2. If any test is failing, open an issue titled "test: <test name> failing" with the failure output. Do not attempt to fix it.
3. If all tests pass and any source file under `backend/` lacks a corresponding test file, draft tests and open a PR titled "test: cover <file>".
4. Do nothing else. Do not refactor. Do not touch unrelated files.
```

Two rules of thumb the hard way:

- **Idempotent.** "Open an issue if X is missing" is good. "Improve the codebase" is a credit-card incident.
- **Narrow.** A loop that's allowed to do five things will eventually find a sixth.

### 12c. Run it on a sane schedule

```powershell
squad loop --interval 60 --timeout 15
```

Hourly tick, each round capped at 15 minutes. If the round needs more than 15 minutes once to do its job, the loop instruction is too broad — split it.

### 12d. Understanding interval vs. timeout

- `--interval N` — minimum gap between round *starts*, not a hard kill. If a round overruns, the next tick is skipped and Ralph waits.
- `--timeout N` — hard ceiling per spawned agent execution (default 30 min). When this elapses the agent process is killed; partial work that was already committed stays committed; nothing else is rolled back.
- `--max-concurrent N` (default 1) — how many rounds can overlap. With the default, rounds are strictly serial.
- **No checkpoint/resume across timeouts.** If a round dies mid-task, the next round starts fresh from `loop.md`. That's why idempotent prompts matter.

### 12e. Stop a loop

Same as triage:

```powershell
New-Item -Path .squad\ralph-stop -ItemType File
```

---

## Honest tradeoffs and when to walk away

A short, opinionated checklist before you commit Ralph to anything that matters:

| You should... | If... |
|---|---|
| Use `squad watch --execute` | You have a real issue backlog of small, well-scoped tickets, branch protection on `main`, and a CI pipeline that catches the obvious mistakes. |
| Use `squad watch` (no execute) | You want to see how Ralph routes work before letting him write code. Always start here. |
| Use `squad loop` | You have a recurring hygiene task that's idempotent and narrow. |
| Walk away | Issues are vague, tests are thin, you're sitting and watching, or you can't articulate what "done" looks like for a round. |

The fastest way to lose money with Squad is to point Ralph at a vague issue tracker on a repo with no tests and let him execute overnight. The fastest way to *gain* something is to use the team interactively (modules 1 and 2) until you have a real intuition for what they do well, then introduce Ralph for the narrow class of work where polling helps.

---

## You're done

You've now seen Squad's three modes:

- **Interactive** (modules 1 and 2) — you drive, the team helps. Where the value lives.
- **Observed** (step 10) — same as interactive, with telemetry. Optional but reassuring.
- **Autonomous** (steps 11–12) — Ralph polls and acts. Useful for narrow problems, expensive for broad ones.

Whether to keep Squad on a real project is now a judgement call you can make with evidence instead of marketing. That's the whole point of the workshop.

---

## Learn more

- [Build autonomous agents with Squad](https://bradygaster.github.io/squad/docs/guide/build-autonomous-agent) — deep dive into Ralph's architecture and configuration
- [Building resilient agents](https://bradygaster.github.io/squad/docs/guide/building-resilient-agents) — patterns for agents that handle failure gracefully
- [Squad cookbook — recipes](https://bradygaster.github.io/squad/docs/cookbook/recipes) — practical patterns for loop instructions and triage workflows
- [Open issues on bradygaster/squad](https://github.com/bradygaster/squad/issues) — current known bugs and feature proposals

---

← Back to [Workshop Index](../README.md) | ← [Module 2 — Intermediate](02-intermediate.md)
