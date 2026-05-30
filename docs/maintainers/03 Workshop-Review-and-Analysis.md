# Squad Workshop — End-to-End Review & Analysis

> **Document type:** Full pedagogical + technical review of the entire workshop
> **Review date:** 2026-05-30
> **Reviewer:** Claude (5-lens multi-agent review: pedagogy/flow, entry-docs, module CLI accuracy, supporting agents/prompts, scripts/CI/config)
> **Method:** Every document read in learner order; **every CLI command/flag/path/output verified against the published binaries** (`@bradygaster/squad-cli@0.9.4` + `@bradygaster/squad-sdk@0.9.4`, plus the live `@github/copilot` CLI). Workshop target = Squad CLI **v0.9.4** (current npm `latest`).
> **Settled items deliberately NOT re-flagged:** `squad watch` as the primary name (verified correct), the `.squad/ralph-stop` convention (kept by project decision), and the `#1017/#1062/#1081` "fixed/by-design" *wording* + the Teams Step 11g reframe (deferred to Tamir).

---

## 📋 Tracking

> Status of every finding R-01…R-27. **23 done, 1 high pending (Tamir-overlap), 3 accepted as-is.** (Updated 2026-05-30.)

| Status | ID | Finding | % done | Done | Fix / change |
|---|---|---|---|---|---|
| Done | R-01 | Verify-Prerequisites: Copilot check false-FAILs valid installs | 100% | ✅ | Join multi-line output to a scalar before `-match` |
| Done | R-02 | Verify-Prerequisites: `gh auth` false-PASSes when logged out | 100% | ✅ | Match `'Logged in to'` (not the substring "logged in") |
| Pending | R-03 | #1062 troubleshooting prescribes a wrong/harmful SDK override | 0% | ⏳ | Remove the `@github/copilot-sdk 0.3.0` override (v0.9.4 ships a runtime patcher). **Overlaps Tamir-deferred §2.4** |
| Done | R-04 | "skills" used in M1 Step 6 before defined | 100% | ✅ | One-line gloss at first use |
| Done | R-05 | `model-selection` skill not installed by `squad init` | 100% | ✅ | Reworded budget doc (ships upstream only) |
| Done | R-06 | `squad loop` example missing `configured: true` | 100% | ✅ | Added to Step 12b + softened onboarding-mode note (template body is placeholder text, not "ignores your instruction") |
| Done | R-07 | coach step map missing Steps 9.5 / 11.6 | 100% | ✅ | Added both rows |
| Done | R-08 | coach mislabels `.copilot/skills/` as "captured" | 100% | ✅ | → "scaffolded by `squad init`" |
| Done | R-09 | Module 1 ~90 min badge optimistic | 100% | ✅ | → ~90–120 min + first-run caveat (README + copilot-instructions aligned) |
| Done | R-10 | headline "routing" never observed | 100% | ✅ | Added a Step 4 routing-observable bullet |
| Done | R-11 | "Ralph" used in M1 budget aside before defined | 100% | ✅ | Reworded Step 1 aside to use already-cast roles (Tester/Scribe/Lead) |
| Done | R-12 | "charter" used but never defined | 100% | ✅ | Added a one-line gloss at first use (Step 2 human-member tip) |
| Done | R-13 | Step 2 verify blurs init-provided vs cast agents (`ralph/`/`scribe/`) | 100% | ✅ | Clarified `ralph/`+`scribe/` come from `squad init`; themed dirs are cast |
| Accepted | R-14 | Module 3 numbering 10 → 11 → 11.6 → 12 reads inserted | — | ➖ | Decimal sub-step `11.6` is fine; renumbering would churn cross-refs + At-a-glance maps for no real gain |
| Done | R-15 | Step 12d lists `--max-concurrent` as a `squad loop` flag | 100% | ✅ | Reworded: loop rounds are serial (`maxConcurrent` fixed at 1, `loop.js:237`); `--max-concurrent` is a `squad watch` flag |
| Done | R-16 | coach/instructions don't mention `squad copilot` | 100% | ✅ | Added the `squad copilot --auto-assign` row to **both** command tables |
| Done | R-17 | coach Step 11 row uses old "triage-only" framing | 100% | ✅ | Reworded → "Ralph Watch Mode (`squad watch`) — triage-only first, then `--execute`" |
| Done | R-18 | cheat-sheet `squad init` "Cast / initialize" wording | 100% | ✅ | → "Initialize the team" (dropped the misleading `cast` synonym) |
| Done | R-19 | stale `SQUAD-WORKSHOP-STANDALONE-PLAN.md` (.NET 9 / Apache) | 100% | ✅ | Deleted in the docs reorg |
| Done | R-20 | `.prompt.md` files never referenced by any module | 100% | ✅ | Added a Module 2 Step 9 pointer to `/inspect-squad-artifacts` (also `\`→`/` swept the prompt files) |
| Done | R-21 | `.gitignore` omits `loop.md` | 100% | ✅ | Added `loop.md` to the runtime-artifacts block |
| Done | R-22 | check-links scanned every markdown file | 100% | ✅ | Scoped to the learner-facing surface |
| Done | R-23 | doctor underline reproduced as ASCII `=` vs `═` | 100% | ✅ | Swapped to box-drawing `═` (U+2550) to match the binary |
| Done | R-24 | cheat-sheet `--max-concurrent`/`--timeout` note slightly confusing | 100% | ✅ | Added a half-clause: `--max-concurrent 1` is the default; `--timeout 20` tightens the 30-min default |
| Done | R-25 | coach hard-codes `9 passed / 2 info` doctor count | 100% | ✅ | Softened coach + copilot-instructions to lead with "`0 failed, 0 warnings` is the signal" (9/2 kept as illustrative) |
| Optional | R-26 | Node check is a version-proxy, not a `node:sqlite` probe | — | ➖ | Acceptable as-is (`squad doctor` does the real probe) |
| Optional | R-27 | Squad version gate is structurally loose | — | ➖ | Works for the 0.9.4 floor; optional `[version]` tidy |

**Net:** every doc-level finding is closed. P0 (R-01/R-02), the P1 batch (R-04…R-10), and the full P2 + nit batch (R-11…R-25) are ✅. **R-14/R-26/R-27** accepted as-is (correct already). The only open item is **R-03** — and it overlaps the Tamir-deferred §2.4, so it's held with §2.4/§2.5 pending Tamir's confirmation (facts verified; can apply on your word).

---

## 1. Executive summary

The workshop is **pedagogically strong and technically accurate**. Its narrative arc (build → compound memory → observe → autonomous) is coherent, and its defining asset is an **evaluative, honest voice** that teaches learners to judge whether Squad earns its keep rather than to click through commands. Across three modules + supporting docs, nearly every command, flag, path, and expected-output block matches the v0.9.4 binary exactly.

The issues are concentrated, not systemic:

- **Two real bugs in `Verify-Prerequisites.ps1`** — the file every learner runs first. One **false-FAILs** the Copilot CLI check for valid installs (blocker); one **false-PASSes** the GitHub-auth check when logged out (high). Both reproduced against the real binaries.
- **One harmful troubleshooting fix** (the `#1062` `@github/copilot-sdk` override) that is wrong on v0.9.4 and could break a working install.
- **A small cluster of pedagogy gaps** — three terms used before they're defined (`skills`, `Ralph`, `charter`), the headline "automatic routing" never observed in the core path, and two optimistic time badges.
- **A few drift items** — the coach agent's step map and skills description lag the newly-added Steps 9.5/11.6; a stale planning doc; minor accuracy nits.

None of the pedagogy/accuracy items are story problems — the arc is sound. The recommended changes are mostly one-line glosses, two genuine script fixes, and content-sync touch-ups.

**Verdict:** ship-ready *after* the two front-door script bugs and the `#1062` override are fixed; everything else is polish that raises an already-good workshop.

---

## 2. What's strong (preserve these)

- **Evaluative framing over click-through.** *"Demos flatter tools. Workshops embarrass them."* (`01-basic.md:447`), explicit success/failure criteria per module, the **"What good looks like" vs "AI confetti"** contrast (`02-intermediate.md:111-125`), and the **"when to walk away"** table (`03-advanced.md:418-429`). This is the workshop's best asset — it teaches *understanding*.
- **Coherent arc + mental model.** Build → compound-memory → observe → autonomous, with the Interactive/Observed/Autonomous modes named and recapped (`03-advanced.md:435-441`).
- **Respects the learner.** "You can stop here" off-ramps (`01-basic.md:451`, `02-intermediate.md:173`) and the README "Honest about scope" note honestly scope core vs optional.
- **Consistent step rhythm** — prompt → "What to watch for" → separate-terminal "Verify" — scaffolds a verification habit.
- **Technically accurate to the binary.** The entire `squad doctor` expected-output block, all `squad watch` flags, `--health`/`aspire` outputs, `squad copilot`, the 8-skill manifest + APM `squad skill install`, `copilot -p`/`--agent`/`--yolo`, `squad config model` (all four forms) and the 5-layer model-resolution hierarchy were each verified line-for-line against v0.9.4.
- **Consistent versioning + clean tooling.** Tool minimums match across README, `prerequisites.md`, and the verify script; `squad-coach.agent.md` is a valid Copilot CLI agent file; PSScriptAnalyzer passes; MIT is consistent everywhere.

---

## 3. Findings (by priority)

Severity: **P0** = fix before the next learner · **P1** = fix soon · **P2** = polish. Each row is actionable.

### P0 — front-door / correctness

| ID | Area | Issue | Fix |
|---|---|---|---|
| **R-01** 🔴 blocker | `scripts/Verify-Prerequisites.ps1:101-106` | **Copilot CLI check false-FAILs valid installs.** `copilot --version 2>&1` returns a **multi-line array** (banner + "Run 'copilot update'…"). PowerShell `-match` on an array does **not** populate `$Matches`, so the version parse yields `0.0.0` (error hidden by `SilentlyContinue`) → spurious FAIL for anyone on Copilot ≥1.0.24. *(Reproduced on copilot 1.0.55.)* | Reduce to a scalar before matching: `$copilotRaw = (copilot --version 2>&1) -join "\`n"` (or `Select-Object -First 1`, like the `gh` check). **[FIXED 2026-05-30]** |
| **R-02** 🟠 high | `scripts/Verify-Prerequisites.ps1:93-95` | **`gh auth status` check false-PASSes when logged out.** The logged-out message is *"You are not logged **into** any GitHub hosts"*; the case-insensitive `Select-String 'Logged in'` matches the `"logged in"` inside `"logged into"` → reports PASS when `gh auth login` is required. | Anchor on `'Logged in to '` (the success phrasing; logged-out says "logged into") or test `$LASTEXITCODE -eq 0`. **[FIXED 2026-05-30]** |
| **R-03** 🟠 high | `docs/troubleshooting.md:190-200` (#1062) | **Prescribed fix is wrong & potentially harmful.** It tells learners to add `"overrides": { "@github/copilot-sdk": "0.3.0" }` to the **lab repo** `package.json`. But (a) squad-sdk@0.9.4 pins `^0.1.32` — `0.3.0` is a major-incompatible substitution; (b) the workshop installs squad **globally**, so a lab-repo override has **zero effect** on which SDK `copilot --agent squad` loads; (c) v0.9.4 already ships a runtime ESM patcher (`vscode-jsonrpc/node` → `node.js`), so **no override is needed**. The entry even says "fixed in 0.9.4+" while still prescribing the override. | Remove the `overrides` block; state the fix is built into v0.9.4 (no action needed). **Overlaps the Tamir-deferred #1062 wording — coordinate before editing**, but the override mechanism is a distinct, real defect. |

### P1 — should fix soon

| ID | Area | Issue | Fix |
|---|---|---|---|
| **R-04** 🟡 progression | `01-basic.md:404,410,419` vs `02-intermediate.md:131` | **"skills" used before defined.** Module 1 Step 6 has the learner capture/inspect skills with no definition; the concept is first explained in Module 2 Step 9.5. A stop-after-Module-1 learner never learns what they inspected. | Add a one-line gloss at first use in Step 6 ("Skills = small reusable markdown modules in `.copilot/skills/` that encode team conventions — Module 2 inspects them in depth."). |
| **R-05** 🟡 accuracy | `docs/budget-and-models.md:59` | **`model-selection` skill is not installed by `squad init`.** v0.9.4 installs exactly 8 skills; `model-selection` exists only upstream in `templates/skills/`. The "if `squad init` installed it" hedge always resolves to *not installed*, and the Module 2 Step 9.5 cross-ref is misleading (that step uses `reviewer-protocol`). | Drop the "if installed / see Step 9.5" framing; point to the upstream `templates/skills/model-selection` instead. |
| **R-06** 🟡 accuracy | `03-advanced.md:377-386` (Step 12b) | **`squad loop` example omits `configured: true`.** The shipped `loop.md` template defaults to `configured: false`; the binary treats `!== true` as **onboarding mode** and won't run the loop. A learner who edits only the body (Step 12b) hits onboarding instead of their loop in Step 12c. | Add to Step 12b: "set `configured: true` in the frontmatter (otherwise `squad loop` runs onboarding mode and skips your instructions)." Show the frontmatter in the example. |
| **R-07** 🟡 up-to-date | `.github/agents/squad-coach.agent.md:134-162` | **Coach step map is stale** — omits the new Step 9.5 (Skills) and Step 11.6 (@copilot). A learner saying "I'm stuck on 9.5/11.6" hits a coach whose own reference doesn't list them, undermining its "use the module step numbers" directive. | Add Step 9.5 and Step 11.6 rows to the coach's step tables. |
| **R-08** 🟡 accuracy | `.github/agents/squad-coach.agent.md:61` | **Coach mislabels `.copilot/skills/`** as "captured reusable skills from the session" — but `squad init` **scaffolds** them (verified in `templates.js`). Directly contradicts Module 2 Step 9.5. | Reword to "curated skills scaffolded by `squad init` … see Module 2 Step 9.5." |
| **R-09** 🟡 sizing | `01-basic.md:11` | **Module 1 ~90 min badge is optimistic.** Step 4 (full vertical-slice build + cold `npm install`/.NET 10 build) plus Step 6's three sequential agent passes routinely exceed 90 min for a first-timer. | Bump to "~90–120 min (allow up to 2h your first time)" and/or add per-step hints (Step 4 "~25–35 min incl. first build", Step 6 "~15–20 min"); set the expectation that agent latency dominates. |
| **R-10** 🟡 understanding | `README.md:13` vs Modules | **Headline "automatic routing" is never observed.** The README's marquee differentiator is only inspected as a file (`routing.md`, Module 2 Step 9); the core build never names routing in action. | In Module 1 Step 4 "What to watch for", add a bullet: "Notice your single prompt split across Backend/Frontend/Tester without you assigning tasks — that's the routing layer." |

### P2 — polish

| ID | Area | Issue | Fix |
|---|---|---|---|
| **R-11** progression | `01-basic.md:206,223` | "Ralph" used as a budget example before it's defined (Module 3). | Use a role already met (Tester) in the Step 1 aside, or add "(Ralph — the autonomous agent, Module 3)". |
| **R-12** understanding | `01-basic.md:268`, `03-advanced.md:228,234` | "charter" used (and central to the #1081 explanation) but never defined. | One-line gloss at first use: "charter = the per-agent instruction file under `.squad/agents/<name>/`." |
| **R-13** consistency | `01-basic.md:266` | Step 2 verify lists `ralph/`, `scribe/` alongside cast agents, blurring init-provided vs cast. | Clarify: "`ralph/` and `scribe/` are scaffolded by `squad init`; the themed dirs are your cast Lead/Backend/Frontend/Tester." |
| **R-14** flow | `03-advanced.md:14-19` | Numbering `11 → 11.6 → 12` with heavy `11g`/`11h` under "Step 11" reads as inserted. | Renumber to integers, or promote `11g`/`11h` out of Step 11; add 11.6 to the At-a-glance caption if the decimal must stay. |
| **R-15** accuracy | `03-advanced.md:405` (Step 12d) | Lists `--max-concurrent` as a `squad loop` flag; loop doesn't parse it (rounds are always serial). | State loop rounds are always serial; move the settable `--max-concurrent` mention to the `squad watch` context. |
| **R-16** consistency | `.github/agents/squad-coach.agent.md`, `.github/copilot-instructions.md` | Neither mentions the `squad copilot` command that Step 11.6 now uses. | Add a `squad copilot --auto-assign` row to both command tables (kept distinct from `copilot --agent squad`). |
| **R-17** consistency | `.github/agents/squad-coach.agent.md:161` | Coach's Step 11 row uses old "triage-only" framing vs the module's "Watch Mode" title. | Reword to "Ralph Watch Mode (`squad watch`) — triage-only first, then `--execute`." |
| **R-18** accuracy | `docs/cheat-sheet.md:26` | "Cast / initialize the team" — `cast` is a *separate* command ("show current session cast"), not an init synonym. | Reword to "Initialize the team in the current repo." |
| **R-19** up-to-date | `docs/SQUAD-WORKSHOP-STANDALONE-PLAN.md` | Stale completed-migration plan: still says **.NET 9** and **Apache 2.0** (repo is .NET 10 + MIT); not linked from README. | Move to `docs/done/` (or add a "historical / superseded" banner) and correct the .NET 9 / Apache refs if kept. |
| **R-20** consistency | `.github/prompts/*.prompt.md` | The two reusable prompts are installed but **never referenced by any module** — invisible to a CLI-only learner. | Reference `/inspect-squad-artifacts` at Module 2 Step 9 and `/debug-step` near the troubleshooting callouts; note they're VS Code Copilot Chat prompts. |
| **R-21** consistency | `.gitignore:15-19` | The "Squad runtime artifacts" pattern omits `./loop.md` (created by `squad loop --init`). Harmless here (lab repo is fully ignored) but incomplete as the documented downstream pattern. | Add `loop.md` to the runtime-artifacts block. |
| **R-22** code | `.github/workflows/check-links.yml` | Scans **all** markdown incl. large internal planning docs (`docs/01…`, `docs/done/*`) with many external/anchor links → noisier CI / flaky 429s. | Scope to `modules, docs` (excluding `docs/done` + planning files), or widen `mlc_config.json` ignore patterns. |
| **R-23** nit | `01-basic.md:139` | `squad doctor` underline reproduced as 15× ASCII `=`; binary prints 15× `═` (U+2550). Length right, glyph differs. | Optional: swap to `═══…` to match exactly. |
| **R-24** nit | `docs/cheat-sheet.md:33` | `--max-concurrent 1` is already the default; `--timeout 20` tightens the default 30 — momentarily confusing vs `squad help`. | Optional half-sentence: "(`--max-concurrent 1` is the default; `--timeout 20` intentionally tightens the 30-min default)". |
| **R-25** nit | `.github/agents/squad-coach.agent.md:45`, `.github/copilot-instructions.md:44` | Hard-codes `9 passed … 2 info` doctor counts (brittle — checks are conditional) vs Module 1's robust "`0 failed` is the signal." | Soften to emphasize `0 failed, 0 warnings` rather than the absolute 9/2 count. |
| **R-26** nit | `scripts/Verify-Prerequisites.ps1:53-62` | Node check validates version only (a fine proxy), not an actual `node:sqlite` probe. | Optional: `node -e "require('node:sqlite')"` + `$LASTEXITCODE`. No change needed. |
| **R-27** nit | `scripts/Verify-Prerequisites.ps1:114-116` | Squad version gate is structurally loose (`$minor -gt 9` ignores major) — correct for the realistic 0.9.4 floor but reads as a bug. | Use `[version]"$major.$minor.$patch" -ge [version]'0.9.4'`. |

---

## 4. Pedagogy & flow — assessment

**Story & progression:** the arc is genuinely good and the transitions work. The only real progression defects are **forward references** (R-04 skills, R-11 Ralph, R-12 charter) — each fixable with a one-line gloss at first use — and the **under-taught headline** (R-10 routing). The "stop-after-Module-1" path is explicitly supported, which makes R-04 (skills never defined for that learner) the most worth fixing.

**Session sizing & timeline:** Module 2 (~45 min) is realistic. Module 1 (~90 min) is tight given the first cold build + three review passes (R-09). Module 3 (~60 min) conflates active work with "start it and walk away" autonomous steps and a possible Docker install (R-09 sibling, nit). Adjust badges or add active-vs-wait splits.

**Understanding vs usage:** excellent where it counts (artifact evaluation, walk-away criteria, mode recap). The gaps are conceptual definitions (charter, skills) and connecting the routing claim to an observable moment.

---

## 5. Technical accuracy & up-to-date — assessment

Verified against v0.9.4 binaries. **Accuracy is high.** The defects are: the two verify-script bugs (R-01/R-02), the harmful `#1062` override (R-03), the `model-selection`-skill cross-ref (R-05), the `configured: true` loop gap (R-06), and the coach's stale skills/step content (R-07/R-08). Everything else (doctor output, watch flags, aspire, copilot, config-model, the model catalog/tiers) matches the binary. The supporting agent/prompt files are valid and accurate; their issues are content-drift vs the modules, not wrong commands.

**Up-to-date status:** the workshop correctly targets v0.9.4 (current stable). The only genuinely stale artifact is `SQUAD-WORKSHOP-STANDALONE-PLAN.md` (R-19, .NET 9 / Apache 2.0).

---

## 6. Suggested action plan

1. **P0 now:** R-01 + R-02 (verify-script bugs) — ✅ *applied with this review*. Then R-03 (`#1062` override) — coordinate with Tamir since it overlaps the deferred entry (**still open** — only remaining item).
2. **P1 next (one small docs PR):** R-04 (skills gloss), R-05 (model-selection ref), R-06 (`configured: true`), R-07 + R-08 (coach sync), R-09 (Module 1 timing), R-10 (routing observable) — ✅ **done**.
3. **P2 (a polish pass):** R-11…R-22 batched; R-23…R-25 nits; R-26/R-27 optional — ✅ **done 2026-05-30** (R-14/R-26/R-27 accepted as-is). See the Tracking table above.
4. **Process:** after P1/P2, archive `docs/01` + `docs/02` + this doc into `docs/done/` and cut a release. *(Doc-level work is now complete; R-03 + §2.4/§2.5 await Tamir before the archive.)*

---

## 7. Out of scope (settled — not re-flagged)

- `squad watch` as primary (verified correct against the binary).
- `.squad/ralph-stop` convention (kept by explicit decision; Ctrl+C is the real stop).
- `#1017/#1062/#1081` "fixed/by-design" *wording* and the Teams Step 11g reframe (deferred to Tamir). *(R-03 is the distinct override-**mechanism** defect, not the wording.)*

---

*Generated from a 5-lens multi-agent review; every CLI claim verified against `@bradygaster/squad-cli@0.9.4` + `@bradygaster/squad-sdk@0.9.4`.*
