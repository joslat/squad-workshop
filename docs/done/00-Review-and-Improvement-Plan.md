# Squad Workshop — Review & Improvement Plan

> **Document type:** Independent re-audit + implementation plan (second pass)
> **Review date:** 2026-05-27
> **Reviewer:** Claude (independent re-audit, no shared context with the prior review)
> **Scope:** Full repository — README, modules, agents, prompts, copilot-instructions, docs (prereqs / troubleshooting / plan), scripts, `.github/` config & workflows. Compares the state of `main` against the previously-archived [REVIEW-AND-IMPROVEMENT-PLAN.md](REVIEW-AND-IMPROVEMENT-PLAN.md) and [UPSTREAM-SQUAD-INVESTIGATION.md](UPSTREAM-SQUAD-INVESTIGATION.md), and surfaces residual / new issues.
> **Status:** ✅ **Implemented.** 11 of 14 items resolved (W-001 → W-011); W-013 is staged in CHANGELOG awaiting `git tag`/`gh release create` (user-approved publishing action); W-012 and W-014 are deferred pending real-world measurement / clean-machine run.

> _Versioning convention: this plan does not repeat the targeted Squad CLI version inline. The version this workshop targets is declared once in the README; everything below references that, not a specific number._

> _Filename history: this document was previously `REVIEW-AND-FIX-PLAN-2026-05.md`._

---

### Implementation status

| ID | Title | Severity | Phase | Resolved? |
|---|---|---|---|---|
| W-001 | `bradygaster/squad-cli` GitHub URL is a 404 | HIGH | [A-1](#a-1-fix-bradygastersquad-cli-404-w-001) | ✅ |
| W-002 | `copilot --agent squad-coach` not discoverable from `reading-list-squad-lab/` | HIGH | [A-2](#a-2-make-squad-coach--prompts-discoverable-in-the-lab-repo-w-002) | ✅ |
| W-003 | Troubleshooting heading uses stale `squad watch --execute` | MEDIUM | [B-1](#b-1-update-squad-watch---execute--squad-triage---execute-w-003) | ✅ |
| W-004 | `vXX.XX.X` placeholder amid exact `squad doctor` expected-output | LOW | [B-2](#b-2-replace-vxxxxx-placeholder-w-004) | ✅ |
| W-005 | README "Modules" table and "Module summaries" duplicate each other | LOW | [B-3](#b-3-de-duplicate-readme-modules--module-summaries-w-005) | ✅ |
| W-006 | No explanation of how to invoke `.prompt.md` files | MEDIUM | [C-1](#c-1-add-how-to-use-these-prompts-explainer-w-006) | ✅ |
| W-007 | "Run squad to start" output contradicts Step 1's instruction | LOW | [C-2](#c-2-run-squad-to-start-override-callout-w-007) | ✅ |
| W-008 | `gh repo create --public` hardcoded with no private-repo note | LOW | [C-3](#c-3-private-repo-alternative-note-w-008) | ✅ |
| W-009 | `.gitignore` doesn't cover Module 3 runtime artifacts | LOW | [C-4](#c-4-add-ralph-artifacts-to-gitignore-w-009) | ✅ |
| W-010 | No CI validation of `Verify-Prerequisites.ps1` syntax | LOW | [C-5](#c-5-add-verify-scriptyml-ci-workflow-w-010) | ✅ |
| W-011 | `squad doctor` expected-output is version-locked | LOW | [D-1](#d-1-forward-drift-callout-for-squad-doctor-w-011) | ✅ |
| W-012 | No premium-request budget guidance for workshop runs | LOW | [D-2](#d-2-premium-request-budget-guidance-w-012) | ⏸ deferred |
| W-013 | `[Unreleased]` CHANGELOG never released | LOW | [D-3](#d-3-cut-release-110-w-013) | ⏸ staged (CHANGELOG entries written; `git tag` + `gh release create` await user approval) |
| W-014 | No end-to-end clean-machine verification stamp | LOW | [D-4](#d-4-end-to-end-clean-machine-verification-w-014) | ⏸ deferred |

---

## Index

1. [Executive summary](#1-executive-summary)
2. [Methodology](#2-methodology)
3. [What is working well](#3-what-is-working-well)
4. [Issues found](#4-issues-found)
   - 4.1 [Bugs — W-001, W-002](#41-bugs)
   - 4.2 [Inconsistencies — W-003, W-004, W-005](#42-inconsistencies)
   - 4.3 [Gaps — W-006, W-007, W-008, W-009, W-010](#43-gaps)
   - 4.4 [Forward-looking risks — W-011, W-012, W-013, W-014](#44-forward-looking-risks)
5. [Implementation plan — ordered fix steps](#5-implementation-plan--ordered-fix-steps)
   - [Phase A: Bug fixes (HIGH)](#phase-a-bug-fixes-high)
   - [Phase B: Inconsistencies (MEDIUM/LOW)](#phase-b-inconsistencies-mediumlow)
   - [Phase C: Gap fills (MEDIUM/LOW)](#phase-c-gap-fills-mediumlow)
   - [Phase D: Forward-looking & process](#phase-d-forward-looking--process)
6. [Verification](#6-verification)
7. [What I'd add on top (out of scope for this cycle)](#7-what-id-add-on-top-out-of-scope-for-this-cycle)

---

## 1. Executive summary

The `squad-workshop` repository is in good shape. The previous audit's items are all genuinely closed — `.NET 10` is consistent across all surfaces, the `git push -u origin master` bug is gone, prerequisite-script paths are correct, the coach agent + structured prompts + always-on `.github/copilot-instructions.md` are now in place. The editorial voice is direct and honest about Squad's failure modes (the `✓ lies when Docker is down` callout, the silent-coordinator-drop section, the `--execute` specialists-aren't-specialists limitation), which is the workshop's strongest asset.

This re-audit surfaces **2 bugs**, **3 inconsistencies**, **5 gaps**, and **4 forward-looking risks** that the previous review did not catch — most of them emerged from the additions made after the initial release (squad coach, prompts, troubleshooting expansions).

**Two HIGH-severity bugs to fix before the next learner runs the workshop:**

1. **W-001** — The GitHub URL `https://github.com/bradygaster/squad-cli` returns **404** (confirmed by HTTP probe). The npm package is correctly named `@bradygaster/squad-cli`, but the source repo on GitHub is `bradygaster/squad`. Two user-visible places point to the broken URL: the "Squad CLI issues" contact link in the new-issue chooser ([.github/ISSUE_TEMPLATE/config.yml](../../.github/ISSUE_TEMPLATE/config.yml)) and the "where to file Squad CLI bugs" link in [CONTRIBUTING.md](../../CONTRIBUTING.md). Modules and troubleshooting already point to the correct repo, so learners get conflicting destinations depending on entry point.

2. **W-002** — The README tells learners to run `copilot --agent squad-coach` from inside `reading-list-squad-lab/`, but the agent file lives in the **workshop** repo at [.github/agents/squad-coach.agent.md](../../.github/agents/squad-coach.agent.md). Copilot CLI discovers agents from the current workspace's `.github/agents/`, so the documented invocation will fail with "agent not found" — and the documented affordance ("use the coach when stuck") silently breaks.

Everything else is incremental polish, gap-fill, or forward-looking risk that becomes a problem only when an underlying tool moves.

---

## 2. Methodology

Files reviewed in this pass:

| File | Lines read |
|---|---|
| `README.md` | All |
| `modules/01-basic.md` | All |
| `modules/02-intermediate.md` | All |
| `modules/03-advanced.md` | All |
| `docs/prerequisites.md` | All |
| `docs/troubleshooting.md` | All |
| `docs/SQUAD-WORKSHOP-STANDALONE-PLAN.md` | First 120 (sampled — historical reference) |
| `docs/done/REVIEW-AND-IMPROVEMENT-PLAN.md` | All (used as audit baseline) |
| `docs/done/UPSTREAM-SQUAD-INVESTIGATION.md` | First 120 (sampled) |
| `scripts/Verify-Prerequisites.ps1` | All |
| `.github/agents/squad-coach.agent.md` | All |
| `.github/prompts/debug-step.prompt.md` | All |
| `.github/prompts/inspect-squad-artifacts.prompt.md` | All |
| `.github/copilot-instructions.md` | All |
| `.github/workflows/check-links.yml` | All |
| `.github/mlc_config.json` | All |
| `.github/ISSUE_TEMPLATE/{broken-step,feedback,config}.yml` | All |
| `.github/PULL_REQUEST_TEMPLATE.md` | All |
| `CHANGELOG.md`, `CONTRIBUTING.md`, `.gitignore` | All |

Cross-checks performed:

1. Repo-wide grep for `.NET 9`, `SDK.9`, `net9` — confirmed all references in active files are gone (only `docs/done/*.md` and `docs/SQUAD-WORKSHOP-STANDALONE-PLAN.md` retain historical mentions, which is acceptable).
2. Repo-wide grep for `squad watch`, `squad status`, `squad triage` to verify command-name consistency between modules and troubleshooting.
3. HTTP probe of `https://github.com/bradygaster/squad-cli` vs. `https://github.com/bradygaster/squad` (results: 404 / 200).
4. Discoverability trace for `squad-coach` agent and the two `.prompt.md` files against documented invocation contexts.
5. Spot-check of internal markdown links across module footers and the README "Getting help" section.
6. Verify-Prerequisites.ps1 logic re-read end-to-end — version thresholds, exit code, output format.

---

## 3. What is working well

To balance the findings below — the following should be preserved as-is:

| Element | Why it's good |
|---|---|
| Honest failure-mode documentation | `✓` Docker-is-down callout, silent coordinator drop, `--execute` specialist limitation, premium request rate-limit. These are documented in-line rather than buried. |
| Verification-first step structure | Every step has a "What to watch for" or "Verify" block. No step ends with "the agent will do the right thing." |
| Module 2 Step 9 "AI confetti" framing | The explicit "what good looks like" vs. "what AI confetti looks like" framing for artifact inspection is the workshop's strongest editorial moment. |
| `scripts/Verify-Prerequisites.ps1` | Robust version parsing, non-zero exit code for CI use, clean PASS/FAIL output, per-item fix suggestions. |
| Squad-coach agent + structured prompts | A workshop-specific addition with no upstream equivalent. The agent has both a Squad-knowledge base and a "tone" block telling it not to oversell. |
| `.github/copilot-instructions.md` | Workshop-wide context injected into every VS Code Copilot Chat session in this repo. Means contributors and readers using Chat get Squad-aware answers without setup. |
| .NET 10 upgrade consistency | All 17 originally-flagged sites updated; the prereq script threshold and the installer hint both match. |
| Plan → audit → upstream-investigation paper trail | Unusual for a workshop, and a genuine asset for future maintainers. |
| Module 3 honesty about Ralph | Explicitly tells learners when to walk away from Ralph (vague issues, thin tests, sitting and watching). |

---

## 4. Issues found

### 4.1 Bugs

#### W-001 — `bradygaster/squad-cli` GitHub URL is a 404

**Severity:** HIGH
**Files:**
- [.github/ISSUE_TEMPLATE/config.yml:7](../../.github/ISSUE_TEMPLATE/config.yml)
- [CONTRIBUTING.md:89](../../CONTRIBUTING.md)

**Symptom:** The "Squad CLI issues" contact in the new-issue chooser, and the "where to file Squad CLI bugs" line in CONTRIBUTING.md, both link to `https://github.com/bradygaster/squad-cli`.

**Why it fails:** The npm package is `@bradygaster/squad-cli`, but the GitHub source repository is `bradygaster/squad`. HTTP probe confirms:

| URL | Status |
|---|---|
| `https://github.com/bradygaster/squad-cli` | 404 |
| `https://github.com/bradygaster/squad` | 200 |

Modules and troubleshooting correctly link to `bradygaster/squad` (via specific issue numbers like #992, #1017, #1026, #1052, #1062, #1081 and the open-issues link at the bottom of Module 3). So learners get conflicting destinations: file-an-issue flow → 404; in-content links → real repo.

**Fix:** Change both occurrences to `https://github.com/bradygaster/squad`. Keep the prose phrasing `@bradygaster/squad-cli` where it refers to the npm package — that's correct.

---

#### W-002 — `copilot --agent squad-coach` not discoverable from `reading-list-squad-lab/`

**Severity:** HIGH
**Files:**
- [README.md:100-104](../../README.md)
- [.github/copilot-instructions.md:81](../../.github/copilot-instructions.md)
- [.github/agents/squad-coach.agent.md:7](../../.github/agents/squad-coach.agent.md) (front-matter description)

**Symptom:** README directs learners:

> Run this from inside your `reading-list-squad-lab` directory:
> ```powershell
> copilot --agent squad-coach
> ```

**Why it fails:** The agent file lives at `squad-workshop/.github/agents/squad-coach.agent.md` — in the **workshop** repo. Copilot CLI's `--agent <name>` flag discovers agent files from the current working directory's `.github/agents/`. From inside `reading-list-squad-lab/`, the squad-coach file is not on Copilot CLI's discovery path, so the invocation will fail with an agent-not-found error.

The "Getting help" affordance silently breaks at the exact moment a stuck learner reaches for it.

The two `.prompt.md` files have the same structural issue but a softer failure mode: the README presents them as links to read+copy, not as runnable prompts, so a learner who opens the file and pastes its content into Copilot Chat still gets value. The squad-coach has no such fallback.

**Fix options:**

| Option | Pros | Cons |
|---|---|---|
| **(a) Tell users to run the coach from the workshop repo working tree** | No tooling needed; instructions only | Requires two open terminals; learners must remember which one |
| **(b) Ship `scripts/Install-WorkshopAgents.ps1`** that copies `squad-coach.agent.md` + the two prompt files into `<lab>/.github/agents/` and `<lab>/.github/prompts/` | One command; coach lives where the learner is working; prompts become VS Code Chat reusable | New script to maintain; learners need to re-run on workshop update |
| **(c) Install the coach as a global Copilot agent** | Always available everywhere | Unclear whether Copilot CLI supports user-scoped agents; risk of polluting the global namespace; couples workshop to Copilot CLI internals |

**Recommendation:** option (b). See implementation plan §5 Phase A-2 for the exact script + README/copilot-instructions copy edits.

---

### 4.2 Inconsistencies

#### W-003 — Troubleshooting heading uses stale `squad watch --execute`

**Severity:** MEDIUM
**File:** [docs/troubleshooting.md:240-254](../troubleshooting.md)

**Symptom:** Module 3 explicitly states the modern command name:

> Ralph is Squad's polling agent. He's the named persona for `squad triage` (formerly `squad watch`) — ([modules/03-advanced.md:136](../../modules/03-advanced.md))

Every command example in Module 3 uses `squad triage --execute`. But the troubleshooting section for upstream issue #1081 still titles itself:

> ### `squad watch --execute` agents don't behave like the assigned specialist

...and uses `squad watch --execute` four times in the body.

**Why it matters:** A learner who hits the issue running `squad triage --execute` and searches the troubleshooting page for that exact string will not find this section. The upstream issue tracker still uses the old name, which is one valid reason to mention it — but as an alias, not as the primary heading.

**Fix:** Rename the heading and rewrite the body to `squad triage --execute`; mention "(formerly `squad watch`)" once for search discoverability. The upstream issue number (#1081) link does not change.

---

#### W-004 — `vXX.XX.X` placeholder amid otherwise-exact `squad doctor` expected-output

**Severity:** LOW
**File:** [modules/01-basic.md:130](../../modules/01-basic.md)

**Symptom:** The expected-output block is copy-exact except for one line:

```
✅  Node.js ≥22.5.0 (node:sqlite) — vXX.XX.X — node:sqlite available
```

Surrounding lines reproduce exact glyphs and punctuation; the summary line is verbatim `9 passed, 0 failed, 0 warnings, 2 info`. A learner comparing line-by-line will trip over `vXX.XX.X` as if it were a literal expected string.

**Fix:** Substitute a real example version (e.g. `v22.5.0`) and add a brief inline annotation: `v22.5.0 — your version may differ`.

---

#### W-005 — README "Modules" table and "Module summaries" duplicate each other

**Severity:** LOW
**File:** [README.md:32-94](../../README.md)

**Symptom:** The "Modules" table (lines 32-37) and the "Module summaries" prose section (lines 80-94) restate the same information for each module. On a landing page this reads as a small editorial smell — the table conveys "what you build / how long / what you need," and the prose section essentially paraphrases.

**Fix options:** delete the prose section, or repurpose it: "what each module is *about*" (table) vs. "what each module tries to *prove*" (prose). The prose version is the more interesting framing — if kept, it should be rewritten to focus on the *evaluation question* each module answers, not on the build deliverable (which is what the table already covers).

---

### 4.3 Gaps

#### W-006 — No explanation of how to invoke `.prompt.md` files

**Severity:** MEDIUM
**Files:**
- [README.md:110-113](../../README.md)
- [.github/prompts/](../../.github/prompts/) (both `.prompt.md` files in this folder)

**Symptom:** README links to:

```markdown
- [Prompt: debug a stuck step](.github/prompts/debug-step.prompt.md)
- [Prompt: inspect Squad artifacts](.github/prompts/inspect-squad-artifacts.prompt.md)
```

...under "Structured help" but never explains what a `.prompt.md` file is, how a learner invokes it (front-matter `mode: ask` indicates VS Code Copilot Chat reusable prompts), or whether they're meant as copy-paste templates or first-class Chat invocations. A first-time learner clicks the link, sees a templated prompt, and has no clear next step.

**Fix:** Add a one-paragraph "How to use these prompts" callout above the links (or as a small subsection) explaining that they are reusable prompts for GitHub Copilot Chat in VS Code, can be invoked by name from the Chat prompt picker (`/<prompt-name>`), and can also be read + copied into any Copilot CLI session.

---

#### W-007 — "Run squad to start" output contradicts Step 1's instruction

**Severity:** LOW
**File:** [modules/01-basic.md:95-148](../../modules/01-basic.md)

**Symptom:** Step 0d's documented expected output ends with: `Your team is ready. Run squad to start.` But Step 1 explicitly tells learners *not* to run `squad`, citing the Squad README's deprecation note. A new learner reads the cheerful Squad output and ignores Step 1's contrary guidance.

**Fix:** Add a two-line callout under Step 0d immediately after the expected-output block:

> Squad's farewell line still says **"Run squad to start"** — ignore it. Use `copilot --agent squad` (Step 1) instead. The interactive `squad` shell is deprecated.

---

#### W-008 — `gh repo create --public` hardcoded with no private-repo note

**Severity:** LOW
**File:** [modules/01-basic.md:78](../../modules/01-basic.md)

**Symptom:** Step 0c forces public repo creation. A workshop participant on a corporate / sensitive account or who prefers private-by-default has no documented alternative.

**Fix:** Add a one-line note under the code block:

> Public is used for simplicity in this workshop; `--private` works identically and won't affect any subsequent step.

---

#### W-009 — `.gitignore` doesn't cover Module 3 runtime artifacts

**Severity:** LOW
**File:** [.gitignore](../../.gitignore)

**Symptom:** Module 3 step 11d explicitly writes `ralph.log` and step 11f / 12e create `.squad/ralph-stop`. These artifacts live in the *lab* repo (already ignored at workshop-repo level via the `reading-list-squad-lab/` entry), so the practical risk is bounded. But:

1. If a learner runs Module 3 with the workshop repo open in the same terminal session, `Tab`-completion could surface these from the wrong working directory.
2. Other learners may copy patterns from this workshop into their own Squad-using repos and not realize Ralph's artifacts need ignoring.

**Fix:** Add three lines to `.gitignore` under a new "Squad runtime artifacts (Ralph)" header:

```
# Squad runtime artifacts (Ralph)
.squad/ralph-stop
ralph.log
*.ralph.log
```

These are no-ops in this workshop repo but document the intended pattern for downstream users.

---

#### W-010 — No CI validation of `Verify-Prerequisites.ps1` syntax

**Severity:** LOW
**File:** [.github/workflows/](../../.github/workflows/)

**Symptom:** `scripts/Verify-Prerequisites.ps1` is the most-executed file in the workshop — every learner runs it before Module 1. The `check-links.yml` workflow validates markdown links, but nothing validates that the PowerShell script still parses or runs in a clean shell. A future fat-finger edit (broken regex, mismatched brace, malformed string interpolation) would ship and silently break the entry door for every new learner.

**Fix:** Add a `verify-script.yml` workflow that runs PSScriptAnalyzer and a syntax-only parse step on PR and push to `main`. Roughly:

```yaml
name: Verify PowerShell script
on:
  push:
    branches: [main]
    paths: ['scripts/**']
  pull_request:
    branches: [main]
    paths: ['scripts/**']

jobs:
  parse:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Parse script
        shell: pwsh
        run: |
          $errors = $null
          [System.Management.Automation.Language.Parser]::ParseFile(
            "$PWD\scripts\Verify-Prerequisites.ps1", [ref]$null, [ref]$errors
          )
          if ($errors) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
      - name: PSScriptAnalyzer
        shell: pwsh
        run: |
          Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
          $r = Invoke-ScriptAnalyzer -Path scripts/Verify-Prerequisites.ps1 -Severity Warning,Error
          if ($r) { $r | Format-Table; exit 1 }
```

This costs ~30 seconds per push and prevents the single highest-impact regression class.

---

### 4.4 Forward-looking risks

#### W-011 — `squad doctor` expected-output is version-locked

**Severity:** LOW (forward risk)
**File:** [modules/01-basic.md:115-134](../../modules/01-basic.md)

**Symptom:** The expected output is reproduced verbatim with a precise summary line `9 passed, 0 failed, 0 warnings, 2 info`. When `bradygaster/squad` bumps a minor and adds, removes, or renames a check, the numbers shift — and the workshop reads as "wrong" even when the tool is healthy.

The existing backward-drift callout (for learners on an older Squad CLI than the README target) demonstrates the pattern. Forward drift has no sibling callout.

**Fix:** Add a forward-drift callout under the expected-output block:

> **If you're on a newer Squad CLI than this workshop targets** (see README) and the summary numbers differ from what's shown above, that's fine as long as the line reads `0 failed`. Squad CLI adds checks on minor bumps. The key signal is **zero failures** — passes and info lines may change.

---

#### W-012 — No premium-request budget guidance for workshop runs

**Severity:** LOW (forward risk)
**File:** [docs/troubleshooting.md:259-274](../troubleshooting.md)

**Symptom:** Troubleshooting names the 1,500-per-month Copilot Pro+ ceiling but doesn't estimate what a full workshop run consumes. Module 3's `squad triage --execute` is the obvious budget hog, but Modules 1 and 2 also burn through premium requests with multi-agent coordination.

**Fix:** After running the workshop end-to-end at least once with a known starting budget, add a row to the troubleshooting section or to each module's prerequisite block:

> **Premium request budget:** Module 1 + Module 2 typically consume ~N premium requests on the default model selection. Module 3's `triage --execute` step is open-ended — cap with `--max-concurrent 1 --timeout 20` as shown.

(Pending an actual measurement — this requires a real workshop run with logging.)

---

#### W-013 — `[Unreleased]` CHANGELOG never released

**Severity:** LOW (process)
**File:** [CHANGELOG.md:9](../../CHANGELOG.md)

**Symptom:** The post-1.0.0 work — squad coach agent, the two prompt files, `.NET 10` upgrade, six new troubleshooting sections, `[Unreleased]` block — sits in `[Unreleased]`. No tag, no GitHub release. The `[![Check links]](...)` badge in the README technically tracks `main`, not a release.

**Fix:** Once W-001 through W-010 are merged, cut **1.1.0**:

1. Promote `[Unreleased]` → `## [1.1.0] — 2026-MM-DD`.
2. Add a fresh empty `## [Unreleased]` block above it.
3. `git tag v1.1.0 && git push origin v1.1.0`.
4. `gh release create v1.1.0` referencing the CHANGELOG entry.

---

#### W-014 — No end-to-end clean-machine verification stamp

**Severity:** LOW (process)
**File:** n/a — process gap

**Symptom:** The audit confirms paths and prose; the previous review's Phase E suggested verification but does not record whether it was performed on a clean machine. The most recent release reads as a "ship-ready" milestone without an attached "verified end-to-end" stamp.

**Fix:** Run the full workshop (Modules 1 + 2 minimum, Module 3 if the budget allows) on a freshly-imaged Windows 11 box and add a single line to the README footer or CHANGELOG:

> Last end-to-end verified: YYYY-MM-DD on Windows 11 (against the Squad CLI version declared in the README header).

This is the cheapest credibility boost available and acts as a self-deprecating "drift detector" — when the stamp date is more than 6 months old, contributors know to re-verify.

---

## 5. Implementation plan — ordered fix steps

Fixes are ordered by risk and dependency. Phase A must be done before publishing 1.1.0 because both items are HIGH-severity user-visible breakage. Phases B–D are independent and can be done in any order.

---

### Phase A: Bug fixes (HIGH)

#### A-1. Fix `bradygaster/squad-cli` 404 (W-001)

**File 1:** `.github/ISSUE_TEMPLATE/config.yml`

Current:
```yaml
  - name: Squad CLI issues
    url: https://github.com/bradygaster/squad-cli
    about: Bugs in Squad itself (not the workshop content) go to the Squad CLI repo.
```

Replace `url` value with `https://github.com/bradygaster/squad`.

**File 2:** `CONTRIBUTING.md`

Current (line 89):
```markdown
- **Squad CLI bugs** — those go to [@bradygaster/squad-cli](https://github.com/bradygaster/squad-cli)
```

Replace with:
```markdown
- **Squad CLI bugs** — those go to [bradygaster/squad](https://github.com/bradygaster/squad) (the npm package is `@bradygaster/squad-cli`; the source repo is `bradygaster/squad`)
```

Leave all `@bradygaster/squad-cli` *package* references untouched in:
- `docs/prerequisites.md` (install commands)
- `docs/troubleshooting.md` (`npm install -g` lines)
- `scripts/Verify-Prerequisites.ps1` (fix message)
- `modules/01-basic.md` (the upgrade-on-stuck callout)
- `.github/agents/squad-coach.agent.md`
- `.github/copilot-instructions.md`

Those are correct — the npm package name has not changed.

---

#### A-2. Make squad-coach + prompts discoverable in the lab repo (W-002)

**A-2a. Create `scripts/Install-WorkshopAgents.ps1`**

```powershell
<#
.SYNOPSIS
    Copies the Squad Workshop coach agent and reusable prompts into the lab repo
    so they are discoverable by Copilot CLI / VS Code Copilot Chat when working
    from inside the lab.

.DESCRIPTION
    Run this from the workshop repo root, passing the path to your lab repo
    (default: ../reading-list-squad-lab).

    The script copies:
      .github/agents/squad-coach.agent.md
      .github/prompts/debug-step.prompt.md
      .github/prompts/inspect-squad-artifacts.prompt.md
    into the lab repo's matching .github/agents/ and .github/prompts/ folders,
    creating them if needed.

.EXAMPLE
    .\scripts\Install-WorkshopAgents.ps1
    .\scripts\Install-WorkshopAgents.ps1 -LabPath ..\reading-list-squad-lab
#>

[CmdletBinding()]
param(
    [string]$LabPath = "..\reading-list-squad-lab",
    [switch]$Force
)

if (-not (Test-Path $LabPath)) {
    Write-Error "Lab repo not found at: $LabPath"
    Write-Host  "Pass -LabPath to point at your reading-list-squad-lab directory."
    exit 1
}

$agentSrc   = "$PSScriptRoot\..\.github\agents\squad-coach.agent.md"
$promptsSrc = Get-ChildItem "$PSScriptRoot\..\.github\prompts\*.prompt.md"

$agentDst   = Join-Path $LabPath ".github\agents"
$promptsDst = Join-Path $LabPath ".github\prompts"

New-Item -ItemType Directory -Path $agentDst   -Force | Out-Null
New-Item -ItemType Directory -Path $promptsDst -Force | Out-Null

# Refuse to overwrite local customizations unless -Force is passed.
$toCopy = @($agentSrc) + $promptsSrc.FullName
$conflicts = $toCopy | ForEach-Object {
    $dst = if ($_ -like "*\agents\*") { $agentDst } else { $promptsDst }
    $target = Join-Path $dst (Split-Path $_ -Leaf)
    if (Test-Path $target) { $target }
} | Where-Object { $_ }

if ($conflicts -and -not $Force) {
    Write-Warning "These files already exist in the lab repo and would be overwritten:"
    $conflicts | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Re-run with -Force to overwrite, or back them up first." -ForegroundColor Yellow
    exit 1
}

Copy-Item $agentSrc   $agentDst   -Force
Copy-Item $promptsSrc $promptsDst -Force

Write-Host ""
Write-Host "Installed into $LabPath\.github\:" -ForegroundColor Green
Write-Host "  agents\squad-coach.agent.md"
Write-Host "  prompts\debug-step.prompt.md"
Write-Host "  prompts\inspect-squad-artifacts.prompt.md"
Write-Host ""
Write-Host "Now from inside the lab repo you can run:" -ForegroundColor Cyan
Write-Host "  copilot --agent squad-coach"
Write-Host ""
```

**A-2b. Update README "Getting help" section**

[README.md:98-114](../../README.md). Current:

```markdown
**Stuck on a step?** Use the Squad Coach agent — it knows every module step, every troubleshooting pattern, and the failure modes of Squad itself. Run this from inside your `reading-list-squad-lab` directory:

```powershell
copilot --agent squad-coach
```
```

Replace with:

```markdown
**Stuck on a step?** Use the Squad Coach agent — it knows every module step, every troubleshooting pattern, and the failure modes of Squad itself.

One-time setup (from the workshop repo root):

```powershell
.\scripts\Install-WorkshopAgents.ps1
```

This copies the coach agent and the two helper prompts into `reading-list-squad-lab\.github\`. Then from inside the lab repo:

```powershell
copilot --agent squad-coach
```
```

**A-2c. Update `.github/copilot-instructions.md`**

Line 81 currently reads:

```markdown
- **"Should I use the coach agent?"** → Yes — `copilot --agent squad-coach` from within the `reading-list-squad-lab` directory gives step-by-step help and Squad expertise on demand.
```

Replace with:

```markdown
- **"Should I use the coach agent?"** → Yes. Run `.\scripts\Install-WorkshopAgents.ps1` once from the workshop repo root to install the coach into your lab repo's `.github/agents/`, then `copilot --agent squad-coach` from inside the lab repo gives step-by-step help and Squad expertise on demand.
```

**A-2d. Update squad-coach front-matter**

[.github/agents/squad-coach.agent.md:1-8](../../.github/agents/squad-coach.agent.md). Current description ends:

```
  Use this agent from inside your reading-list-squad-lab
  directory: copilot --agent squad-coach
```

Replace with:

```
  Install with .\scripts\Install-WorkshopAgents.ps1, then invoke
  from inside your reading-list-squad-lab directory with:
  copilot --agent squad-coach
```

**A-2e. Add a "Coach available" callout to Module 1 step 0e or 0f**

After the `squad doctor` block in [modules/01-basic.md](../../modules/01-basic.md), add:

```markdown
> **Optional — install the workshop coach now.** From a separate terminal in the workshop repo:
> ```powershell
> .\scripts\Install-WorkshopAgents.ps1
> ```
> Then in your lab terminal, `copilot --agent squad-coach` is available any time you get stuck.
```

This converts the coach from a passive offering to a step-time decision.

---

### Phase B: Inconsistencies (MEDIUM/LOW)

#### B-1. Update `squad watch --execute` → `squad triage --execute` (W-003)

**File:** `docs/troubleshooting.md`

Current heading (line 240):
```markdown
### `squad watch --execute` agents don't behave like the assigned specialist
```

Replace with:
```markdown
### `squad triage --execute` agents don't behave like the assigned specialist (formerly `squad watch`)
```

Replace the four `squad watch --execute` occurrences in the body with `squad triage --execute`. Keep one parenthetical mention near the upstream-issue link for search discoverability:

```markdown
**Cause:** `squad triage --execute` (the command was renamed from `squad watch` upstream) uses the `squad:{member}` label only as a routing filter...
```

---

#### B-2. Replace `vXX.XX.X` placeholder (W-004)

**File:** `modules/01-basic.md` line 130

Current:
```
✅  Node.js ≥22.5.0 (node:sqlite) — vXX.XX.X — node:sqlite available
```

Replace with:
```
✅  Node.js ≥22.5.0 (node:sqlite) — v22.5.0 — node:sqlite available
```

And add a one-line annotation in the prose immediately after the code block:

> The exact `v22.5.0` line will show your installed Node version — anything ≥22.5.0 is fine.

---

#### B-3. De-duplicate README "Modules" / "Module summaries" (W-005)

**File:** `README.md` lines 80-94 ("Module summaries" section).

**Recommendation:** Delete the prose section entirely. The table at lines 32-37 already covers what + how-long + prereqs; the prose section paraphrases the same information without adding evaluation framing. The README is shorter and stronger without it.

If the prose is kept, rewrite each module entry as **what the module tries to prove** rather than what it builds (the table already has the latter):

```markdown
### Module 1 — Basic
*Question this module answers:* does Squad's team model genuinely reduce context friction on a real, end-to-end build, or is the overhead theater?

### Module 2 — Intermediate
*Question this module answers:* does the team get faster on the second feature because the repo remembers, or does it retrace? You inspect the artifacts yourself.

### Module 3 — Advanced
*Question this module answers:* does autonomous mode (Ralph) earn its keep on your repo, or should you stay in interactive mode? Observability with Aspire is the diagnostic.
```

This makes the section a genuine companion to the table, not a paraphrase.

---

### Phase C: Gap fills (MEDIUM/LOW)

#### C-1. Add "How to use these prompts" explainer (W-006)

**File:** `README.md` lines 110-113.

Insert a short paragraph immediately before the two prompt links:

```markdown
**About the prompts:** these are GitHub Copilot Chat reusable prompts (front-matter `mode: ask`). In VS Code with Copilot Chat, invoke them by name from the Chat prompt picker. You can also read the file directly and copy the templated prompt into any Copilot CLI session.

- [Prompt: debug a stuck step](.github/prompts/debug-step.prompt.md) — paste your error, get a diagnosis
- [Prompt: inspect Squad artifacts](.github/prompts/inspect-squad-artifacts.prompt.md) — honest evaluation of your `.squad/` files after Module 2
```

---

#### C-2. "Run squad to start" override callout (W-007)

**File:** `modules/01-basic.md` immediately after Step 0d's inline expected-output line (around line 95 — the line that ends with `Your team is ready. Run squad to start.`).

Add:

```markdown
> **Note on Squad's "Run squad to start" line:** ignore it. The interactive `squad` shell is deprecated. Use `copilot --agent squad` as shown in Step 1 below.
```

Note: in Step 0d the expected output is described in prose, not in a fenced code block — insert the callout on a new line directly under the `**Expected output:**` paragraph.

---

#### C-3. Private-repo alternative note (W-008)

**File:** `modules/01-basic.md` Step 0c, after the `gh repo create` code block (around line 88).

Add a one-line note below the existing callout:

```markdown
> If you'd rather not publish a workshop exercise, use `--private` instead of `--public`. No subsequent step depends on the repo being public.
```

---

#### C-4. Add Ralph artifacts to `.gitignore` (W-009)

**File:** `.gitignore`

Append:

```
# Squad runtime artifacts (Ralph) — these typically live in the lab repo
# (already excluded above) but are listed here as a pattern for downstream users
.squad/ralph-stop
ralph.log
*.ralph.log
```

---

#### C-5. Add `verify-script.yml` CI workflow (W-010)

**File:** `.github/workflows/verify-script.yml` (new)

```yaml
name: Verify PowerShell script

on:
  push:
    branches: [main]
    paths:
      - 'scripts/**'
      - '.github/workflows/verify-script.yml'
  pull_request:
    branches: [main]
    paths:
      - 'scripts/**'
      - '.github/workflows/verify-script.yml'

jobs:
  parse:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Parse Verify-Prerequisites.ps1
        shell: pwsh
        run: |
          $errors = $null
          [System.Management.Automation.Language.Parser]::ParseFile(
            "$PWD\scripts\Verify-Prerequisites.ps1",
            [ref]$null,
            [ref]$errors
          )
          if ($errors) {
              $errors | ForEach-Object { Write-Error $_.Message }
              exit 1
          }
          Write-Host "Parse OK"

      - name: PSScriptAnalyzer
        shell: pwsh
        run: |
          Install-Module PSScriptAnalyzer -Scope CurrentUser -Force
          $r = Invoke-ScriptAnalyzer -Path scripts/Verify-Prerequisites.ps1 `
                 -Severity Warning,Error
          if ($r) {
              $r | Format-Table -AutoSize
              exit 1
          }
          Write-Host "PSScriptAnalyzer OK"
```

Add a CI badge to `README.md` next to the existing two badges:

```markdown
[![Verify script](https://github.com/joslat/squad-workshop/actions/workflows/verify-script.yml/badge.svg)](https://github.com/joslat/squad-workshop/actions/workflows/verify-script.yml)
```

---

### Phase D: Forward-looking & process

#### D-1. Forward-drift callout for `squad doctor` (W-011)

**File:** `modules/01-basic.md` immediately after the expected-output block in Step 0f (around line 134, near the C-2 callout).

Add:

```markdown
> **If you're on a newer Squad CLI than this workshop targets** (see README) and the summary numbers differ — different `passed` count, different `info` count — that's expected. Squad CLI adds checks on minor bumps. The signal that matters is **`0 failed`**.
```

---

#### D-2. Premium request budget guidance (W-012)

**File:** `docs/troubleshooting.md` in the rate-limit section (around line 274), or as a new "Budget" section in `docs/prerequisites.md`.

**Blocker:** requires a real measured run. Add a `// TODO measure on next workshop run` note in the CHANGELOG `[Unreleased]` entry and leave this open until measured.

Placeholder text to slot in once measured:

```markdown
**Rough budget for a full workshop run** (measured on Copilot Pro+, Claude Sonnet 4 as the session model):

| Module | Premium requests | Notes |
|---|---|---|
| Module 1 (Basic) | ~N | Multi-agent vertical-slice build |
| Module 2 (Intermediate) | ~N | Smaller — memory should compound |
| Module 3 Aspire (optional) | <N | Mostly observation |
| Module 3 Ralph (`triage --execute`) | open-ended | Cap with `--max-concurrent 1 --timeout 20` |

If you have a fresh monthly budget of 1,500, Modules 1+2 should leave you with plenty of headroom for Module 3 or your own real work.
```

---

#### D-3. Cut release 1.1.0 (W-013)

After A-1, A-2, B-1, B-2, B-3, C-1, C-2, C-3, C-4, C-5, D-1 are merged:

1. Update `CHANGELOG.md`:
   - Add entries under `[Unreleased]` for everything from this plan
   - Promote `[Unreleased]` → `## [1.1.0] — 2026-MM-DD`
   - Add a fresh empty `## [Unreleased]` block above

2. Tag and push:
   ```powershell
   git tag v1.1.0
   git push origin v1.1.0
   ```

3. Create the GitHub release. PowerShell doesn't support bash-style heredocs — use a here-string piped into `gh`:
   ```powershell
   $notes = @'
   ...content from CHANGELOG [1.1.0] entry...
   '@
   $notes | gh release create v1.1.0 --title "v1.1.0" --notes-file -
   ```
   The closing `'@` must be at column 0. Alternatively, write the notes to a temp file and pass `--notes-file <path>`.

---

#### D-4. End-to-end clean-machine verification (W-014)

Run Modules 1 and 2 end-to-end on a freshly-imaged Windows 11 box, using the Squad CLI version declared in the README header. Module 3 optional but recommended for Aspire + triage-only (skip `--execute` unless you have a real backlog to point Ralph at).

On success, add a footer line to `README.md`:

```markdown
---

> Last end-to-end verified: 2026-MM-DD on Windows 11, PowerShell 7.x (against the Squad CLI version declared above).
```

Re-verify every 6 months or on any major-tool bump.

---

## 6. Verification

After all phases:

**E-1. Re-run prereq checker:**
```powershell
.\scripts\Verify-Prerequisites.ps1
```
Must show all PASS, summary `0 failed`.

**E-2. Confirm the 404 is gone:**
```powershell
# These must both return 200:
(Invoke-WebRequest -Uri https://github.com/bradygaster/squad -Method Head).StatusCode
# The 404 URL must no longer appear anywhere in tracked content:
Select-String -Path README.md,CONTRIBUTING.md,.github\**\*.* -Pattern "bradygaster/squad-cli"
# (npm package mentions are fine; only the GitHub URL should be gone)
```

**E-3. Confirm coach installation flow works:**
```powershell
# From workshop repo root, with a fresh lab repo at ..\reading-list-squad-lab:
.\scripts\Install-WorkshopAgents.ps1
# Then in the lab repo:
cd ..\reading-list-squad-lab
copilot --agent squad-coach
# Should attach to the coach agent, not error with "agent not found"
```

**E-4. Confirm CI workflows pass:**
- `check-links.yml` — green
- `verify-script.yml` — green (new)

**E-5. Spot-check internal links:**
```powershell
Select-String -Path README.md,modules\*.md,docs\*.md,CONTRIBUTING.md `
              -Pattern "\]\((\.|modules/|docs/|scripts/|\.github/)"
```
All resolved paths should exist.

**E-6. Verify the troubleshooting heading change:**
```powershell
Select-String -Path docs\troubleshooting.md -Pattern "squad watch --execute"
```
Should match only inside the parenthetical "(formerly `squad watch`)" mention, not as a heading.

---

## 7. What I'd add on top (out of scope for this cycle)

These are not bugs or gaps in the current workshop — they're directional improvements for a future cycle, after the items above ship.

1. **Module 1 Step 6.5 (or Module 2 Step 7.5): "Use the coach."** Right now the coach is mentioned in the README's "Getting help" section but never *exercised* in the workflow. A one-step exercise — "Ask the coach to compare your `decisions.md` to the `inspect-squad-artifacts` rubric and grade it" — would convert a passive resource into a closing demonstration of what the workshop has built up.

2. **A scripted "tear-down + reset" path.** `scripts/Reset-Lab.ps1` that backs up `.squad/decisions.md` and `.squad/agents/*/history.md` then re-runs from a known clean state. Useful for facilitators running the workshop multiple times.

3. **Capstone "evaluation" doc.** Modules 1–3 ask the learner to *form an opinion* on Squad. Currently that opinion has nowhere to land. A `docs/evaluation-template.md` (markdown checklist mirroring the artifact-quality rubric + the Module 3 walk-away criteria) would let learners produce something durable.

4. **A "what to do if the team underperforms" branch in the coach agent.** The current `squad-coach.agent.md` is excellent at unsticking technical errors but doesn't have a branch for "the team is *working* but the outputs are mediocre." That's the more common, less-discussed failure mode this workshop is actually equipped to discuss.

5. **Cross-platform companion.** Either commit fully to Windows-only (rename `scripts/` → `scripts/windows/`) or write a brief macOS/Linux companion. The current "macOS/Linux users will need to..." line in the README is honest but leaves cross-platform readers without a starting point.

---

---

## Sign-off

**Status:** ✅ **Implemented.**

- **11 of 14 items resolved** (W-001 → W-011) and verified in the repo.
- **W-013 (release cut):** CHANGELOG entries are written under `[Unreleased]`. To finish, an authorized user runs:
  ```powershell
  # 1. Promote [Unreleased] → ## [1.1.0] — <today> in CHANGELOG.md (with a fresh empty [Unreleased] block above)
  # 2. Tag + push:
  git tag v1.1.0
  git push origin v1.1.0
  # 3. Create the release:
  $notes = @'
  ...content from CHANGELOG [1.1.0] entry...
  '@
  $notes | gh release create v1.1.0 --title "v1.1.0" --notes-file -
  ```
- **W-012 (premium-request budget):** deferred — requires a measured end-to-end workshop run with logging. Placeholder text is in §4.4 D-2.
- **W-014 (clean-machine verification stamp):** deferred — requires a freshly-imaged Windows 11 box. Footer template is in §5 D-4.
- This document is archived in `docs/done/`. Internal relative paths were updated to reflect the new depth.
