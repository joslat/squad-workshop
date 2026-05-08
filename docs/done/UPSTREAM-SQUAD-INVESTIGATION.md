# Upstream Squad Repository Investigation

> Assessment of `bradygaster/squad` — learning resources, agent files, Ralph capabilities and limitations, and current open issues relevant to this workshop.
>
> **Investigated:** May 2026 — Squad CLI v0.9.4 (main branch)  
> **Official docs site:** https://bradygaster.github.io/squad/  
> **Status:** ✅ COMPLETE — findings applied to `docs/troubleshooting.md` and all three modules. Archived to `docs/done/`.

---

## Table of Contents

1. [Learning Resources in the Upstream Repo](#1-learning-resources-in-the-upstream-repo)
2. [Agent Files — What Squad Uses to Manage Itself](#2-agent-files--what-squad-uses-to-manage-itself)
3. [Ralph — What Works Today](#3-ralph--what-works-today)
4. [Ralph — Current Limitations](#4-ralph--current-limitations)
5. [Open Issues Affecting Workshop Learners](#5-open-issues-affecting-workshop-learners)
6. [Other Notable Open Issues](#6-other-notable-open-issues)
7. [What to Add to troubleshooting.md](#7-what-to-add-to-troubleshootingmd)
8. [What Can Be Reused or Referenced in This Workshop](#8-what-can-be-reused-or-referenced-in-this-workshop)
9. [Summary Table](#9-summary-table)

---

## 1. Learning Resources in the Upstream Repo

### What exists

The upstream repo has a **full Astro-based documentation site** under `docs/`. The content lives at `docs/src/content/docs/` and is published at https://bradygaster.github.io/squad/.

**Guide section** (`docs/src/content/docs/guide/`):

| File | Size | Content |
|------|------|---------|
| `guide.md` | 22KB | Main comprehensive guide — how to use Squad end to end |
| `sample-prompts.md` | 17KB | Annotated sample prompts learners can copy and adapt |
| `guide/build-autonomous-agent.md` | 15KB | How to build and configure autonomous agents with Squad |
| `guide/faq.md` | 8.6KB | Frequently asked questions, including gotchas |
| `guide/contributing.md` | 9.4KB | Contributor onboarding — local dev setup |
| `guide/extensibility.md` | 5.1KB | How the extension/plugin system works |
| `guide/building-extensions.md` | 3.2KB | How to build a Squad extension |
| `guide/building-resilient-agents.md` | 4.4KB | Patterns for agents that handle failure gracefully |

**Cookbook** (`docs/src/content/docs/cookbook/`):

| File | Size | Content |
|------|------|---------|
| `cookbook/recipes.md` | 7.3KB | Practical recipes: common patterns, prompts, and workflows |

**Other docs sections:**
- `concepts/` — conceptual docs (team model, memory, routing, etc.)
- `features/` — per-feature docs
- `reference/` — API/config reference
- `get-started/` — getting-started guides
- `insider-program.md` — how to get early-access builds

### What does NOT exist in upstream

- **No dedicated workshop** — no step-by-step tutorial, no hands-on lab, no scaffolding for a practice project. The workshop in this repo (`squad-workshop`) is unique and fills a real gap.
- **No `.devcontainer/` or lab scaffolding** — learners building in the upstream repo must set up everything manually.
- **No sample application** — no reference app like the Personal Reading List used in this workshop.
- **No `.github/prompts/` files** — the upstream repo only has `.github/agents/squad.agent.md` and the site docs. No structured debug prompt, no artifact inspection prompt.

### Assessment

The upstream docs are comprehensive reference material, not a learning journey. Learners who try to get started from the upstream docs alone will find clear explanations of concepts but no guided practice. **This workshop's three-module hands-on approach is highly complementary and fills a genuine gap.**

The `sample-prompts.md` and `cookbook/recipes.md` are directly useful to link from workshop modules — they give learners vetted patterns to copy after they've learned the basics.

---

## 2. Agent Files — What Squad Uses to Manage Itself

### `.github/agents/squad.agent.md` (92KB)

This is the **only** agent file in the upstream repo's `.github/agents/` directory. It is the Squad coordinator prompt — the ~92KB file that:

- Defines the coordinator persona (Picard)
- Contains all routing logic, casting algorithms, ceremony definitions
- Houses Ralph's full work-check cycle
- Defines the Scribe integration
- Contains all spawn prompt templates for sub-agents
- Sets all governance rules (branch protection, PR workflow, reviewer logic)

**Key fact for the workshop:** This file is what `squad init` copies into each lab repo as `.github/agents/squad.agent.md`. It is the entire brain of Squad. It is NOT loaded into the workshop repo — it belongs in the *lab* repo.

**Issue #1052** — `squad upgrade` overwrites this file with no merge strategy. Any customizations made in the lab repo are silently destroyed on upgrade.

**Issue #1036** — This file is ~95KB (as of April 2026, now 92KB). It is fully loaded into every session's system prompt. There is a proposal to split it into stubs + on-demand reference files to reduce it to ~35–45KB.

### `.github/copilot-instructions.md` (3KB)

A small always-loaded context file in the upstream Squad repo that gives contributors background on the Squad project itself. Not the same as a user-facing instructions file. Its sentinel check design (detecting when the coordinator has been silently dropped) is relevant for issue #1017.

---

## 3. Ralph — What Works Today

Ralph is Squad's autonomous monitoring persona, activated by `squad triage` (poll once) or `squad loop` (scheduled recurring). Here is what works reliably as of v0.9.4:

### `squad triage`

- Reads open GitHub Issues on the connected repository
- Labels and categorizes issues automatically using the routing table in `.squad/routing.md`
- Adds triage comments to issues explaining priority and assigned area
- Assigns issues to team members when the routing is clear
- Works as a one-shot command: run it, Ralph triages, done

### `squad loop`

- Runs `squad triage` on a schedule using a prompt file (`.squad/loop.md`)
- Useful for ongoing housekeeping: keeping issues labeled, stale issues flagged
- To stop cleanly: `New-Item -Path .squad\ralph-stop -ItemType File`; delete that file before next run
- Reads only GitHub Issues as its work queue — does NOT read chat history

### `squad watch`

- `squad watch` — monitors the repository for activity (issues opened, PRs created)
- `squad watch --board` — monitors a GitHub ProjectV2 board (see limitation in section 4)
- `squad watch --execute` — autonomous mode: Ralph picks up work from issues and executes it (see limitation in section 4)

### General Ralph behavior (reliable)

- Ralph does NOT scan TODO comments in code
- Ralph does NOT invent work
- Ralph does NOT read previous chat sessions
- Ralph processes GitHub Issues as his only work queue
- Ralph can write files, make commits, open PRs — all standard git/GitHub operations
- Ralph respects the `.squad/routing.md` to decide which team member handles what

---

## 4. Ralph — Current Limitations

These are confirmed limitations as of v0.9.4 based on open issues.

### Critical limitations

**`squad watch --execute` uses generic prompt, not specialist charter** (Issue #1081)

When `squad watch --execute` spawns a session to handle a labeled issue (e.g., `squad:bishop`), Ralph spawns with a **generic Ralph prompt**, not Bishop's actual charter. The `squad:{member}` label is used only as a routing filter — it is never injected into the spawn prompt as a role assignment. The spawned agent has no specialist knowledge of who it's supposed to be.

**Impact on workshop:** Module 3 (Advanced) should note this. `squad watch --execute` is not a reliable way to get specialist agent behavior; the spawned session acts as a generic assistant.

**Squad coordinator can be silently dropped in long sessions** (Issue #1017)

The coordinator file (`squad.agent.md`) is ~92KB. In sessions that follow long prior conversations (where a session summary is injected), the summary can consume enough context budget that the coordinator file is silently omitted from the system prompt. When this happens:

- Squad stops routing to team members
- All governance rules (branch protection, PR workflow, reviewer gates) vanish
- The session behaves like vanilla Copilot with no warning
- Direct pushes to `main` can happen

**Impact on workshop:** Add to troubleshooting. Symptom: "Squad feels like regular Copilot." Fix: start a fresh session.

**Context budget starvation after heavy use** (Issue #1037)

After weeks of heavy use, `.squad/` files can grow to 1–3MB (355K–561K tokens). This starves agents of usable context window. Not a workshop-day issue for beginners, but relevant for Module 2 (inspecting artifact quality) and Module 3.

### Moderate limitations

**`squad watch --board` hardcodes `--owner @me`** (Issue #1079)

Only works for personally-owned ProjectV2 boards. Fails silently for org-owned boards.

**No `cancel_agent` tool** (Issue #1012)

If Ralph spawns a sub-agent with the wrong prompt or model, there is no way to stop it. Misfired agents run to completion.

**No checkpoint/resume on timeout**

If a long Ralph session times out (rate limiting, network, model limits), there is no resume capability. Ralph starts from scratch on the next run. Large tasks should be broken into smaller issues.

**`squad upgrade` overwrites squad.agent.md** (Issue #1052)

Running `squad upgrade` after customizing `.github/agents/squad.agent.md` destroys local customizations. No merge strategy exists. Workaround: keep a backup, use a post-upgrade script.

**Personal/global squad fails to auto-detect on Windows** (Issues #984, #1010)

`squad init --global` creates a personal squad at `%APPDATA%\squad`. When `squad init` is then run inside a project, it does not inherit from the global squad on Windows. The `.squad/config.json` `teamRoot` points to the local project, not the global path. Requires manual correction.

Also: the `squad.agent.md` created by `--global` lives in a path Copilot never scans for agent files — so the global agent file is unused. Each repo needs its own copy.

**`parseGitHubRemote` regex bug** (Issue #1077)

`[^/.]` in the regex excludes dots from repo names. Repos named like `my.project` will fail git remote parsing. Workaround: use repo names without dots.

### Minor limitations

**`squad externalize`/`squad internalize` not in `squad --help`** (Issue #1050)

These commands exist and work but are invisible in help output. `squad externalize` moves `.squad/` state out of the working tree (for non-git integration scenarios).

**`squad new agent` doesn't update `squad.config.ts`** (Issue #1047)

Running `squad new agent` creates the agent charter file but doesn't register it in `squad.config.ts`, so the next `squad build` loses the new agent.

**`squad build` ignores `squad externalize` location** (Issue #1048)

Files generated by `squad build` go to the original location even after `squad externalize` was run.

**Rate limiting causes agent failures** (Issue #992)

On Copilot Pro+ plans (1,500 premium requests/month), heavy multi-agent sessions can exhaust the budget. Multiple concurrent agents on the same task can hit rate limits mid-execution. No retry or graceful degradation.

---

## 5. Open Issues Affecting Workshop Learners

These are issues a workshop participant may directly encounter in a 3-hour session. Priority order:

### P0 — Will likely hit on Windows

| Issue | Symptom | Workaround |
|-------|---------|------------|
| **#1062** `@github/copilot-sdk` 0.1.32 `ERR_MODULE_NOT_FOUND` on Windows | `Cannot find module 'vscode-jsonrpc/node'` when running `squad` | Add to `package.json`: `"overrides": { "@github/copilot-sdk": "0.3.0" }` |

### P1 — Likely hit during module work

| Issue | Symptom | Workaround |
|-------|---------|------------|
| **#1017** Coordinator silently dropped | Squad ignores routing; behaves like vanilla Copilot; commits to `main` | Start a fresh session |
| **#1026** `squad init` marks all files new in git | Every file shows as modified after `squad init` in existing project | Run `git checkout -- .` to unstage; squad's `.gitattributes` handles this; or `git add -A && git commit` |
| **#1081** `squad watch --execute` doesn't inject specialist charter | Spawned agent behaves generically, not like the assigned team member | Don't rely on `--execute` for specialist behavior in the workshop |

### P2 — May hit if exploring advanced features

| Issue | Symptom | Workaround |
|-------|---------|------------|
| **#1067** Infinite post-work loop | Agent keeps running 45+ minutes after completing real work | Stop the session manually; the work is done |
| **#1029** Named-agent delegation does inline work ~40% of the time | Coordinator answers directly instead of delegating to requested agent | Re-request the delegation; or use fresh session |
| **#1010/#984** Personal/global squad fails on Windows | `squad init` in project doesn't inherit global squad | Manually edit `.squad/config.json`; set `teamRoot` to global path |
| **#1052** `squad upgrade` destroys customizations | Post-upgrade `.github/agents/squad.agent.md` loses your changes | Keep a backup; apply customizations after upgrade |

---

## 6. Other Notable Open Issues

These are not bugs learners will hit, but they are architecturally significant for understanding where Squad is going:

| Issue | What it is |
|-------|-----------|
| **#1068** Plugin/Extensibility System Epic | Full plugin install/validate/enable/disable CLI — `squad plugin install` — design-stage backlog |
| **#1037** Context Budget Optimization | `.squad/` grows to 1–3MB tokens after heavy use; proposes index.md + workstream isolation + lazy loading |
| **#1036** Split squad.agent.md | Reduce 95KB coordinator to ~40KB via stub + on-demand reference files |
| **#1032** Aegis built-in RAI Reviewer | Proposed 3rd built-in agent (alongside Scribe and Ralph) — Responsible AI reviewer with traffic-light verdicts — design-stage |
| **#885** Starter skill packs | Ship 5 common skills with `squad init` — proven 18% faster task completion in A/B tests |
| **#457** Monorepo support | Per-directory `.squad-context.md` + `.squads/` inheritance for enterprise monorepos |
| **#1033** Spec Kit integration | Question: how to use Squad alongside GitHub Spec Kit — no official guidance yet |
| **#1096** Branch model change | `insider` branch eliminated; `main` (stable) + `dev` (pre-release) only. `npm i @bradygaster/squad-cli@insider` still works, now publishes from `dev` |

---

## 7. What to Add to troubleshooting.md

Based on this investigation, the following known issues should be documented in `docs/troubleshooting.md` in this workshop:

### Windows ERR_MODULE_NOT_FOUND (Issue #1062)

```
Error [ERR_MODULE_NOT_FOUND]: Cannot find module '.../node_modules/vscode-jsonrpc/node'
```

**Cause:** `@github/copilot-sdk` 0.1.32 has a broken path reference on Windows.

**Fix:** Add to your lab repo's `package.json`:
```json
"overrides": {
  "@github/copilot-sdk": "0.3.0"
}
```
Then run `npm install`.

### Squad behaves like vanilla Copilot — no team routing (Issue #1017)

**Symptom:** Squad stops dispatching to team members. Commits go directly to `main`. No branch creation.

**Cause:** The 92KB coordinator prompt was silently dropped due to context budget pressure from a prior long session's summary.

**Fix:** Start a completely fresh session with `copilot --agent squad`. The coordinator will be fully loaded again.

### All files marked as modified after `squad init` (Issue #1026)

**Symptom:** After `squad init` in an existing project, `git status` shows every file as modified.

**Cause:** `squad init` writes `.gitattributes`. On Windows, line-ending normalization triggers on re-read.

**Fix:** `git checkout -- .` or stage and commit. Not a data loss issue — your files are unchanged.

### squad watch --execute agents don't act like specialists (Issue #1081)

**Symptom:** When `squad watch --execute` spawns a session for a `squad:bishop` labeled issue, the agent doesn't exhibit Bishop's personality or specialist focus — it behaves like a generic assistant.

**Cause:** The `squad:{member}` label is used only as a routing filter. The specialist's charter is never injected into the spawn prompt.

**Fix/Workaround:** Use `copilot --agent squad` interactive sessions for specialist work. Don't rely on `--execute` for quality specialist agent behavior — use it only for simple, well-defined tasks.

### Rate limiting — agents fail mid-task (Issue #992)

**Symptom:** `Naomi didn't land repo changes. Her lane completed with a model rate-limit failure.`

**Cause:** Copilot Pro+ includes 1,500 premium requests/month. Multi-agent waves burn through these quickly.

**Fix:** Wait for the rate limit to reset, or reduce the number of concurrent agents. Batch smaller tasks instead of spawning everything at once.

---

## 8. What Can Be Reused or Referenced in This Workshop

### Direct links to add to workshop modules

These official docs pages should be linked from the workshop as "want to learn more" resources:

| Upstream resource | URL | Add to |
|-------------------|-----|--------|
| Main guide | https://bradygaster.github.io/squad/docs/guide | Module 1 closing section |
| Sample prompts | https://bradygaster.github.io/squad/docs/sample-prompts | Module 1 Step 10 (giving prompts to the team) |
| Cookbook / recipes | https://bradygaster.github.io/squad/docs/cookbook/recipes | Module 2 intro |
| Build autonomous agent | https://bradygaster.github.io/squad/docs/guide/build-autonomous-agent | Module 3 opening |
| FAQ | https://bradygaster.github.io/squad/docs/guide/faq | docs/troubleshooting.md |
| Building resilient agents | https://bradygaster.github.io/squad/docs/guide/building-resilient-agents | Module 3 |

### Patterns to adopt from upstream issues

**Issue #885 — Skill packs**

The A/B testing evidence in this issue is compelling: agents with pre-injected skills complete tasks 18% faster with 100% best-practice adherence vs. variable results without skills. Module 2 of this workshop teaches learners to inspect `.squad/wisdom.md` — it is worth adding a step where learners manually seed one starter skill into `.squad/skills/` before their second feature request and observe the difference.

**Issue #1037 — Context budget awareness**

Module 2 Step 9 (artifact quality inspection) should note that `.squad/` files grow over time and that this is a real-world concern. The index.md approach proposed in this issue is something advanced learners can try after the workshop.

**Issue #1036 — squad.agent.md size**

When teaching Module 3 (Aspire observability), mention that the 92KB coordinator prompt is itself a cost driver. Learners seeing large token counts in the Aspire dashboard for session-start traces should understand that this is where much of it goes.

### No agent files to reuse

The upstream repo has only one agent file: the coordinator (`squad.agent.md`). It is already used by Squad (copied into each lab repo by `squad init`). There is nothing reusable from `.github/agents/` for this workshop — the coach agent created in this repo (`.github/agents/squad-coach.agent.md`) is a workshop-specific addition with no upstream equivalent.

---

## 9. Summary Table

| Category | Finding | Action for Workshop |
|----------|---------|-------------------|
| **Learning resources** | No upstream workshop exists. Comprehensive reference docs at bradygaster.github.io/squad | Link to sample-prompts, cookbook, FAQ from modules |
| **Agent files** | Only `squad.agent.md` (coordinator, 92KB). No other agents upstream | Workshop's squad-coach.agent.md is unique; no conflicts |
| **Ralph — triage** | Works well. Reads GitHub Issues, labels, assigns | Module 3 Step 11 is accurate |
| **Ralph — loop** | Works well for recurring housekeeping | Document ralph-stop mechanism clearly ✓ |
| **Ralph — watch --execute** | Bug #1081: spawns generic agent, not specialist charter | Add warning to Module 3; don't demo specialist quality |
| **Windows-specific bug** | #1062: `vscode-jsonrpc/node` error. Workaround: override copilot-sdk to 0.3.0 | Add to troubleshooting.md |
| **Silent coordinator drop** | #1017: long sessions can silently lose Squad governance | Add to troubleshooting.md; mention in Module 3 |
| **squad upgrade** | #1052: destroys customizations, no merge strategy | Note in CONTRIBUTING.md; add to troubleshooting.md |
| **Global squad on Windows** | #1010: personal squad doesn't auto-detect | Add to troubleshooting.md |
| **No upstream workshop** | This workshop is unique; fills a genuine learning gap | No changes needed — validates workshop's purpose |
| **Context bloat** | #1037: .squad/ grows to 1–3MB tokens in heavy use | Mention in Module 2 artifact quality section |
| **Rate limiting** | #992: Pro+ users can exhaust 1500 requests/month | Add to troubleshooting.md |
