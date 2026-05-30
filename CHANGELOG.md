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
- `docs/done/REVIEW-AND-IMPROVEMENT-PLAN.md` — full audit of workshop vs. plan, bug register, and improvement roadmap
- `docs/done/UPSTREAM-SQUAD-INVESTIGATION.md` — assessed `bradygaster/squad` for learning resources, Ralph capabilities/limitations, and open issues affecting workshop learners
- `README.md`: "Getting help" section with coach agent invocation and structured help links; targeted-version notice; "About the prompts" explainer; `verify-script.yml` badge
- `CONTRIBUTING.md`: contribution license clause and version maintenance checklist
- `modules/01-basic.md`, `modules/02-intermediate.md`, `modules/03-advanced.md`: "Learn more" sections with links to official Squad docs
- `modules/01-basic.md`: Step 0d "Run squad to start" override callout, Step 0f forward-drift callout, optional install-coach callout, private-repo alternative note
- `docs/troubleshooting.md`: six new sections covering upstream bugs — `ERR_MODULE_NOT_FOUND` on Windows, silent coordinator drop, post-`squad init` false-positive git modifications, `--execute` specialist limitation, rate limiting, and `squad upgrade` overwrite
- `modules/03-advanced.md`: explicit warning about `squad triage --execute` specialist charter limitation (upstream issue #1081)
- `.gitignore`: Squad runtime artifacts (`.squad/ralph-stop`, `ralph.log`, `*.ralph.log`) — documents the pattern for downstream Squad users
- Navigation footers on all three modules
- `README.md`: **Acknowledgements** section crediting Brady Gaster (creator of the Squad CLI) and Tamir Dresher (Squad co-creator; author of `tamirdresher/squad-skills`)
- `docs/01 EarlierWorkshopReviewAnd-Implementation-Plan.md`: §0 Reassessment (2026-05-30) — challenges the doc's status, reverses its command-name premise to `squad watch`, and corrects the `--once` / `loop.md` / Teams-path / `gh copilot` assumptions against live Squad source
- `docs/02 Post-PR1-Verification-and-Fixes.md`: per-item verification of PR #1 (each claim cited to `bradygaster/squad` source) plus a repo-wide fix inventory
- **Tier 1 adoption from `squad-skills`** (per `docs/01` §0.8): new `docs/cheat-sheet.md` (prompt patterns + verified current CLI commands), per-module **"At a glance"** maps with ⏱️ time estimates on all three modules, and two optional **"Try if interested"** side-quests in Module 3. Cheat sheet linked from the README "Structured help" list.
- **Tier 2a adoption (team extensions):** Module 2 **Step 9.5 — "Skills"** (inspects the skills `squad init` already installs in `.copilot/skills/`, then tests whether one changes behavior; no dependency on external repos) and Module 3 **Step 11.6 — "Add @copilot to your team"** (`squad copilot --auto-assign`, the bounded-autonomy alternative to Ralph `--execute`). Commands verified against Squad CLI v0.9.4 + dev source.
- **Tier 2b adoption (models & budget):** new `docs/budget-and-models.md` — per-agent model tiers via `squad config model` (writes `.squad/config.json`), the model-resolution order, a sensible tier mix, and a rough premium-request budget (closes the W-012 budget gap). Linked from the README and Module 1's model-selection step.

### Changed
- **Upgraded from .NET 9 (STS, EOL May 2026) to .NET 10 LTS** (supported through November 2028) — all module prompts, prerequisite tables, and `scripts/Verify-Prerequisites.ps1` updated
- `docs/prerequisites.md`: added Windows-only note (workshop uses `winget` throughout)
- `README.md`: added Windows-only note near prerequisites section; removed redundant "Module summaries" prose section (the table + scope-note already cover the same information)
- `docs/troubleshooting.md`: renamed `squad watch --execute` heading to `squad triage --execute` (formerly `squad watch`) — body now uses the modern name, with a single parenthetical alias for search discoverability
- **Relicensed Apache-2.0 → MIT** (`LICENSE`, `README.md` badge + License section, `CONTRIBUTING.md`) — aligns with the MIT-licensed `tamirdresher/squad-skills` and simplifies external contribution ahead of accepting PR #1
- **Command-name direction reversed → adopting `squad watch` as the primary name** (per the authoritative PR [#1](https://github.com/joslat/squad-workshop/pull/1) from Squad co-creator Tamir Dresher). This supersedes the `squad watch → squad triage` change two bullets above — both names route to the same command, but `watch` is the original/native one and the only one that accepts `--health`. Repo-wide sweep tracked in `docs/02 Post-PR1-Verification-and-Fixes.md`.
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

### Pending verification — deferred to Tamir (trust vote; see `docs/02 Post-PR1-Verification-and-Fixes.md`)
- Correct troubleshooting for upstream #1017 / #1062 / #1081 — verified fixed on `dev` / `v0.9.6-insider.3`, **not** in v0.9.4 stable (PR #1's "fixed in 0.9.4+" and "#1081 by design" are both inaccurate; v0.9.4 still pins the broken `@github/copilot-sdk ^0.1.32`)
- Reframe the Teams `~/.squad/teams-webhook.url` instructions (PR #1 Step 11g + `docs/01` §B3): that path is read by **Tamir's `ralph-watch.ps1` wrapper**, not by the built-in `squad watch`; built-in Teams uses the `teams-graph` OAuth adapter + the `notification-routing` skill

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
