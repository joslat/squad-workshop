# 🎁 Module 4 — Bonus: Where Squad Goes Next

> Six modular topics for after you finish the mainline workshop. Pick what applies — none of this builds on anything else. Closer to a reference guide than a tutorial.

← Back to [Workshop Index](../README.md) · [← Module 3](03-advanced.md)

---

## At a glance

**⏱️ Pick-and-choose** · each section stands alone; read the one you need.

| # | Topic | When you'd want it | ⏱️ |
|---|---|---|---|
| B1 | [Working with other humans on the same Squad](#b1--working-with-other-humans-on-the-same-squad) | You want to bring Squad to your team | ~15 min read |
| B2 | [Squad meets the rest of your stack (MCP)](#b2--squad-meets-the-rest-of-your-stack-mcp) | You want agents to reach Teams / ADO / a database | ~10 min read |
| B3 | [Notifications via Teams](#b3--notifications-via-teams) | You want Ralph to post status to a channel | ~10 min read |
| B4 | [Scale beyond your laptop (always-on Ralph)](#b4--scale-beyond-your-laptop-always-on-ralph) | You want Ralph running without your machine on | ~10 min read |
| B5 | [Cross-machine coordination](#b5--cross-machine-coordination) | You work from a laptop *and* a DevBox/VM | ~10 min read |
| B6 | [Choosing what to keep on real work](#b6--choosing-what-to-keep-on-real-work) | You finished and want a decision framework | ~5 min read |

> **None of this is on the mainline.** Modules 1–2 are the workshop. Module 3 is the optional tour. This is the appendix — breadth, not depth. Everything here was checked against the shipped `@bradygaster/squad-cli` (v0.11.0); where a command or path is fragile or a pattern is a published *specification* rather than turnkey behavior, the section says so plainly. (The workshop is pinned to 0.11.0; later releases should be largely compatible, but the appendix hasn't been re-validated end-to-end against them.)

---

## B1 — Working with other humans on the same Squad

Squad's state lives in `.squad/` in your repo. The implication: two people sharing a repo share the same Squad — by design, because repo-native memory is the whole point. But it's worth knowing the failure modes before you onboard your team.

### What works out of the box

- **Memory survives across people.** Every `copilot --agent squad` session reads `.squad/decisions.md` and `.squad/agents/<name>/history.md`. A decision your colleague recorded yesterday is in your session today.
- **Concurrent edits merge as appends, not conflicts.** `squad init` writes a `.gitattributes` that puts Git's built-in **union merge** strategy on the append-only team-state files:

  ```gitattributes
  # Squad: union merge for append-only team state files
  .squad/decisions.md merge=union
  .squad/agents/*/history.md merge=union
  .squad/log/** merge=union
  .squad/orchestration-log/** merge=union
  ```

  So two branches both appending to `decisions.md` merge cleanly instead of conflicting. (This is the `merge=union` *strategy* — no custom merge driver to install, nothing to set up in `.gitconfig`.)
- **The roster is shared.** `team.md` and `routing.md` are committed to the repo; everyone sees the same cast and the same routing rules.

### What doesn't work out of the box

- **Sessions don't see each other live.** If you and a colleague both run `copilot --agent squad` at the same time, you each get a separate session. Coordination happens through Git and through issue/PR comments — there's no shared cursor.
- **Conflicting decisions are possible.** Two people independently asking "Lead, decide SQLite vs Postgres" can record two different decisions. Union merge keeps *both* — *resolving* the contradiction is human work.
- **Routing can drift.** If two people customize `routing.md` independently, you get a Git merge to resolve before pushing.

### Adding humans to the roster

Humans are first-class roster members. From a Copilot session:

```
Add Sarah Johnson as Product Owner. Contact: sarah@company.com.
```

The coordinator follows its built-in *Human Team Members* rules and appends a row to the `## Members` table in `.squad/team.md`:

```markdown
| Name          | Role           | Charter | Status    |
|---------------|----------------|---------|-----------|
| Sarah Johnson | Product Owner  | —       | 👤 Human  |
```

A human member gets a **👤 Human** badge, their real name (no casting), and **no charter or history files**. The key behavioral difference from an agent: **humans are not spawnable.** An agent will never autonomously hand work to a human and march on as if it's done — instead the coordinator *presents* the work and **waits for you to relay the human's input**. Non-dependent work keeps flowing in parallel so a human block doesn't stall the team, and after more than one turn the coordinator surfaces a nudge like:

```
📌 Still waiting on Sarah Johnson for the pricing-model sign-off.
```

Multiple humans are supported and tracked independently, and if a human acting as reviewer rejects a change, the normal reviewer-rejection lockout applies.

> **Honest caveat (verified against the binary):** the human-member behavior is driven entirely by rules baked into the shipped `squad.agent.md`. The agent prompt points to an on-demand reference at `.squad/templates/human-members.md`, but **that file is not shipped** in the current package, and there is no dedicated "add a human" skill. So the behavior is real and reliable; the deeper reference the prompt mentions simply isn't there to read.

### Rules of thumb for team adoption

1. **Branch-protect `main`.** Push routing/decision changes via PR; let one person — the de-facto Squad steward — approve.
2. **One Scribe per repo, not per person.** The Scribe is the merge authority for memory. Don't have everyone spawn their own.
3. **Treat `.squad/` like code.** Review changes to `routing.md` and `team.md` as carefully as a CI config.
4. **For two people *splitting* work, use GitHub Issues + Ralph triage** (Module 3), not the cross-machine queue (B5) — that's for one person on multiple machines.

> **Honest tradeoff.** The team story is *possible* but under-documented upstream — expect to invent a few conventions for the first couple of weeks. Past ~5 people on one repo, designate a Squad steward who owns `routing.md` and `decisions.md` review.

---

## B2 — Squad meets the rest of your stack (MCP)

Model Context Protocol (MCP) is how an agent reaches systems outside your repo. Without it, an agent reads/writes files and runs shell commands. With MCP servers configured, it can read Azure DevOps work items, post to Teams, search Outlook, drive a browser with Playwright, or query a database.

### Squad doesn't own MCP — the Copilot CLI does

This is the part most write-ups get wrong: **Squad scaffolds no MCP config of its own.** `squad init` ships a docs file (`.squad/templates/mcp-config.md`) and a few skills that *consume* GitHub MCP tools (with a `gh` CLI fallback) — but it generates no JSON and starts no servers. MCP servers are configured in the **Copilot CLI's** own config, and Squad's agents inherit whatever you set there.

### Where the config actually lives

As of Squad 0.11.0 and the current `copilot` CLI, MCP servers can be configured in three places — know all three rather than assuming there's only one:

```
.mcp.json                           # project root — canonical per-project MCP config in 0.11.0; commit it to share with your team
.copilot/mcp-config.json            # project-level — may STILL be emitted for backward compatibility; the CLI continues to read it
$HOME/.copilot/mcp-config.json      # personal/global — your machine-wide servers (overridable via the COPILOT_HOME env var)
```

Project-root `.mcp.json` is the canonical location to add per-project servers in 0.11.0; the older `.copilot/mcp-config.json` may still be written out for compatibility; and `$HOME/.copilot/mcp-config.json` remains the personal, machine-wide location. You can also add a server interactively from a Copilot session with `/mcp add`.

> **Correction to older notes:** there is **no `.vscode/mcp.json`** for the standalone CLI — that path is VS Code's MCP convention, not the CLI's. (The Copilot CLI does read a per-project file for *LSP* at `.github/lsp.json`, but not for MCP.)

### A correct server entry

The config is a top-level `mcpServers` map. On the current schema each server needs a **`tools`** array (`["*"]` = expose all tools); local servers use `command`/`args`/optional `env`, and remote servers use `type: "http"` (or `"sse"`) with a `url`:

```json
{
  "mcpServers": {
    "trello": {
      "type": "local",
      "command": "npx",
      "args": ["-y", "@trello/mcp-server"],
      "tools": ["*"],
      "env": {
        "TRELLO_API_KEY": "${TRELLO_API_KEY}",
        "TRELLO_TOKEN": "${TRELLO_TOKEN}"
      }
    }
  }
}
```

The bare `{ command, args, env }` shape you'll see in older examples still parses, but it omits the now-expected `tools` field and can end up exposing no tools — prefer the form above.

### When MCP starts to matter

- Your work tracking is in Azure DevOps or Linear, not GitHub Issues (Ralph polls GitHub by default; MCP gives him a way to reach the others).
- You want agents to post status to Teams or Slack (see B3 for the Teams specifics).
- You want screenshot-driven UI review (Playwright MCP).

If you finished the workshop and never touch MCP, that's fine — the Reading List app didn't need it.

**Learn more:** the [MCP server registry](https://github.com/modelcontextprotocol) · Tamir Dresher's deeper [MCP integration writeup](https://github.com/tamirdresher/squad-skills) (snapshot — pin to a commit, it targets an older Squad).

---

## B3 — Notifications via Teams

If you want Ralph to *announce* — "triaged 3 issues, here are the labels" — there are two ways to wire it up. The practical one, and the one Tamir Dresher's workshop teaches, is the webhook wrapper.

### The wrapper path (recommended — Tamir's `ralph-watch.ps1`)

The simplest path is a Power Automate "Workflows" incoming webhook that the **`ralph-watch.ps1` wrapper** — the "Ralph, Go!" pattern from [Module 3 Step 11h](03-advanced.md) — reads and posts to. Save the webhook URL to `~/.squad/teams-webhook.url`, and the wrapper handles the rest each round:

```powershell
# In Teams: create a Power Automate "Workflows" incoming webhook, copy the URL.
# (Classic O365 "Incoming Webhook" connectors are being retired — use Workflows.)
"https://....webhook.office.com/..." | Set-Content -Path "$HOME/.squad/teams-webhook.url"
```

The wrapper reads that file and posts after each triage round:

```powershell
# Inside ralph-watch.ps1, after a round:
$webhook = Get-Content "$HOME/.squad/teams-webhook.url" -Raw
$body = @{ text = "Ralph triaged 3 issues this round." } | ConvertTo-Json
Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType 'application/json'
```

> **Run Ralph through the wrapper to get the posts** — `~/.squad/teams-webhook.url` is the wrapper's mechanism (Step 11h), so the alerts fire when you run `ralph-watch.ps1`. That's how Tamir runs his.

### The built-in path (`teams-graph` OAuth)

For teams that want OAuth instead of a webhook, Squad also ships a Microsoft Graph–based integration: the `teams-graph` channel (a `TeamsCommunicationAdapter` against `login.microsoftonline.com` / `https://graph.microsoft.com/v1.0`, tokens cached at `$HOME/.squad/teams-tokens-<hash>.json`), with topic-to-channel routing handled by the shipped **`notification-routing`** skill via `.squad/teams-channels.json`. There's also a `--monitor-teams` watch capability, but it runs the *other* direction — it reads Teams messages (via WorkIQ MCP) and files them as GitHub issues labelled `teams-bridge`. The OAuth path is enterprise-grade (Entra app registration + consent): worth it for a real team channel, overkill for a solo experiment.

### Tradeoff

This is opt-in noise generation. Most workshop runs don't need it. Add it only when you have a real audience — an oncall channel, a daily standup. Otherwise Ralph just clutters Teams.

---

## B4 — Scale beyond your laptop (always-on Ralph)

If you're committed to running Ralph around the clock, three options ranked by cost-to-effort:

| Option | Cost | Effort | When |
|---|---|---|---|
| GitHub Actions cron (below) | Free for public repos; 2,000 min/mo free for private | Minimal — one YAML file | Default — start here |
| Local desktop + PowerToys Awake | Free | Low — keep a machine on | You already have an always-on desktop |
| Azure DevBox | ~$0.25/hr (~$180/mo for 24/7) | Medium — provision, install, keep awake | You need an isolated/remote env anyway |

### The corrected GitHub Actions workflow (no `--once`)

You may have seen a "heartbeat" workflow that runs `squad watch --once --output-format json`. **Neither flag exists** — verified against the binary. `squad watch` and `squad triage` are the same command, and it accepts `--interval`, `--execute`, `--timeout`, `--max-concurrent`, `--log-file`, capability flags, and more — but **no single-pass flag** and **no JSON output mode**. Worse: `squad watch` runs its first round *immediately* and then enters a poll loop that **only exits on Ctrl-C (SIGINT/SIGTERM)**. So `squad watch --once` in CI would ignore the unknown flag and then run *forever*, pinning the runner until its hard timeout.

The fix uses the one useful fact about that behavior — **the first round runs immediately** — and bounds the process so it's killed right after that round. Let the cron *be* the interval; let `timeout` end the single invocation:

```yaml
# .github/workflows/ralph-heartbeat.yml
name: Ralph Heartbeat (bounded triage)
on:
  schedule:
    - cron: '*/10 * * * *'   # the cron IS the interval — every 10 minutes
  workflow_dispatch: {}

permissions:
  contents: read
  issues: write
  pull-requests: write

jobs:
  triage:
    runs-on: ubuntu-latest
    timeout-minutes: 8          # hard backstop so a hung process can't pin a runner
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
      - name: Authenticate gh
        run: echo "${{ secrets.GITHUB_TOKEN }}" | gh auth login --with-token
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: Run ONE bounded triage round
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          # 'timeout' sends SIGTERM, which watch's shutdown handler honors and exits
          # cleanly. --interval 60 keeps the in-process timer from firing a 2nd round
          # before we stop it; the immediate first round is all we want.
          # Exit code 124 means "timed out as designed" — treat it as success.
          timeout --signal=TERM 6m \
            npx -y @bradygaster/squad-cli@latest watch \
              --interval 60 --execute --max-concurrent 1 --timeout 5 \
              --log-file heartbeat.log \
          || [ $? -eq 124 ]
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: heartbeat-log
          path: heartbeat.log
```

Why it's correct: the first triage round runs on launch, `timeout --signal=TERM 6m` kills the otherwise-immortal process after it, `|| [ $? -eq 124 ]` swallows the expected timeout exit so the job goes green, and `timeout-minutes: 8` is the safety net. **Drop `--execute`** for scan-only (Ralph labels and comments, writes no code) — start there for a week and only add `--execute` once the labels are consistently right.

### Local always-on

Run `squad watch` (or `squad loop`) in a terminal and keep the machine from sleeping with **Windows PowerToys Awake** (*Settings → Awake → keep awake indefinitely*). Zero cost if you already leave a machine on.

### Azure DevBox

Worth it when you *also* want a remote dev environment. Provision a DevBox, RDP in, `npm install -g @bradygaster/squad-cli`, `gh auth login`, start Ralph, and keep it awake (PowerToys Awake). Tamir's workshop quotes ~$0.25/hr (~$180/mo for 24/7). If your *only* reason is always-on Ralph, the Actions cron above does the same job for free.

---

## B5 — Cross-machine coordination

This is for one **person** working from a laptop **and** a DevBox/VM who wants work and results to flow between them automatically. (For two *people* sharing one Squad, that's B1.)

There are two distinct mechanisms here, and they're at different maturity levels — be honest with yourself about which you're using.

### The implemented path: shared team state with `squad link`

If you want several machines to share **one** team's memory, you don't need a queue — you point each machine's project at a common team root. `squad link <team-repo-path>` (or `squad init --mode remote <team-repo-path>`) writes a machine-local `.squad/config.json`:

```json
{
  "version": 1,
  "teamRoot": "../shared-team",
  "projectKey": null
}
```

Squad's dual-root resolver then finds the team identity in `teamRoot` while you work in the project repo. `config.json` is added to `.gitignore` automatically — it holds machine-specific paths and must never be committed. This is real, implemented code (a remote-mode concept contributed upstream as PR #131).

> `squad rc` / `squad start` (the devtunnel-based "drive your Squad from your phone" remote control) also exist, but they're **deprecated** in the current CLI and slated for removal — don't build on them.

### The specified pattern: the cross-machine task queue

Squad ships a **`cross-machine-coordination` skill** (installed into `.github/skills/` by `squad init`) describing a Git-based task queue: a machine drops a YAML task file under `.squad/cross-machine/tasks/`, commits and pushes; Ralph on the target machine pulls it, validates it against a command whitelist, executes it, and writes a result under `.squad/cross-machine/results/`. A task file looks like:

```yaml
# .squad/cross-machine/tasks/2026-03-14T1530Z-laptop-gpu-001.yaml
id: gpu-voice-clone-001
source_machine: laptop
target_machine: devbox
priority: high
task_type: gpu_workload
payload:
  command: "python scripts/voice-clone.py --input voice.wav --output cloned.wav"
  expected_duration_min: 15
status: pending
```

Per-machine behavior is configured under a `cross_machine` key in `.squad/config.json` (`enabled`, `poll_interval_seconds`, `this_machine`, `command_whitelist`, `task_timeout_minutes`). For ad-hoc work, the same skill describes a GitHub-issue path: open an issue labelled `squad:machine-devbox` and Ralph on that machine claims it.

> ⚠️ **Status — read the skill's own header.** This skill is marked **"Specification (ready for implementation)"**, and its execution steps are written as *pseudo-code*. In plain terms: the **file formats, the queue layout, the config schema, and the security model are defined and shipped** as a design you can build on — but don't assume the watch loop executes the queue end-to-end with zero wiring. The watch capabilities that *are* implemented (triage, execute, decision-hygiene, retro, monitor-teams/email) do not include a turnkey cross-machine executor. Treat B5's queue as a documented, ship-blessed *pattern* — solid to build against, not a feature you flip on. The `squad link` shared-state path above, by contrast, is fully implemented today.

### Honest tradeoff

If you just want multiple machines to share memory, use `squad link` — it works now. The autonomous task queue is a real, well-specified design, but you'll be implementing (or at least verifying) the executor yourself. Try it on a non-critical repo first.

---

## B6 — Choosing what to keep on real work

You've finished the workshop. Now the only question that matters: do you introduce Squad to a real project? A short framework.

### Keep Squad if

- You consistently re-explain context to AI assistants across sessions.
- You work on more than one repo and would benefit from per-repo team memory.
- Your repo has architectural decisions worth recording (most do).
- You have a Copilot Pro+ plan or institutional budget (see [budget-and-models](../docs/budget-and-models.md)).

### Don't keep Squad if

- You're a contractor on someone else's repo and can't commit `.squad/`.
- Your work is mostly one-shot bug fixes on a stable codebase — Squad's value is coordination, not single tasks.
- Your tests are thin — Squad's review pass needs something to push against.
- The team's artifacts after [Module 2 Step 9](02-intermediate.md) read as AI confetti, not real work. Trust your own read of `decisions.md` and `wisdom.md`.

### What to do in the next two weeks

1. Pick one **real** repo (not the workshop one) and run `squad init`.
2. Use the team on one real feature — no smaller than a day of work.
3. After five days, inspect `.squad/` again with the rubric from Module 2 Step 9.
4. Decide. Either commit to Squad for that repo or remove `.squad/` and move on. **Don't half-adopt** — the value is in compounding memory, which requires consistent use.

Whether to keep Squad is now a judgement you can make with evidence instead of marketing. That's the whole point of the workshop.

---

## Beyond this workshop — what else Squad 0.11.0 can do

This workshop exercises the core loop: `init` · `doctor` · interactive `copilot --agent squad` sessions · `watch`/`loop` · `aspire` · `economy` · `@copilot`. Squad 0.11.0 ships a much larger surface you can explore on your own — run `squad --help` for the authoritative list. A quick map of what's out there:

| Area | Commands | What it's for |
|---|---|---|
| **Context hygiene** | `squad nap` | Compress / prune / archive `.squad/` state as it grows (`--deep`, `--dry-run`) |
| **Cost & orientation** | `squad cost`, `squad status` | Token-usage report from orchestration logs; show which squad is active and why |
| **Cross-squad orchestration** | `squad discover`, `delegate`, `registry`, `upstream` | Route work between independent squads across repos |
| **External state** | `squad externalize`, `internalize`, `link`, `init-remote` | Move `.squad/` state to an external root, or share one team across machines |
| **Personal / ambient squad** | `squad personal`, `consult`, `extract` | A private, project-independent squad that advises in read-only "ghost" mode |
| **Scaling & remote** | `squad subsquads`, `start`, `rc`, `copilot-bridge` | Multi-Codespace scaling and remote control (some remote-control paths are deprecated — see B5 above) |
| **SDK & backends** | `squad build`, `migrate`, `sync`, `init --sdk`, `--state-backend` | SDK-first (`squad.config.ts`) authoring and alternate state backends |
| **Portability** | `squad export`, `import`, `preset` (`list`/`apply`/`install <source>`), `roles`, `cast` / `hire` | Move teams between repos, apply or install curated presets (incl. shared ones from a GitHub URL or local path), seed base roles, add members |
| **Governed memory** | `squad memory`, `state-mcp`, `scrub-emails` | Class-based memory writes, an MCP state server, and PII scrubbing |

None of these are required for the workshop — but knowing they exist tells you how far Squad scales past a 3-hour intro. If you try three, make them `squad nap` (keep state lean), `squad cost` (see the spend), and `squad status` (know which squad you're in).

---

## Learn more

- [Squad documentation](https://bradygaster.github.io/squad/) — official guides and the command reference
- [Squad cookbook — recipes](https://bradygaster.github.io/squad/docs/cookbook/recipes) — loop and triage patterns
- [GitHub Copilot CLI docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli) — the authoritative source for MCP config (project-root `.mcp.json`, with `.copilot/mcp-config.json` and `$HOME/.copilot/mcp-config.json` still read for compatibility/global use)
- [tamirdresher/squad-skills](https://github.com/tamirdresher/squad-skills) — the companion workshop these topics draw on (pin to a commit; it targets an older Squad)
- [Open issues on bradygaster/squad](https://github.com/bradygaster/squad/issues) — current known bugs and feature proposals

---

← Back to [Workshop Index](../README.md) | ← [Module 3 — Advanced](03-advanced.md)
