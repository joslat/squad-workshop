# Changelog

All notable changes to this workshop will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- AI coaching infrastructure: `.github/agents/squad-coach.agent.md` (invokable with `copilot --agent squad-coach`), `.github/prompts/debug-step.prompt.md`, `.github/prompts/inspect-squad-artifacts.prompt.md`
- `.github/copilot-instructions.md` — always-on Squad context injected into every VS Code Copilot Chat session in this repo
- `docs/done/REVIEW-AND-IMPROVEMENT-PLAN.md` — full audit of workshop vs. plan, bug register, and improvement roadmap
- `docs/done/UPSTREAM-SQUAD-INVESTIGATION.md` — assessed `bradygaster/squad` for learning resources, Ralph capabilities/limitations, and open issues affecting workshop learners
- `README.md`: "Getting help" section with coach agent invocation and structured help links
- `CONTRIBUTING.md`: contribution license clause and version maintenance checklist
- `modules/01-basic.md`, `modules/02-intermediate.md`, `modules/03-advanced.md`: "Learn more" sections with links to official Squad docs
- `docs/troubleshooting.md`: six new sections covering upstream bugs — `ERR_MODULE_NOT_FOUND` on Windows, silent coordinator drop, post-`squad init` false-positive git modifications, `--execute` specialist limitation, rate limiting, and `squad upgrade` overwrite
- `modules/03-advanced.md`: explicit warning about `squad watch --execute` specialist charter limitation (upstream issue #1081)
- Navigation footers on all three modules

### Changed
- **Upgraded from .NET 9 (STS, EOL May 2026) to .NET 10 LTS** (supported through November 2028) — all module prompts, prerequisite tables, and `scripts/Verify-Prerequisites.ps1` updated
- `docs/prerequisites.md`: added Windows-only note (workshop uses `winget` throughout)
- `README.md`: added Windows-only note near prerequisites section

### Fixed
- `modules/01-basic.md`: fixed step ordering — README creation now happens before `gh repo create` (was attempting to push an empty repo in the original 0b step)
- `modules/01-basic.md`: fixed `git push -u origin master` — replaced with `gh repo create --push` which uses the current branch name automatically, avoiding the `master`/`main` mismatch
- `modules/01-basic.md`: fixed `..\scripts\Verify-Prerequisites.ps1` path (wrong when run from repo root — correct path is `.\scripts\Verify-Prerequisites.ps1`)
- `docs/prerequisites.md`: fixed `../scripts/Verify-Prerequisites.ps1` path in opening callout (same issue — now `.\scripts\...`)
- `docs/prerequisites.md`: fixed mixed .NET version numbers — summary table showed `9.0.0` while body example showed `10.0.102`, now consistently `10.x.x`
- `modules/02-intermediate.md`: fixed `squad status` → `squad doctor` (`squad status` is undocumented in workshop context; `squad doctor` covers both active-squad confirmation and health checks)

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
