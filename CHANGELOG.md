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

### Changed
- **Upgraded from .NET 9 (STS, EOL May 2026) to .NET 10 LTS** (supported through November 2028) — all module prompts, prerequisite tables, and `scripts/Verify-Prerequisites.ps1` updated
- `docs/prerequisites.md`: added Windows-only note (workshop uses `winget` throughout)
- `README.md`: added Windows-only note near prerequisites section; removed redundant "Module summaries" prose section (the table + scope-note already cover the same information)
- `docs/troubleshooting.md`: renamed `squad watch --execute` heading to `squad triage --execute` (formerly `squad watch`) — body now uses the modern name, with a single parenthetical alias for search discoverability

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
