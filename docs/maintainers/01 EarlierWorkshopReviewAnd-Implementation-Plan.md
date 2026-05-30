# Earlier Workshop Review & Adoption Plan

> **Document type:** External-workshop analysis + adoption proposal
> **Review date:** 2026-05-28
> **Reviewer:** Claude
> **Source reviewed:** [tamirdresher/squad-skills](https://github.com/tamirdresher/squad-skills) — `workshop/` directory at `main@2026-05-04`
>   - `workshop/README.md` (1,534 lines / 44 KB, last updated 2026-03-13 per its own header)
>   - `workshop/ralph-watch.ps1` (204 lines — persistent Ralph monitor v8)
>   - `workshop/squad.config.ts` (64 lines — Squad TypeScript config example)
> **Scope of this doc:** identify the techniques/practices in Tamir's earlier workshop, assess each against the current Squad CLI (v0.9.4) and against our workshop, and propose specific blends for what is genuinely worth adopting.
> **Status:** 🔁 **Reassessed 2026-05-30 (read [§0](#0-reassessment-2026-05-30) first).** The original "pending review" status is superseded. PR [#1](https://github.com/joslat/squad-workshop/pull/1) is now authoritative, which (a) **reverses this doc's command-name premise — `squad watch` is adopted, not `squad triage`** — and (b) source re-verification has invalidated several assumptions used below (`--once`, `.squad/loop.md`, the Teams `teams-webhook.url` path). The technique catalog (§4) and proposals (§5) remain the plan of record but must be applied through §0's corrections. Companion: [`02 Post-PR1-Verification-and-Fixes.md`](02%20Post-PR1-Verification-and-Fixes.md).

---

## 📋 Adoption tracking

> Live status of every adoption in this plan. **Mainline (Tier 1 + Tier 2) is fully shipped and merged.** Tier 3 is blocked/pending. (Updated 2026-05-30.)

| Status | Name | Description | % done | Done | Fix / change |
|---|---|---|---|---|---|
| Done | **Tier 1 — formats + cheat-sheet** (T-004/005/026/027) | "Try if interested" side-quests (M3), `docs/cheat-sheet.md`, per-module "At a glance" maps + ⏱️ badges, light tone | 100% | ✅ | Shipped in **PR #3** (merged) |
| Done | **Tier 2a — team extensions** (T-001 Skills, T-006 @copilot) | Module 2 Step 9.5 "Skills", Module 3 Step 11.6 "@copilot" — no dependency on the unmaintained `squad-skills` repo | 100% | ✅ | Shipped in **PR #4** (merged) |
| Done | **Tier 2b — models & budget** (T-003) | `docs/budget-and-models.md` (per-agent `squad config model`, tiers, budget) + README & Module 1 links | 100% | ✅ | Shipped in **PR #5** (merged); documents the W-012 budget gap (measured numbers still estimates) |
| Blocked | **Tier 3 — Actions Ralph** (T-002) | Ralph as a GitHub Actions cron (the no-laptop tier) | 0% | ❌ | **Blocked:** `squad watch --once` does not exist in v0.9.4/dev. Needs a verified single-pass mechanism before authoring |
| Pending | **Tier 3 — bonus appendix** (T-012/013/014/015/016/025) | `modules/04-bonus.md`: MCP, Teams, DevBox, cross-machine, human members, multi-person Squad | 0% | ⬜ | Not created. Each topic needs binary verification + authoring; Teams overlaps the Tamir-deferred reframe ([02 §2.5](02%20Post-PR1-Verification-and-Fixes.md)) |
| Optional | **Partial-adoption** (T-007/008/009/010/011) | ceremonies, directive capture, `squad.config.ts`, resources table, themed casting ("we have it; theirs is sharper") | 0% | ⬜ | Light-touch polish; not started (low priority) |
| N/A | **Already-have / Reject** (T-019–024 / T-017,018) | doctor, decisions flow, failure-mode honesty, verifier, coach, build target / `ralph-watch.ps1`, webhook diagram | — | ➖ | No action by design |

**Net:** mainline adoptions ✅ done; remaining = Tier 3 (Actions-Ralph blocked, bonus appendix unwritten) + optional partials.

---

## Index

0. [Reassessment (2026-05-30) — post-PR #1, watch-authoritative](#0-reassessment-2026-05-30)
1. [Executive Summary](#1-executive-summary)
2. [The Upstream Workshop at a Glance](#2-the-upstream-workshop-at-a-glance)
3. [Methodology](#3-methodology)
3.5. [Structural Blending Strategy — the four-layer model](#35-structural-blending-strategy)
4. [Techniques Catalog (T-001 … T-027)](#4-techniques-catalog)
5. [Adoption Proposals — Detailed](#5-adoption-proposals--detailed)
   - 5.1 [T-001 Skills](#51-t-001--skills-as-a-first-class-feature)
   - 5.2 [T-002 Three-tier Ralph](#52-t-002--three-tier-ralph-deployment)
   - 5.3 [T-003 Model tiers](#53-t-003--model-tiers-for-cost-optimization)
   - 5.4 [T-004 🎯 Try-if-interested](#54-t-004--try-if-interested-micro-exercises)
   - 5.5 [T-005 Cheat sheet](#55-t-005--quick-reference-cheat-sheet)
   - 5.6 [T-006 @copilot coding agent](#56-t-006--copilot-coding-agent-as-a-team-member)
   - 5.7 [T-026 Per-module TOC](#57-t-026--per-module-table-of-contents)
   - 5.8 [T-027 Friendly tone](#58-t-027--friendly-tone-adoption)
   - 5.9 [Bonus content — `modules/04-bonus.md`](#59-bonus-content--modules04-bonusmd)
6. [Items Deliberately Rejected](#6-items-deliberately-rejected)
7. [Tracking Table](#7-tracking-table)
8. [Sequencing Recommendation — five waves](#8-sequencing-recommendation)

---

## 0. Reassessment (2026-05-30)

> **Why this section exists.** This document was written 2026-05-28 assuming `squad triage` was canonical and inferring several upstream behaviours from prose. Since then: (1) PR [#1](https://github.com/joslat/squad-workshop/pull/1) — from Tamir Dresher, a Squad co-creator — has been **accepted as authoritative**, making **`squad watch` the primary command name** for this workshop; and (2) every load-bearing claim has been re-verified against `bradygaster/squad` source (`v0.9.4` / `dev`) and the npm package (`latest = 0.9.4`, `insider = 0.9.6-insider.3`, confirmed 2026-05-30). The catalog (§4) and proposals (§5) are still the plan of record — **apply them through the corrections here.** Full per-item proof + a repo-wide fix inventory live in the companion doc [`02 Post-PR1-Verification-and-Fixes.md`](02%20Post-PR1-Verification-and-Fixes.md).

### 0.1 Command-name premise is reversed → adopt `squad watch`

Throughout this doc (§1, §2, §4 T-002, §5) the assumption is "`squad watch` is stale, `squad triage` is canonical." **For this workshop that is now reversed.** Verified facts:

- Both names work — `cli-entry.ts` dispatches `if (cmd === 'triage' || cmd === 'watch')` to the same `runWatch`.
- `squad watch` is the **original/native** name ([release v0.5.1](https://github.com/bradygaster/squad/releases/tag/v0.5.1), 2026-02-20); the implementation still lives in `commands/watch/`.
- The official docs *surface* `triage` (`squad --help` lists only `triage`; [cli.md](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/reference/cli.md) calls it "primary name; `watch` is an alias"; [FAQ](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/guide/faq.md): triage became primary "as of v0.8.26"). So both are defensible — we choose `watch` per the co-creator's PR.
- **`--health` only works with `watch`** (`if (cmd === 'watch' && args.includes('--health'))`), so `squad watch` is functionally *more* complete — adopting it fixes the latent `squad triage --health` bug in Module 3.

**Action:** sweep `squad triage` (the command) → `squad watch` everywhere (full inventory in companion §2.1). Keep the english verb "triage". All "watch→triage rename / triage canonical / watch stale" statements in this doc are superseded.

### 0.2 `--once` does not exist → §5.2 (T-002 GitHub Actions Ralph) needs rework

The §5.2 proposal (Step 11.5) and the §4 T-002 note schedule a cron running `squad triage --once`. **There is no `--once` flag** on `watch`/`triage` in v0.9.4 or dev — `runWatch` always enters a `setInterval` loop after the first round (verified in `cli-entry.ts` flag-parsing and `watch/index.ts`). The "single safe pass" the proposal relies on doesn't exist as written.

**Corrected approach:** bound a single round at the *job* level (e.g. `timeout`-wrap `squad watch`, or let the Actions cron schedule be the interval and kill the process after one round) and **verify the real one-shot mechanism on the target build before drafting the YAML.** Until then, T-002 Step 11.5 is **ADOPT-pending-verification**, not ready-to-ship.

### 0.3 `loop.md` is repo-root, not `.squad/loop.md`

`squad loop` reads `./loop.md` from the repo root (`loop.ts`: `path.join(workTreeRoot, 'loop.md')`); `squad loop --init` writes there. The `.squad/loop.md` references in this doc (e.g. line ~905) and any §5.1/§5.9 mentions are wrong — use `./loop.md`.

### 0.4 Teams `~/.squad/teams-webhook.url` (§B3) — read by Tamir's wrapper, not by `squad watch`

§B3 (and PR #1 Step 11g) tell the reader to save a webhook at `~/.squad/teams-webhook.url` "where Ralph will look." Precisely: **the built-in `squad watch` does not read that file** (zero `webhook` references in the shipped `squad-cli` binary, both v0.9.4 and v0.9.6-insider.3) — but **Tamir's `ralph-watch.ps1` wrapper does** (`Test-Path`s it and POSTs). So the instruction is accurate *for that script*, not for the CLI daemon. The built-in Teams path is the `teams-graph` OAuth adapter (tokens cached at `~/.squad/teams-tokens-{hash}.json`) plus the shipped `notification-routing` skill (`.squad/teams-channels.json`). Reframe §B3 accordingly. Full proof in companion [§2 / §4](02%20Post-PR1-Verification-and-Fixes.md).

### 0.5 Invocation: `copilot`, never `gh copilot`; `agency copilot` is non-canonical

Any *adopted* invocation must use the standalone `copilot` binary: `copilot --agent squad --yolo` (one-shot: `copilot -p "…" --agent squad --yolo`). `gh copilot` (extension) has only `suggest`/`explain` and is deprecated; `agency copilot` (in Tamir's source workshop) is non-canonical. The repo's `plugins/spawn-squad/SKILL.md` models the correct pattern.

### 0.6 Squad-skills repo: unchanged → analysis still current (with three upgrades)

Re-checked `tamirdresher/squad-skills` on 2026-05-30: **last push 2026-05-04** (HEAD "add cross-squad-communication"; the 2026-05-27 touch was metadata only), MIT-licensed, skills live under **`plugins/`** (25 of them), not `skills/`. So this doc's 27-technique analysis is **still accurate — no re-survey needed.** Three upgrades to fold into §5.1 / the catalog:

1. **Modernize the Skills install (T-001):** the repo README now documents `copilot plugin marketplace add tamirdresher/squad-skills` + `copilot plugin install <name>@squad-skills` — newer/cleaner than the `git clone … && cp -r plugins/reflect .squad/skills/reflect` flow in §5.1. Teach the marketplace flow; keep copy-into-`.squad/skills/` as the offline fallback. (`reflect` remains the best demo skill — 🟢 Easy / no deps; `fact-checking` and `blog-writing` are equal backups.)
2. **Source canonical invocations from `plugins/spawn-squad/SKILL.md`** — it uses `copilot --agent squad --yolo` correctly; the cleanest reference to scrub any `gh copilot`/`agency copilot` drift.
3. **`plugins/github-project-board`** has concrete `gh project item-*` recipes the board content only gestures at — high value, but **parameterize** the hardcoded `tamirdresher_microsoft` project IDs before adopting.

### 0.7 Where I agree with this doc, and where I'd now diverge

**Agree (unchanged):** the four-layer structure (§3.5); ADOPT-mainline T-001 (Skills), T-003 (model tiers), T-004 (🎯 side-quests), T-005 (cheat-sheet), T-006 (@copilot); ADOPT-style T-026/T-027; and the **REJECT of Tamir's `ralph-watch.ps1`** (T-017) as fragile vs the built-in loop. Note: **PR #1's Step 11h "Ralph, Go!" script is essentially T-017 re-entering through the back door** — and it carries the `gh copilot` bug — so the reject verdict stands; if kept, it belongs in bonus as an *illustration*, not mainline.

**Diverge / adjust:**
- **T-002 (Actions Ralph): downgrade from ready-ADOPT to ADOPT-pending-verification** until the no-`--once` reality (§0.2) is resolved.
- **Teams + human-members placement:** PR #1 inlines both into mainline (Module 3 Step 11g / Module 1 Step 2); this doc routes them to **bonus** (§B3, T-016). Keep bonus as the target — but since the PR ships them inline and is authoritative, the post-merge task is to **relocate/dedupe**, not re-add.
- **T-003 model names:** refresh to the current era (Opus 4.8 / Sonnet 4.6 / Haiku 4.5) when writing the tier table; the IDs in Tamir's `squad.config.ts` are illustrative only.

### 0.8 Adoption strategy — what to adopt now, ranked by impact (the source repo is unmaintained)

**The fact that reshapes this whole plan:** `tamirdresher/squad-skills` is **unmaintained and targets an older Squad** — re-confirmed 2026-05-30: last push **2026-05-04** ("add cross-squad-communication"), MIT. Its workshop uses `agency copilot`, `squad watch --once`, `npx … watch`, `.squad/skills` copy-install, and stale model IDs — all aged out. So the rule is: **harvest the durable ideas; take no runtime dependency on the repo; verify every command against current Squad before shipping.**

Three guardrails:

1. **Snapshot, not dependency.** If a step installs from the repo (the Skills demo), pin a commit and label it a "community snapshot (unmaintained)". Prefer skills that are pure markdown (evergreen) over any wired to CLI internals — and prefer a skill that **ships with Squad** (the CLI bundles `templates/skills/`, e.g. `notification-routing`) so there's no external dependency at all.
2. **Verify-before-ship.** Every command goes through the binary-grep check we did this week. Already done for `watch` / `loop.md` / `copilot` / `--health`.
3. **Durability over breadth.** Prefer items whose value survives version bumps (format, framing, concepts) over items wired to a specific CLI surface (Actions YAML, Teams plumbing).

Ranked by impact-per-maintenance-cost:

**Tier 1 — adopt now (high impact, ≈zero staleness risk):**
- **T-004 🎯 "Try if interested" side-quests** + **T-026 per-module TOC** + **T-027 friendly tone / ⏱️ badges** — pure format. Biggest readability/engagement lift for the least risk. Do these first.
- **T-005 quick-reference cheat sheet** — authored with *current* commands (`squad watch`, `copilot --agent squad --yolo`, `./loop.md`). High "I'll actually use this" value.

**Tier 2 — adopt now, with a verified mechanism:**
- **T-003 model tiers + budget** — evergreen concept; ship with current model IDs (Opus 4.8 / Sonnet 4.6 / Haiku 4.5) after confirming the per-agent config surface on the target build. Also closes the W-012 budget gap.
- **T-001 Skills demo** — teach the concept via the **native `copilot plugin` / `squad plugin` flow** (not Tamir's `cp -r … .squad/skills`); demo **`reflect`** (pure markdown, no deps) or a Squad-shipped skill; label any squad-skills source a pinned snapshot.
- **T-006 @copilot coding agent** (`squad copilot`) — the bounded-autonomy contrast to Ralph `--execute`; verify the add-to-team flow on the current build.

**Tier 3 — defer / rework (blocked or infra-heavy):**
- **T-002 GitHub-Actions Ralph** — **blocked**: depends on `squad watch --once`, which does not exist (verified). Rework only after confirming a real single-pass mechanism; do **not** ship Tamir's stale YAML.
- **Bonus (Teams, MCP, DevBox, cross-machine, human/multi-person)** — keep in `modules/04-bonus.md`; lowest priority given infra cost + the stale repo. For Teams, describe the built-in `teams-graph` / `notification-routing` path, not the wrapper's `teams-webhook.url`.

**Net recommendation:** ship **Tier 1 as one small, safe PR** (format + cheat-sheet) for immediate impact; do **Tier 2 as a second PR** once the model-config and plugin flows are spot-checked; leave **Tier 3** tracked as bonus/blocked. This keeps the workshop's depth-first discipline, absorbs the genuinely durable parts of Tamir's breadth, and takes no dependency on an unmaintained repo.

### 0.9 New status

🟡 **Active — corrected; PR #1 follow-ups landed; adoption now governed by §0.8 tiers.** The command-name / `loop.md` / `gh copilot` corrections (§0.1, §0.3, §0.5) are **applied to the active workshop** (commit `2fb3003`); §2.4/§2.5 (issue-version wording, Teams reframe) are deferred to Tamir as a trust vote. The adoption proposals in §4–§5 remain the plan of record, executed in the **Tier 1 → Tier 2 → Tier 3** order above. T-002 is blocked on CLI verification (§0.2). See companion [`02 Post-PR1-Verification-and-Fixes.md`](02%20Post-PR1-Verification-and-Fixes.md).

---

## 1. Executive summary

Tamir Dresher's workshop (`tamirdresher/squad-skills/workshop/`) is a **breadth-first playground tour** of Squad — 12 sections + 4 appendices, ~2 hours, "pick what interests you" pacing, no specific build target. Ours is a **depth-first build exercise** — 3 modules, ~3 hours, specific Reading List app, evaluation-oriented. They are complementary rather than competing.

Tamir's workshop was last updated 2026-03-13 — about 2 months before the current state of Squad CLI (v0.9.4). Several command names have changed since (`squad watch` → `squad triage`), and the `agency copilot --yolo --agent squad` invocation pattern they use is non-canonical relative to the current `copilot --agent squad`. So some of their material has aged out. **[Superseded — see [§0.1](#0-reassessment-2026-05-30): for this workshop `squad watch` is now adopted as primary, reversing the `watch → triage` direction stated here. The `agency copilot → copilot --agent squad` correction still holds.]**

**Structural insight (§3.5):** the right blend isn't "his style vs. ours." It's a **four-layer learning structure**:

1. **Mainline** (linear walkthrough — Modules 1-3) — the spine. Build the Reading List app step by step. Don't dilute.
2. **Side quests** (🎯 Try if interested — Module 3 boxes) — optional micro-exercises riding alongside main steps.
3. **Reference folder** (`docs/reference/`) — post-workshop portable artifacts (cheat sheet, budget table, skills primer, ceremonies glossary).
4. **Bonus appendix** (`modules/04-bonus.md`) — modular pick-and-choose topics that don't fit the mainline (MCP, multi-person Squad, DevBox, cross-machine, Teams integration, human members).

This shape lets us keep the walkthrough discipline that makes our workshop work *and* add the modular breadth that makes Tamir's useful as a reference.

**27 distinct techniques identified.** Of those:

| Verdict | Count | Examples |
|---|---|---|
| **ADOPT — mainline** (gap + applicable + worth teaching in the spine) | **6** | Skills, three-tier Ralph (incl. Actions cron), model tiers for cost, @copilot coding agent, 🎯 Try-if-interested side quests, quick-reference cheat sheet |
| **ADOPT — style** (cross-cutting readability) | **2** | Per-module TOC table at top of each module file, light friendly-tone (section emoji + ⏱️ time badges) |
| **PARTIAL** (light inline edits — we have it, theirs is sharper) | **5** | Ceremonies naming, directive capture pattern, `squad.config.ts`, consolidated resources table, themed casting |
| **BONUS** (modular topics → new `modules/04-bonus.md` — *previously listed as REJECT*) | **6** | MCP integrations, Teams Adaptive Cards, DevBox setup, cross-machine, human members, **multi-person Squad (new — T-025)** |
| **REJECT** (genuinely out of scope) | **2** | Tamir's `ralph-watch.ps1` wrapper script, webhook architecture diagram |
| **ALREADY-HAVE** (we cover it better) | **6** | `squad doctor`, decisions/memory flow, failure-mode honesty, verifier script, coach agent, specific build target |

**Eight concrete mainline adoptions proposed** with file-level integration plans in §5, plus a single new `modules/04-bonus.md` covering all six bonus topics. Each adoption is small (≤2 new sections + minor edits per module) and individually shippable without disturbing the rest of the workshop.

**New since last revision:** the question "Squad tracks one person's tasks — what about two?" is answered as a new T-025 (Multi-person Squad), placed in `modules/04-bonus.md`. Squad's repo-scoped `.squad/` + Git-based decision merging + cross-machine queue *do* support multi-person collaboration, but the upstream story is rough enough that it belongs in Bonus rather than Mainline.

---

## 2. The upstream workshop at a glance

### Structure

| § | Section | Time | Style |
|---|---|---|---|
| 1 | Prerequisites & Setup | ~10 min | Manual `git --version` checks; no verifier script |
| 2 | Install Squad CLI | ~5 min | `squad init`, `squad status` |
| 3 | First Conversation | ~15 min | Hire the team via the coordinator's prompts |
| 4 | Squad Playground | open-ended | "Talk to agents, parallel work, decisions" |
| 5 | GitHub Issues Routing | optional | Label-based assignment |
| 6 | Project Board Tracking | optional | Project V2 columns + Ralph board reports |
| 7 | Ralph — Work Monitor | optional | Three deployment modes |
| 8 | **Skills — Extend Your Squad** | optional | Install from marketplace, create your own |
| 9 | **MCP Integrations** | optional | Teams, Outlook, ADO, Playwright |
| 10 | **@copilot Coding Agent** | optional | Add @copilot to the team; capability profile |
| 11 | Advanced (Ceremonies, Humans, Cross-Machine) | optional | Light intros |
| 12 | Reference & Exploration Guide | reference | Quick-reference table, model tiers |
| App A | GitHub Actions hosted Ralph | reference | `squad-heartbeat.yml`, `squad-triage.yml`, etc. |
| App B | Teams & Email integration | reference | Webhooks, Adaptive Cards, WorkIQ |
| App C | DevBox for remote Squad | reference | Cloud always-on infrastructure |
| App D | Webhook & notification architecture | reference | ASCII diagram, routing by severity |

### Editorial voice

- Heavy use of emoji headers (🎓, 🤖, 📋, 🔄, 🏷️, 🧩) — we use almost none.
- "⏱️ ~X minutes" timing badge per section.
- "🎯 Try It!" / "🎯 Try If Interested" closing block per section — opt-in mini-exercises.
- Every section ends with a **Reference Material** subsection listing relevant files/paths.
- Tone is enthusiastic ("happy building!", "the fun is in discovery") — markedly less skeptical than ours.

### Significant omissions vs. our workshop

- No verifier script — uses manual `git --version` checks.
- No coach agent.
- No structured prompt files (`debug-step.prompt.md`, `inspect-squad-artifacts.prompt.md`).
- No discussion of Squad's failure modes (Aspire `✓` lies, coordinator drop, `--execute` specialist limitation, premium-request budget) — these are documented in our [docs/troubleshooting.md](../troubleshooting.md) with upstream issue links, absent from Tamir's.
- No artifact-quality evaluation framework — their version of "Module 2 Step 9 inspect `.squad/`" is "poke around, see what was created."
- Uses stale command names (`squad watch` instead of `squad triage`) and a non-canonical CLI invocation (`agency copilot --yolo --agent squad`).

### Net assessment

The upstream workshop is a **good map of the territory** — it surveys Skills, MCPs, GitHub Actions, the `@copilot` agent, Ceremonies, and Cross-Machine in a way that ours doesn't. But it lacks the evaluative discipline our workshop emphasizes (verify, inspect artifacts, judge whether memory compounds, walk away when Squad doesn't earn its keep). The richest harvest is in §8 (Skills), §10 (@copilot), §12 (Quick-reference), Appendix A (GitHub Actions cron Ralph), and the model-tier table in §12.

---

## 3. Methodology

1. Listed the `tamirdresher/squad-skills/workshop/` directory contents via `gh api`. Three files in scope: `README.md`, `ralph-watch.ps1`, `squad.config.ts`.
2. Read all three files end-to-end.
3. Cross-referenced each section against our current workshop ([README.md](../../README.md), [modules/01-basic.md](../../modules/01-basic.md), [modules/02-intermediate.md](../../modules/02-intermediate.md), [modules/03-advanced.md](../../modules/03-advanced.md), [docs/troubleshooting.md](../troubleshooting.md), [.github/agents/squad-coach.agent.md](../../.github/agents/squad-coach.agent.md)).
4. For each technique, applied a four-question filter:
   - **(a) Applicable today?** — does the technique still work given Squad has evolved since 2026-03-13? (Check `squad watch` → `squad triage`, `agency copilot` → `copilot`, etc.)
   - **(b) Already covered?** — does our workshop already do this?
   - **(c) Teaching value?** — would learning this make a learner better at using Squad on real work?
   - **(d) Worth the scope cost?** — does adding it dilute the workshop's core thesis ("can Squad earn its keep?") or strengthen it?
5. Verdict per technique: **ADOPT / PARTIAL / BONUS / REJECT / ALREADY-HAVE**.
6. For ADOPT items, drafted concrete blending proposals in §5 with file:line targets.

---

## 3.5 Structural blending strategy

The hardest design choice in this analysis: how do you adopt the breadth of a "playground / unit exercises" workshop without breaking the discipline of an "end-to-end real-project walkthrough"? They optimize for different things.

| Property | Ours (current) | Tamir's |
|---|---|---|
| **Primary path** | Linear (Module 1 → 2 → 3) | Pick-what-interests-you |
| **Build target** | One specific app (Reading List) | None — bring your own |
| **Success criterion** | "Did the team earn its keep on the build?" | "Did you learn what Squad can do?" |
| **Risk if poorly executed** | Reads as too rigid | Reads as a feature list with no soul |

The blend doesn't mean **choosing** one. It means **layering** them so a learner can pick a depth that matches their need.

### The four layers

```
┌─────────────────────────────────────────────────────────────────────────┐
│  LAYER 1 — MAINLINE  (Modules 1-3, README, prerequisites)               │
│  Linear walkthrough. Build the Reading List app. Evaluate honestly.     │
│  Owns: the "does Squad earn its keep?" thesis.                          │
│  Adoption: SPINE EXTENSIONS only — new steps that genuinely belong on   │
│  the build path (Skills install, Actions cron Ralph, @copilot).         │
└─────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  LAYER 2 — SIDE QUESTS  (🎯 Try if interested — Module 3 only)          │
│  Small optional micro-exercises riding alongside main steps.            │
│  Owns: depth-first exploration without breaking the mainline.           │
│  Adoption: 🎯 markers on Module 3 (where "guided tour" tone exists).    │
│  NOT on Modules 1-2 — those are linear by design.                       │
└─────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  LAYER 3 — REFERENCE  (docs/reference/ folder)                          │
│  Post-workshop portable artifacts. Consulted, not read end-to-end.      │
│  Owns: durability — useful 3 months after the workshop ends.            │
│  Adoption: cheat-sheet, budget-and-models, skills primer, ceremonies    │
│  glossary, consolidated resources table.                                 │
└─────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  LAYER 4 — BONUS  (modules/04-bonus.md — single file, six sections)     │
│  Modular pick-and-choose topics. Lives in modules/ alongside the        │
│  mainline — part of the workshop, but pick-and-choose pacing.           │
│  Owns: "I want to use Squad with my team / corporate stack / DevBox."   │
│  Adoption: MCP, Teams integration, DevBox, cross-machine, human         │
│  members, multi-person Squad (new — T-025).                             │
└─────────────────────────────────────────────────────────────────────────┘
```

### Why this shape

- **Tamir's strengths preserved, his pacing not imposed.** His best content (Skills, GitHub Actions Ralph, @copilot, cheat-sheet, model tiers) becomes mainline spine extensions or reference docs — those are where they belong. His pacing ("everything optional") becomes the bonus appendix only — that's where pick-and-choose is appropriate.
- **Our strengths preserved, his discipline absorbed.** Modules 1-2 stay linear; Module 3 keeps its "optional tour" tone but gets the side-quest pattern that makes that tone *legible*. The build-and-evaluate thesis doesn't have to fight with "go explore."
- **Maintainability.** Reference docs in a folder are easier to find, link, and version-bump than scattered subsections. The bonus appendix is a single file by design — six topics, no folder navigation, all in one place a learner can read on a flight.

### Reference folder vs. bonus module — what goes where

Both are post-mainline material, but they sit in different folders for a reason:

| `docs/reference/` (folder of portable artifacts) | `modules/04-bonus.md` (workshop module, optional) |
|---|---|
| Lives in `docs/` because it's **reference**, not workshop progression | Lives in `modules/` because it's **workshop content** — just with pick-and-choose pacing |
| Consulted **during** and **after** the workshop | Read **after** Module 3, optionally — sits in the same folder as Modules 1-3 so it's discoverable |
| Each file is a portable artifact (cheat sheet, budget table) | Whole file is a "where to go next" map — six topical sections |
| Looks up: "what's the prompt for X?" "what's the budget for Y?" | Reads: "I want to add Teams integration — what's the gist?" |
| Linked from the README "Getting help" section + per-module footers | Linked from the README modules table + Module 3 closing line |

**Why bonus content is in `modules/` not `docs/`:** the workshop's content lives in `modules/`. Reference artifacts (cheat sheets, glossaries) are *about* the workshop and go in `docs/`. Bonus topics are *part of* the workshop — they extend its scope rather than referencing it — so they belong next to Modules 1-3. The file is named `04-bonus.md` (not `04-advanced-extras.md`) to signal it's optional, not a hidden Module 4 that learners are expected to complete.

### How each adopted technique maps to a layer

| Technique | Layer | Where exactly |
|---|---|---|
| T-001 Skills | Mainline + Reference | New Module 2 Step 9.5 (mainline) + `docs/reference/skills.md` (deep-dive companion) |
| T-002 Actions cron Ralph | Mainline | New Module 3 Step 11.5 |
| T-003 Model tiers | Reference | `docs/reference/budget-and-models.md` (linked from Module 1 Step 1) |
| T-004 🎯 Side quests | Side quests | Module 3 only — Steps 10, 11, 11.5, 11.6, 12 |
| T-005 Cheat sheet | Reference | `docs/reference/cheat-sheet.md` |
| T-006 @copilot coding agent | Mainline | New Module 3 Step 11.6 |
| T-007 Ceremonies | Reference + inline | `docs/reference/ceremonies-glossary.md` + two one-sentence inline notes |
| T-008 Directive capture | Inline | One callout in Module 1 Step 5 |
| T-010 Resources table | Reference | `docs/reference/resources.md` |
| T-011 Themed casting | Inline | One sentence in Module 1 Step 2 |
| T-012-T-016, T-025 | Bonus | `modules/04-bonus.md` (single file, six sections) |
| T-026 Per-module TOC | Style | Top of each `modules/*.md` |
| T-027 Friendly tone | Style | Section emoji + ⏱️ time badges across all modules |

This map drives the sequencing in §8.

---

## 4. Techniques catalog

Each row is a self-contained verdict. File:line references in the "We have it?" column are to our workshop.

### Adoptions (high-value gaps)

#### T-001 — Skills as a first-class feature

**What it is:** Squad's `skills/` system — portable knowledge modules (markdown + scripts) that agents can install to gain new capabilities (Teams automation, fact-checking, news briefings, GitHub project board management, etc.). Tamir's §8 explains the format (`SKILL.md` with front-matter), the confidence-lifecycle (LOW → MEDIUM → HIGH), and the marketplace (his own repo).

**Applicable today?** Yes. `squad doctor` checks the skills directory; `.squad/skills/{name}/` is real; `.copilot/skills/` is referenced in our own [modules/01-basic.md:374-377](../../modules/01-basic.md) Step 6 verification block.

**We have it?** **No.** Our workshop mentions `.copilot/skills/` once in passing (Module 1 Step 6 verification) and `.squad/skills/` is mentioned only by Squad Coach's knowledge base. Learners finish our workshop without understanding that Skills exist or how to install them. This is a significant gap.

**Teaching value?** High. Skills are the path from "interactive Squad session" to "Squad that gains capabilities over time." Without teaching this, our workshop misses the entire extensibility story.

**Verdict:** **ADOPT** — see [§5.1](#51-t-001--skills-as-a-first-class-feature) for the proposal (new Module 2 Step 9.5: "Install a skill, watch the team use it").

---

#### T-002 — Three-tier Ralph deployment (in-session / local watchdog / GitHub Actions cron)

**What it is:** Tamir's §7 frames Ralph as having three deployment levels. The third (GitHub Actions cron) is documented in Appendix A with full workflow YAML (`squad-heartbeat.yml`, `squad-triage.yml`, `sync-squad-labels.yml`).

**Applicable today?** Partially. The YAML uses `squad watch --once` (stale name), but the *pattern* — schedule a runner that invokes Squad CLI to poll issues — is sound. Translating to `squad triage --once` (or whatever the current `--once` equivalent is) is mechanical.

**We have it?** Partial. [modules/03-advanced.md:172-188](../../modules/03-advanced.md) covers in-session and local-watchdog Ralph (`squad triage --interval 5`). The third tier — running Ralph as a GitHub Actions scheduled job so it survives without a local machine — is not covered.

**Teaching value?** Medium-high. The cloud-cron tier is the one a real team would actually adopt for an issue-tracker auto-triage workflow. Without it, learners may conclude Ralph "needs a laptop running."

**Verdict:** **ADOPT** — see [§5.2](#52-t-002--three-tier-ralph-deployment) for the proposal (new Module 3 Step 11.5: "Ralph in GitHub Actions — the no-laptop tier").

---

#### T-003 — Model tiers for cost optimization

**What it is:** Tamir's §12 table maps **Fast** (Haiku) / **Standard** (Sonnet) / **Premium** (Opus) tiers to *roles* (Ralph & Scribe → Fast; coding agents → Standard; mission-critical decisions → Premium). Configured per-agent in `.squad/config.json`.

**Applicable today?** Yes — Squad's per-agent model configuration is real and documented in the upstream `squad.config.ts` example file. (Note: the *specific* model IDs Tamir lists are stale — `claude-haiku-3`, `claude-sonnet-3.5`, `claude-opus-4` — current LTS-equivalents at the time of this review are Haiku 4.5, Sonnet 4.6, Opus 4.7. The pattern is correct; the names need updating.)

**We have it?** No. Our [modules/01-basic.md:170-191](../../modules/01-basic.md) Step 1 model-selection block says "use the strongest model available" — true for *one* session model, but doesn't expose per-agent tiering. This connects directly to our existing budget gap W-012 (baseline review, removed in cleanup).

**Teaching value?** High. Premium-request budget is the single most-asked workshop-runner question after "does Squad earn its keep?" Tiering is the answer — and teaching it gives our existing budget gap a concrete fix.

**Verdict:** **ADOPT** — see [§5.3](#53-t-003--model-tiers-for-cost-optimization) for the proposal (new Module 2 sub-section on tier configuration + a reference table in the Quick start). Closes W-012.

---

#### T-004 — "🎯 Try It!" / "🎯 Try If Interested" micro-exercises

**What it is:** Every section in Tamir's workshop ends with a small opt-in exercise block, distinct from the section's main content. Lower commitment than a full step; serves as a checkpoint or a path to exploration.

**Applicable today?** Yes, format-only.

**We have it?** Partially. We have **mandatory** "What to watch for" / "Verify" blocks (e.g. [modules/01-basic.md:298-306](../../modules/01-basic.md)). They're effective but heavier. We don't have low-commitment "if you want, also try X" branches.

**Teaching value?** Medium. The pattern is most useful in Module 3 (Advanced), which is already framed as "guided tour, treat as optional" — adding "🎯 Try If Interested" blocks gives that framing teeth and reduces the all-or-nothing feeling. Less useful in Modules 1 and 2, which are linear builds.

**Verdict:** **ADOPT** — see [§5.4](#54-t-004--try-if-interested-micro-exercises) (light touch — Module 3 only).

---

#### T-005 — Quick-reference cheat sheet ("What you want" → "What to say")

**What it is:** Tamir's §12 has a two-column table mapping common intents to the exact phrase to say to the team:

| What you want | What to say |
|---|---|
| Team status | "Status" or "Who's on the team?" |
| Triage issues | "Check for new issues" |
| Start monitoring | "Ralph, go" |
| Capture a rule | "Always use TypeScript" |
| Get caught up | "What happened?" |
| Parallel work | "Team, build X" |

**Applicable today?** Yes — these are interactive-prompt patterns, not CLI commands.

**We have it?** No. Our workshop teaches specific prompts step-by-step but never consolidates them into a cheat sheet a learner can refer back to after the workshop ends.

**Teaching value?** High. This is the artifact a learner would print out and tape next to their monitor. It's also the most reusable piece of the workshop — usable on any future Squad project, not just the Reading List app.

**Verdict:** **ADOPT** — see [§5.5](#55-t-005--quick-reference-cheat-sheet) (new appendix at the end of [README.md](../../README.md) or a new [docs/cheat-sheet.md](../cheat-sheet.md)).

---

#### T-006 — `@copilot` coding agent as a team member

**What it is:** Tamir's §10 explains how to add GitHub's `@copilot` agent to the team via `squad copilot`, presents a capability profile (good fit / needs review / not suitable), and shows the auto-assign workflow (label `squad:copilot` → `@copilot` claims the issue → opens a PR).

**Applicable today?** Yes — `@copilot` (the GitHub-managed coding agent) is real and orthogonal to the Copilot CLI's Squad agent. Adding it to the team is a documented Squad feature.

**We have it?** No. Our [modules/03-advanced.md](../../modules/03-advanced.md) covers Ralph as the "autonomous" tier but never mentions `@copilot`. The two are complementary: Ralph is the *router*; `@copilot` is one of the *workers* he can route to.

**Teaching value?** Medium-high. Without this, learners think the only autonomous option is Ralph spawning a fresh Copilot session — which is `--execute` with the known specialist limitation ([issue #1081](https://github.com/bradygaster/squad/issues/1081)). `@copilot` is the alternative path: properly bounded autonomous work on small, labeled issues.

**Verdict:** **ADOPT** — see [§5.6](#56-t-006--copilot-coding-agent-as-a-team-member) (new Module 3 Step 11.5b or 12.5: "Add `@copilot` to your team — the bounded-autonomy alternative").

---

### Partial adoptions (light touch)

#### T-007 — Ceremonies (Design Review, Retrospective, Model Review)

**What it is:** Tamir's §11 frames recurring team activities as **ceremonies** that auto-trigger at key moments and live in `.squad/ceremonies.md`.

**Applicable today?** Yes — Squad CLI scaffolds `.squad/ceremonies.md` per the upstream docs, but our workshop never inspects it.

**We have it?** Partially. Module 1 Step 3 (explore + plan) functions as a design review without using the term; Module 1 Step 6 functions as a retro without using the term. We just don't name them.

**Teaching value?** Low. Adding the ceremony vocabulary is mostly cosmetic — but it does give learners a name to search for in upstream docs.

**Verdict:** **PARTIAL** — add one sentence in [modules/01-basic.md](../../modules/01-basic.md) Step 3 ("This is a *Design Review* in Squad terminology — see `.squad/ceremonies.md`") and Step 6 ("This is a *Retrospective* — same file"). No new section.

---

#### T-008 — Directive capture pattern ("Always X" / "Never Y" / "From now on Z")

**What it is:** Tamir's §12 documents a verbal shortcut — say `Always use TypeScript strict mode` and Squad auto-promotes it to a decision in `.squad/decisions/inbox/` → `.squad/decisions.md`.

**Applicable today?** Yes — this is documented Squad behavior.

**We have it?** Partially. [modules/01-basic.md](../../modules/01-basic.md) Step 5 explicitly asks the Lead to record a decision, and Module 2 inspects `decisions.md`. We don't teach the *verbal directive shortcut* — only the explicit "Lead, decide X" framing.

**Teaching value?** Medium. The directive shortcut is what a real working learner would use; the explicit "Lead, decide X" is workshop-formal.

**Verdict:** **PARTIAL** — add a small "Side note: directive shortcut" callout in [modules/01-basic.md](../../modules/01-basic.md) Step 5 showing the three patterns (`Always`, `Never`, `From now on`).

---

#### T-009 — `squad.config.ts` model/routing/casting config file

**What it is:** Tamir's `squad.config.ts` (the third workshop file) is a TypeScript config defining model tiers, routing rules, casting universe allowlist, and governance flags.

**Applicable today?** Verify — the `@bradygaster/squad` package import in his file is plausible but our workshop has not exercised this surface area. Squad's per-agent `config.json` is documented; whether the `.ts` form is canonical or just one example is worth confirming before adopting.

**We have it?** No. We don't expose any config-file editing.

**Teaching value?** Low-medium. Most workshop learners won't write a config file in their first 3 hours with Squad. But seeing one makes the "configurable" nature concrete.

**Verdict:** **PARTIAL** — include the file as a reference snippet in T-003's model-tier section (folded together). Don't make it a standalone topic.

---

#### T-010 — Consolidated resources table

**What it is:** Tamir's "Resources" closing table — single place with links to Squad CLI docs, GitHub repo, CLI reference, skills marketplace, npm package.

**Applicable today?** Yes.

**We have it?** Partially. We have per-module "Learn more" footers (introduced in 1.0.0 release). We don't have *one* consolidated table.

**Teaching value?** Low. The per-module footers already do this job, scoped to the module's topic. Consolidating is mild improvement.

**Verdict:** **PARTIAL** — add a single "Resources" subsection to README, above "Contributing", that lists the official links. Keep the per-module footers.

---

#### T-011 — Themed casting universe (Star Trek / Matrix / LOTR / Marvel)

**What it is:** Tamir highlights that the coordinator picks agent names from a thematic cast (Picard, Geordi, Riker, Crusher, etc.) — the names are persistent, memorable, and create the team feel.

**Applicable today?** Yes — this is core Squad behavior.

**We have it?** Barely. Our [modules/01-basic.md:206-209](../../modules/01-basic.md) Step 2 mentions "each member gets a name from a thematic cast" in one bullet and moves on. We never lean into it.

**Teaching value?** Low — but a real tone improvement. Naming creates the social fiction that makes the team-model click for learners.

**Verdict:** **PARTIAL** — in [modules/01-basic.md](../../modules/01-basic.md) Step 2, add a single sentence noting the universe (e.g., "Squad's default is Star Trek TNG — you'll likely meet Picard, Crusher, Geordi, etc. The names are persistent and stored in `.squad/casting/registry.json` so they survive across sessions."). One sentence, no more.

---

### Cross-cutting style adoptions

#### T-026 — Per-module table of contents at the top of each module

**What it is:** Tamir opens his workshop with a `| # | Section | Purpose |` table — a 2-second visual map of what's in the doc. We have something equivalent in our README's "Modules" table but not at the top of individual module files. A learner who jumps straight into `modules/01-basic.md` from a Google search has no quick overview.

**Applicable today?** Yes — pure formatting.

**We have it?** No.

**Teaching value?** Medium. Cheap to add, immediately improves orientation. Most useful in Module 1 (longest module, 6+ steps) and Module 3 (most subsections).

**Verdict:** **ADOPT — style.** Add a `## At a glance` table near the top of each `modules/*.md` file with `Step | What | Time` columns. See [§5.7](#57-t-026--per-module-table-of-contents).

---

#### T-027 — Friendly tone: section emoji + ⏱️ time badges

**What it is:** Tamir uses ⏱️ time badges per section, section-heading emoji (🎓 🤖 📋 🔄 🏷️ 🧩), and 💡 tip callouts. The effect is warmth without sacrificing content density. Our current workshop is deliberately spare on decoration — readable but a bit austere.

**Applicable today?** Yes.

**We have it?** No.

**Teaching value?** Low individually, meaningful collectively. Workshop readability is improved by *signal* (emoji-as-icon, used consistently) but harmed by *noise* (emoji-as-decoration, sprinkled randomly).

**Verdict:** **ADOPT — style.** Add ⏱️ time badges to every numbered step, one emoji per major section heading (used as a *type* indicator, not decoration), and 💡 for tip callouts. Keep body copy emoji-free — voice stays evaluative. See [§5.8](#58-t-027--friendly-tone-adoption).

> The 🎯 glyph is reserved for T-004 side quests, where it functions as a structural marker.

---

### Bonus content (modular topics → `modules/04-bonus.md`)

These were previously listed as "REJECT" but the right framing is **bonus** — modular topics that don't fit the linear mainline but are valuable enough to ship as workshop content with pick-and-choose pacing. They go into `modules/04-bonus.md` (single file, six sections), discoverable from the README modules table as "Bonus — optional".

#### T-012 — MCP integrations (Teams, Outlook, ADO, Playwright, EngineeringHub)

**What it is:** Tamir's §9 covers connecting Squad to external systems via Model Context Protocol servers.

**Verdict:** **BONUS** — too corp-specific to be mainline (adds an MCP infrastructure setup burden that learners may not need), but valuable enough that a learner asking "can Squad reach my work tools?" deserves a real answer. Lives in [§5.9](#59-bonus-content--modules04-bonusmd) as the "Reach out to other systems" bonus section.

---

#### T-013 — Teams Adaptive Cards / Email webhooks

**What it is:** Tamir's Appendix B and D cover formatting rich Teams notifications and falling back to Outlook COM.

**Verdict:** **BONUS** — folded into the same Teams/Email bonus section as T-012 (one section, not two — they overlap).

---

#### T-014 — DevBox setup for always-on Squad

**What it is:** Tamir's Appendix C — Azure DevBox provisioning, devtunnel access, PowerToys Awake to prevent sleep.

**Verdict:** **BONUS** — Azure-specific. The simpler "always-on Ralph" need is covered by the mainline T-002 (GitHub Actions cron). DevBox is for learners who *also* want a remote dev environment. Lives in the "Scale Squad beyond your laptop" bonus section.

---

#### T-015 — Cross-machine coordination

**What it is:** Tamir's §11 + Appendix C — Git-based task queue distributing work across machines via `.squad/cross-machine/`.

**Verdict:** **BONUS** — folds with T-014 (both are "scale beyond your laptop") and with T-025 multi-person Squad (the cross-machine queue is the technical mechanism that makes multi-person work).

---

#### T-016 — Human members in the team

**What it is:** Tamir's §11 — adding humans to `team.md` with a 👤 badge, configuring communication channels.

**Verdict:** **BONUS** — connects directly to T-025 (multi-person Squad). One bonus section covers both: "Working with other humans on the same Squad."

---

#### T-025 — Multi-person Squad ("Squad tracks one person — what about two?") — NEW

**What it is:** Not in Tamir's workshop explicitly, but a natural question from the user reviewing this adoption plan. Squad's state lives in `.squad/` in the repo — so two people sharing a repo automatically share the same Squad. But:

- Each person runs their own `copilot --agent squad` session locally; sessions don't see each other in real time.
- Decisions and memory files (`decisions.md`, `agents/*/history.md`, `identity/wisdom.md`) are append-only by design; `squad init` writes `.gitattributes` with merge drivers that handle concurrent edits.
- For coordinated multi-machine work (e.g., one person on a laptop + one on a DevBox), the cross-machine queue (T-015) is the documented mechanism.
- Conflict modes: two people editing routing simultaneously can produce odd team-state drift. Branch-protect `main`, push changes via PR, let the Scribe merge.

**Applicable today?** Mostly. The merge-driver behavior is documented; the cross-machine queue is real; the failure modes are real but under-documented upstream.

**We have it?** No. Our workshop is solo-dev throughout.

**Teaching value?** High — for any learner who finishes the workshop and wants to introduce Squad to their team. This is the #1 follow-up question.

**Verdict:** **BONUS** — gets its own section in `modules/04-bonus.md` titled "Working with other humans on the same Squad" (folds in T-016 human members). See [§5.9](#59-bonus-content--modules04-bonusmd).

---

### Genuinely rejected (truly out of scope)

#### T-017 — Tamir's `ralph-watch.ps1` v8 script

**What it is:** A 204-line PowerShell wrapper that drives `gh copilot <prompt>` directly with a multi-paragraph Ralph prompt baked in, plus lockfile / structured logging / heartbeat JSON / Teams alerts on 3+ failures.

**Applicable today?** Mostly. It wraps `gh copilot` (Copilot CLI) with a Ralph-specific prompt — a different approach than our `squad triage --interval 5` which uses Squad CLI's built-in Ralph loop. The script is **more featureful** (heartbeat, lockfile, log rotation, alerts) but **less idiomatic** (re-implements logic Squad CLI now provides natively).

**Verdict:** **REJECT** for the workshop body. The features that matter (heartbeat, lockfile, Teams alerts) would be a better-fit upstream feature request to `bradygaster/squad`. The script's pattern of "raw `gh copilot` + prompt" is also fragile — every Squad CLI change to the Ralph prompt requires editing this script.

We could **link** to it in [docs/troubleshooting.md](../troubleshooting.md) as "if `squad triage` doesn't give you the observability you need, see Tamir's alternative wrapper" — but not adopt it.

---

#### T-018 — Webhook & notification architecture (ASCII diagram)

**What it is:** Tamir's Appendix D shows a full enterprise notification flow (agent → Scribe → webhook config → format → Teams + Email).

**Verdict:** **REJECT** — enterprise ops topic, doesn't fit even as bonus content. The T-012/T-013 bonus section covers the *intent* (Squad reaches Teams) at a useful level of abstraction; the full webhook plumbing is too implementation-specific.

---

### Already-have (we cover better)

#### T-019 — `squad doctor`

We cover this in [modules/01-basic.md:106-138](../../modules/01-basic.md) Step 0f with full expected output and v0.9.1 backward-compat callout. Tamir's coverage is one sentence in §2 + one sentence in troubleshooting.

#### T-020 — Decisions / memory flow

Our [modules/01-basic.md:251-275](../../modules/01-basic.md) Step 3 explains the inbox → merged-file flow explicitly, including why the inbox is empty after a step. Tamir's coverage glosses over the inbox mechanism.

#### T-021 — Failure-mode honesty

Our [docs/troubleshooting.md](../troubleshooting.md) documents six upstream Squad bugs with issue links (#992, #1017, #1026, #1052, #1062, #1081). Tamir's troubleshooting is four paragraphs, none of which acknowledge known upstream bugs.

#### T-022 — Prerequisite verifier script

Our [scripts/Verify-Prerequisites.ps1](../../scripts/Verify-Prerequisites.ps1) is a robust PASS/FAIL checker with non-zero exit code. Tamir's workshop has manual `git --version` checks.

#### T-023 — Coach agent

Our [.github/agents/squad-coach.agent.md](../../.github/agents/squad-coach.agent.md) — a workshop-specific coaching agent with module step references. No upstream equivalent.

#### T-024 — Specific build target (Reading List app)

Our workshop builds one specific app end-to-end. Tamir's workshop is "build whatever you want — playground." Both are valid; ours is better for first-time learners who need a concrete success criterion.

---

## 5. Adoption proposals — detailed

Each adoption below is independently shippable. File:line targets are concrete; copy is drafted; sequencing is described in §8.

---

### 5.1 T-001 — Skills as a first-class feature

**Goal:** Teach learners that Skills exist, how to install one, and how an agent uses one — without bloating the workshop.

**Target placement:** New mini-step in Module 2, after Step 9 (artifact inspection) and before "You can stop here." Numbering it **Step 9.5** keeps the existing step numbers stable.

**Why Module 2 and not Module 3:** Module 3 is "optional guided tour"; Skills are core enough to belong in the build phase. Adding it before Step 9 would distract from artifact inspection (the workshop's centerpiece); after Step 9 it functions as a "here's how the team gets *better* over time" capstone.

**Proposed copy (new section in [modules/02-intermediate.md](../../modules/02-intermediate.md)):**

```markdown
---

## Step 9.5: Install a skill and watch the team use it

Squad agents gain new capabilities through **skills** — portable markdown modules (sometimes with scripts) that any agent can install and use. The skill ecosystem is maintained at [tamirdresher/squad-skills](https://github.com/tamirdresher/squad-skills) and includes things like fact-checking, news briefings, GitHub project board management, and reflective learning capture.

This step installs one skill and asks the team to use it.

### 9.5a. Install the `reflect` skill

The `reflect` skill teaches the team to capture lessons whenever you correct them. Lessons land in `.squad/identity/wisdom.md` automatically.

```powershell
# From inside reading-list-squad-lab/
git clone --depth 1 https://github.com/tamirdresher/squad-skills.git $env:TEMP\squad-skills
Copy-Item -Recurse $env:TEMP\squad-skills\plugins\reflect .squad\skills\reflect
```

Verify:

```powershell
Get-ChildItem .squad\skills\reflect\
```

You should see `SKILL.md`, `plugin.json`, and possibly a `README.md`.

### 9.5b. Tell the team to use it

In your Copilot CLI session:

```
Team, install the reflect skill from .squad/skills/reflect/SKILL.md.
From now on, whenever I correct you, capture the lesson in identity/wisdom.md
using the reflect skill's process.
```

### 9.5c. Force a correction and watch the skill fire

Pick something the team did in Step 7 (the filter feature) and correct it deliberately:

```
The filter implementation hardcodes the status values. From now on,
status values should come from a single source of truth — define an
enum or constant once and reference it everywhere.
```

After the team finishes, verify the lesson was captured:

```powershell
Get-Content .squad\identity\wisdom.md
```

A new entry should appear that names the pattern (single source of truth for status values) and is **specific to this project** — not generic best-practice advice.

### What "good" looks like for skills

- The captured lesson is concrete (file paths, names, conventions) — not "use enums for clarity."
- Future agent work in this session reflects the lesson without you re-explaining it.
- Skills earn trust: a skill that produces useful output gets called automatically next time; one that produces filler should be removed.

> **Skill confidence is real.** Squad tracks how often a skill is used and how often its output is useful. New skills are LOW confidence (agent asks before using); reliable ones become HIGH (used automatically). Inspect `.squad/skills/{name}/confidence.json` if it exists in your version.

### Why this matters

Skills are how a Squad gets *better* over time — not just remembers, but acquires capability. If you wanted to add web research, contract drafting, or screenshot-based UI review to your team, you'd add a skill, not a new agent. This is the upstream extensibility story.

---
```

**Other edits:**

- [README.md:99-114](../../README.md) "Getting help" section — add a third bullet to the structured-help list:
  ```markdown
  - [Skills marketplace](https://github.com/tamirdresher/squad-skills) — community-maintained skill modules; Module 2 Step 9.5 shows how to install one
  ```
- [docs/troubleshooting.md](../troubleshooting.md) — add a small entry under "General" for skill-related issues:
  ```markdown
  ### A skill doesn't fire when expected
  Skills earn confidence through use. New skills (LOW confidence) require the agent to explicitly invoke them. If a skill never fires, check `.squad/skills/{name}/confidence.json` and ask the agent directly: `Please use the {name} skill for this task.`
  ```
- [.github/agents/squad-coach.agent.md](../../.github/agents/squad-coach.agent.md) — add a short section "Skills questions" so the coach can answer "how do I install a skill?".

---

### 5.2 T-002 — Three-tier Ralph deployment

**Goal:** Teach learners that Ralph can run as a scheduled GitHub Action without a local machine, so the autonomous tier doesn't require a babysitter.

**Target placement:** New step in Module 3 between Step 11 (Ralph local watch) and Step 12 (`squad loop`). Numbering it **Step 11.5** keeps existing steps stable.

**Proposed copy (new section in [modules/03-advanced.md](../../modules/03-advanced.md)):**

```markdown
---

## Step 11.5: Ralph in GitHub Actions — the no-laptop tier (optional)

Step 11 ran Ralph from your local terminal. That works while your machine is on; it doesn't help when you close the laptop. The same Ralph polling loop can run as a scheduled GitHub Action.

> **Three tiers of Ralph:**
>
> | Tier | How | Best for |
> |---|---|---|
> | **In-session** | Self-chains during a `copilot --agent squad` session | While you're actively working |
> | **Local watchdog** | `squad triage --interval N` in a terminal (Step 11) | Hours-long sessions, observable in your shell |
> | **Cloud heartbeat** | GitHub Actions cron (this step) | Continuous, no machine required |

### 11.5a. Add the workflow

Create `.github/workflows/squad-heartbeat.yml` in your lab repo:

```yaml
name: Squad heartbeat (Ralph triage)

on:
  schedule:
    - cron: '*/15 * * * *'   # Every 15 minutes
  workflow_dispatch:           # Manual trigger from the Actions tab

jobs:
  triage:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    permissions:
      issues: write
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Install Squad CLI
        run: npm install -g @bradygaster/squad-cli

      - name: Run Ralph one round (triage only, no execute)
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: squad triage --once
```

### 11.5b. Commit and watch the first run

```powershell
git add .github\workflows\squad-heartbeat.yml
git commit -m "ci: schedule Ralph heartbeat every 15 minutes"
git push
```

Go to your repo's **Actions** tab and trigger the workflow manually (**Run workflow** button) for the first run. The cron will then fire every 15 minutes.

### 11.5c. Verify it works

After the manual trigger:

1. Open the workflow run in the Actions tab.
2. Look at the `Run Ralph one round` step output — should show Ralph polling, finding issues with `squad` label, and applying `squad:{member}` labels.
3. Check the issue you filed in Step 11b — it should now have a `squad:{member}` triage label and a comment.

### Stay in `--once` (no `--execute`)

This workflow runs `squad triage --once`, **not** `--execute`. Triage-only is the safe tier: Ralph labels and comments, but does not write code. Adding `--execute` to a scheduled workflow would mean autonomous agents spawning PRs while you sleep — possible, but with all the [#1081 specialist-charter caveats](https://github.com/bradygaster/squad/issues/1081) from Step 11d, and a much harder failure mode to debug.

**Rule of thumb:** start with `--once`, run it for a week, and only consider adding `--execute` if the triage labels Ralph applies are consistently right.

### Cost note

GitHub-hosted runners are free for public repos and have a 2,000-minutes/month allowance for private ones. This workflow runs ~30 seconds per invocation × 96 invocations/day = ~48 minutes/day = ~1,440 minutes/month — within the free tier for private repos, and free for public.

> **Honest tradeoff:** this is the most "fire and forget" Ralph tier and also the one that's hardest to observe. If something goes wrong (label sprawl, Ralph spamming comments), you find out via your GitHub email notifications, not by watching a terminal. Start with a wide `--interval` (every 60 minutes) and tighten only when you trust it.

---
```

**Other edits:**

- [README.md:32-37](../../README.md) Modules table — Module 3 "What you build" cell — append `Three tiers of Ralph (in-session / local / cloud cron)` to make the new content discoverable.
- [docs/troubleshooting.md](../troubleshooting.md) — add a section under "Module 3 — Aspire and Ralph":
  ```markdown
  ### Scheduled Ralph workflow fails with "permission denied" on labels
  The `GITHUB_TOKEN` provided by GitHub Actions has limited default permissions. The workflow above explicitly requests `issues: write`. If you customized the workflow and removed that line, Ralph cannot apply `squad:{member}` labels — restore the `permissions:` block.
  ```

---

### 5.3 T-003 — Model tiers for cost optimization

**Goal:** Teach learners that not every agent needs the premium model, and show them how to tier so they don't burn their premium budget on Ralph polling.

**Target placement:** Two touchpoints.

1. A new **brief** subsection in Module 1 Step 1, right after the existing model-selection block — explaining that the model picked there is the *session* model, and that per-agent tiers exist.
2. A new "Cost and model tiers" reference section in [docs/prerequisites.md](../prerequisites.md) (or a new [docs/budget-and-models.md](../budget-and-models.md)) with the full tier table.

**Proposed copy — Module 1 Step 1 addition (after line 191):**

```markdown
### One session model vs. per-agent tiers

The `/model` choice above sets the **session model** — what the coordinator uses by default. Squad also supports **per-agent model tiers**, configured in `.squad/config.json` after init. This matters because:

- The Lead, Backend, Frontend, and Tester benefit from a strong model (Sonnet or Opus class).
- The Scribe (logging memory) and Ralph (issue polling) don't need premium reasoning — Haiku-class is fine and 5× cheaper.

If you run out of budget mid-workshop or notice Ralph burning premium requests on routine polls, see [docs/budget-and-models.md](../../docs/budget-and-models.md) for the per-agent tier configuration.

> **Workshop default:** for Modules 1 and 2, the single-session-model choice above is enough. Tier optimization matters more once you point Ralph at a real backlog (Module 3).
```

**Proposed new file [docs/budget-and-models.md](../budget-and-models.md):**

```markdown
# Budget and model tiers

Squad supports per-agent model selection. This matters for cost: routing every request — including Ralph's idle polling — through the premium tier burns the monthly budget fast.

> **Premium request budget (Copilot Pro+):** 1,500 premium requests per month. Heavy multi-agent sessions can consume 50–200 of those in a single workshop module. See [docs/troubleshooting.md](../troubleshooting.md#agents-fail-mid-task-with-model-rate-limit-errors) for the rate-limit error pattern.

## Recommended tiering

| Tier | Model class (as of 2026-05) | Use for |
|---|---|---|
| **Fast** | Haiku 4.5 | Ralph (polling), Scribe (logging), routine status checks |
| **Standard** | Sonnet 4.6 | Backend, Frontend, Tester — most coding work |
| **Premium** | Opus 4.7 | Lead (architecture, review), mission-critical decisions |

Use the **strongest model you have access to** for the session-level choice in Module 1 Step 1, then *narrow* specific agents down with the config below. Don't try to optimize before you know what's slow or expensive.

## Configuring tiers

Edit `.squad/config.json` after init:

```json
{
  "agents": {
    "ralph":  { "model": "haiku-4.5" },
    "scribe": { "model": "haiku-4.5" },
    "picard": { "model": "opus-4.7" },
    "geordi": { "model": "sonnet-4.6" },
    "riker":  { "model": "sonnet-4.6" }
  }
}
```

> **Names vary.** Substitute your actual cast member names — `Get-Content .squad\team.md` to confirm.

> **Model availability varies.** The exact model IDs that `copilot --agent squad` recognizes depend on your Copilot CLI version. Check `/model` in a running session to see what's available before editing the config.

## Workshop budget estimate

Rough numbers from running the full workshop with the recommended tier mix:

| Module | Premium requests | Notes |
|---|---|---|
| Module 1 (Basic) | ~40–80 | Multi-agent vertical-slice build, Lead review |
| Module 2 (Intermediate) | ~25–50 | Smaller — memory should compound |
| Module 3 Aspire | <10 | Mostly observation |
| Module 3 Ralph `--once` | ~5 per round | One round to validate routing |
| Module 3 Ralph `--execute` | Open-ended | Cap with `--max-concurrent 1 --timeout 20` |

Modules 1 + 2 with the tier mix above leave plenty of monthly headroom (~1,300+ premium requests remaining) for Module 3 and your own real work.
```

**Other edits:**

- [README.md](../../README.md) Prerequisites section — add a line under the prereq table:
  ```markdown
  > **Budget note:** the workshop assumes a Copilot Pro+ plan (1,500 premium requests/month). See [docs/budget-and-models.md](docs/budget-and-models.md) for per-agent model tier configuration if you want to stretch the budget.
  ```
- [docs/troubleshooting.md](../troubleshooting.md) — add a cross-reference inside the existing rate-limit section ([line 274](../troubleshooting.md)) pointing to `budget-and-models.md`.

This adoption also closes W-012 (premium-request budget guidance).

---

### 5.4 T-004 — "🎯 Try If Interested" micro-exercises

**Goal:** Add low-commitment exploration branches to Module 3 to match its "guided tour, treat as optional" framing.

**Target placement:** Module 3 only. Module 1 and 2 stay linear.

**Proposed additions to [modules/03-advanced.md](../../modules/03-advanced.md):**

Five small "Try if interested" footers, one per existing step. Each is 2-3 lines, asks one question, and points to one thing to look at. Example, to append at the end of Step 10 (Aspire):

```markdown
### Try if interested

Pick *one* if curious:

- **Compare traces between agents.** Open the Aspire dashboard during a multi-agent task and identify which agent burned the most tokens — does the Lead's review pass cost more than the Backend's implementation?
- **Trace a tool call.** Find an MCP or shell tool call in the trace tree and read its arguments + result. What did the agent actually see?
```

Apply the same pattern to Steps 11, 11.5 (new from T-002), 12. Two-line "Try if interested" footer each.

> **Why no emoji header.** Our workshop's voice has been deliberately spare on decoration. Adopting the `🎯` glyph specifically would clash. Use the heading `### Try if interested` plain.

---

### 5.5 T-005 — Quick-reference cheat sheet

**Goal:** Give learners a portable, post-workshop cheat sheet of the prompt patterns they've learned.

**Target placement:** New file [docs/cheat-sheet.md](../cheat-sheet.md), linked from the README's "Getting help" section.

**Proposed new file content:**

```markdown
# Squad — Quick reference cheat sheet

> A compact list of the most useful prompt patterns and CLI commands taught in this workshop. Print it; tape it; come back to it after the workshop.

## Prompts you'll say to your team

| What you want | What to say |
|---|---|
| Hire the team | "I'm a solo developer building X. Use a lean team: Lead, Backend, Frontend, Tester, Scribe. Stack: Y. Set up the team now." |
| Plan before coding | "Before building anything, explore the repo, propose folder structure, capture one architecture decision, and explain the implementation plan. No code yet." |
| Build a feature | "Build the first vertical slice: backend X, frontend Y, tests Z. Keep it minimal but production-clean." |
| Force a decision | "Lead, decide whether we should use A or B. Record the decision with rationale in decisions.md." |
| Run a code review | "Lead, review all changes as if this were a real PR. Be specific about what's good and what needs improvement." |
| Add edge-case tests | "Tester, look for edge cases we skipped. Add tests for them." |
| Capture a permanent rule (directive shortcut) | "Always use TypeScript strict mode." / "Never commit secrets." / "From now on, all PRs need a test plan." |
| Catch up after a break | "What happened while I was away?" / "Status?" |
| Parallel work | "Team, build X. Backend writes the API, Frontend writes the UI, Tester writes the tests — work in parallel." |
| Inspect a decision | (in terminal) `Get-Content .squad\decisions.md` |
| Inspect agent memory | (in terminal) `Get-ChildItem .squad\agents\ -Recurse -Include history.md \| ForEach-Object { Get-Content $_ }` |

## CLI commands

| Command | What it does |
|---|---|
| `squad init` | Scaffold the team workspace (one-time per repo) |
| `squad doctor` | Health check — should show `0 failed` |
| `copilot --agent squad` | Launch the interactive Squad session (your main interface) |
| `copilot --agent squad --yolo` | Same, with auto-approve on |
| `/allow-all` | Toggle auto-approve inside a running session |
| `/model` | Switch the session model |
| `/quit` | Exit the Copilot CLI session |
| `squad triage` | Run Ralph one round in triage-only (safe — labels + comments only) |
| `squad triage --interval 5` | Run Ralph as a local watchdog every 5 minutes |
| `squad triage --execute` | **Caution** — Ralph autonomously works on issues (see Module 3 caveats) |
| `squad aspire` | Launch Aspire telemetry dashboard (requires Docker) |
| `squad loop` | Run a recurring prompt from `./loop.md` (repo root) |
| `New-Item -Path .squad\ralph-stop -ItemType File` | Stop a running Ralph cleanly |

## Files you should know

| Path | What's in it |
|---|---|
| `.squad/team.md` | Roster — who's on the team |
| `.squad/routing.md` | Which agent handles which type of work |
| `.squad/decisions.md` | Team-wide architectural decisions (read by every agent on session start) |
| `.squad/decisions/inbox/` | Pending decisions — usually empty after Scribe merges them |
| `.squad/agents/{name}/charter.md` | What agent X specializes in |
| `.squad/agents/{name}/history.md` | What agent X learned from past sessions |
| `.squad/identity/wisdom.md` | Patterns the team has captured that should survive across projects |
| `.squad/skills/{name}/SKILL.md` | Installed skill — see Module 2 Step 9.5 |
| `.github/agents/squad.agent.md` | The Squad coordinator (~92 KB — auto-installed by `squad init`) |
| `.github/workflows/squad-heartbeat.yml` | Scheduled cloud Ralph (Module 3 Step 11.5) |
```

**Other edits:**

- [README.md:99-114](../../README.md) "Getting help" section — add to the structured-help list:
  ```markdown
  - [docs/cheat-sheet.md](docs/cheat-sheet.md) — quick reference of all prompts, commands, and files
  ```

---

### 5.6 T-006 — `@copilot` coding agent as a team member

**Goal:** Teach the bounded-autonomy alternative to Ralph `--execute`.

**Target placement:** New small Module 3 step. Either replace Step 12 (`squad loop`) or insert as Step 11.6. Recommended: **Step 11.6**, sized to ~80 lines.

**Proposed copy (new section in [modules/03-advanced.md](../../modules/03-advanced.md)):**

```markdown
---

## Step 11.6: Add `@copilot` to your team (optional)

GitHub's `@copilot` agent — distinct from your `copilot --agent squad` session — can join your Squad as a team member that autonomously claims labeled issues and opens PRs. This is the *bounded-autonomy alternative* to Ralph `--execute`: instead of Ralph spawning a generic Copilot session ([issue #1081](https://github.com/bradygaster/squad/issues/1081)), `@copilot` runs in GitHub's infrastructure with its own well-defined capability profile.

### When `@copilot` is a good fit

| Category | Fit | Notes |
|---|---|---|
| Bug fixes with a clear failing test | ✅ Good | Well-defined boundary |
| Dependency bumps + minor compatibility fixes | ✅ Good | Bounded |
| Small features with a clear spec in the issue body | 🟡 Review required | PR review is mandatory |
| Refactors that touch many files | 🟡 Risky | Plan the PR scope tightly |
| Architecture, security review, system design | 🔴 Bad | Keep with your interactive Squad |

### 11.6a. Add `@copilot` to the team

In your Copilot CLI session:

```
Add @copilot to the team as a junior implementer. Add the squad:copilot label.
```

The team will update `.squad/team.md` to include `@copilot` and ensure the `squad:copilot` label exists in the repo.

### 11.6b. File an issue scoped for `@copilot`

`@copilot` does best with a clear acceptance criterion in the issue body. Try:

```powershell
gh issue create --title "Add input validation: title must be 1-200 chars" `
  --body @"
The POST /api/books endpoint currently accepts any title.

Acceptance criteria:
- Reject empty title with 400
- Reject title > 200 chars with 400
- Add unit tests for both rejection paths
- Add unit test for valid case (title = 'Test Book')

This is a bounded change — touch only the validation layer and tests.
"@ `
  --label "squad,squad:copilot"
```

### 11.6c. Watch `@copilot` claim it

Within a few minutes, `@copilot` will:
1. Self-assign the issue.
2. Create a branch (`copilot/<issue-number>-<slug>`).
3. Open a draft PR.
4. Push commits until acceptance criteria appear satisfied.
5. Mark the PR ready for review.

Watch in the **Pull requests** tab. The whole flow typically takes 5-15 minutes.

### 11.6d. Review the PR

This is the part that matters. `@copilot` is bounded but not infallible. Review:

- Did it touch only the validation layer? (Should not have rewritten unrelated code.)
- Are the tests real tests, or did it test the validation by re-implementing it?
- Did it add the *valid case* test, not just the rejection paths?

If review reveals a mistake, comment on the PR. `@copilot` responds to review feedback by pushing fixes.

### Ralph `--execute` vs. `@copilot`: when to use which

| Use Ralph `--execute` | Use `@copilot` |
|---|---|
| You have a backlog of varied issues and want routing | You want bounded work on a *specific* labeled issue |
| You're OK with the generic-Ralph spawn prompt limitation | You want GitHub's managed autonomous tier |
| You want all work to happen in one observable session | You want each task in its own branch + PR |
| You're testing how Ralph routes | You're testing whether `@copilot` finishes a real task |

For workshop purposes, **try one bounded `@copilot` task before pointing Ralph `--execute` at anything that matters.** It's a faster, cheaper feedback loop.

---
```

**Other edits:**

- [docs/troubleshooting.md](../troubleshooting.md) — extend the existing `--execute`/#1081 entry with a "Alternative" section:
  ```markdown
  **Alternative — `@copilot` (GitHub's managed coding agent):** for bounded, single-issue autonomous work, add `@copilot` to the team and label issues `squad:copilot`. `@copilot` runs in GitHub infrastructure with a documented capability profile and doesn't hit the specialist-charter limitation. See [Module 3 Step 11.6](../../modules/03-advanced.md).
  ```

---

### 5.7 T-026 — Per-module table of contents

**Goal:** Give a learner who lands on a module file a 2-second visual map of what's inside.

**Target placement:** Top of each `modules/*.md`, immediately after the H1 title and the existing back-link.

**Proposed copy — same structure for each module, varied content:**

**Module 1** ([modules/01-basic.md](../../modules/01-basic.md)):

```markdown
## At a glance

| Step | What you do | ⏱️ |
|---|---|---|
| 0 | Create the repo and initialize Squad (a–f) | ~10 min |
| 1 | Launch Copilot CLI with the Squad agent | ~5 min |
| 2 | Cast a lean solo-dev team | ~10 min |
| 3 | Make the team explore + plan first | ~10 min |
| 4 | Build the first vertical slice | ~25 min |
| 5 | Force an architectural decision | ~10 min |
| 6 | Use the reviewer on purpose | ~20 min |
```

**Module 2** ([modules/02-intermediate.md](../../modules/02-intermediate.md)):

```markdown
## At a glance

| Step | What you do | ⏱️ |
|---|---|---|
| 7 | Add a second-wave feature (filter + validation + tests) | ~25 min |
| 8 | Commit and push | ~3 min |
| 9 | Inspect `.squad/` artifacts honestly | ~15 min |
| 9.5 | Install a skill and watch the team use it *(new — T-001)* | ~10 min |
```

**Module 3** ([modules/03-advanced.md](../../modules/03-advanced.md)):

```markdown
## At a glance

| Step | What you do | ⏱️ | Mode |
|---|---|---|---|
| 10 | Observe with .NET Aspire | ~15 min | optional |
| 11 | Ralph — local watchdog | ~15 min | optional |
| 11.5 | Ralph in GitHub Actions *(new — T-002)* | ~10 min | optional |
| 11.6 | Add `@copilot` coding agent *(new — T-006)* | ~15 min | optional |
| 12 | Prompt-driven loops (`squad loop`) | ~10 min | optional |
```

The `optional` column is unique to Module 3 because every step there is opt-in.

**Other edits:** None — this is purely additive at the top of each file.

---

### 5.8 T-027 — Friendly tone adoption

**Goal:** Warm up the workshop's voice without sacrificing its evaluative discipline.

**Rules of the road:**

- **One emoji per major section heading** — used as a *type indicator*, not decoration. Never two emoji in a row.
- **⏱️ before every step time** — visually distinguishes time from content.
- **💡 for tips** — distinct from regular callouts (which stay as `> **Note:**` blockquotes).
- **🎯 reserved for T-004 side quests only** — never for regular content.
- **Body copy stays emoji-free** — voice stays direct and evaluative.

**Section-emoji map (proposed):**

| Section type | Emoji | Used on |
|---|---|---|
| Goal / overview | 🎯 | (NO — reserved for side quests, use no emoji) |
| Goal / overview | 📦 | Module 1 "Goal", Module 2 "Prerequisites" |
| Build / vertical slice | 🔨 | Module 1 Step 4 |
| Decisions / architecture | 🗺️ | Module 1 Steps 3, 5 |
| Review / quality | 🔍 | Module 1 Step 6, Module 2 Step 9 |
| Memory / artifacts | 📚 | Module 2 Step 9 |
| Skills | 🧩 | Module 2 Step 9.5 (new) |
| Observability | 🔭 | Module 3 Step 10 |
| Autonomous / Ralph | 🤖 | Module 3 Steps 11, 11.5, 11.6, 12 |
| Bonus / extras | 🎁 | Module 4 Bonus |
| Reference / docs | 📖 | docs/reference/* files |
| Tip / callout | 💡 | Inline tip callouts (replaces some `> **Tip:**`) |

**Example diff — Module 1 Step 4 heading:**

Current:
```markdown
## Step 4: Build the first vertical slice
```

Proposed:
```markdown
## 🔨 Step 4: Build the first vertical slice  ⏱️ ~25 min
```

**Example diff — Module 3 Step 11 heading:**

Current:
```markdown
## Step 11: Try Ralph — Watch Mode (optional, safe in triage-only)
```

Proposed:
```markdown
## 🤖 Step 11: Try Ralph — Watch Mode  ⏱️ ~15 min  (optional, safe in triage-only)
```

**Body-copy untouched.** No emoji sprinkled in prose. The discipline is: emoji is a *navigational icon* on a header or a *type marker* on a callout (`💡`), never a paragraph decoration.

**Other edits:**

- [README.md](../../README.md) "Modules" table — add a leading emoji column matching the section emoji scheme for visual continuity.
- [.github/copilot-instructions.md](../../.github/copilot-instructions.md) Tone section (line 87) — add a sentence: *"Use emoji as section icons (one per heading) and ⏱️ for time badges. Keep body copy emoji-free."*

---

### 5.9 Bonus content — `modules/04-bonus.md`

**Goal:** Provide a single file in `modules/` that gathers all the modular topics (MCP, multi-person, DevBox, cross-machine, human members, Teams integration) into one pick-and-choose document — workshop content with Tamir-style pacing.

**Why one file, not a folder:** the six topics are small individually (~80-200 lines each). One file is easier to skim, easier to link to specific sections via anchors, and easier to maintain (one open-issue queue, not six). A learner opening this on a flight reads top-to-bottom; one with a specific need uses Ctrl-F or the TOC.

**Target placement:** [modules/04-bonus.md](../../modules/04-bonus.md) — sits next to `01-basic.md`, `02-intermediate.md`, `03-advanced.md` in the modules folder. Discoverable from the README modules table as a fourth row with `Optional / Bonus` in the time column.

**Proposed file structure:**

```markdown
# 🎁 Module 4 — Bonus: Where Squad goes next

> Six modular topics for after you finish the mainline workshop. Pick what
> applies — none of this builds on anything else. Closer to a reference guide
> than a tutorial.

← Back to [Workshop Index](../../README.md) · [← Module 3](03-advanced.md)

---

## At a glance

| # | Topic | When you'd want it | ⏱️ |
|---|---|---|---|
| B1 | Working with other humans on the same Squad | You want to introduce Squad to your team | ~15 min read |
| B2 | Squad meets the rest of your stack (MCP) | You want Squad to read Teams / Outlook / ADO | ~10 min read |
| B3 | Notifications via Teams + Email | You want Ralph to post status to a channel | ~5 min read |
| B4 | Scale beyond your laptop (DevBox + always-on) | You want Ralph running 24/7 without your machine | ~10 min read |
| B5 | Cross-machine coordination | You have multiple machines (laptop + DevBox + …) | ~10 min read |
| B6 | Reflection — choosing what to keep on real work | You finished the workshop and want a decision framework | ~5 min read |

> **None of this is on the mainline.** Modules 1-2 are the workshop. Module 3 is the optional tour. This is the appendix.

---

## B1. 🤝 Working with other humans on the same Squad

*(folds T-016 + T-025)*

Squad's state lives in `.squad/` in your repo. The implication: two people sharing a repo share the same Squad — by design, because that's the point of repo-native memory. But it's worth knowing the failure modes before you onboard your team.

### What works out of the box

- **Decisions and memory survive across people.** Every `copilot --agent squad` session reads `.squad/decisions.md` and `.squad/agents/*/history.md`. If your colleague added a decision yesterday, your session sees it today.
- **Append-only merge drivers.** `squad init` writes a `.gitattributes` file with merge strategies for the memory files. Concurrent edits to `decisions.md` from two branches merge as appends, not conflicts.
- **The team roster is shared.** `team.md` and `routing.md` are repo-committed; everyone sees the same cast.

### What doesn't work out of the box

- **Sessions don't see each other in real time.** If you and your colleague both run `copilot --agent squad` at the same time, you each get a separate session. There's no "shared cursor" — coordination happens via Git and via issue/PR comments, not by being in the same Copilot session.
- **Conflicting decisions are possible.** Two people independently asking "Lead, decide whether to use SQLite or Postgres" can produce two conflicting decisions. The Scribe will merge them as appends; *resolving* the conflict is human work.
- **Routing changes can drift.** If both people customize `routing.md` independently and push, you'll get an append-conflict on Git. Resolve it before pushing.

### Adding humans to the roster

Squad has explicit support for adding humans as team members. From a Copilot session:

```
Add Sarah Johnson as Product Owner. Contact: sarah@company.com.
```

The team will update `team.md`:

```markdown
| Sarah Johnson | 👤 Human — Product Owner | sarah@company.com |
```

The key difference from agent members: **humans aren't spawnable.** Agents won't autonomously hand work to a human — they'll *flag* work that needs human input and wait. You define how that handoff happens (an issue comment, a Teams message via B3, an email).

### Rules of thumb for team Squad adoption

1. **Branch-protect `main`.** Push routing/decision changes via PR. Let one person (the de-facto Squad steward) approve.
2. **One Scribe per repo, not per person.** The Scribe agent is the merge authority. Don't have each person spawn their own Scribe instance.
3. **Treat `.squad/` like any other code.** Code review changes to `routing.md` and `team.md` as carefully as you'd review a CI config.
4. **The cross-machine queue (B5) is for when the same person works from multiple machines.** It's not the right tool for two people splitting work — use GitHub Issues + Ralph triage for that.

### Honest tradeoff

The team-Squad story is *possible* but *under-documented* upstream. Expect to invent some conventions yourself for the first few weeks. If your team is more than ~5 people sharing a repo, you'll probably want a designated Squad steward who owns `routing.md` and `decisions.md` review.

---

## B2. 🧩 Squad meets the rest of your stack (MCP)

*(folds T-012)*

Model Context Protocol (MCP) is the standard way Squad's agents reach out to systems outside your repo. Without MCP, an agent can only read/write files and run shell commands. With MCP servers configured, an agent can: read Azure DevOps work items, post Teams messages, search Outlook, screenshot a browser with Playwright, query a database.

### Workshop minimum: know it exists

If you finish the workshop and never touch MCP, that's fine. The Reading List app didn't need it.

### When MCP starts to matter

- Your work tracking lives in Azure DevOps or Linear, not GitHub Issues. (Ralph polls GitHub by default; MCP gives him a way to poll ADO too.)
- You need agents to post status to Teams or Slack.
- You want screenshot-driven UI review (Playwright MCP).

### Setup at a glance

MCP servers are configured per-tool:

- **Global**: `~/.copilot/mcp-config.json` (applies to every Copilot session on your machine)
- **Per-project**: `.vscode/mcp.json` (applies only in this repo)

Example — adding the GitHub MCP server (often useful even with Squad's native GitHub support):

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${env:GITHUB_TOKEN}"
      }
    }
  }
}
```

### What to read next

- The MCP server registry — [github.com/modelcontextprotocol](https://github.com/modelcontextprotocol)
- Tamir's full MCP integration writeup (more depth than this section warrants): [tamirdresher/squad-skills workshop §9](https://github.com/tamirdresher/squad-skills/blob/main/workshop/README.md#9-mcp-integrations--extend-capabilities)

---

## B3. 📨 Notifications via Teams + Email

*(folds T-013)*

If you want Ralph to *announce* — "I triaged 3 issues, here are the labels" — Teams webhooks are the easiest path. Outlook COM (or SMTP) is the fallback when Teams isn't available.

The full Adaptive Card / multi-channel routing setup is enterprise-grade and lives in [Tamir's Appendix B + D](https://github.com/tamirdresher/squad-skills/blob/main/workshop/README.md#appendix-b-teams--email-integration). What we'll cover here is the minimum that's useful.

### Teams webhook — minimum viable

> ⚠️ **Correction (see [§0.4](#0-reassessment-2026-05-30)):** the built-in `squad watch` does **not** auto-read `~/.squad/teams-webhook.url` — but **Tamir's `ralph-watch.ps1` wrapper does** read it and POST below, so this works only when *that script* runs (not `squad watch` alone). Built-in Teams uses the `teams-graph` OAuth adapter + the `notification-routing` skill. Prefer a Power Automate **Workflows** URL — classic O365 Incoming Webhook connectors are being retired.

```powershell
# In Teams: create a Power Automate "Workflows" incoming webhook → copy URL
# Save it somewhere YOUR script reads (Ralph does NOT read this automatically):
Set-Content -Path $env:USERPROFILE\.squad\teams-webhook.url -Value "https://....webhook.office.com/..."
```

A simple Ralph round can then post a status message:

```powershell
$webhook = Get-Content $env:USERPROFILE\.squad\teams-webhook.url
$body = @{ text = "Ralph triaged 3 issues this round." } | ConvertTo-Json
Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType 'application/json'
```

For richer notifications (color-coded priority, click-through buttons), use Adaptive Cards — Tamir's appendix has working JSON templates.

### Tradeoff

This is opt-in noise generation. Most workshop runs don't need it. Add it only if you have a real audience for the notifications (an oncall channel, a daily standup) — otherwise Ralph just clutters Teams.

---

## B4. ☁️ Scale beyond your laptop (DevBox + always-on)

*(folds T-014)*

If you're committed to running Ralph 24/7, you have three options ranked by cost-to-effort:

| Option | Cost | Effort | When |
|---|---|---|---|
| GitHub Actions cron (Module 3 Step 11.5) | Free for public repos, 2000 min/mo free for private | Minimal — one YAML file | Default — start here |
| Local desktop + PowerToys Awake | Free | Low — install Awake, keep machine on | You already have a desktop that's always on |
| Azure DevBox | ~$0.25/hour (~$180/mo for 24/7) | Medium — provision, devtunnel, install Squad | You need GPU, isolated env, or remote access |

### DevBox setup at a glance

If you're going the DevBox route — sometimes useful for enterprise workflows where the dev machine is locked down:

1. Provision via Azure Portal (DevBox project + pool) — ~15 min.
2. RDP in, clone your repo, `gh auth login`, `npm install -g @bradygaster/squad-cli`.
3. Start Ralph (`squad triage --interval 5` or the GitHub Actions cron from Module 3 Step 11.5).
4. Install [PowerToys Awake](https://github.com/microsoft/PowerToys/releases) to keep the DevBox from sleeping.
5. Optionally, set up devtunnel for external access: `devtunnel host -p 3000 --allow-anonymous`.

### Honest tradeoff

If your only reason for a DevBox is "always-on Ralph," the GitHub Actions cron from Module 3 Step 11.5 does the same job at zero cost. DevBox makes sense when you *also* want a remote development environment for other reasons.

---

## B5. 🔄 Cross-machine coordination

*(folds T-015)*

Squad supports distributing work across multiple machines using Git as the task queue. This is for the case where the **same person** works from a laptop + DevBox + workstation and wants Squad state to flow between them. It is **not** the right tool for multiple humans sharing one Squad (see B1).

### The cross-machine queue

```
.squad/cross-machine/
├── tasks/          # Work to be done — one .md per task
│   ├── task-001-iss-42-laptop.md
│   └── task-002-iss-43-devbox.md
└── results/        # Completed work
```

A task file describes a unit of work + which machine should claim it. Machines polling the queue claim tasks by adding their machineId to the file and committing.

### Configuration

In `.squad/config.json`:

```json
{
  "machineId": "LAPTOP-WORK",
  "peers": {
    "DEVBOX-CLOUD": {
      "role": "devbox",
      "teamRoot": "/home/user/project"
    }
  }
}
```

### Honest tradeoff

This surface is more aspirational than battle-tested. The merge semantics for two machines simultaneously claiming the same task aren't well-documented. Try it on a non-critical repo first.

---

## B6. 🪞 Reflection — choosing what to keep on real work

You've finished the workshop. Now you have to decide whether to introduce Squad to a real project. A short framework for that decision:

### Keep Squad if

- You consistently re-explain context to AI assistants across sessions.
- You work on >1 repo and would benefit from per-repo team memory.
- Your repo has architectural decisions worth recording (most do).
- You have a Copilot Pro+ plan (or institutional budget for one).

### Don't keep Squad if

- You're a contractor working on someone else's repo (you can't commit `.squad/`).
- Your work is mostly bug fixes on a stable codebase — Squad's value is in coordination, not in one-shot tasks.
- Your tests are thin or non-existent — Squad's review pass needs something to push against.
- The team's artifacts after Module 2 Step 9 read as AI confetti, not real work. (That's the inspect-step decision; trust your own read of `decisions.md` and `wisdom.md`.)

### What to do in the next two weeks

1. Pick one *real* repo (not the workshop one) and run `squad init` on it.
2. Use the team on one real feature, no smaller than a day of work.
3. After 5 days, inspect `.squad/` again with the rubric from Module 2 Step 9.
4. Decide. Either commit to Squad for that repo or remove the `.squad/` directory and move on. Don't half-adopt — the value is in the compounding memory, which requires consistent use.

---

← Back to [Workshop Index](../../README.md) · [← Module 3](03-advanced.md)
```

**Other edits to support `modules/04-bonus.md`:**

- [README.md](../../README.md) Modules table — add a 4th row:
  ```markdown
  | 4 | [Bonus](modules/04-bonus.md) | Six modular topics: team Squad, MCP, Teams notifications, DevBox, cross-machine, reflection framework | Pick-and-choose | Completed module 3 helpful but not required. |
  ```
- [modules/03-advanced.md](../../modules/03-advanced.md) "You're done" closing section — add a final line pointing to Module 4:
  ```markdown
  > If you want to go further: [Module 4 — Bonus](04-bonus.md) covers team Squad, MCP, scale, and the decision framework for adopting Squad on a real project.
  ```

---

## 6. Items deliberately rejected

For the record — these are explicitly **not** being adopted, with brief reasons.

| Technique | Reason for reject |
|---|---|
| **T-017 — Tamir's `ralph-watch.ps1` script** | Wraps `gh copilot` directly with a baked-in prompt — fragile to upstream changes; reimplements features Squad CLI provides natively. Better as a future upstream feature request to `bradygaster/squad` than as workshop content. |
| **T-018 — Webhook architecture diagram** | Enterprise ops topic. Doesn't fit even as bonus content — the bonus section B3 covers the *intent* at a useful level; the full webhook plumbing is too implementation-specific to teach. |

T-012 through T-016 were previously listed here as REJECT. They are now BONUS — folded into [modules/04-bonus.md](../../modules/04-bonus.md) (sections B1-B5 in [§5.9](#59-bonus-content--modules04-bonusmd)).

---

## 7. Tracking table

This is the canonical list of changes triggered by this analysis. Flip `⏳` → `✅` as each lands.

### Mainline adoptions (build path)

| ID | Title | Severity | Verdict | Touches | Resolved? |
|---|---|---|---|---|---|
| **T-001** | Skills as a first-class feature | MEDIUM | ADOPT — mainline | New Module 2 Step 9.5; new `docs/reference/skills.md`; README "Getting help"; troubleshooting; coach agent | ⏳ |
| **T-002** | Three-tier Ralph deployment (Actions cron) | MEDIUM | ADOPT — mainline | New Module 3 Step 11.5; README modules table; troubleshooting | ⏳ |
| **T-006** | `@copilot` coding agent as team member | MEDIUM | ADOPT — mainline | New Module 3 Step 11.6; troubleshooting `--execute` cross-ref | ⏳ |

### Side-quest adoption (Module 3 only)

| ID | Title | Severity | Verdict | Touches | Resolved? |
|---|---|---|---|---|---|
| **T-004** | 🎯 "Try if interested" micro-exercises | LOW | ADOPT — side quests | Module 3 — 5 footers across Steps 10, 11, 11.5, 11.6, 12 | ⏳ |

### Reference adoptions (`docs/reference/` folder)

| ID | Title | Severity | Verdict | Touches | Resolved? |
|---|---|---|---|---|---|
| **T-003** | Model tiers for cost optimization | MEDIUM | ADOPT — reference | New `docs/reference/budget-and-models.md`; Module 1 Step 1 addition; README prereqs note; troubleshooting cross-ref. Closes W-012. | ⏳ |
| **T-005** | Quick-reference cheat sheet | LOW | ADOPT — reference | New `docs/reference/cheat-sheet.md`; README "Getting help" link | ⏳ |

### Style adoptions (cross-cutting readability)

| ID | Title | Severity | Verdict | Touches | Resolved? |
|---|---|---|---|---|---|
| **T-026** | Per-module TOC table at top of each module | LOW | ADOPT — style | `modules/01-basic.md`, `02-intermediate.md`, `03-advanced.md` — `## At a glance` table near top | ⏳ |
| **T-027** | Friendly tone (section emoji + ⏱️ time badges) | LOW | ADOPT — style | All module headings; README modules table; `.github/copilot-instructions.md` tone section | ⏳ |

### Partial adoptions (inline edits + small reference docs)

| ID | Title | Severity | Verdict | Touches | Resolved? |
|---|---|---|---|---|---|
| **T-007** | Ceremonies naming | LOW | PARTIAL | Two inline notes in Module 1 Steps 3 + 6; new `docs/reference/ceremonies-glossary.md` (~50 lines) | ⏳ |
| **T-008** | Directive capture pattern (`Always X`) | LOW | PARTIAL | One callout in Module 1 Step 5 | ⏳ |
| **T-009** | `squad.config.ts` example | LOW | PARTIAL | Fold into T-003's `budget-and-models.md` | ⏳ (covered by T-003) |
| **T-010** | Consolidated resources table | LOW | PARTIAL | New `docs/reference/resources.md`; README link | ⏳ |
| **T-011** | Themed casting universe | LOW | PARTIAL | One sentence in Module 1 Step 2 | ⏳ |

### Bonus adoptions (single file — `modules/04-bonus.md`)

| ID | Title | Severity | Verdict | Bonus section | Resolved? |
|---|---|---|---|---|---|
| **T-012** | MCP integrations | LOW | BONUS | B2 — Squad meets the rest of your stack | ⏳ |
| **T-013** | Teams Adaptive Cards / Email webhooks | LOW | BONUS | B3 — Notifications via Teams + Email | ⏳ |
| **T-014** | DevBox setup | LOW | BONUS | B4 — Scale beyond your laptop | ⏳ |
| **T-015** | Cross-machine coordination | LOW | BONUS | B5 — Cross-machine coordination | ⏳ |
| **T-016** | Human team members | LOW | BONUS | B1 — Working with other humans on the same Squad (folded with T-025) | ⏳ |
| **T-025** | Multi-person Squad — *new in this revision* | MEDIUM | BONUS | B1 — Working with other humans on the same Squad (folded with T-016) | ⏳ |
| — | B6 — Reflection / decision framework — *new editorial* | LOW | BONUS | B6 — Choosing what to keep on real work | ⏳ |
| — | `modules/04-bonus.md` file itself | MEDIUM | BONUS | New module file; README modules table; Module 3 closing line | ⏳ |

### Rejected (no action, no bonus inclusion)

| ID | Title | Verdict |
|---|---|---|
| T-017 | Tamir's `ralph-watch.ps1` | REJECT — fragile pattern; better as upstream feature request |
| T-018 | Webhook architecture diagram | REJECT — too implementation-specific even for bonus |

### Already covered (no action)

| ID | Title | Why we win |
|---|---|---|
| T-019 | `squad doctor` | Our Step 0f has full expected output + v0.9.1 callout |
| T-020 | Decisions / memory flow | Our Step 3 explains inbox → merged-file explicitly |
| T-021 | Failure-mode honesty | Our troubleshooting documents 6 upstream bugs with issue links |
| T-022 | Verifier script | Tamir has manual `git --version`; we have a robust PASS/FAIL checker |
| T-023 | Coach agent | We have one; Tamir's workshop does not |
| T-024 | Specific build target | Reading List app > "build whatever you want" for first-time learners |

### Cross-references to other open audit items

| Other doc | Item closed/touched | How |
|---|---|---|
| the baseline review (removed in cleanup) | **W-012** — Premium-request budget guidance | T-003 ships `docs/reference/budget-and-models.md` with a workshop budget estimate table — closes W-012. |

---

## 8. Sequencing recommendation

Total surface area if everything lands:

**New files (8):**
- `docs/reference/cheat-sheet.md`
- `docs/reference/budget-and-models.md`
- `docs/reference/skills.md`
- `docs/reference/ceremonies-glossary.md`
- `docs/reference/resources.md`
- `modules/04-bonus.md`
- `.github/workflows/squad-heartbeat.yml` (Module 3 Step 11.5 ships this as part of the lab repo, not as a workshop-repo file — included here for completeness)

**Modified existing files (~12 small edits):**
- [README.md](../../README.md) — modules table updates, prereqs note, "Getting help" links, section emoji
- [modules/01-basic.md](../../modules/01-basic.md) — `## At a glance` table, ⏱️ time badges, section emoji, directive-capture callout, ceremonies inline notes, themed-casting sentence
- [modules/02-intermediate.md](../../modules/02-intermediate.md) — `## At a glance` table, ⏱️ time badges, section emoji, new Step 9.5 (Skills)
- [modules/03-advanced.md](../../modules/03-advanced.md) — `## At a glance` table, ⏱️ time badges, section emoji, new Steps 11.5 + 11.6, 🎯 side-quest footers, closing line to Module 4
- [docs/troubleshooting.md](../troubleshooting.md) — skill troubleshooting entry, scheduled-Ralph permissions entry, `--execute` `@copilot` cross-ref, budget-and-models cross-ref
- [.github/agents/squad-coach.agent.md](../../.github/agents/squad-coach.agent.md) — Skills knowledge section
- [.github/copilot-instructions.md](../../.github/copilot-instructions.md) — tone-rules sentence

**Net additions:** Module 2 grows from 3 → 4 steps; Module 3 grows from 3 → 5 steps; new `modules/04-bonus.md` (~600 lines); new `docs/reference/` folder (~5 files, ~80-200 lines each). The mainline workshop time is essentially unchanged because new steps in Modules 2 and 3 are explicitly opt-in.

### Five waves

To avoid landing it all in one PR:

**🎨 Wave 0 — Style + polish (1 small PR)**
Lands first because it's pure readability with zero behavior change.
- **T-026** — Per-module TOC tables (add `## At a glance` to each module).
- **T-027** — Friendly tone (section emoji map + ⏱️ time badges).
- **T-007, T-008, T-010, T-011** — Partials (inline ceremonies notes, directive-capture callout, themed-casting sentence). The new `docs/reference/ceremonies-glossary.md` and `docs/reference/resources.md` from this wave can be empty stubs initially; populate in Wave 1.

**🏗️ Wave 1 — Foundation + reference folder (1 PR)**
Establishes `docs/reference/` and closes the prior-audit budget gap.
- **T-003** — Model tiers → `docs/reference/budget-and-models.md`. Closes W-012.
- **T-005** — Cheat sheet → `docs/reference/cheat-sheet.md`.
- Fill the stubs from Wave 0 (ceremonies-glossary, resources).

**🧩 Wave 2 — Module 2 capability story (1 PR)**
The centerpiece of this analysis.
- **T-001** — Skills → new Module 2 Step 9.5 + `docs/reference/skills.md`. Test end-to-end on a real `tamirdresher/squad-skills` install.

**🤖 Wave 3 — Module 3 autonomous tier (1 PR)**
- **T-002** — Actions cron Ralph → new Module 3 Step 11.5.
- **T-006** — `@copilot` coding agent → new Module 3 Step 11.6.
- **T-004** — 🎯 Side quests → 5 footers across Module 3 (now that Steps 11.5 and 11.6 exist).

**🎁 Wave 4 — Bonus module (1 PR)**
- New `modules/04-bonus.md` covering B1 (T-016 + T-025), B2 (T-012), B3 (T-013), B4 (T-014), B5 (T-015), B6 (decision framework).
- README modules table — add Module 4 row.
- Module 3 closing — add pointer to Module 4.

### Release cadence

- After Wave 0: tag **1.1.1** (style polish — incremental on the 1.1.0 release planned in the baseline review §5 D-3 (removed in cleanup)).
- After Wave 3: tag **1.2.0** (Module 2 capability story + Module 3 autonomous tier — meaningful expansion).
- After Wave 4: tag **1.3.0** (bonus module — first "Module 4" of the workshop).

Each wave is a standalone PR. Don't bundle Wave 2 with Wave 3 — they're independently shippable and each warrants its own review pass.

---

*End of analysis. Total techniques surveyed: 27. Mainline adoptions: 3. Side-quest adoption: 1. Reference adoptions: 2. Style adoptions: 2. Partial adoptions: 5. Bonus adoptions: 7 (six topics + the file itself). Genuinely rejected: 2. Already-covered: 6.*
