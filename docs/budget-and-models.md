# Budget & Model Tiers

> How to control which model each agent uses, and roughly what a workshop run costs. The **mechanism** here is verified against Squad CLI **v0.9.4**; the model **catalog** changes between releases, so always run `squad config model` to see what your installed version actually offers.

← Back to [Workshop Index](../README.md)

---

## Why this matters

By default every agent in a session shares one model — whatever your Copilot CLI session is set to (Module 1, Step 1). That's fine to start, but on real work it's wasteful: Ralph's polling and the Scribe's note-taking don't need a frontier model, while the Lead's architectural review benefits from one. Squad lets you set a **default model** plus **per-agent overrides**, so you spend premium capability only where it pays off.

## The command

```powershell
# Show the current configuration (and the model catalog your version supports)
squad config model

# Set a global default for every agent
squad config model <model-id>

# Pin a stronger model to one agent (e.g. the reviewer)
squad config model <model-id> --agent reviewer

# Clear a per-agent override (fall back to the default)
squad config model --clear --agent reviewer
```

These persist to `.squad/config.json` as `defaultModel` (global) and `agentModelOverrides` (a per-agent map). Open it to confirm what you set:

```powershell
Get-Content .squad\config.json
```

> Run `squad config model` with no model-id **first** — it prints the catalog your installed version supports. Model IDs change between releases, so prefer the list it shows over any hard-coded name. (Hard-coding `claude-opus-4`-style IDs in docs is exactly how older guides go stale.)

## Tiers

Squad groups models into three tiers. As of v0.9.4 the catalog has 18+ models; representative examples (confirm the exact IDs with `squad config model`):

| Tier | Good for | Examples |
|---|---|---|
| **premium** | architecture, nuanced review, mission-critical decisions | `claude-opus-4.x` |
| **standard** | day-to-day coding across .NET + React | `claude-sonnet-4.x`, `gpt-5.x` |
| **fast** | polling, routing, note-taking, cheap high-volume work | `claude-haiku-4.5` |

## How a model gets chosen (resolution order)

When an agent runs, Squad picks its model by the **first rule that matches**:

1. **Per-agent override** — `agentModelOverrides.{agent}` in `.squad/config.json`
2. **Global default** — `defaultModel` in `.squad/config.json`
3. **Session directive** — what you set in the Copilot CLI session (`/model`)
4. **Charter preference** — a `## Model` section in the agent's charter file
5. **Task-aware auto** — Squad's heuristic for the task type
6. **Fallback** — `claude-haiku-4.5`

So a per-agent override beats everything; the session `/model` you picked in Module 1 sits in the middle.

> Squad ships a `model-selection` skill that documents this in more depth — `Get-Content .copilot\skills\model-selection\SKILL.md` if `squad init` installed it (see [Module 2, Step 9.5](../modules/02-intermediate.md)), or read it upstream under `templates/skills/`.

## A sensible tier mix

| Role | Tier | Why |
|---|---|---|
| Ralph (watch) & Scribe | fast | High-volume, low-stakes — polling and note merging |
| Backend / Frontend / Tester | standard | The bulk of the coding work |
| Lead (review, architecture) | premium | The decisions and reviews you most want to be right |

```powershell
squad config model claude-haiku-4.5                  # cheap global default
squad config model claude-sonnet-4.6 --agent backend
squad config model claude-sonnet-4.6 --agent frontend
squad config model claude-opus-4.6   --agent lead    # premium only where it counts
```

(Use the exact IDs from `squad config model` — the ones above are illustrative.)

## Rough budget for a workshop run

> **These are estimates, not a measured run** (tracking item W-012). Treat them as order-of-magnitude — premium-request consumption depends heavily on your model mix and how much the agents iterate.

Assuming a Copilot **Pro+** plan (1,500 premium requests / month):

| Module | Rough premium requests | Notes |
|---|---|---|
| Module 1 (Basic) | ~40–80 | Multi-agent vertical-slice build + Lead review |
| Module 2 (Intermediate) | ~25–50 | Smaller — memory should compound |
| Module 3 — Aspire | <10 | Mostly observation |
| Module 3 — Ralph (triage-only round) | ~5 / round | One round to validate routing |
| Module 3 — Ralph `--execute` | open-ended | Cap with `--max-concurrent 1 --timeout 20` |

Modules 1 + 2 with the tier mix above should leave plenty of monthly headroom for Module 3 and your own work. If you approach the ceiling, drop the global default to a **fast** model and reserve premium for the Lead.

---

← Back to [Workshop Index](../README.md)
