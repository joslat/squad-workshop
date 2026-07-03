# 04 — Squad 0.11.0 Modernization Review & Gap Analysis

> **Date:** 2026-07-01
> **Reviewer:** Automated modernization pass (Copilot CLI)
> **Method:** Every claim below verified against the **installed `@bradygaster/squad-cli@0.11.0`** binary on this machine (Node 22.22.2, .NET 10.0.102, gh 2.93.0, Copilot CLI 1.0.66). CLI surface captured via `squad --help`, `squad <cmd> --help`, `squad roles`, and a real `squad init --no-workflows` in a throwaday repo. Bundled `CHANGELOG.md` (top entry `0.10.0`) and `templates/skills/` read directly from the global install.
> **Supersedes (for version target only):** docs `01`–`03`, which target **v0.9.4**. Those remain valid as historical records of the 0.9.4-era review; this document is the current source of truth for the **0.11.0** target.
> **See also:** [`../versions/0.11.0.md`](../versions/0.11.0.md) — per-release notes, breaking changes, and a 0.11.0-specific workshop coverage audit.

---

## 1. Summary

The workshop content was bumped from **Squad CLI 0.9.4 → 0.11.0** (commit `b9fd246`, 14 files). This review re-verified every load-bearing CLI claim in the learner-facing content against the real 0.11.0 binary.

**Verdict:** The modernization is **accurate**. No command, flag, or path that the workshop *teaches* is wrong on 0.11.0. The remaining findings are **coverage gaps** — 0.11.0 ships a substantially larger command surface than the workshop exercises, and a few invariants (notably the `squad doctor` "0 warnings" rule) are now slightly too strict because 0.11.0 added new checks.

Nothing here is a blocker. The gaps are prioritized below.

> **Update (2026-07-02): all six gaps below (G1–G6) have been applied to the workshop content** in the same pass that produced this document. Each gap heading is annotated with its resolution. See the priority table in §4 for the file-by-file summary.

---

## 2. Verified correct on 0.11.0 (no action needed)

| Claim (workshop) | Verification on 0.11.0 |
|---|---|
| `squad watch` is the primary command; alias of `triage` | ✅ `squad watch --help` → `squad watch v0.11.0 — Scan for work and categorize issues`. Alias intact. |
| `squad watch --health` shows watch status and exits | ✅ Runs, prints `📋 No watch instance detected. Start one with: squad watch --execute --interval 5`, and **self-exits**. |
| `squad watch --once` / `--output-format` do **not** exist (Module 4 §B4) | ✅ Still absent. `triage`/`watch` accept `--interval`, `--execute`, `--timeout`, `--max-concurrent`, `--log-file`, capability flags — no single-pass, no JSON output. |
| `squad config model` (all forms) | ✅ Works. Lives under `squad config` (`squad config --help` → "Manage Squad configuration"); not in the top-level `--help` summary, but the subcommand is real and functional. |
| Built-in roster = Scribe + Ralph + **Rai** + **Fact-Checker** (README/modules) | ✅ A real `squad init` scaffolds `.squad/agents/` = `scribe`, `ralph`, `Rai`, `fact-checker`. All four are always-on. |
| `squad doctor` structure (`## Members` header check, agents/casting/decisions checks) | ✅ `9 passed, 0 failed` on a clean init. Structure matches. |
| Version pins, Copilot CLI ≥ 1.0.59 (folder-trust), Node ≥ 22.5.0, .NET 10 | ✅ Consistent across README, modules, prerequisites, verify script. |

---

## 3. Gaps & issues

### G1 — `squad doctor` "0 warnings" invariant is too strict on 0.11.0  · **Medium** · ✅ Resolved

**Where:** `modules/01-basic.md` (doctor step), `docs/troubleshooting.md`, `docs/cheat-sheet.md`.

**Issue:** The workshop teaches that a healthy `squad doctor` shows **`0 failed, 0 warnings`**. On 0.11.0, `doctor` added a check that emits a **⚠️ warning** when the `copilot` binary isn't resolvable on `PATH`:

```
⚠️  Copilot CLI available — 'copilot --version' failed — watch capabilities
    (monitor-teams, monitor-email, retro, decision-hygiene) require the Copilot CLI…
Summary: 9 passed, 0 failed, 1 warnings, 2 info
```

This fires whenever `copilot` isn't on `PATH` in the shell running `doctor` (common in non-interactive shells, CI, or GitHub-CLI-extension-only installs) — **even when the learner's interactive Copilot setup is perfectly fine**. A learner following the "0 warnings = healthy" rule will think they failed.

**Fix:** Reframe the invariant so the **hard gate is `0 failed`**. Treat the Copilot-CLI-on-PATH ⚠️ as **expected/environmental** and tell the learner how to confirm it's benign (`copilot --version` in the same shell; if that works interactively, ignore the doctor warning). Keep the 2 ℹ️ info lines as already documented.

---

### G2 — 0.11.0 commands that reinforce the workshop's own themes are untaught  · **Medium** · ✅ Resolved

**Where:** `docs/cheat-sheet.md`, `modules/02-intermediate.md` (memory theme), `modules/03-advanced.md` (budget/economy theme).

**Issue:** Three new top-level commands map directly onto themes the workshop already builds a narrative around, but are never mentioned:

| Command | What it does | Theme it reinforces |
|---|---|---|
| `squad nap` | Context hygiene — compress/prune/archive `.squad/` state (`--deep`, `--dry-run`) | **Module 2** "compounding memory" — learners currently have no taught way to manage state growth |
| `squad cost` | Report token usage from orchestration logs (`--all`, `--agent <name>`) | **Module 3** budget/economy — natural companion to `squad economy` |
| `squad status` | Show which squad is active and why | Basic orientation, useful everywhere |

(`squad memory write --class …` also exists for governed memory ops, but is more advanced and can stay out of scope.)

**Fix:** Add cheat-sheet rows for `nap`, `cost`, `status`. Add a one-paragraph callout tying `squad nap` to Module 2 (after the memory-inspection step) and `squad cost` to Module 3 (alongside `squad economy`). Low effort, high pedagogical payoff.

---

### G3 — Module 3 omits 0.11.0 `triage`/`watch` opt-in capability flags  · **Low–Medium** · ✅ Resolved

**Where:** `modules/03-advanced.md` (Ralph / `squad watch --execute` sections).

**Issue:** Module 3 documents `--interval`, `--execute`, `--max-concurrent`, `--timeout`. 0.11.0 adds a whole **opt-in capabilities** layer to `triage`/`watch` (enable via `--<name>` or `config.json`, disable via `--no-<name>`):

```
--self-pull · --board [--board-project N] · --monitor-teams · --monitor-email
--two-pass · --wave-dispatch · --retro · --decision-hygiene
```

Plus `--copilot-flags "…"` and `--log-file <path>`. None are mentioned, so a learner reading the module believes the flag list is shorter than it is.

**Fix:** Add a short note: "0.11.0 adds opt-in Ralph capabilities (project-board lifecycle, two-pass scan, wave dispatch, Teams/email monitoring, retro/decision-hygiene). Run `squad triage --help` for the full list." No need to teach each one.

---

### G4 — `squad init` flag surface expanded; lab-relevant flags unmentioned  · **Low** · ✅ Resolved

**Where:** `modules/01-basic.md` Step 0 (init).

**Issue:** 0.11.0 `init` now accepts `--no-workflows`, `--preset <name>`, `--state-backend local|orphan|two-layer`, `--sdk`, `--roles`, `--global`, and `init --mode remote <path>`. The workshop uses plain `squad init`. `--no-workflows` in particular is handy for a throwaway lab repo with no CI, and `--preset` previews the curated-agent-collection feature.

**Fix:** Optional one-line aside on `--no-workflows` for lab repos and a pointer to `squad preset list` / `init --preset`. Not required for correctness.

---

### G5 — Large advanced 0.11.0 surface entirely outside the workshop  · **Low (scope)** · ✅ Resolved

**Where:** would be a new appendix in `modules/04-bonus.md`.

**Issue:** 0.11.0 ships many commands the workshop never references: `subsquads` (multi-Codespace scaling), `start` / `rc` / `copilot-bridge` (remote control from phone/browser), `discover` / `delegate` / `registry` / `upstream` (cross-squad orchestration), `externalize` / `internalize` / `link` / `init-remote` (external state roots), `schedule`, `personal` / `consult` / `extract` (ambient personal squad), `build` / `migrate` / `sync` (SDK-first + state backends), `export` / `import`, `state-mcp`, `scrub-emails`, `roles`, `cast`/`hire`. Most are legitimately out of scope for a 3-hour intro, but their absence is invisible — a learner finishing the workshop won't know they exist.

**Fix:** Add a short **"Beyond this workshop — what else 0.11.0 can do"** appendix to Module 4 with a one-line-per-command map and a pointer to `squad --help`. Sets expectations, no deep coverage.

---

### G6 — Historical maintainer docs still read as "current, target v0.9.4"  · **Low (housekeeping)** · ✅ Resolved

**Where:** `docs/maintainers/01`, `02`, `03`.

**Issue:** Those three docs repeatedly state the workshop target is **v0.9.4** and verify against the 0.9.4 binary. They were intentionally excluded from the modernization (they are archival), but a maintainer opening doc `03` cold could mistake it for the current state.

**Fix:** Add a one-line "**Superseded for version target — see `04 Squad-0.11.0-Modernization-Review.md`**" banner to the top of doc `03` (and optionally `01`/`02`). Leave the bodies untouched as history.

---

## 4. Priority & suggested order

| # | Gap | Severity | Effort | Status |
|---|-----|----------|--------|--------|
| G1 | doctor "0 warnings" too strict | Medium | S | ✅ Applied — reframed hard gate to `0 failed` + benign-warning note in `modules/01-basic.md`, `docs/troubleshooting.md`, `.github/copilot-instructions.md` |
| G2 | `nap` / `cost` / `status` untaught | Medium | S | ✅ Applied — cheat-sheet rows + `nap` callout in Module 2, `cost` callout in Module 3 |
| G3 | Module 3 capability flags | Low–Med | S | ✅ Applied — opt-in capabilities note + `squad triage --help` pointer |
| G4 | `init` flags (`--no-workflows`, presets) | Low | S | ✅ Applied — flags aside at Module 1 Step 0d |
| G5 | advanced-surface appendix | Low | M | ✅ Applied — "Beyond this workshop" appendix in Module 4 |
| G6 | maintainer-doc banners | Low | XS | ✅ Applied — superseded banners on docs `01`/`02`/`03` |

## 5. Maintainer notes (precision, not errors)

- **Rai is an always-on agent, not a catalog role.** `squad roles` lists 21 base roles including `fact-checker` but **not** `rai`/`responsible-ai`. Rai is scaffolded by `init` like Scribe/Ralph (always-on), so the README's "4 built-ins" framing is correct — just don't expect to find "Rai" under `squad roles`.
- **`squad config model` is hidden from the top-level help.** It's real (under `squad config`) but won't appear if someone only reads `squad --help`. Worth a maintainer awareness note if anyone "tidies" config references.
- **Bundled `templates/skills/` now ships ~50 skills** (up from 8 at 0.9.4-era), including coordinator playbooks, `nap`, `economy-mode`, `fact-checking`, `humanizer`, cross-squad, and more. The Module 2 skills step ( `.github/skills/` ) is path-correct; the volume is just much larger now.
