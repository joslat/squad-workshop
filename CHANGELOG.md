# Changelog

All notable changes to this workshop will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- AI coaching infrastructure: `.github/agents/squad-coach.agent.md` (invokable with `copilot --agent squad-coach`), `.github/prompts/debug-step.prompt.md`, `.github/prompts/inspect-squad-artifacts.prompt.md`
- `scripts/Install-WorkshopAgents.ps1` — installs the coach agent and prompt files into the lab repo's `.github/` so Copilot CLI can discover them; refuses to overwrite without `-Force`
- `.github/copilot-instructions.md` — always-on Squad context injected into every VS Code Copilot Chat session in this repo
- `.github/workflows/verify-script.yml` — CI parse + PSScriptAnalyzer for every PowerShell script on PR/push
- `scripts/PSScriptAnalyzerSettings.psd1` — keeps user-facing Write-Host warnings out of CI; failing rules remain blocking
- `README.md`: "Getting help" section with coach agent invocation and structured help links; targeted-version notice; "About the prompts" explainer; `verify-script.yml` badge
- `CONTRIBUTING.md`: contribution license clause and version maintenance checklist
- `modules/01-basic.md`, `modules/02-intermediate.md`, `modules/03-advanced.md`: "Learn more" sections with links to official Squad docs
- `modules/01-basic.md`: Step 0d "Run squad to start" override callout, Step 0f forward-drift callout, optional install-coach callout, private-repo alternative note
- `docs/troubleshooting.md`: six new sections covering upstream bugs — `ERR_MODULE_NOT_FOUND` on Windows, silent coordinator drop, post-`squad init` false-positive git modifications, `--execute` specialist limitation, rate limiting, and `squad upgrade` overwrite
- `modules/03-advanced.md`: explicit warning about `squad triage --execute` specialist charter limitation (upstream issue #1081)
- `.gitignore`: Squad runtime artifacts (`.squad/ralph-stop`, `ralph.log`, `*.ralph.log`) — documents the pattern for downstream Squad users
- Navigation footers on all three modules
- `README.md`: **Acknowledgements** section crediting Brady Gaster (creator of the Squad CLI) and Tamir Dresher (Squad co-creator; author of `tamirdresher/squad-skills`)
- `docs/maintainers/01 EarlierWorkshopReviewAnd-Implementation-Plan.md`: §0 Reassessment (2026-05-30) — challenges the doc's status, reverses its command-name premise to `squad watch`, and corrects the `--once` / `loop.md` / Teams-path / `gh copilot` assumptions against live Squad source
- `docs/maintainers/02 Post-PR1-Verification-and-Fixes.md`: per-item verification of PR #1 (each claim cited to `bradygaster/squad` source) plus a repo-wide fix inventory
- **Tier 1 adoption from `squad-skills`** (per `docs/maintainers/01` §0.8): new `docs/cheat-sheet.md` (prompt patterns + verified current CLI commands), per-module **"At a glance"** maps with ⏱️ time estimates on all three modules, and two optional **"Try if interested"** side-quests in Module 3. Cheat sheet linked from the README "Structured help" list.
- **Tier 2a adoption (team extensions):** Module 2 **Step 9.5 — "Skills"** (inspects the skills `squad init` already installs in `.copilot/skills/`, then tests whether one changes behavior; no dependency on external repos) and Module 3 **Step 11.6 — "Add @copilot to your team"** (`squad copilot --auto-assign`, the bounded-autonomy alternative to Ralph `--execute`). Commands verified against Squad CLI v0.9.4 + dev source.
- **Tier 2b adoption (models & budget):** new `docs/budget-and-models.md` — per-agent model tiers via `squad config model` (writes `.squad/config.json`), the model-resolution order, a sensible tier mix, and a rough premium-request budget (closes the W-012 budget gap). Linked from the README and Module 1's model-selection step.
- `docs/maintainers/03 Workshop-Review-and-Analysis.md` — full 5-lens pedagogical + technical review of the workshop (strong points, prioritized findings R-01…R-27, action plan); every CLI claim verified against `@bradygaster/squad-cli@0.9.4`.
- **`modules/04-bonus.md` — Bonus appendix (Tier 3 adoption).** Six pick-and-choose topics: B1 team/multi-person Squad (the `.gitattributes` `merge=union` setup, human roster members, not-spawnable handling), B2 MCP (`$HOME/.copilot/mcp-config.json` — corrected: no `.vscode/mcp.json` for the standalone CLI; `tools` field required), B3 Teams notifications (the real `teams-graph` OAuth adapter + `notification-routing` skill, with the `teams-webhook.url` path correctly attributed to Tamir's `ralph-watch.ps1` wrapper, not `squad watch`), B4 always-on Ralph (a **corrected** GitHub Actions workflow — the phantom `squad watch --once` replaced by cron-as-interval + `timeout --signal=TERM`), B5 cross-machine (the shipped `cross-machine-coordination` skill, honestly labelled a "Specification", plus `squad link` for shared team state), and B6 a keep-it-or-not decision framework. Every command/path verified against the v0.9.4 binary. Linked from the README modules table (4th row) and a Module 3 "go further" pointer.

### Changed
- **Reorganized `docs/` by audience.** Learner-facing docs (`prerequisites`, `troubleshooting`, `cheat-sheet`, `budget-and-models`) stay at `docs/` root; the planning / review / maintenance docs moved to **`docs/maintainers/`**. The older `docs/done/` audits and the stale `SQUAD-WORKSHOP-STANDALONE-PLAN.md` (.NET 9 / Apache-2.0 — superseded, review item R-19) were removed. `check-links` CI scoped to the learner-facing surface (review item R-22).
- **Cross-platform (PowerShell 7).** Reframed the workshop as PowerShell 7-based (runs on Windows/macOS/Linux), not Windows-only. `docs/prerequisites.md` now lists install commands for all three OSes per tool (`winget` / `brew` / `apt`+official feeds), verified against official docs. `README` reframed + a note that macOS/Linux users use `/` paths and `$HOME`. `scripts/Verify-Prerequisites.ps1` detects the OS (shows OS-appropriate install hints; skips the Windows-only execution-policy check on macOS/Linux). `scripts/Install-WorkshopAgents.ps1` switched to `/` separators so it runs under `pwsh` on every OS. No duplicate bash scripts — one PowerShell codebase. (Squad CLI and the Copilot CLI npm route both need Node ≥ 22.5 — already the workshop's floor.)
- **Upgraded from .NET 9 (STS, EOL May 2026) to .NET 10 LTS** (supported through November 2028) — all module prompts, prerequisite tables, and `scripts/Verify-Prerequisites.ps1` updated
- `README.md`: removed redundant "Module summaries" prose section (the table + scope-note already cover the same information)
- `docs/troubleshooting.md`: renamed `squad watch --execute` heading to `squad triage --execute` (formerly `squad watch`) — body now uses the modern name, with a single parenthetical alias for search discoverability
- **Relicensed Apache-2.0 → MIT** (`LICENSE`, `README.md` badge + License section, `CONTRIBUTING.md`) — aligns with the MIT-licensed `tamirdresher/squad-skills` and simplifies external contribution ahead of accepting PR #1
- **Command-name direction reversed → adopting `squad watch` as the primary name** (per the authoritative PR [#1](https://github.com/joslat/squad-workshop/pull/1) from Squad co-creator Tamir Dresher). This supersedes the `squad watch → squad triage` change two bullets above — both names route to the same command, but `watch` is the original/native one and the only one that accepts `--health`. Repo-wide sweep tracked in `docs/maintainers/02 Post-PR1-Verification-and-Fixes.md`.
- `CONTRIBUTING.md`: fixed broken `../LICENSE` link → `LICENSE`

### Fixed
- `.github/ISSUE_TEMPLATE/config.yml`, `CONTRIBUTING.md`: replaced 404 URL `https://github.com/bradygaster/squad-cli` with the real source repo `https://github.com/bradygaster/squad` (the npm package is `@bradygaster/squad-cli`; the GitHub repo is `bradygaster/squad`)
- `README.md`: documented coach-agent install flow — agents in this repo are not discoverable from the lab repo's working directory unless copied in (now handled by `scripts/Install-WorkshopAgents.ps1`)
- `modules/01-basic.md`: replaced `vXX.XX.X` placeholder in `squad doctor` expected-output with a real example version and an annotation that the line varies per install
- `scripts/Verify-Prerequisites.ps1`: removed unused `$results` variable; flipped a `$null` equality comparison to put `$null` on the left (PSScriptAnalyzer recommendation)
- `README.md`: Module 3 row in the Modules table no longer lists "watch mode" (an alias of `squad triage`) as a separate item — now reads "`squad triage` (polling and `--execute`), plus prompt-driven `squad loop`"
- `modules/01-basic.md`: fixed step ordering — README creation now happens before `gh repo create` (was attempting to push an empty repo in the original 0b step)
- `modules/01-basic.md`: fixed `git push -u origin master` — replaced with `gh repo create --push` which uses the current branch name automatically, avoiding the `master`/`main` mismatch
- `modules/01-basic.md`: fixed `..\scripts\Verify-Prerequisites.ps1` path (wrong when run from repo root — correct path is `.\scripts\Verify-Prerequisites.ps1`)
- `docs/prerequisites.md`: fixed `../scripts/Verify-Prerequisites.ps1` path in opening callout (same issue — now `.\scripts\...`)
- `docs/prerequisites.md`: fixed mixed .NET version numbers — summary table showed `9.0.0` while body example showed `10.0.102`, now consistently `10.x.x`
- `modules/02-intermediate.md`: fixed `squad status` → `squad doctor` (`squad status` is undocumented in workshop context; `squad doctor` covers both active-squad confirmation and health checks)
- **Completed the `squad triage` → `squad watch` sweep** across the active workshop (the spots PR #1 left): `modules/03-advanced.md` (`--interval`, `--health`, walk-away table), `.github/copilot-instructions.md`, `.github/agents/squad-coach.agent.md` — alias phrasing standardized to "`squad watch` (alias: `squad triage`)". Fixes a latent bug: `--health` is only handled for `watch`, so `squad triage --health` was a no-op.
- **Completed `.squad/loop.md` → `./loop.md`** (repo root) in `.github/copilot-instructions.md` + `.github/agents/squad-coach.agent.md` (the 2 spots PR #1 missed); binary-verified (`loop.js`: `path.join(workTreeRoot, 'loop.md')`)
- `modules/03-advanced.md`: `gh copilot -p` → `copilot -p` at the round description (`:218`) and in the "Ralph, Go!" script — `gh copilot` (extension) has no `-p`/`--agent`/`--yolo`; Squad spawns the standalone `copilot`
- **`scripts/Verify-Prerequisites.ps1` — two front-door bugs** (found by the full workshop review, reproduced against real binaries): the **Copilot CLI** check false-FAILed valid installs (`copilot --version` is multi-line; `-match` on an array doesn't populate `$Matches`) — now joined to a scalar first; and the **`gh auth status`** check false-PASSed when logged out ("not logged **into**" matched the success substring "logged in") — now matches `'Logged in to'`. Same multi-line guard applied defensively to the `squad --version` check.
- **Workshop-review polish pass (R-11…R-25) + cross-platform sweep cleanup.** Closed the remaining review findings: forward-reference glosses (R-11 "Ralph", R-12 "charter", R-13 init-vs-cast dirs in Module 1), `squad copilot --auto-assign` added to **both** coach command tables (R-16), coach Step-11 framing → "Watch Mode" (R-17), cheat-sheet `squad init` no longer says "Cast" (R-18), Module 2 now points to `/inspect-squad-artifacts` (R-20), `.gitignore` ignores `loop.md` (R-21), doctor underline uses box-drawing `═` (R-23), cheat-sheet `--max-concurrent`/`--timeout` clarified (R-24), and the brittle `9 passed / 2 info` doctor counts now lead with "`0 failed, 0 warnings`" (R-25). Corrected two CLI claims against v0.9.4 source: Step 12d now states `squad loop` rounds are **serial** (`maxConcurrent` fixed at 1; `--max-concurrent` is a `squad watch` flag — R-15), and Step 10 notes `squad aspire` uses the .NET Aspire **workload** when present and falls back to Docker otherwise. Also finished the `\`→`/` sweep the earlier pass missed: `.github/prompts/*.prompt.md` (README-linked) and `.github/ISSUE_TEMPLATE/broken-step.yml`. (R-14/R-26/R-27 accepted as-is; **R-03** stays held with the Tamir-deferred items.)

### Pending verification — deferred to Tamir (trust vote; see `docs/maintainers/02 Post-PR1-Verification-and-Fixes.md`)
- Correct troubleshooting for upstream #1017 / #1062 / #1081 — verified fixed on `dev` / `v0.9.6-insider.3`, **not** in v0.9.4 stable (PR #1's "fixed in 0.9.4+" and "#1081 by design" are both inaccurate; v0.9.4 still pins the broken `@github/copilot-sdk ^0.1.32`)
- Reframe the Teams `~/.squad/teams-webhook.url` instructions (PR #1 Step 11g + `docs/maintainers/01` §B3): that path is read by **Tamir's `ralph-watch.ps1` wrapper**, not by the built-in `squad watch`; built-in Teams uses the `teams-graph` OAuth adapter + the `notification-routing` skill

### Deferred
- Premium-request budget guidance (W-012) — requires a measured end-to-end workshop run
- End-to-end clean-machine verification stamp (W-014) — requires a freshly-imaged Windows 11 box

---

## [1.0.0] — 2026-05-08

### Added
- Module 1 — Basic: build a .NET 10 + React reading list app with Squad end-to-end (~90 min)
- Module 2 — Intermediate: second-wave feature, memory compounding test, artifact inspection (~45 min)
- Module 3 — Advanced: .NET Aspire observability + Ralph autonomous triage/loop mode (~60 min)
- `docs/prerequisites.md` — full prerequisites reference with install commands for all 8 tools
- `docs/troubleshooting.md` — common failure patterns extracted from module inline callouts
- `scripts/Verify-Prerequisites.ps1` — standalone prereq checker with PASS/FAIL output and exit code
- GitHub issue templates: broken-step reporter and post-module feedback form
- Link-check CI workflow
