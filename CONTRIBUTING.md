# Contributing to Squad Workshop

Thanks for helping improve this workshop. Contributions fall into a few categories — each has its own lightweight process.

---

## Reporting a broken step

If a step in a module doesn't work — wrong command, changed tool API, version mismatch — file an issue using the **Broken step** template.

The template asks for:
- Which module and step failed
- What happened (exact command + output)
- Your tool versions (paste `.\scripts\Verify-Prerequisites.ps1` output)
- OS and terminal

A broken-step issue with tool versions is almost always fixable within a day. A vague "step 4 doesn't work" report is not.

---

## Fixing a typo or small content error

Small fixes — typos, broken links, wrong expected output — are welcome as direct PRs. No issue needed.

Before opening a PR:
- Run `.\scripts\Verify-Prerequisites.ps1` on the step you're fixing (even if it's prose) to confirm the surrounding context is still accurate.
- Confirm all markdown links in the file you edited still resolve.

---

## Updating for a new tool version

When Squad CLI, GitHub Copilot CLI, or any other tool releases a version that changes workshop steps:

1. Open a **Broken step** issue first describing what changed.
2. If you can fix it, reference the issue in your PR and update:
   - The relevant step in `modules/`
   - `docs/prerequisites.md` (minimum version table)
   - `scripts/Verify-Prerequisites.ps1` (version check — threshold *and* fix message *and* winget ID)
   - `README.md` (quick prerequisites table)
   - `CHANGELOG.md` under `## Unreleased`
   - `docs/troubleshooting.md` if the old version leaves a known failure pattern

**Version maintenance checklist** — when the minimum version of any tool changes:

| File | What to update |
|---|---|
| `docs/prerequisites.md` | Summary table version + winget ID + body section heading + expected output |
| `modules/01-basic.md` | Prerequisites table |
| `README.md` | Quick prerequisites table |
| `scripts/Verify-Prerequisites.ps1` | `-ge N` threshold + `'N.0.0+'` string + winget ID in fix message |
| `CHANGELOG.md` | Add entry under `## Unreleased` |

---

## Proposing a new module

New modules are welcome but require more upfront alignment. Before writing:

1. Open a Discussion describing:
   - What capability the module covers
   - What you build (concrete deliverable)
   - Estimated time
   - Any new prerequisites it adds
2. Wait for feedback before investing significant writing time. A module that overlaps with an existing one, or is too abstract to follow, is hard to merge.

Module guidelines:
- Each module must be self-contained — a reader who skips earlier modules should know exactly what prereqs they need.
- Every step must include a "What to watch for" or "Verify" checkpoint — no step that ends with "the agent will do the right thing."
- Honest about failure modes. If something can go wrong, document it.

---

## PR checklist

Before requesting review:

- [ ] Tested the changed step(s) end-to-end (not just read them)
- [ ] All internal markdown links resolve
- [ ] No personal account names, tokens, or paths left in content
- [ ] `scripts/Verify-Prerequisites.ps1` updated if minimum versions changed
- [ ] `CHANGELOG.md` updated under `## Unreleased`

---

## What this repo is not

Please don't open issues or PRs for:
- **Squad CLI bugs** — those go to [@bradygaster/squad-cli](https://github.com/bradygaster/squad-cli)
- **GitHub Copilot CLI issues** — those go to GitHub support
- Feature requests for Squad itself — this repo documents Squad, it doesn't build it

---

## License

By contributing to this workshop, you agree that your contributions will be licensed under the same [Apache License 2.0](../LICENSE) as the rest of the repository. You confirm that you have the right to submit the work under this license.
