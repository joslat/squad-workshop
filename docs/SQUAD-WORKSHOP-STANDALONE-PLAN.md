# Plan: Squad Workshop — Standalone Repository

> **Status:** Draft — ready for review  
> **Goal:** Extract the Squad Workshop from `agent-memory-dotnet` into a fully self-contained public repository that can stand alone as a learner resource.

---

## 1. Repository Identity

### Name

**`squad-workshop`**

Rationale: clean, lowercase, immediately searchable, matches the `@bradygaster/squad-cli` naming style. No framework prefix is needed because the workshop is *about Squad*, not about .NET — .NET is just what you build with it.

Alternatives considered and rejected:

| Candidate | Reason rejected |
|---|---|
| `dotnet-squad-workshop` | Implies Squad is a .NET tool — it isn't |
| `squad-lab` | Vague, clashes with `reading-list-squad-lab` (the lab repo built *during* the workshop) |
| `learn-squad` | Marketing-y, not dev-first |
| `squad-cli-workshop` | Redundant — Squad is always CLI |

---

### Short description (GitHub repo subtitle, ≤ 100 chars)

Primary (recommended):
```
Workshop: assemble your AI dev team with Squad and ship a full-stack app in minutes.
```

Alt A (action-first, slightly longer):
```
Learn to build, instruct, and manage your AI dev team with Squad — ship apps by giving orders.
```

Alt B (superpower hook):
```
Squad superpowers: create your AI team, give orders, ship a full-stack app in minutes.
```

Alt C (workshop-forward):
```
Hands-on: use Squad's full power to spin up an AI dev team and ship production code fast.
```

> **Recommendation:** use the primary. It signals *workshop* (learner intent), *assemble your AI dev team* (Squad's core value prop — roles, memory, routing), and *ship in minutes* (the payoff). Under 90 chars so it fits the GitHub About field without truncation.
>
> The key ideas present across all options: (1) it's a *workshop that teaches*, (2) you *create and manage* the team, (3) you *give orders* rather than write prompts, (4) the result is *shipping a full-stack app fast*.

---

### Long description (README intro / GitHub About)

```
You've used AI assistants. You've pasted context fifty times. You've re-explained
the architecture to a new chat window.

Squad is different. It gives your repo a resident team — Lead, Backend Engineer,
Frontend Engineer, Tester — with persistent memory, specialist roles, and a routing
layer that sends work to the right agent automatically. One session, real decisions,
compounding context.

This workshop is the fastest honest way to find out whether it actually changes how
you work. In three self-contained modules (~3 hours total) you build a real .NET 9 +
React app from scratch using the team, record an architectural decision through them,
run a regression-aware second feature to test whether memory compounds, and — if you
want to go further — observe live telemetry with .NET Aspire and hand autonomous
issue triage to Ralph.

You don't need to finish all three. Complete Module 1 and you'll have a working app
and a concrete answer to "does Squad earn its place in my workflow?"
```

---

### GitHub topics (tags)

```
squad  ai-agents  copilot  dotnet  workshop  hands-on  cli  ai-team  llm
```

---

## 2. Repository Structure

```
squad-workshop/
│
├── README.md                           # Landing page — overview, module table,
│                                       #   what you build, quick prereq summary,
│                                       #   "start here" links, license badge
│
├── LICENSE                             # Apache 2.0
│
├── CONTRIBUTING.md                     # How to file issues for broken steps,
│                                       #   propose new modules, submit fixes
│
├── CHANGELOG.md                        # Workshop version history
│
├── .gitignore                          # IDE artifacts, OS junk, no source code
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── broken-step.yml             # Structured form: which module, which step,
│   │   │                               #   what failed, tool versions
│   │   ├── feedback.yml                # Post-module experience report
│   │   └── config.yml                  # Disable blank issues, link to discussions
│   ├── PULL_REQUEST_TEMPLATE.md        # Contributor PR checklist
│   └── workflows/
│       └── check-links.yml             # markdown-link-check on push/PR to main
│
├── modules/
│   ├── 01-basic.md                     # Module 1 — ~90 min — Build the app
│   ├── 02-intermediate.md              # Module 2 — ~45 min — Compound memory
│   └── 03-advanced.md                  # Module 3 — ~60 min — Aspire + Ralph
│
├── scripts/
│   └── Verify-Prerequisites.ps1        # Standalone prereq checker extracted
│                                       #   from Module 1 (runnable before opening
│                                       #   any module file)
└── docs/
    ├── prerequisites.md                # Full prerequisites page (all tools, all
    │                                   #   versions, all install commands) — also
    │                                   #   linked from README and Module 1
    └── troubleshooting.md              # Common failure patterns and fixes
```

### Rationale for `modules/` subfolder

Keeps the repo root clean. The root is the *entry point* (README.md) — not the workshop itself. Learners start at `README.md`, which links into `modules/`. Internal navigation between modules stays one-level relative (`../modules/02-intermediate.md`), which is trivial.

---

## 3. Content Inventory and Migration Map

### 3.1 Files to migrate (with modifications)

| Source (current) | Destination (new repo) | Modifications needed |
|---|---|---|
| `Workshop/README.md` | `README.md` | Expand into a full landing page. Add badges, repo description, "What is Squad?", "What you'll build", quick prereq table, license/contributing links. Remove any implicit reference to `agent-memory-dotnet`. |
| `Workshop/01-basic.md` | `modules/01-basic.md` | Update nav links. Extract prereq section into `docs/prerequisites.md` + keep a summary + link. Extract verification script into `scripts/Verify-Prerequisites.ps1`. |
| `Workshop/02-intermediate.md` | `modules/02-intermediate.md` | Update nav links only. |
| `Workshop/03-advanced.md` | `modules/03-advanced.md` | Update nav links only. |

### 3.2 Files to create from scratch

| File | Content description |
|---|---|
| `LICENSE` | Apache 2.0 license, copyright `joslat` |
| `CONTRIBUTING.md` | Contribution guide — filing broken-step issues, fixing typos, proposing new modules, testing changes before PRs |
| `CHANGELOG.md` | Initial `v1.0.0` entry — "Initial release: three modules extracted from agent-memory-dotnet" |
| `.gitignore` | VS Code settings, OS files (`.DS_Store`, `Thumbs.db`), no source exclusions (repo has no source) |
| `.github/ISSUE_TEMPLATE/broken-step.yml` | Structured broken-step reporter |
| `.github/ISSUE_TEMPLATE/feedback.yml` | Post-completion feedback form |
| `.github/ISSUE_TEMPLATE/config.yml` | Disable blank issues |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR checklist: tested the step, links valid, no personal data |
| `.github/workflows/check-links.yml` | Run `markdown-link-check` on PRs and pushes to `main` |
| `scripts/Verify-Prerequisites.ps1` | Extracted and standalone version of the prereq script from Module 1 |
| `docs/prerequisites.md` | Full prerequisites reference — all 8 tools, all versions, all install commands — usable as a preflight before opening any module |
| `docs/troubleshooting.md` | Common failure scenarios with exact error text and fixes |

---

## 4. Content Changes Required

### 4.1 README.md (landing page rewrite)

The current `Workshop/README.md` is a module index, not a repo landing page. The new `README.md` must include:

- **Repo name + tagline** in the H1
- **What Squad is** — one short paragraph so someone landing cold understands the subject matter
- **What you'll build** — the Personal Reading List app, .NET 9 + React
- **Module table** — keep the existing table exactly, update links to `modules/`
- **Prerequisites summary** — a one-line-per-tool table (Node 22.5+, .NET 9+, etc.) with a link to `docs/prerequisites.md`
- **Quick start** — "Clone, run the verify script, open Module 1"
- **License and Contributing** badges / links
- **Honest scope note** — keep the existing callout: "Modules 1 and 2 are the workshop; Module 3 is a guided tour of riskier corners"

### 4.2 Navigation link fixes

Every module file has header/footer nav links that currently use flat relative paths (`01-basic.md`, `README.md`). After moving to `modules/`, these become:

| Current | Updated |
|---|---|
| `← Back to [Workshop Index](README.md)` | `← Back to [Workshop Index](../README.md)` |
| `[← Module 1 (Basic)](01-basic.md)` | `[← Module 1 (Basic)](01-basic.md)` *(same folder — unchanged)* |
| `[Module 2 — Intermediate](02-intermediate.md)` | `[Module 2 — Intermediate](02-intermediate.md)` *(same folder — unchanged)* |

In `README.md` module table, links change from `01-basic.md` to `modules/01-basic.md`.

### 4.3 Prerequisite extraction (Module 1 → `docs/prerequisites.md`)

Module 1 currently contains the full prerequisite list inline. It should be shortened to a summary table linking to `docs/prerequisites.md` for the full detail. This avoids the wall of install commands appearing before the "what you'll build" narrative.

Module 1 summary replacement:

> See [docs/prerequisites.md](../docs/prerequisites.md) for full install instructions. Run `scripts/Verify-Prerequisites.ps1` to check all tools in one pass before continuing.

### 4.4 Script extraction (Module 1 → `scripts/Verify-Prerequisites.ps1`)

The inline PowerShell snippet in Module 1 becomes a proper `.ps1` file with:

- A header comment block explaining what it checks
- The same version check logic
- A final summary that shows PASS/FAIL per tool
- A clear exit code (non-zero if any check fails — useful for future CI)

### 4.5 `docs/troubleshooting.md` — content to include

Extracted from inline callouts in the workshop modules. Minimum entries:

| Problem | Mentioned in | Troubleshooting entry |
|---|---|---|
| `squad doctor` false positives | Module 1 | Versions ≤ 0.9.1; upgrade to 0.9.4+ |
| `copilot` not on PATH after install | Module 1 | Restart terminal; PowerShell 7 required |
| `squad aspire` `✓` line lying when Docker is down | Module 3 | Start Docker first; test with `docker info` |
| Aspire dashboard stays empty | Module 3 | Firewall / Squad version / OTLP not auto-wired |
| `ralph-stop` file blocking next Ralph run | Module 3 | Delete `.squad/ralph-stop` before starting |
| `UnauthorizedAccess` running Squad | Module 1 | Set execution policy to `RemoteSigned` |
| GitHub CLI auth failing in Ralph | Module 3 | Re-run `gh auth login`; check `gh auth status` |

---

## 5. New Content: `docs/prerequisites.md`

Standalone full prerequisites page. Structure:

```markdown
# Prerequisites

> Run `../scripts/Verify-Prerequisites.ps1` to check all tools in one pass.

## Summary

| Tool | Minimum version | Check command | Install |
|---|---|---|---|
| Node.js | 22.5.0 | `node --version` | `winget install OpenJS.NodeJS.22` |
| .NET SDK | 9.0.0 | `dotnet --version` | `winget install Microsoft.DotNet.SDK.9` |
| Git | any recent | `git --version` | `winget install Git.Git` |
| GitHub CLI | 2.89.0 | `gh version` | `winget install GitHub.cli` |
| GH auth | logged in | `gh auth status` | `gh auth login` |
| GitHub Copilot CLI | 1.0.24 | `copilot --version` | `winget install GitHub.Copilot` |
| Squad CLI | 0.9.4 | `squad --version` | `npm i -g @bradygaster/squad-cli` |
| PS exec policy | RemoteSigned | `Get-ExecutionPolicy -Scope CurrentUser` | `Set-ExecutionPolicy ...` |

## Detailed install instructions
[...same as current Module 1 content, verbatim...]
```

---

## 6. New Content: `.github/ISSUE_TEMPLATE/broken-step.yml`

Structured issue template so filed bugs are immediately actionable:

```yaml
name: Broken step
description: Report a step in the workshop that failed or gave unexpected results
labels: ["bug", "workshop-content"]
body:
  - type: dropdown
    id: module
    attributes:
      label: Module
      options: ["1 — Basic", "2 — Intermediate", "3 — Advanced"]
    validations:
      required: true
  - type: input
    id: step
    attributes:
      label: Step number or heading
    validations:
      required: true
  - type: textarea
    id: what-happened
    attributes:
      label: What happened
      description: Paste the exact command, error output, or unexpected behavior
    validations:
      required: true
  - type: textarea
    id: tool-versions
    attributes:
      label: Tool versions
      description: Paste the output of scripts/Verify-Prerequisites.ps1
    validations:
      required: true
  - type: input
    id: os
    attributes:
      label: OS and terminal
      placeholder: "e.g. Windows 11, PowerShell 7.4"
    validations:
      required: true
```

---

## 7. New Content: `.github/workflows/check-links.yml`

```yaml
name: Check links

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check-links:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: gaurav-nelson/github-action-markdown-link-check@v1
        with:
          use-quiet-mode: 'yes'
          config-file: '.github/mlc_config.json'
```

Also requires `.github/mlc_config.json` to ignore `localhost` links in the Aspire module:

```json
{
  "ignorePatterns": [
    { "pattern": "^http://localhost" }
  ]
}
```

---

## 8. GitHub Repository Setup Checklist

When creating the repo on GitHub, apply these settings:

| Setting | Value |
|---|---|
| Visibility | Public |
| License | Apache 2.0 |
| Default branch | `main` |
| Topics | `squad`, `ai-agents`, `copilot`, `dotnet`, `workshop`, `hands-on`, `cli` |
| About → Description | *short description from §1* |
| About → Website | *(leave blank or point to a future docs site)* |
| Issues | Enabled |
| Discussions | Enabled — for Q&A and async help |
| Wiki | Disabled (docs live in repo) |
| Packages | Disabled |
| Branch protection on `main` | Require PR + 1 review (or just status checks if solo) |

---

## 9. Execution Plan — Ordered Steps

### Phase 1: Prepare content locally

- [ ] **1.1** Clone or create the new repo folder locally (`mkdir squad-workshop && cd squad-workshop && git init`)
- [ ] **1.2** Copy the four workshop files as a starting point:
  - `Workshop/README.md` → `README.md`
  - `Workshop/01-basic.md` → `modules/01-basic.md`
  - `Workshop/02-intermediate.md` → `modules/02-intermediate.md`
  - `Workshop/03-advanced.md` → `modules/03-advanced.md`
- [ ] **1.3** Rewrite `README.md` as a full landing page (§4.1)
- [ ] **1.4** Update nav links in all three module files (§4.2)
- [ ] **1.5** Extract prereq section from `modules/01-basic.md` into `docs/prerequisites.md` (§4.3 and §5) and replace with summary + link
- [ ] **1.6** Extract verification script from Module 1 into `scripts/Verify-Prerequisites.ps1` (§4.4) and replace inline with a link
- [ ] **1.7** Write `docs/troubleshooting.md` from the inline callouts across all three modules (§4.5)

### Phase 2: Create repo boilerplate

- [ ] **2.1** Create `LICENSE` (Apache 2.0)
- [ ] **2.2** Create `CONTRIBUTING.md`
- [ ] **2.3** Create `CHANGELOG.md` with initial v1.0.0 entry
- [ ] **2.4** Create `.gitignore`
- [ ] **2.5** Create `.github/ISSUE_TEMPLATE/broken-step.yml` (§6)
- [ ] **2.6** Create `.github/ISSUE_TEMPLATE/feedback.yml`
- [ ] **2.7** Create `.github/ISSUE_TEMPLATE/config.yml`
- [ ] **2.8** Create `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] **2.9** Create `.github/workflows/check-links.yml` + `mlc_config.json` (§7)

### Phase 3: Create the GitHub repository

- [ ] **3.1** Create the GitHub repo:
  ```powershell
  gh repo create squad-workshop --public --description "Hands-on workshop: build a full-stack app with Squad, your repo-native AI team." --source . --push
  ```
- [ ] **3.2** Apply topics via GitHub CLI:
  ```powershell
  gh api repos/{owner}/squad-workshop/topics --method PUT --field "names[]=squad" --field "names[]=ai-agents" --field "names[]=copilot" --field "names[]=dotnet" --field "names[]=workshop" --field "names[]=hands-on" --field "names[]=cli"
  ```
- [ ] **3.3** Enable Discussions in GitHub UI (Settings → General → Discussions)
- [ ] **3.4** Configure branch protection on `main`
- [ ] **3.5** Verify the CI link-check action passes on the initial push

### Phase 4: Post-launch hygiene

- [ ] **4.1** Walk through Module 1 yourself from the new repo, following every step verbatim — this is a full smoke test of the content end-to-end
- [ ] **4.2** Walk through at least the first two steps of Module 2 to confirm the prerequisites carry correctly
- [ ] **4.3** File a test issue using the `broken-step` template to confirm it renders correctly
- [ ] **4.4** Update `Workshop/README.md` in `agent-memory-dotnet` to add a note pointing to the new standalone repo: "The workshop has a dedicated home at [squad-workshop](https://github.com/<owner>/squad-workshop)"

---

## 10. What This Repository Is Not

State this explicitly in `README.md` and `CONTRIBUTING.md` to manage expectations:

- It is **not** an official Squad repository (Squad is maintained at `@bradygaster/squad-cli`)
- It is **not** part of the `agent-memory-dotnet` project (which is about Neo4j-backed agent memory for .NET)
- It is **not** a template for what you build during the workshop (the lab repo `reading-list-squad-lab` is created live during Module 1 and is ephemeral)
- It is **not** a fork or repackaging of Squad itself

---

## 11. Open Questions (resolve before Phase 1)

| # | Question | Options | Recommendation |
|---|---|---|---|
| Q1 | GitHub owner — personal account or org? | Personal (`joslat`) vs. a new org | Personal for now; easy to transfer to an org later |
| Q2 | Keep modules in `modules/` or at repo root? | `modules/` (proposed) vs. root flat | `modules/` — root stays clean |
| Q3 | Discussions vs. GitHub Issues for Q&A? | Issues only vs. Issues + Discussions | Both — Issues for bugs, Discussions for questions |
| Q4 | Should the link-checker CI be mandatory (blocking) or advisory? | Required status check vs. informational | Informational at first; promote to required after first clean run |
| Q5 | Version-pin Squad CLI in the workshop? | Pin `0.9.4` vs. always "latest" | Pin the *minimum* (`0.9.4+`) with "or later", and update CHANGELOG when newer versions are tested |

---

## 12. Success Criteria

The new repository is complete when:

1. A developer who has never heard of this workshop can land on `README.md`, understand what Squad is and what they'll build, run the verify script, and start Module 1 — without reading any other file first.
2. All internal links resolve (CI check is green).
3. Module 1 can be completed end-to-end from the new repo without referencing anything from `agent-memory-dotnet`.
4. All open questions in §11 are resolved.
5. The `agent-memory-dotnet` Workshop folder links back to the new repo.
