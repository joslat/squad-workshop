# Squad Workshop — Deep Review & Improvement Plan

> **Document type:** In-depth audit + implementation plan  
> **Review date:** 2026-05-08  
> **Reviewer:** GitHub Copilot  
> **Scope:** Full repository audit against `SQUAD-WORKSHOP-STANDALONE-PLAN.md`, content correctness, consistency, bugs, and .NET version upgrade assessment  
> **Status:** ✅ ALL ITEMS COMPLETE — implementation finished 2026-05-08. Archived to `docs/done/`.

---

### Implementation summary (as of 2026-05-08)

| Item | Severity | Resolved? |
|---|---|---|
| BUG-01 — `git push` targets `master` | HIGH | ✅ Fixed — reordered Steps 0b/0c; `gh repo create --push` handles initial push |
| BUG-02 — Script path wrong in `prerequisites.md` | HIGH | ✅ Fixed — `.\scripts\Verify-Prerequisites.ps1` |
| BUG-03 — Script path wrong in `01-basic.md` | HIGH | ✅ Fixed — `.\scripts\Verify-Prerequisites.ps1` |
| BUG-04 — Step ordering: repo before first commit | MEDIUM | ✅ Fixed — README commit now before `gh repo create` |
| INC-01 — MIT vs Apache 2.0 in plan doc | LOW | ✅ Fixed — `SQUAD-WORKSHOP-STANDALONE-PLAN.md` updated to Apache 2.0 |
| INC-02 — Mixed .NET version numbers | MEDIUM | ✅ Fixed — resolved as part of .NET 10 upgrade |
| INC-03 — `squad status` undocumented | MEDIUM | ✅ Fixed — replaced with `squad doctor` |
| GAP-01 — No README badges | LOW | ✅ Fixed — license + CI badges added |
| GAP-02 — No Windows-only platform note | MEDIUM | ✅ Fixed — added to README and prerequisites.md |
| GAP-03 — No contribution license clause | LOW | ✅ Fixed — Apache 2.0 clause added to CONTRIBUTING.md |
| GAP-04 — Module 1 missing footer nav | LOW | ✅ Fixed — footer added |
| GAP-05 — No version maintenance policy | LOW | ✅ Fixed — maintenance checklist added to CONTRIBUTING.md |
| .NET 9 EOL → .NET 10 upgrade | CRITICAL | ✅ Done — all 4 files updated |
| Troubleshooting additions from upstream issues | — | ✅ Done — 6 new sections added (issues #992, #1017, #1026, #1052, #1062, #1081) |
| "Learn more" sections in all 3 modules | — | ✅ Done |
| CHANGELOG `## [Unreleased]` | — | ✅ Done |

---

## Index

1. [Executive Summary](#1-executive-summary)
2. [Methodology](#2-methodology)
3. [Plan vs. Implementation Audit](#3-plan-vs-implementation-audit)
   - 3.1 [Files present — plan vs. reality](#31-files-present--plan-vs-reality)
   - 3.2 [Content changes required — audit status](#32-content-changes-required--audit-status)
   - 3.3 [Open questions from plan — resolution status](#33-open-questions-from-plan--resolution-status)
4. [Bugs and Defects](#4-bugs-and-defects)
   - 4.1 [BUG-01 — `git push` targets `master` instead of `main`](#41-bug-01--git-push-targets-master-instead-of-main)
   - 4.2 [BUG-02 — Script path wrong in `docs/prerequisites.md`](#42-bug-02--script-path-wrong-in-docsprerequisitesmd)
   - 4.3 [BUG-03 — Script path wrong in `modules/01-basic.md`](#43-bug-03--script-path-wrong-in-modules01-basicmd)
   - 4.4 [BUG-04 — Step ordering: repo creation before first commit](#44-bug-04--step-ordering-repo-creation-before-first-commit)
5. [Inconsistencies](#5-inconsistencies)
   - 5.1 [INC-01 — License mismatch between plan and implementation](#51-inc-01--license-mismatch-between-plan-and-implementation)
   - 5.2 [INC-02 — .NET version confusion in `prerequisites.md`](#52-inc-02--net-version-confusion-in-prerequisitesmd)
   - 5.3 [INC-03 — `squad status` used but not documented](#53-inc-03--squad-status-used-but-not-documented)
6. [Gaps (Missing from Implementation)](#6-gaps-missing-from-implementation)
   - 6.1 [GAP-01 — No README badges despite plan requirement](#61-gap-01--no-readme-badges-despite-plan-requirement)
   - 6.2 [GAP-02 — No platform scope warning (Windows-only content)](#62-gap-02--no-platform-scope-warning-windows-only-content)
   - 6.3 [GAP-03 — CONTRIBUTING.md doesn't declare contribution license](#63-gap-03--contributingmd-doesnt-declare-contribution-license)
   - 6.4 [GAP-04 — Module 1 has no return link in footer](#64-gap-04--module-1-has-no-return-link-in-footer)
   - 6.5 [GAP-05 — Version maintenance policy not documented](#65-gap-05--version-maintenance-policy-not-documented)
7. [Critical: .NET 9 End-of-Life Assessment](#7-critical-net-9-end-of-life-assessment)
   - 7.1 [EOL timeline and risk](#71-eol-timeline-and-risk)
   - 7.2 [Scope of changes for .NET 10 upgrade](#72-scope-of-changes-for-net-10-upgrade)
8. [Implementation Plan — Ordered Fix Steps](#8-implementation-plan--ordered-fix-steps)
   - Phase A: [Critical bug fixes (do first)](#phase-a-critical-bug-fixes-do-first)
   - Phase B: [.NET 10 upgrade](#phase-b-net-10-upgrade)
   - Phase C: [Inconsistency fixes](#phase-c-inconsistency-fixes)
   - Phase D: [Gap fills](#phase-d-gap-fills)
   - Phase E: [Post-fix verification](#phase-e-post-fix-verification)
9. [What Is Working Well](#9-what-is-working-well)
10. [Risk Register](#10-risk-register)

---

## 1. Executive Summary

The `squad-workshop` repository is structurally sound and remarkably complete for a v1.0.0. The plan was executed faithfully: all planned files exist, navigation links are correct, the prerequisite checker script is well-written, the issue templates are thorough, and the CI link-check workflow is in place.

However, a full cross-examination against the plan and against current tool versions surfaces **4 bugs**, **3 inconsistencies**, **5 gaps**, and **1 critical upgrade decision** that must be addressed before the workshop can be recommended to learners without caveats.

**The most urgent issue is .NET 9's end-of-life.** .NET 9 is a Standard Term Support (STS) release with an 18-month support window starting November 2024. That window expires approximately May 2026 — which is *today*. A workshop that teaches learners to scaffold `.NET 9` applications is teaching them to build on a runtime that Microsoft will not patch. The fix is straightforward: upgrade all references to .NET 10 (LTS, supported through November 2028).

**The second most urgent issue is a broken git command.** Module 1 Step 0c instructs learners to run `git push -u origin master`. Modern git installations default to `main` as the initial branch name, meaning this command will silently fail or push to the wrong branch for the majority of users.

**Two path bugs** make the prerequisite verification script impossible to run as documented: `docs/prerequisites.md` instructs running `../scripts/Verify-Prerequisites.ps1` "from the repo root" (the `../` prefix would actually navigate above the repo root), and `modules/01-basic.md` references `..\scripts\Verify-Prerequisites.ps1` from a working directory where the user is at the repo root, not inside `modules/`.

Everything else is incremental improvement, not blockers.

---

## 2. Methodology

Files reviewed:

| File | Lines read |
|---|---|
| `docs/SQUAD-WORKSHOP-STANDALONE-PLAN.md` | All (500+) |
| `README.md` | All |
| `modules/01-basic.md` | All |
| `modules/02-intermediate.md` | All |
| `modules/03-advanced.md` | All |
| `docs/prerequisites.md` | All |
| `docs/troubleshooting.md` | All |
| `scripts/Verify-Prerequisites.ps1` | All |
| `CHANGELOG.md` | All |
| `CONTRIBUTING.md` | All |
| `LICENSE` | First 30 lines (enough to identify license type) |
| `.gitignore` | All |
| `.github/ISSUE_TEMPLATE/broken-step.yml` | All |
| `.github/ISSUE_TEMPLATE/feedback.yml` | All |
| `.github/ISSUE_TEMPLATE/config.yml` | All |
| `.github/PULL_REQUEST_TEMPLATE.md` | All |
| `.github/workflows/check-links.yml` | All |
| `.github/mlc_config.json` | All |

Review approach:
1. Compared every planned deliverable (plan §2, §3, §9) against the actual repo structure
2. Traced each content requirement (plan §4–§7) against the actual file content
3. Cross-checked all internal links in module files (spot-check)
4. Verified all shell commands and expected outputs for plausibility
5. Assessed .NET 9 STS support lifecycle against current date
6. Searched for all `.NET 9` references to enumerate upgrade scope

---

## 3. Plan vs. Implementation Audit

### 3.1 Files present — plan vs. reality

| Planned file | Present? | Notes |
|---|---|---|
| `README.md` | ✅ | Full landing page — well written |
| `LICENSE` | ✅ | Apache 2.0 (plan said MIT — see INC-01) |
| `CONTRIBUTING.md` | ✅ | |
| `CHANGELOG.md` | ✅ | |
| `.gitignore` | ✅ | |
| `.github/ISSUE_TEMPLATE/broken-step.yml` | ✅ | |
| `.github/ISSUE_TEMPLATE/feedback.yml` | ✅ | |
| `.github/ISSUE_TEMPLATE/config.yml` | ✅ | |
| `.github/PULL_REQUEST_TEMPLATE.md` | ✅ | |
| `.github/workflows/check-links.yml` | ✅ | |
| `.github/mlc_config.json` | ✅ | |
| `modules/01-basic.md` | ✅ | |
| `modules/02-intermediate.md` | ✅ | |
| `modules/03-advanced.md` | ✅ | |
| `scripts/Verify-Prerequisites.ps1` | ✅ | |
| `docs/prerequisites.md` | ✅ | |
| `docs/troubleshooting.md` | ✅ | |

**Verdict:** All planned files are present. The structure is complete. ✅

---

### 3.2 Content changes required — audit status

| Plan requirement | Implemented? | Quality | Issues |
|---|---|---|---|
| §4.1 README as full landing page (tagline, what Squad is, what you'll build, module table, prereq summary, quick start, license/contributing) | ✅ | Good | Badges missing (GAP-01); `.NET 9` needs update (BUG upstream) |
| §4.2 Nav links updated in all modules | ✅ | Correct | All `../README.md`, `01-basic.md`, `02-intermediate.md`, `03-advanced.md` resolve correctly |
| §4.3 Prereq section extracted from Module 1 to `docs/prerequisites.md` | ✅ | Good | Module 1 prereq table summary exists; full detail is in `docs/prerequisites.md` |
| §4.4 Verification script extracted to `scripts/Verify-Prerequisites.ps1` | ✅ | Excellent | Script is robust, has exit code, good formatting |
| §4.5 `docs/troubleshooting.md` from inline callouts | ✅ | Good | All 7 planned entries present |
| §5 `docs/prerequisites.md` full detail page | ✅ | Good | Path bug in opening note (BUG-02); .NET version confusion (INC-02) |
| §6 `.github/ISSUE_TEMPLATE/broken-step.yml` | ✅ | Excellent | Goes beyond the plan's spec |
| §7 `.github/workflows/check-links.yml` + `mlc_config.json` | ✅ | Good | `retryOn429` and `retryCount` extras are beneficial |

---

### 3.3 Open questions from plan — resolution status

Plan §11 listed five open questions that needed resolution before Phase 1:

| Q# | Question | Resolved? | Resolution |
|---|---|---|---|
| Q1 | GitHub owner — personal account or org? | ✅ | Personal `joslat` (config.yml confirms) |
| Q2 | Keep modules in `modules/` or at repo root? | ✅ | `modules/` — clean root confirmed |
| Q3 | Discussions vs. Issues for Q&A? | ✅ | Both — config.yml links to Discussions |
| Q4 | Link-checker CI — mandatory or advisory? | ✅ | Present; assumed informational at first per recommendation |
| Q5 | Version-pin Squad CLI? | ✅ | Pinned at `0.9.4+` minimum with upgrade path documented |

**All open questions were resolved. ✅**

---

## 4. Bugs and Defects

### 4.1 BUG-01 — `git push` targets `master` instead of `main`

**Severity:** HIGH  
**File:** `modules/01-basic.md`, Step 0c  
**Line:** 82  

**Symptom:**
```powershell
git push -u origin master
```

**Why it fails:** Modern git (≥2.28, default since 2020) initializes new repos with `main` as the default branch name, not `master`. GitHub also defaults new repos to `main`. A learner running this command will either:
- Get `error: src refspec master does not match any` (their local branch is `main`)
- Push to a `master` branch on GitHub that doesn't exist and create an orphaned non-default branch

The `gh repo create --push` in Step 0b pushes to `HEAD` and lets the remote track whatever the local init created. If that's `main`, a subsequent `git push -u origin master` on a fresh local repo will fail immediately.

**Fix:**
```powershell
git push -u origin HEAD
```
Using `HEAD` instead of a hardcoded branch name works regardless of whether the local default is `main` or `master`, and is the idiomatically correct way to push a new branch.

**Affected locations (1):**
- `modules/01-basic.md` — Step 0c, the `git push` line

---

### 4.2 BUG-02 — Script path wrong in `docs/prerequisites.md`

**Severity:** HIGH  
**File:** `docs/prerequisites.md`, line 3  

**Symptom:**
```
> Run `../scripts/Verify-Prerequisites.ps1` from the repo root to check all tools in one pass.
```

**Why it fails:** The text says "from the repo root" but the path `../scripts/Verify-Prerequisites.ps1` uses `..` (parent directory), which would navigate *above* the repo root. From the repo root `squad-workshop/`, running `../scripts/...` would look for `scripts/` one level above the repo — it doesn't exist there and the command will fail.

The correct path to run **from the repo root** is:
```powershell
.\scripts\Verify-Prerequisites.ps1
```

**Root cause:** The path in the note appears to have been written from the perspective of the `docs/` subdirectory (`../scripts/` would be correct from `docs/`), but the instruction text says "from the repo root."

**Fix:** Change the opening note in `docs/prerequisites.md` to:
```
> Run `.\scripts\Verify-Prerequisites.ps1` from the repo root to check all tools in one pass.
```

Also update the near-identical text in the final section of `docs/prerequisites.md`:
```
## Verify all tools in one pass
Run the standalone checker script from the repo root:
.\scripts\Verify-Prerequisites.ps1
```
This second occurrence (`.\scripts\Verify-Prerequisites.ps1`) is already correct. Only the opening note at line 3 needs fixing.

**Affected locations (1):**
- `docs/prerequisites.md` — opening blockquote, line 3

---

### 4.3 BUG-03 — Script path wrong in `modules/01-basic.md`

**Severity:** HIGH  
**File:** `modules/01-basic.md`, Prerequisites section  
**Line:** 29  

**Symptom:**
```powershell
..\scripts\Verify-Prerequisites.ps1
```

**Why it fails:** When a learner is reading Module 1, their working directory (terminal) is the repo root `squad-workshop\` — not inside `modules\`. The step 0a hasn't been executed yet (the learner hasn't `cd`'d into any project folder), so the user is still at the repo root.

From `squad-workshop\`, the path `..\scripts\Verify-Prerequisites.ps1` navigates to the *parent* of the repo root and looks for a `scripts\` directory there, which doesn't exist. The command will fail with `path not found`.

The correct command **from the repo root** is:
```powershell
.\scripts\Verify-Prerequisites.ps1
```

**Fix:** Change the prerequisite check block in `modules/01-basic.md` to:
```powershell
.\scripts\Verify-Prerequisites.ps1
```

**Affected locations (1):**
- `modules/01-basic.md` — Prerequisites section, the code block

---

### 4.4 BUG-04 — Step ordering: `gh repo create` before first commit

**Severity:** MEDIUM  
**File:** `modules/01-basic.md`, Steps 0b and 0c  

**Symptom:** The steps are:
1. **Step 0a** — `mkdir reading-list-squad-lab; cd; git init` (empty repo, no commits)
2. **Step 0b** — `gh repo create reading-list-squad-lab --public --source . --push` (tries to push from empty local repo)
3. **Step 0c** — Create README.md, commit, `git push -u origin master`

**Why it's a problem:**  
Running `gh repo create --push` (Step 0b) on a repo with zero commits may succeed creating the remote repo but will either silently skip the push or produce a warning about nothing to push. Step 0c then tries `git push -u origin master` *after* the README is committed — but by then the remote is already linked (origin was set in 0b), and the `--push` flag may have created a different default branch setup.

The behaviour varies by:
- `gh` version (pre-2.x vs post-2.x handling of empty repos)
- Git version (what default branch name `git init` creates)
- Whether `--push` silently no-ops on an empty repo or errors

**The safest fix** is to reorder so the first commit exists before creating the GitHub remote:

1. `mkdir + cd + git init`
2. Create `README.md`
3. `git add README.md + git commit`
4. `gh repo create --push` (now has content to push)
5. *(Step 0c content is absorbed into the above)*

This also eliminates the `git push -u origin master` command (BUG-01) since `gh repo create --push` handles the initial push.

**Detailed fix:** See Phase A in the [Implementation Plan](#8-implementation-plan--ordered-fix-steps) for the exact revised step sequence.

---

## 5. Inconsistencies

### 5.1 INC-01 — License mismatch between plan and implementation

**Severity:** LOW (internal inconsistency; not user-facing)  
**Files:** `docs/SQUAD-WORKSHOP-STANDALONE-PLAN.md` vs. `LICENSE`, `README.md`  

**Detail:**  
The plan (§3.2) specifies: `MIT license, copyright joslat`  
The actual `LICENSE` file is: **Apache License 2.0**  
`README.md` says: `This workshop is licensed under the Apache License 2.0`  

The implementation is internally consistent (LICENSE file and README agree on Apache 2.0). The plan is the outlier.

**Assessment:** Apache 2.0 is a reasonable choice — it explicitly grants patent rights and is widely compatible. The divergence from the plan appears to have been a deliberate decision made during implementation, and the result is consistent. No user-facing impact.

**Action:** Update the plan document to reflect the actual decision, and optionally add a brief note in `CONTRIBUTING.md` clarifying that contributions fall under the Apache 2.0 license (see GAP-03).

---

### 5.2 INC-02 — .NET version confusion in `prerequisites.md`

**Severity:** MEDIUM  
**File:** `docs/prerequisites.md`  

**Three conflicting signals in the same section:**

| Location | What it says |
|---|---|
| Summary table (line 14) | Minimum version `9.0.0` |
| Section heading (line 46) | "2. .NET 9 SDK or later" |
| Detail body (line 52) | `**Expected:** \`9.x.x\` or later (e.g. \`10.0.102\`)` |

The example `10.0.102` is a .NET **10** version string (major=10). This leaks evidence of a partial, incomplete .NET 10 update where someone updated the body example but not the table or section heading.

This creates a confusing signal: the summary says `9.0.0`, the detail says "or later (e.g. 10.0.102)." A learner with .NET 10 installed (who sees `10.0.102` from `dotnet --version`) might wonder whether they meet the minimum requirement.

**Fix:** This inconsistency is resolved entirely by the .NET 10 upgrade in Phase B. After the upgrade, all three locations will consistently say `10.0.0` / "10.x.x" / ".NET 10".

---

### 5.3 INC-03 — `squad status` used but not documented

**Severity:** MEDIUM  
**File:** `modules/02-intermediate.md`, "If you closed and came back later" block  

**Detail:**
```powershell
squad status     # confirm the squad is active
```

`squad status` is referenced once, with no explanation of what it outputs, what success or failure looks like, or whether it even exists as a distinct command in Squad CLI. The well-documented `squad doctor` command runs comprehensive health checks; `squad status` may be a different command, an alias, or may not exist at all in the Squad CLI's documented public API.

In contrast, `squad doctor` is thoroughly documented in Module 1 with full expected output. If `squad status` is a real command, it needs the same treatment. If it isn't, it should be replaced by `squad doctor`.

**Fix:** Replace `squad status` with `squad doctor` in Module 2, or — if `squad status` is a valid, distinct command — add a note showing expected output and what PASS/FAIL looks like.

---

## 6. Gaps (Missing from Implementation)

### 6.1 GAP-01 — No README badges despite plan requirement

**Severity:** LOW  
**File:** `README.md`  
**Plan reference:** §2 repo structure comment ("license badge"), §4.1 ("License and Contributing badges / links")  

The plan explicitly calls for badges in the README. The current README has no badges at all — no CI status badge, no license badge.

Two immediately useful badges:

```markdown
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Check links](https://github.com/joslat/squad-workshop/actions/workflows/check-links.yml/badge.svg)](https://github.com/joslat/squad-workshop/actions/workflows/check-links.yml)
```

The license badge is purely cosmetic but signals to a landing visitor what the terms are before reading the bottom of the page. The CI badge provides direct feedback on whether the link-check is currently passing.

**Fix:** Add both badges below the repo tagline in `README.md` (see Phase D).

---

### 6.2 GAP-02 — No platform scope warning (Windows-only content)

**Severity:** MEDIUM  
**Files:** `README.md`, `docs/prerequisites.md`  

Every install command in the workshop uses `winget` (Windows Package Manager). Every shell script is `.ps1` (PowerShell). Module 3 explicitly calls out "Windows-only" only in passing. A macOS or Linux user landing on the repo from, e.g., a tweet would hit `winget` commands and `.ps1` scripts without understanding why they don't work.

The prerequisites page install commands:
- `winget install OpenJS.NodeJS.22` — Windows only
- `winget install Microsoft.DotNet.SDK.9` — Windows only
- `winget install Git.Git` — Windows only
- `winget install GitHub.cli` — Windows only
- `winget install GitHub.Copilot` — Windows only

There is no "Windows/PowerShell required" note anywhere visible from the repo root or the prerequisites page.

**Fix:** Add a platform note to:
1. `README.md` Quick Start section (before the prerequisite table)
2. `docs/prerequisites.md` opening section

Example wording:
> **Platform note:** This workshop uses PowerShell and `winget`. The content and scripts are tested on Windows 11 with PowerShell 7+. On macOS or Linux, install tools using your platform's package manager (`brew`, `apt`, etc.) and adapt `.ps1` commands to your shell; the Squad concepts and prompts apply on any platform.

---

### 6.3 GAP-03 — CONTRIBUTING.md doesn't declare contribution license

**Severity:** LOW  
**File:** `CONTRIBUTING.md`  

Standard practice for open source repos is to clarify that contributions are submitted under the project's license. `CONTRIBUTING.md` is otherwise thorough but doesn't include this line.

**Fix:** Add a brief note at the bottom of `CONTRIBUTING.md`:
```
## License

By contributing to this repository, you agree that your contributions will be licensed
under the [Apache License 2.0](LICENSE) that covers this project.
```

---

### 6.4 GAP-04 — Module 1 has no return link in the footer

**Severity:** LOW  
**File:** `modules/01-basic.md`  

Module 2 and Module 3 both have `← Back to [Workshop Index](../README.md)` in their **header** navigation. Module 1 also has it in the header. However, Module 1's footer only has a forward link to Module 2:

> If you want to test whether the persistent memory actually compounds... continue to **[Module 2 — Intermediate](02-intermediate.md)**.

There is no `← Back to [Workshop Index](../README.md)` link in the Module 1 footer. Modules 2 and 3 both have the back link in the header (which is above the content). On a long page, a reader who scrolled to the bottom of Module 1 has no easy navigation back to the workshop index without scrolling all the way up.

**Fix:** Add a footer nav line to `modules/01-basic.md` after the Module 2 forward link:
```markdown
← Back to [Workshop Index](../README.md)
```

---

### 6.5 GAP-05 — Version maintenance policy not documented

**Severity:** LOW  
**Files:** `CONTRIBUTING.md`, `docs/prerequisites.md`  

The workshop pins specific minimum versions for all tools. The plan (§11, Q5) says to "update CHANGELOG when newer versions are tested" but there's no guidance in `CONTRIBUTING.md` about *how* to update versions. The PR checklist mentions updating `scripts/Verify-Prerequisites.ps1` and `docs/prerequisites.md` if minimum versions change, which is good. However:

1. There's no guidance on *who decides* when a version bump is appropriate (just "tool releases a new version" isn't enough — the workshop needs to test it first)
2. There's no guidance on what triggers a version bump vs. a patch note

**Fix:** Add a short "Updating minimum tool versions" section to `CONTRIBUTING.md` with the checklist of files to update and the expectation that the step that uses the new version has been verified.

---

## 7. Critical: .NET 9 End-of-Life Assessment

### 7.1 EOL timeline and risk

**.NET release lifecycle summary (relevant versions):**

| Version | Type | Released | Supported Until |
|---|---|---|---|
| .NET 8 | LTS | Nov 2023 | Nov 2026 |
| .NET 9 | STS | Nov 2024 | **~May 2026** ⚠️ |
| .NET 10 | LTS | Nov 2025 | Nov 2028 |

**.NET 9 is Standard Term Support (STS):** 18 months from release. Released November 2024 → support expires approximately **May 2026**.

**Current date: May 8, 2026.** .NET 9 is at or past its end-of-life date.

**Implications for the workshop:**

1. **Security:** Microsoft will not release security patches for .NET 9 after EOL. A workshop that instructs learners to install `.NET SDK 9.0.0` is directing them to install a runtime with no security updates.

2. **Install friction:** The `winget install Microsoft.DotNet.SDK.9` command may start returning deprecation warnings or may redirect users to .NET 10. Learners following the workshop will face confusing error states.

3. **Verify script false passes:** `scripts/Verify-Prerequisites.ps1` checks `[int]$Matches[1] -ge 9`, meaning .NET 9.x will PASS the check — even after EOL, even if the learner should be on .NET 10.

4. **Reputation:** A workshop that teaches on an EOL runtime signals poor maintenance. First-time learners may not catch this and proceed with a false confidence in the stack they're learning.

**Recommendation: Upgrade to .NET 10 LTS.** This is strongly recommended, not optional:

- .NET 10 is LTS with support through November 2028
- It is backward-compatible with .NET 9 minimal APIs (no learner code changes required in the workshop prompts themselves — the AI team generates the code)
- The only changes needed are in documentation strings, the prereq checker script, and the prerequisite install commands

### 7.2 Scope of changes for .NET 10 upgrade

**Files with `.NET 9` references (17 occurrences found):**

| File | Occurrences | Change type |
|---|---|---|
| `README.md` | 3 | Text: "`.NET 9`" → "`.NET 10`" |
| `modules/01-basic.md` | 5 | Text + code prompts: "`.NET 9`" → "`.NET 10`" |
| `docs/prerequisites.md` | 3 | Summary table min version, section heading, winget command |
| `scripts/Verify-Prerequisites.ps1` | 1 | Version check threshold: `-ge 9` → `-ge 10`; fix message text |
| `CHANGELOG.md` | 1 | Historical entry text update + new Unreleased entry |
| `docs/SQUAD-WORKSHOP-STANDALONE-PLAN.md` | 3 | Plan document text (lower priority — this is reference/history) |

**Modules 02 and 03:** No explicit `.NET 9` text references found. No changes needed in those files.

**`Verify-Prerequisites.ps1` check logic correction:**

Current:
```powershell
# --- 2. .NET SDK ---
$dotnetRaw = dotnet --version 2>&1
$dotnetOk  = $false
if ($dotnetRaw -match '^(\d+)\.') {
    $dotnetOk = [int]$Matches[1] -ge 9
}
$r = Test-Result '.NET SDK' $dotnetOk ($dotnetRaw -join '') '9.0.0+' `
    'winget install Microsoft.DotNet.SDK.9 --accept-source-agreements --accept-package-agreements'
```

After upgrade:
```powershell
# --- 2. .NET SDK ---
$dotnetRaw = dotnet --version 2>&1
$dotnetOk  = $false
if ($dotnetRaw -match '^(\d+)\.') {
    $dotnetOk = [int]$Matches[1] -ge 10
}
$r = Test-Result '.NET SDK' $dotnetOk ($dotnetRaw -join '') '10.0.0+' `
    'winget install Microsoft.DotNet.SDK.10 --accept-source-agreements --accept-package-agreements'
```

---

## 8. Implementation Plan — Ordered Fix Steps

Fixes are ordered by risk and dependency. Phase A must be done before anything else because BUG-01 and BUG-04 affect the same Step 0 block. Phases B–D are independent and can be done in any order after Phase A.

---

### Phase A: Critical bug fixes (do first)

**A-1. Fix Steps 0b + 0c in `modules/01-basic.md` (BUG-01 + BUG-04)**

The two bugs interact: Step 0b runs `gh repo create --push` on an empty repo, and Step 0c pushes with `master`. The fix reorders and merges the two steps into a coherent sequence.

**Current steps 0b and 0c:**
```
### 0b. Create a GitHub repo and set origin
gh repo create reading-list-squad-lab --public --source . --push

### 0c. Create a minimal README and push
@"....."@ | Set-Content README.md
git add README.md
git commit -m "initial commit: project description"
git push -u origin master
```

**Replace with:**
```markdown
### 0b. Create a minimal README and make the first commit

```powershell
@"
# Reading List Squad Lab

A personal reading list app built as a Squad workshop exercise.

- .NET 10 minimal API backend
- React + TypeScript frontend
- SQLite or in-memory storage
"@ | Set-Content README.md

git add README.md
git commit -m "initial commit: project description"
```

### 0c. Create the GitHub repo and push

```powershell
gh repo create reading-list-squad-lab --public --source . --push
```

> This creates the GitHub repo, links it as `origin`, and pushes your initial commit in one command. If the repo already exists:
> ```powershell
> git remote add origin https://github.com/<your-username>/reading-list-squad-lab.git
> git push -u origin HEAD
> ```
```

Key changes:
- README creation and first commit happen in Step 0b (before the remote is created)
- `gh repo create --push` is now Step 0c and pushes the already-committed README
- `git push -u origin master` is removed; `gh repo create --push` handles the initial push
- Fallback `git push` uses `HEAD` instead of `master`

**A-2. Fix prerequisite script path in `modules/01-basic.md` (BUG-03)**

Change:
```powershell
..\scripts\Verify-Prerequisites.ps1
```
To:
```powershell
.\scripts\Verify-Prerequisites.ps1
```

**A-3. Fix prerequisite script path in `docs/prerequisites.md` (BUG-02)**

Change the opening blockquote from:
```
> Run `../scripts/Verify-Prerequisites.ps1` from the repo root to check all tools in one pass.
```
To:
```
> Run `.\scripts\Verify-Prerequisites.ps1` from the repo root to check all tools in one pass.
```

---

### Phase B: .NET 10 upgrade

Apply all changes in this order to avoid partial states:

**B-1. Update `scripts/Verify-Prerequisites.ps1`**

Change the `.NET SDK` check block:

```powershell
# Change the threshold from -ge 9 to -ge 10
$dotnetOk = [int]$Matches[1] -ge 10

# Change the required version label
$r = Test-Result '.NET SDK' $dotnetOk ($dotnetRaw -join '') '10.0.0+' `
    'winget install Microsoft.DotNet.SDK.10 --accept-source-agreements --accept-package-agreements'
```

**B-2. Update `docs/prerequisites.md`**

- Summary table: Change `9.0.0` → `10.0.0`, change `winget install Microsoft.DotNet.SDK.9` → `winget install Microsoft.DotNet.SDK.10`
- Section heading: Change `### 2. .NET 9 SDK or later` → `### 2. .NET 10 SDK or later`
- Body: Change `**Expected:** \`9.x.x\` or later (e.g. \`10.0.102\`)` → `**Expected:** \`10.x.x\` or later (e.g. \`10.0.100\`)`
- Install command: Change `winget install Microsoft.DotNet.SDK.9` → `winget install Microsoft.DotNet.SDK.10`
- This also resolves INC-02 (version confusion).

**B-3. Update `README.md`**

Three changes:
1. Intro paragraph: `.NET 9 + React app` → `.NET 10 + React app`
2. What you'll build list: `.NET 9 minimal API backend` → `.NET 10 minimal API backend`
3. Module 1 row in the module table: `A working .NET 9 + React reading list app` → `A working .NET 10 + React reading list app`
4. Quick start prerequisite table: `.NET SDK | 9.0.0` → `.NET SDK | 10.0.0`

**B-4. Update `modules/01-basic.md`**

Five changes (all `.NET 9` → `.NET 10`):
1. Goal section: `A .NET 9 minimal API backend` → `A .NET 10 minimal API backend`
2. Prereq table: `.NET SDK | 9.0.0` → `.NET SDK | 10.0.0`
3. README content in Step 0b: `.NET 9 minimal API backend` → `.NET 10 minimal API backend`
4. Step 2 team setup prompt: `Stack: .NET 9 minimal API` → `Stack: .NET 10 minimal API`
5. Step 4 build prompt: `Backend: .NET 9 minimal API endpoint` (×2) → `Backend: .NET 10 minimal API endpoint`

**B-5. Update `CHANGELOG.md`**

Add under `## [Unreleased]`:
```markdown
## [Unreleased]

### Changed
- Upgraded all .NET 9 references to .NET 10 LTS — .NET 9 STS reached end-of-life in May 2026.
  Minimum .NET SDK version is now 10.0.0. Update the SDK and run `.\scripts\Verify-Prerequisites.ps1`
  to verify.
```

Update the v1.0.0 historical entry:
```markdown
- Module 1 — Basic: build a .NET 10 + React reading list app with Squad end-to-end (~90 min)
```
*(This reflects the current state of the module, not the historical state at release. Adjust if you prefer to preserve the historical `.NET 9` text.)*

---

### Phase C: Inconsistency fixes

**C-1. Fix `squad status` in `modules/02-intermediate.md` (INC-03)**

Change:
```powershell
squad status     # confirm the squad is active
```
To:
```powershell
squad doctor     # confirm setup is healthy
```

If `squad status` is a valid, distinct command that returns a different kind of output from `squad doctor`, keep it but add expected-output documentation similar to Module 1 Step 0f. Without verification that `squad status` exists and works, the safe fix is to replace it with the well-documented `squad doctor`.

**C-2. Update plan document `SQUAD-WORKSHOP-STANDALONE-PLAN.md` to reflect Apache 2.0 (INC-01)**

In the plan's §3.2 table row for `LICENSE`:
- Change `MIT license, copyright \`joslat\`` to `Apache License 2.0, copyright joslat`

In the plan's §4.1 description, if "license/contributing links" mention MIT, update to Apache 2.0.

*(This is a plan document update for historical accuracy, not a user-facing fix.)*

---

### Phase D: Gap fills

**D-1. Add README badges (GAP-01)**

Add immediately after the tagline blockquote in `README.md`:

```markdown
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Check links](https://github.com/joslat/squad-workshop/actions/workflows/check-links.yml/badge.svg)](https://github.com/joslat/squad-workshop/actions/workflows/check-links.yml)
```

**D-2. Add platform scope note (GAP-02)**

In `README.md`, Quick Start section, add before the prerequisites table:

```markdown
> **Platform note:** This workshop uses PowerShell 7+ and `winget` (Windows Package Manager). Scripts and install commands are tested on Windows 11. On macOS or Linux, use your platform's package manager (`brew`, `apt`, etc.) and adapt `.ps1` scripts to your shell. The Squad concepts, prompts, and module steps apply on any platform.
```

In `docs/prerequisites.md`, add the same note after the opening blockquote (after the `> Run .\scripts\...` line).

**D-3. Add contribution license note to `CONTRIBUTING.md` (GAP-03)**

Add at the end of `CONTRIBUTING.md`:

```markdown
## License

By contributing to this repository, you agree that your contributions will be licensed under
the [Apache License 2.0](LICENSE) that covers this project.
```

**D-4. Add footer back-link to `modules/01-basic.md` (GAP-04)**

At the very end of `modules/01-basic.md`, after the existing forward link to Module 2, add:

```markdown
← Back to [Workshop Index](../README.md)
```

**D-5. Add version maintenance guidance to `CONTRIBUTING.md` (GAP-05)**

Add a new section "Updating minimum tool versions" to `CONTRIBUTING.md` (before the "What this repo is not" section):

```markdown
## Updating minimum tool versions

When a tool releases a version that makes an older version incompatible with the workshop steps, a version bump is warranted. Before opening a PR:

1. Verify the specific step that is broken works correctly on the new minimum version.
2. Update all four locations consistently:
   - `docs/prerequisites.md` — summary table and detail install command
   - `modules/01-basic.md` — prerequisites table
   - `scripts/Verify-Prerequisites.ps1` — version check threshold and fix message
   - `README.md` — Quick Start prerequisites table
3. Add a note to `CHANGELOG.md` under `## Unreleased`.
4. Do not bump versions proactively for "just released" tool versions — only bump when the old minimum is confirmed broken or insecure.
```

---

### Phase E: Post-fix verification

After all phases are complete, verify:

**E-1. Run `Verify-Prerequisites.ps1`**

```powershell
.\scripts\Verify-Prerequisites.ps1
```

Confirm all tool checks produce PASS with the new .NET 10 threshold. Confirm a .NET 9-only installation would produce FAIL (if testable).

**E-2. Check all internal links**

```powershell
# Manually spot-check, or wait for CI link-check to run
```

Or trigger the CI check by pushing to `main` / opening a PR.

**E-3. Trace Module 1 Steps 0a–0e mentally**

Walk through the revised Step 0 flow:
- 0a: `mkdir + cd + git init`
- 0b: Create README + commit (no remote yet)
- 0c: `gh repo create --push` (remote created, README pushed)
- 0d: `squad init`
- 0e: `git add -A + commit + push`

Confirm no orphaned `git push` commands remain with hardcoded `master`.

**E-4. Search for any remaining `.NET 9` references**

```powershell
Select-String -Path "README.md","modules\*.md","docs\*.md","scripts\*.ps1" -Pattern "\.NET 9|SDK\.9|SDK\.9" | Select-Object Path, LineNumber, Line
```

Should return zero matches (only the plan document `SQUAD-WORKSHOP-STANDALONE-PLAN.md` is allowed to retain `.NET 9` references as historical context).

**E-5. Verify `CHANGELOG.md` `## Unreleased` section is updated**

Confirm the .NET 10 upgrade note is present under `## Unreleased`.

---

## 9. What Is Working Well

To balance the findings above — the following elements are genuinely well-executed and should be preserved as-is:

| Element | Why it's good |
|---|---|
| `scripts/Verify-Prerequisites.ps1` | Robust version parsing, non-zero exit code for CI use, clean PASS/FAIL output, per-item fix suggestions. |
| `.github/ISSUE_TEMPLATE/broken-step.yml` | Goes beyond the plan's spec — adds a placeholder example for the "what happened" field, adds "anything else" field. |
| `docs/troubleshooting.md` | Every planned entry is present; the `ralph-stop` file troubleshooting note is specific and actionable. |
| Module 3 honesty | The module openly documents that `squad aspire` gives a misleading `✓` when Docker isn't running. Documenting tool gotchas honestly builds learner trust. |
| Module 2 Step 9 "AI confetti" test | The explicit "what good looks like" vs. "what AI confetti looks like" framing for artifact inspection is a standout piece of workshop writing. |
| Navigation link structure | All `../README.md`, `01-basic.md`, `02-intermediate.md`, `03-advanced.md` relative links are correct across all three modules. |
| Squad CLI version-pinning with `squad doctor` expected output | Pinning at `0.9.4+` and showing the exact `9 passed, 0 failed, 0 warnings, 2 info` output gives a precise "you're good" signal. |
| `.github/mlc_config.json` extras | Added `retryOn429: true` and `retryCount: 2` beyond the plan's spec — good defensive practice for the link checker. |
| Module 1 `/allow-all` note | Correctly explains the tradeoff between safety and workflow friction; doesn't pretend `--yolo` is the default or encourage it uncritically. |

---

## 10. Risk Register

| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R1 | `squad` CLI release changes `squad doctor` expected output | High (living tool) | Low (workshop step has caveat text) | Track Squad CHANGELOG; update expected output on confirmed breakage |
| R2 | Copilot CLI changes the `/model` or `/allow-all` command syntax | Medium | Medium (Module 1 Step 1) | Update module when confirmed broken; add note in troubleshooting |
| R3 | Node.js 22 EOL (April 2027) | Low (within 1 year) | Medium | Upgrade to Node 24 LTS when Node 22 EOL approaches |
| R4 | GitHub CLI `gh repo create` flag changes | Low | Medium (Module 1 Step 0c) | Note in troubleshooting if `--push` behaviour changes |
| R5 | `squad triage --health` or `squad loop` commands removed/renamed | Low | Low (optional module) | Module 3 is explicitly optional; flag as informational |
| R6 | `.NET 10` winget package ID differs from `Microsoft.DotNet.SDK.10` | Low | Medium | Verify winget ID before publishing Phase B fixes |

---

*End of review. Total issues identified: 4 bugs, 3 inconsistencies, 5 gaps, 1 critical upgrade recommendation.*  
*Highest priority actions: Phase A (BUG-01, BUG-02, BUG-03) and Phase B (.NET 10 upgrade).*
