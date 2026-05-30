# Post-PR #1 — Verification & Fix-Later Checklist

> **Document type:** Post-merge verification log + actionable fix inventory
> **Created:** 2026-05-30
> **Author:** Claude (independent verification against the live Squad CLI source)
> **Trigger PR:** [joslat/squad-workshop#1](https://github.com/joslat/squad-workshop/pull/1) — *"fix: command names, loop.md path, closed bug refs, + human member / Teams / Ralph Go sections"* (authored by Tamir Dresher's squad agent via issue #3492)
> **Decision context:** PR #1 is being **accepted as authoritative** (Tamir Dresher is a co-creator of Squad). Per that decision, **`squad watch` is adopted as the primary command name** workshop-wide. This document records what was verified, what is still wrong after the merge, and exactly where to fix it — **we verify and fix these later.**

> **Ground-truth basis:** `bradygaster/squad` source (tags `v0.9.4` and branch `dev`/`main`) and the published npm package `@bradygaster/squad-cli`. npm dist-tags confirmed 2026-05-30: `latest = 0.9.4`, `insider = 0.9.6-insider.3`, `preview = 0.8.17-preview`. **v0.9.4 is the newest *stable* release**; the workshop targets it.

---

## Status legend

| Mark | Meaning |
|---|---|
| ✅ **Correct** | PR claim verified true against source — keep as-is |
| 🟡 **Correct-but-incomplete** | PR fix is right but doesn't cover every occurrence — finish the sweep |
| ❌ **Wrong** | PR claim contradicted by source — fix after merge |
| 🔧 **Latent bug exposed** | A pre-existing workshop bug surfaced during verification |

---

## 1. PR #1 item-by-item verdict (expanded, with source + proof)

| # | PR change | Verdict | Source & proof (verified) | Fix-later action |
|---|---|---|---|---|
| 1 | Rename `squad triage` → `squad watch` as primary; calls `watch` "preferred", `triage` the "alias" | ✅ **Adopt** (per decision) — but note the nuance | Both names are accepted: `cli-entry.ts` dispatch `if (cmd === 'triage' \|\| cmd === 'watch')` ([blob](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-cli/src/cli-entry.ts)). The implementation dir is `commands/watch/` (`runWatch`), command was **born as `squad watch`** in [release v0.5.1](https://github.com/bradygaster/squad/releases/tag/v0.5.1) (2026-02-20). **Counter-signal:** `squad --help` lists only `triage`, and the official CLI reference says *"`squad triage` … (primary name; `watch` is an alias)"* ([cli.md](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/reference/cli.md)); FAQ: *"squad triage is the new primary command name (as of v0.8.26)"* ([faq.md](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/guide/faq.md)). **Net:** both work; `watch` is the original/native name + co-creator's preference, `triage` is the docs-surfaced label. Adopting `watch` is valid **and** fixes item 7 below. | Sweep all remaining `squad triage` command invocations → `squad watch` (see §2.1). Keep the english verb "triage". |
| 2 | `.squad/loop.md` → `./loop.md` (repo root) | ✅ **Correct** | `loop.ts`: `const loopFilePath = options.filePath ? path.resolve(workTreeRoot, options.filePath) : path.join(workTreeRoot, 'loop.md')` ([blob](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-cli/src/cli/commands/loop.ts)). CLI docs: *"`--file <path>` — Path to loop file (default: `loop.md` in project root)"* ([cli.md](https://github.com/bradygaster/squad/blob/v0.9.4/docs/src/content/docs/reference/cli.md)). | 🟡 PR fixes Module 3 only — **2 spots still wrong** (see §2.2). |
| 3 | #1017, #1062 "fixed upstream — upgrade to **0.9.4+**" | ❌ **Wrong version** | Both **closed as `completed`** (verified via `gh api`: #1017 closed 2026-05-22, #1062 closed 2026-05-20) — but fixed **after** v0.9.4. #1017 by [PR #1035](https://github.com/bradygaster/squad/pull/1035); #1062 by [PR #1134](https://github.com/bradygaster/squad/pull/1134) (bumped `@github/copilot-sdk` to `^0.3.0`). **Decisive:** at tag `v0.9.4`, `packages/squad-sdk/package.json` still pins the **broken** `@github/copilot-sdk ^0.1.32`. Fixes are contained only in `v0.9.6-insider.3`/`dev`. | Reword troubleshooting (see §2.4): "fixed on **dev / v0.9.6-insider.3** — **not** in v0.9.4 stable." |
| 4 | #1081 "closed **by design**" | ❌ **Wrong — it was a real fix** | Closed as `completed` (not `not_planned`/wontfix) 2026-05-19 by [PR #1133](https://github.com/bradygaster/squad/pull/1133): `execute.ts` now imports `loadAgentCharter` and prepends Ralph's charter. So the specialist-charter limitation **was fixed** (on dev), not declared intended. | Reword to "fixed on dev/insider; v0.9.4 still affected." (see §2.4) |
| 5 | Human-member tip in `team.md` (Module 1 Step 2) | ✅ **Keep** | Matches documented Squad behavior (agents read `.squad/team.md` at session start); aligns with doc 01 technique **T-016**. | None. (Optional: doc 01 would file human-members under bonus — placement only.) |
| 6 | Teams via `~/.squad/teams-webhook.url`, "auto-enabled, no code changes" (Step 11g) | ❌ **Fabricated path** | No such path or file-presence auto-enable exists in source. Teams = either the **`teams-graph` OAuth adapter** configured in `.squad/config.json` (tokens cached at `~/.squad/teams-tokens-{hash}.json`, [comms-teams.ts](https://github.com/bradygaster/squad/blob/main/packages/squad-sdk/src/platform/comms-teams.ts)), or a **BYO MCP server** in `.vscode/mcp.json` with env `TEAMS_WEBHOOK_URL` ([notifications.md](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/features/notifications.md)). `comms.ts` `readTeamsConfig()` reads **only** `.squad/config.json`. | Rewrite Step 11g to the real mechanism (see §2.5). **Same bug in doc 01 §B3.** |
| 7 | "Ralph, Go!" script: `gh copilot -p $prompt --agent squad --yolo` (Step 11h) | ❌ **Wrong binary** | `gh copilot` (extension) supports only `suggest`/`explain` — no `-p`/`--agent`/`--yolo`; deprecated 2025-10-25 ([gh-copilot](https://github.com/github/gh-copilot)). The flags exist only on the standalone `copilot` CLI ([GitHub Copilot CLI docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)). Squad's own spawn code uses `{ cmd: 'copilot', args: ['-p', prompt, …] }` ([monitor-teams.ts](https://github.com/bradygaster/squad/blob/main/packages/squad-cli/src/cli/commands/watch/capabilities/monitor-teams.ts)). | Change to `copilot -p "…" --agent squad --yolo` (see §2.3). **Pre-existing twin at `03-advanced.md:218`.** |
| 7b | (exposed) `squad triage --health` in Module 3 | 🔧 **Latent bug** | Source gates `--health` on `watch` **only**: `if (cmd === 'watch' && args.includes('--health'))` ([cli-entry.ts](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-cli/src/cli-entry.ts)). So `squad triage --health` is **not handled**. Adopting `squad watch` **fixes** this for free. | Change `03-advanced.md:227` → `squad watch --health` (folded into §2.1). |

**Scorecard:** of PR #1's six changes — **3 adopt** (1 per decision, 2, 5), **3 wrong and must be corrected after merge** (3+4 issue versions, 6 Teams, 7 script). Plus one latent bug (7b) that the `watch` adoption happens to fix.

---

## 2. Repo-wide change inventory ("change it everywhere")

Adopting `squad watch` and accepting the PR means several sweeps must be completed across the repo. File:line references are as of 2026-05-30 (pre-merge `main`); the PR will shift some line numbers when merged.

### 2.1 `squad triage` (command) → `squad watch`

Change **only the command invocation** `squad triage`. **Do not** change the english verb "triage" / "triage-only mode" / "triage notes" / "triage label" — those are correct prose.

**Active files — PR #1 already converts these** (verify after merge): `README.md:38`, `modules/03-advanced.md:136,204,309`, `docs/troubleshooting.md:125,135,240,244`.

**Active files — PR #1 does NOT touch; still need converting:**

| File:line | Current | Change to | Note |
|---|---|---|---|
| `modules/03-advanced.md:176` | `squad triage --interval 1` | `squad watch --interval 1` | |
| `modules/03-advanced.md:227` | `squad triage --health` | `squad watch --health` | **functional fix** — `--health` only works on `watch` (item 7b) |
| `modules/03-advanced.md:310` | `Use \`squad triage\` (no execute)` | `Use \`squad watch\` (no execute)` | PR left this row as `triage` while changing the row above → internal inconsistency |
| `modules/03-advanced.md:295` | `Same as triage:` | `Same as watch:` | prose, minor |
| `.github/copilot-instructions.md:32` | `\| \`squad triage\` \| Run Ralph in polling mode…` | `squad watch` | always-loaded Copilot context |
| `.github/copilot-instructions.md:40` | `(\`squad triage\` / \`squad loop\`)` | `(\`squad watch\` / \`squad loop\`)` | |
| `.github/agents/squad-coach.agent.md:32` | `\| \`squad triage\` \| Polls GitHub Issues…` | `squad watch` | coach must match the modules |
| `docs/troubleshooting.md:272` | `…to triage/watch commands` | `…to \`squad watch\` commands` | already mentions both; simplify |

**Decision needed — how to frame the alias:** since the source shows `triage` is the *help-surfaced* primary, the cleanest honest phrasing is the PR's own Module 3 wording: **"`squad watch` (also available as `squad triage`)"**. Standardize that one phrasing wherever the alias is mentioned, instead of the current *"`squad triage` (formerly `squad watch`)"* (which is now backwards under the decision).

**Historical / archived — do NOT rewrite (point-in-time records); add a forward note instead:**
- `CHANGELOG.md:24,32,39` — records the *original* triage migration. Add a **new** changelog entry for the watch reversion rather than editing history.
- `docs/done/00-Review-and-Improvement-Plan.md` (W-003 etc.), `docs/done/REVIEW-AND-IMPROVEMENT-PLAN.md`, `docs/done/UPSTREAM-SQUAD-INVESTIGATION.md` — archived audits; leave as historical record (optionally add a one-line "superseded by the watch decision — see this doc" banner).
- `docs/01 EarlierWorkshopReviewAnd-Implementation-Plan.md` — updated separately (see that doc's new §0).

### 2.2 `.squad/loop.md` → `./loop.md` (repo root)

PR #1 fixes `modules/03-advanced.md:246,248,256,260`. **Still wrong after merge:**

| File:line | Current | Change to |
|---|---|---|
| `.github/copilot-instructions.md:33` | `…prompt file (\`.squad/loop.md\`)…` | `./loop.md` |
| `.github/agents/squad-coach.agent.md:33` | `Reads \`.squad/loop.md\` and runs…` | `./loop.md` |
| `docs/done/UPSTREAM-SQUAD-INVESTIGATION.md:111` | `…prompt file (\`.squad/loop.md\`)` | archived — optional |
| `docs/01 …Plan.md:905` | `Run a recurring prompt from \`.squad/loop.md\`` | fixed in doc 01 §0 |

### 2.3 `gh copilot -p` → `copilot -p`

| File:line | Current | Change to | Note |
|---|---|---|---|
| `modules/03-advanced.md:218` | `Invokes \`gh copilot -p <context-file>\`…` | `copilot -p <context-file>` | **pre-existing bug**, not introduced by the PR |
| `modules/03-advanced.md` Step 11h (PR-added) | `gh copilot -p $prompt --agent squad --yolo` | `copilot -p "$prompt" --agent squad --yolo` | the "Ralph, Go!" script |
| `docs/01 …Plan.md:496,498,500,1429` | describe Tamir's `ralph-watch.ps1` wrapping `gh copilot` | leave (accurate description of *his* script); ensure any *adopted* invocation uses `copilot` | |

### 2.4 Issue-status corrections (#1017, #1062, #1081)

PR #1 rewrites `docs/troubleshooting.md:188 (#1062), 208 (#1017), 244 (#1081)` to "fixed in 0.9.4+" / "by design". After merge, correct each to:

> **Status (verified 2026-05-30):** Closed as *completed* and fixed on `dev` (shipping in `v0.9.6-insider.3`, the npm `insider` tag) — **not yet in a stable release. v0.9.4 (current stable / workshop target) is still affected.** Keep the workaround until a stable build after v0.9.4 ships. (#1081 was a real code fix — `loadAgentCharter` now injects the charter — not "by design".)

Proof: `gh api` states (all `completed`); fixing PRs [#1035](https://github.com/bradygaster/squad/pull/1035), [#1134](https://github.com/bradygaster/squad/pull/1134), [#1133](https://github.com/bradygaster/squad/pull/1133); `@github/copilot-sdk` pin at `v0.9.4` = `^0.1.32` (broken) vs `^0.3.0` on dev.

### 2.5 Teams notification correction (Step 11g + doc 01 §B3)

Replace the `~/.squad/teams-webhook.url` "auto-enable" instructions (in **both** the PR's new Step 11g **and** `docs/01 …Plan.md:1293,1299`) with the real mechanism:

- **Option A — built-in `teams-graph` adapter:** configure `communications` in `.squad/config.json`; authenticates via interactive OAuth (browser/device code); tokens cached at `~/.squad/teams-tokens-{hash}.json`. Not webhook-based.
- **Option B — BYO MCP notification server:** add a server to `.vscode/mcp.json` with env `TEAMS_WEBHOOK_URL` set to a Power Automate Workflows webhook (e.g. the community `teams-webhook-mcp.js`).

Per doc 01's own verdict, Teams belongs in **bonus** (`modules/04-bonus.md` §B3), not mainline Module 3 — so consider relocating Step 11g there during the doc-01 adoption pass.

---

## 3. Fix-later checklist

- [ ] **§2.1** Sweep remaining `squad triage` → `squad watch` (8 active spots, incl. the `--interval 1`, `--health`, and the inconsistent table row PR #1 missed).
- [ ] **§2.1** Standardize the alias phrasing to "`squad watch` (also available as `squad triage`)".
- [ ] **§2.2** Fix `.squad/loop.md` → `./loop.md` in `copilot-instructions.md:33` and `squad-coach.agent.md:33` (PR misses both).
- [ ] **§2.3** Fix `gh copilot -p` → `copilot -p` at `03-advanced.md:218` and in the PR's Step 11h script.
- [ ] **§2.4** Correct the three issue-status entries: "fixed on dev/`v0.9.6-insider.3`, not in v0.9.4 stable"; #1081 was a real fix, not by-design.
- [ ] **§2.5** Rewrite Teams (Step 11g + doc 01 §B3) to the real `teams-graph`/MCP mechanism; consider moving to bonus.
- [ ] **§7b** Confirm `squad watch --health` works and `squad triage --health` does not, on the workshop's target version.
- [ ] Add a new `CHANGELOG.md` entry recording the watch adoption + these corrections (don't rewrite historical entries).
- [ ] Re-run the `check-links` workflow after edits (new GitHub source URLs added here).

---

## 4. Notes on verification method

All "❌ Wrong" verdicts were confirmed against source, not docs prose alone: issue states via `gh api repos/bradygaster/squad/issues/<n>`; version containment via `git compare` of fix-merge commits against `v0.9.4` vs `v0.9.6-insider.3`; the `@github/copilot-sdk` pin read directly from `package.json` at tag `v0.9.4`; command dispatch and `--health`/`loop.md` paths read from `cli-entry.ts` and `loop.ts`. The `gh copilot` vs `copilot` distinction was cross-checked against the `github/gh-copilot` README (deprecated, suggest/explain only) and the GitHub Copilot CLI docs (`-p`/`--agent`/`--allow-all`/`--yolo`).

One claim from the automated review was **rejected during double-checking**: that the live workshop uses `agency copilot …` or `squad agent run …`. A repo-wide grep found **neither** in the active modules — those strings appear only in `docs/01 …Plan.md` where it *describes Tamir's* workshop. Do not "fix" something the workshop doesn't contain.
