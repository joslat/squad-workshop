# Post-PR #1 — Verification & Fix Checklist

> **Document type:** Post-merge verification log + actionable fix inventory
> **Created:** 2026-05-30 · **Last verified:** 2026-05-30 (exhaustive, binary-level)
> **Author:** Claude (independent verification against the live Squad CLI source **and the published npm binaries**)
> **Trigger PR:** [joslat/squad-workshop#1](https://github.com/joslat/squad-workshop/pull/1) — *"fix: command names, loop.md path, closed bug refs, + human member / Teams / Ralph Go sections"* (authored by **Tamir Dresher**, Squad co-creator). **Merged** to `main` 2026-05-30.
> **Decision context:** PR #1 is **authoritative**. Per that decision, **`squad watch` is adopted as the primary command name** workshop-wide.

> **Ground-truth basis.** Two independent sources, both checked:
> 1. **Published npm binaries** — `npm pack @bradygaster/squad-cli@latest` (**0.9.4**) and `@insider` (**0.9.6-insider.3**); compiled `dist/` grepped directly. Plus `@bradygaster/squad-sdk@0.9.4`.
> 2. **GitHub source** — `bradygaster/squad` at tag `v0.9.4` / branch `main`, and issue/PR state via `gh api`.
> npm dist-tags (2026-05-30): `latest = 0.9.4`, `insider = 0.9.6-insider.3`, `preview = 0.8.17-preview`. **v0.9.4 is the newest *stable* release** (the workshop's target).

> ⚠️ **A note on method.** A claim is only marked wrong when contradicted by the **shipped binary or source** — never by "the file isn't on this machine." Paths like `~/.squad/teams-webhook.url` are home-directory paths created on demand; their absence on an uninstalled machine proves nothing. Every verdict below cites reproducible evidence in §4.

---

## 📋 Tracking

> Status of every PR #1 follow-up. **Items we own are done;** the two Tamir-deferred items remain. (Updated 2026-05-30.)

| Status | Name | Description | % done | Done | Fix / change |
|---|---|---|---|---|---|
| Done | **§2.1 command name** | `squad triage` → `squad watch` (primary), repo-wide | 100% | ✅ | All command invocations renamed; alias phrasing standardized; fixed the latent `squad triage --health` no-op |
| Done | **§2.2 loop.md path** | `.squad/loop.md` → `./loop.md` (repo root) | 100% | ✅ | Fixed repo-wide incl. the 2 spots PR #1 missed (binary-verified `path.join(workTreeRoot,'loop.md')`) |
| Done | **§2.3 copilot binary** | `gh copilot -p` → `copilot -p` | 100% | ✅ | Module 3 round-description + the "Ralph, Go!" script |
| Deferred → Tamir | **§2.4 issue-version wording** | #1017/#1062/#1081 "fixed in 0.9.4+ / by design" is inaccurate | 0% | ⏳ | Correct text known: fixed in `v0.9.6-insider.3`/dev (not v0.9.4 stable); #1081 was a real code fix, not "by design". *Can apply now if we stop waiting on Tamir.* |
| Deferred → Tamir | **§2.5 Teams reframe** | Step 11g `~/.squad/teams-webhook.url` mis-attributed to `squad watch` | 0% | ⏳ | It's read by Tamir's `ralph-watch.ps1` wrapper, not the CLI; or describe the built-in `teams-graph` OAuth + `notification-routing` skill |
| Decision | **§3.6 ralph-stop** | `.squad/ralph-stop` stop-file | — | ➖ | **KEEP** as a workshop convention (verified absent in the v0.9.4 binary; retained by project decision) |
| Done | **§3.7 review-pass fixes** | cheat-sheet `hire`/`heartbeat` aliases, `aspire` Docker note, Step 11d/11e | 100% | ✅ | Applied during the review pass |

**Net:** §2.1/2.2/2.3 + §3.7 ✅ done; §2.4/§2.5 deferred to Tamir (facts verified, ready to apply); ralph-stop kept by decision.

---

## Status legend

| Mark | Meaning |
|---|---|
| ✅ **Done** | Verified + already fixed in the working tree |
| ✅ **Correct** | PR claim verified true — keep as-is |
| ⏳ **Pending** | Verdict reached; fix not yet applied (awaiting decision / Tamir's input) |
| ❌ **Inaccurate** | Contradicted by binary/source — needs correction |
| 🔧 **Latent bug** | Pre-existing workshop bug surfaced during verification |

---

## 1. PR #1 item-by-item verdict

| # | PR change | Verdict | Status |
|---|---|---|---|
| 1 | Adopt `squad watch` as primary (vs `squad triage`) | ✅ **Correct to adopt** — both names route to the same command; `watch` is the original/native name and the only one accepting `--health`. (`triage` remains the help-surfaced label — so frame it as an alias, not as "wrong".) | ✅ **Done** — sweep applied (§3.1) |
| 2 | `.squad/loop.md` → `./loop.md` (repo root) | ✅ **Correct** — binary-confirmed `path.join(workTreeRoot, 'loop.md')` | ✅ **Done** — 2 spots PR missed now fixed (§3.2) |
| 3 | #1017 / #1062 "fixed upstream — upgrade to **0.9.4+**" | ⚠️ **Defensible (reading-dependent)** — both closed *completed* and fixed in `v0.9.6-insider.3`/dev (i.e. **> 0.9.4**), so "0.9.4+" read as "a version after 0.9.4" is accurate. Caveat: no *stable* release past v0.9.4 yet; v0.9.4 itself still ships the broken `@github/copilot-sdk ^0.1.32`. | ⏳ Tamir (§3.4) |
| 4 | #1081 "closed **by design**" | ⚠️ **Wording nit** — closed *completed* by a real code fix ([PR #1133](https://github.com/bradygaster/squad/pull/1133) adds `loadAgentCharter`) in dev/insider, so "by design" is imprecise. In v0.9.4 the limitation still holds (charter not injected), so the module's caveat stays correct for the stable target. | ⏳ Tamir (§3.4) |
| 5 | Human-member tip in `team.md` (Module 1) | ✅ **Correct — keep** — matches documented Squad behavior + doc 01 T-016 | ✅ Keep |
| 6 | Teams via `~/.squad/teams-webhook.url`, "Ralph reads it at startup, auto-enabled" (Step 11g) | ❌ **Mis-attributed (not fabricated)** — the path is **real in Tamir's `ralph-watch.ps1` wrapper** (it reads the file and POSTs), but the **built-in `squad watch`/Ralph does NOT read it** (zero `webhook` references anywhere in the shipped `squad-cli` binary). So Step 11g only works if you *also* run the Step 11h wrapper. | ⏳ Pending — reframe (§3.5) |
| 7 | "Ralph, Go!" script: `gh copilot -p … --agent squad --yolo` (Step 11h) | ❌ **Wrong binary** — `gh copilot` (extension) has no `-p`/`--agent`/`--yolo` (deprecated 2025-10-25). Squad spawns the standalone `copilot`. Correct: `copilot -p "…" --agent squad --yolo`. | ✅ **Done** — fixed at `:218` + the Step 11h script (§3.3) |
| 7b | *(exposed)* `squad triage --health` in Module 3 | 🔧 **Latent bug** — `--health` is gated on `cmd === 'watch'` only, so `squad triage --health` is silently unhandled. Adopting `squad watch` **fixes it**. | ✅ **Done** — fixed via the rename |

**Scorecard:** 3 correct/keep (1, 2, 5) — items 1, 2 and 7b **applied**; 4 need correction (3, 4, 6, 7) — all verdicted, fixes pending (7 held pending Tamir's reply).

---

## 2. The Teams finding in detail (the one to get right)

PR #1 Step 11g says: *"Ralph reads this file at startup. No code changes needed — if the file exists and is non-empty, Teams alerts are enabled automatically."* Three findings, in order of certainty:

1. **The built-in `squad watch`/`triage` does NOT read `~/.squad/teams-webhook.url`.** Grepping the **entire** shipped `@bradygaster/squad-cli` package (v0.9.4 **and** v0.9.6-insider.3) for `teams-webhook`, `webhook`, `TEAMS_WEBHOOK` returns **nothing** — and Ralph's `watch` command code lives in that very package (`dist/cli/commands/watch/`). So "Ralph auto-reads it" is **not** true of the CLI.
2. **The path is real — in Tamir's own wrapper.** `tamirdresher/squad-skills/workshop/ralph-watch.ps1` defines `$teamsWebhookFile = Join-Path $squadDir "teams-webhook.url"` (line 68) and, each round, `if (Test-Path $teamsWebhookFile) { … Invoke-RestMethod -Uri $webhookUrl -Method Post … }` (lines 134–139). So Step 11g accurately describes **the Step 11h script's** behavior — it just attributes it to `squad watch`.
3. **The real built-in Teams path** (verified in `@bradygaster/squad-sdk@0.9.4`): OAuth via the `teams-graph` adapter, tokens cached at `~/.squad/teams-tokens-{hash(tenantId:clientId)}.json` (`dist/platform/comms-teams.js`), plus the shipped **`notification-routing` skill** that maps notification types to channels via `.squad/teams-channels.json`.

**Verdict wording for the doc:** *not* "fabricated." Say: *"`~/.squad/teams-webhook.url` is read by the `ralph-watch.ps1` script (Step 11h), not by `squad watch` itself. For built-in Teams, Squad uses the `teams-graph` OAuth adapter and the `notification-routing` skill."*

---

## 3. Repo-wide change inventory

Change **only the command `squad triage`** → `squad watch`; never the english verb "triage" / "triage-only" / "triage notes".

### 3.1 `squad triage` → `squad watch` — ✅ DONE

PR #1 already converted `README.md`, `docs/troubleshooting.md` (4 spots), and `modules/03-advanced.md` (Step 11 intro, run command, walk-away `--execute` row). This pass fixed the **6 it left behind**:

| File:line | Was | Now |
|---|---|---|
| `modules/03-advanced.md:176` | `squad triage --interval 1` | `squad watch --interval 1` |
| `modules/03-advanced.md:227` | `squad triage --health` | `squad watch --health` *(functional fix — see 7b)* |
| `modules/03-advanced.md:361` | `Use \`squad triage\` (no execute)` | `Use \`squad watch\` (no execute)` *(was inconsistent with the row above)* |
| `.github/copilot-instructions.md:32` | `\`squad triage\` \| Run Ralph…` | `\`squad watch\` … (alias: \`squad triage\`)` |
| `.github/copilot-instructions.md:40` | `persona (\`squad triage\` / \`squad loop\`)` | `persona (\`squad watch\` / \`squad loop\`)` |
| `.github/agents/squad-coach.agent.md:32` | `\`squad triage\` \| Polls GitHub Issues…` | `\`squad watch\` … (alias: \`squad triage\`)` |

Standardized alias phrasing: **"`squad watch` (alias: `squad triage`)"**. Historical files left as records: `CHANGELOG.md` (added a forward entry instead), `docs/done/*`.

### 3.2 `.squad/loop.md` → `./loop.md` — ✅ DONE

PR #1 fixed the Module 3 occurrences. This pass fixed the 2 it missed:

| File:line | Was | Now |
|---|---|---|
| `.github/copilot-instructions.md:33` | `prompt file (\`.squad/loop.md\`)` | `(\`./loop.md\`, repo root)` |
| `.github/agents/squad-coach.agent.md:33` | `Reads \`.squad/loop.md\`` | `Reads \`./loop.md\` (repo root)` |

### 3.3 `gh copilot -p` → `copilot -p` — ✅ DONE

| File:line | Current | Should be | Note |
|---|---|---|---|
| `modules/03-advanced.md:218` | `Invokes \`gh copilot -p <context-file>\`` | `copilot -p <context-file>` | pre-existing, not from PR #1 |
| `modules/03-advanced.md:280` | `gh copilot -p $prompt --agent squad --yolo` | `copilot -p "$prompt" --agent squad --yolo` | inside PR #1's Step 11h script — raised in the email to Tamir |

### 3.4 Issue-status correction (#1017 / #1062 / #1081) — ⏳ DEFERRED to Tamir (trust vote)

> **Left as-is intentionally** — Tamir may correct these upstream/in-repo himself shortly. Recommended wording when addressed:

PR #1 rewrote `docs/troubleshooting.md` to "fixed in 0.9.4+" / "by design". Replace with:

> **Status (verified 2026-05-30):** closed as *completed* and fixed on `dev` (ships in `v0.9.6-insider.3`) — **not in v0.9.4 stable, which the workshop targets and which still ships the bug.** Keep the workaround until a stable release after v0.9.4. (#1081 was a real code fix, not "by design".)
>
> **Update (dev re-check, 2026-05-30):** if "0.9.4+" is read as *versions after 0.9.4*, the PR's wording is essentially correct — the fixes are confirmed present in `v0.9.6-insider.3` and on the current `dev` source (HEAD `c4f9d58`), both > 0.9.4. So this is a low-priority wording nuance, left to Tamir: the only precise caveats are (a) no *stable* release past v0.9.4 exists yet and (b) #1081 was a code fix, not "by design".

### 3.5 Teams (Step 11g + doc 01 §B3) — ⏳ DEFERRED to Tamir (trust vote)

Either (a) move the `teams-webhook.url` instructions under Step 11h and say *the script* reads them, or (b) describe the built-in path (`teams-graph` OAuth + `notification-routing` skill / `.squad/teams-channels.json`). Per doc 01, Teams belongs in **bonus**, not mainline.

### 3.6 `.squad/ralph-stop` — KEEP (project decision, 2026-05-30)

Review flagged that `ralph-stop` appears **nowhere** in the shipped binary — re-verified against **both v0.9.4 stable and the current `dev` source** (HEAD `c4f9d58`): `squad watch` stops only on `SIGINT`/`SIGTERM` (Ctrl+C), and `--sentinel-file` (no default; doc comment says "shuts down when *removed*") isn't wired into the watch run path. Even Tamir's `ralph-watch.ps1` says *"To stop: Ctrl+C"*.

**Decision: keep `.squad/ralph-stop` as-is** across the workshop (modules + cheat-sheet) — retained as a workshop convention pending confirmation with the Squad authors. **No edits made.** Recorded so the finding isn't lost; revisit if the authors confirm it is/isn't honored (e.g. by the agent persona).

### 3.7 Review-pass fixes applied (2026-05-30)

From the adversarial review of the Tier 1 PR:
- **Cheat sheet (PR #3):** removed two fabricated aliases — `squad init` "(alias: `squad hire`)" (`hire` is a separate unimplemented stub) and `squad doctor` "(alias: `squad heartbeat`)" (no such command); softened the `squad aspire` Docker note (dotnet path needs no Docker).
- **Module 3 (main):** Step 11d "writes a temp file / `copilot -p <context-file>`" → corrected to inline `copilot -p "<prompt>"`; Step 11e `--health` output fields corrected (PID, uptime, gh-auth + drift, interval, repo, capabilities — no "last poll"/"round").

---

## 4. Source & proof (reproducible — for review)

### 4.1 Reproduce the binary checks

```bash
# Download the actual published binaries
npm pack @bradygaster/squad-cli@latest      # -> bradygaster-squad-cli-0.9.4.tgz
npm pack @bradygaster/squad-cli@insider     # -> bradygaster-squad-cli-0.9.6-insider.3.tgz
npm pack @bradygaster/squad-sdk@latest      # -> bradygaster-squad-sdk-0.9.4.tgz
for f in *.tgz; do d="${f%.tgz}"; mkdir -p "$d"; tar -xzf "$f" -C "$d"; done

grep -rin "teams-webhook\|webhook"  */package/dist     # CLI: (no matches)
grep -rin "loop.md"                 */package/dist     # -> path.join(workTreeRoot, 'loop.md')
grep -rin "once"     */package/dist/cli-entry.js       # no --once flag
grep -rin "health"   */package/dist/cli-entry.js       # cmd === 'watch' && --health
grep -rin "=== 'triage'\|=== 'watch'" */package/dist   # if (cmd === 'triage' || cmd === 'watch')
```

### 4.2 Evidence table (what the commands return)

| Claim | Evidence (verbatim) | Source |
|---|---|---|
| Both names → one command; `watch` is real registration | `if (cmd === 'triage' \|\| cmd === 'watch')` — `dist/cli-entry.js:342` (0.9.4) / `:417` (insider) | npm binary; [cli-entry.ts](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-cli/src/cli-entry.ts) |
| `--health` only on `watch` (item 7b) | `if (cmd === 'watch' && args.includes('--health'))` — `dist/cli-entry.js:337` (0.9.4) / `:412` (insider) | npm binary; cli-entry.ts |
| `triage` is the help-surfaced primary; `watch` an alias | `squad --help` lists only `triage`; *"`squad triage` … (primary name; `watch` is an alias)"* | [cli.md](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/reference/cli.md); [faq.md](https://github.com/bradygaster/squad/blob/main/docs/src/content/docs/guide/faq.md) ("as of v0.8.26") |
| `watch` is the original name | release header *"`squad watch` — Ralph Local Watchdog"* (2026-02-20) | [release v0.5.1](https://github.com/bradygaster/squad/releases/tag/v0.5.1) |
| `loop.md` is repo-root | `loop.js:199 … path.join(workTreeRoot, 'loop.md')`; `loop.d.ts:24 "default: loop.md in cwd"` | npm binary; [loop.ts](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-cli/src/cli/commands/loop.ts) |
| No `--once` flag | only hit is an unrelated comment (`insider cli-entry.js:495`) | npm binary (both versions) |
| #1017 closed *completed* | `closed 2026-05-22`, `state_reason=completed` (via `gh api`) | [#1017](https://github.com/bradygaster/squad/issues/1017) · fix [PR #1035](https://github.com/bradygaster/squad/pull/1035) |
| #1062 closed *completed*; v0.9.4 unfixed | `closed 2026-05-20`; `squad-sdk@0.9.4` still pins `@github/copilot-sdk ^0.1.32` | [#1062](https://github.com/bradygaster/squad/issues/1062) · fix [PR #1134](https://github.com/bradygaster/squad/pull/1134) |
| #1081 real fix, not "by design" | `closed 2026-05-19`, `state_reason=completed`; fix adds `loadAgentCharter` | [#1081](https://github.com/bradygaster/squad/issues/1081) · fix [PR #1133](https://github.com/bradygaster/squad/pull/1133) |
| `~/.squad/teams-webhook.url` NOT read by CLI | `grep webhook */package/dist` → **no matches** in `squad-cli` (both versions) | npm binary |
| …but **is** read by Tamir's wrapper | `ralph-watch.ps1:68 $teamsWebhookFile = Join-Path $squadDir "teams-webhook.url"`; `:134 if (Test-Path …) { Invoke-RestMethod -Uri $webhookUrl -Method Post }` | [ralph-watch.ps1](https://github.com/tamirdresher/squad-skills/blob/main/workshop/ralph-watch.ps1) |
| Real built-in Teams = OAuth tokens | `comms-teams.js:32 … teams-tokens-${hash}.json` (in `~/.squad/`) | npm binary `@bradygaster/squad-sdk@0.9.4`; [comms-teams.ts](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-sdk/src/platform/comms-teams.ts) |
| Real built-in Teams routing = skill | `.squad/teams-channels.json` per the shipped `notification-routing` skill | npm binary template; [notification-routing SKILL.md](https://github.com/bradygaster/squad/blob/v0.9.4/packages/squad-cli/templates/skills/notification-routing/SKILL.md) |
| `gh copilot` lacks `-p`/`--agent`/`--yolo` | extension exposes only `suggest`/`explain`; deprecated 2025-10-25 | [github/gh-copilot](https://github.com/github/gh-copilot) |
| Squad spawns standalone `copilot` | `{ cmd: 'copilot', args: ['-p', prompt, …] }` | [monitor-teams.ts](https://github.com/bradygaster/squad/blob/main/packages/squad-cli/src/cli/commands/watch/capabilities/monitor-teams.ts); [Copilot CLI docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli) |

---

## 5. Fix checklist

- [x] **§3.1** `squad triage` → `squad watch` sweep (6 remaining active spots) — **done**
- [x] **§3.1** Standardize alias phrasing to "`squad watch` (alias: `squad triage`)" — **done**
- [x] **§3.2** `.squad/loop.md` → `./loop.md` in `copilot-instructions.md` + `squad-coach.agent.md` — **done**
- [x] **7b** `squad triage --health` → `squad watch --health` — **done** (fixes a latent bug)
- [x] **§3.3** `gh copilot -p` → `copilot -p` at `03-advanced.md:218` and the Step 11h script — **done**
- [ ] **§3.4** *(deferred to Tamir — trust vote)* Correct #1017/#1062/#1081 troubleshooting: "fixed on dev/`v0.9.6-insider.3`, not v0.9.4 stable"; #1081 = real fix
- [ ] **§3.5** *(deferred to Tamir — trust vote)* Reframe Teams (Step 11g): it's the `ralph-watch.ps1` script that reads `~/.squad/teams-webhook.url`, not `squad watch`; or describe the built-in `teams-graph`/skill path
- [ ] Add a stable-release watch: when a stable >v0.9.4 ships with the three fixes, flip the troubleshooting wording

---

## 6. Notes

- A claim from the first automated review was **rejected on double-check**: that the live workshop uses `agency copilot …` or `squad agent run …`. A repo-wide grep finds **neither** in the active modules — they appear only in `docs/01` *describing Tamir's* workshop.
- My earlier draft of this doc called the Teams path "fabricated." That was **overstated** — corrected here: the path is real (Tamir's wrapper), just mis-attributed to `squad watch`. Verified by grepping the shipped binaries, not by the file's absence on this machine.
