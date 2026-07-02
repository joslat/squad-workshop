# Troubleshooting

Common failure patterns across all three modules, with exact error text and fixes.

---

## Installation and setup

### `UnauthorizedAccess` when running `squad`

**Symptom:**

```
squad : File C:\...\squad.ps1 cannot be loaded because running scripts is disabled on this system.
```

**Cause:** PowerShell execution policy is `Restricted` or `AllSigned`.

**Fix:**

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

Restart your terminal and retry.

---

### `copilot` command not found after install

**Symptom:** `copilot: The term 'copilot' is not recognized...`

**Cause:** The installer updated PATH but the current terminal session doesn't see it yet.

**Fix:** Close and reopen your terminal (PowerShell 7+ required — the installer adds it if missing). If it still fails:

```powershell
# Confirm where it installed to:
Get-Command copilot -ErrorAction SilentlyContinue

# Or find it manually:
where.exe copilot
```

If `where.exe` finds it but `Get-Command` doesn't, your `$env:PATH` in the current session is stale. Restart the terminal.

---

### `squad doctor` reports warnings

**Symptom:**

```
⚠️  casting/registry.json missing
⚠️  <some other warning>
```

**Cause:** An older `squad init` didn't scaffold everything `squad doctor` expects (for example `casting/registry.json`), producing false-positive warnings. Newer releases fix this.

**Fix:**

```powershell
npm install -g @bradygaster/squad-cli@latest
```

Re-run `squad doctor`. The invariant that matters is **`0 failed`** — the exact `passed`/`info` counts vary by version, so don't treat them as must-match. A healthy 0.11.0 global install looks like `9 passed, 0 failed, 0 warnings, 2 info` (the 2 `info` lines about `vscode-jsonrpc` / `copilot-sdk session.js` are expected for global installs). **A single ⚠️ warning about "Copilot CLI available — 'copilot --version' failed" is environmental, not a failure** — it fires when the `copilot` binary isn't on `PATH` in the shell running `doctor`. If `copilot --version` works in your interactive shell, ignore it; the hard gate is `0 failed`.

---

### Non-interactive / automation runs appear blocked (folder-trust gate)

**Symptom:** A `--yolo`, scripted, or Ralph (`squad watch` / `squad loop`) run against the lab folder seems to do nothing, hang, or exit without progress — even though the same work succeeds interactively.

**Cause:** GitHub Copilot CLI 1.0.59+ adds a **folder-trust security gate**. The first time you use Copilot CLI in a folder it asks you to trust it. Non-interactive and automation runs can't answer that prompt, so they stall or back off.

**Fix:** Launch Copilot CLI interactively in the lab folder once and approve the trust prompt, then re-run your automation:

```powershell
cd reading-list-squad-lab
copilot --agent squad     # approve the "trust this folder" prompt, then /quit
```

After the folder is trusted, non-interactive / `--yolo` / Ralph runs proceed normally.

---

### `gh auth status` shows not logged in

**Symptom:** `You are not logged into any GitHub hosts.`

**Fix:**

```powershell
gh auth login
```

Select `GitHub.com` → `HTTPS` → authenticate via browser. Then verify:

```powershell
gh auth status
```

Should show `✓ Logged in to github.com account <your-username>`.

---

## Module 3 — Aspire and Ralph

### `squad aspire` shows `✓` but dashboard is empty or unreachable

**Symptom:** The command prints `✓ Aspire dashboard launching` but `http://localhost:18888` returns a connection error.

**Cause:** Docker Desktop is not running. The `✓` line is printed even when Docker fails — it's a known gotcha in the current Squad version.

**Fix:**

1. Stop the command (`Ctrl+C`)
2. Start Docker Desktop from the Start menu
3. Wait for the whale icon to stop animating
4. Confirm Docker is healthy:
   ```powershell
   docker info | Select-String "Server Version"
   ```
5. Re-run `squad aspire`

---

### Aspire dashboard stays empty during a Squad session

**Symptom:** You're running `copilot --agent squad` and the agents are clearly doing work, but the Aspire dashboard at `http://localhost:18888` shows no traces.

**Possible causes:**

1. **Aspire wasn't actually running** — see above.
2. **Squad version too old** — v0.9.0+ auto-wires OpenTelemetry. If you're on an older version, run `squad upgrade` and restart the session.
3. **Firewall blocking `localhost:4317`** — Windows Firewall may block the OTLP gRPC port. Allow it once for the session.

---

### `ralph-stop` file blocks the next Ralph run

**Symptom:** `squad watch` or `squad loop` exits immediately on the next run with a message about a stop file.

**Cause:** You stopped Ralph cleanly last time by creating `.squad/ralph-stop`, and the file wasn't deleted.

**Fix:**

```powershell
Remove-Item .squad/ralph-stop -ErrorAction SilentlyContinue
```

Then re-run your `squad watch` or `squad loop` command.

---

### `gh auth` failing inside a Ralph execution round

**Symptom:** Ralph logs an auth error during a round, and the 4-tier escalation eventually backs off.

**Fix:**

```powershell
gh auth login
gh auth status   # confirm it shows logged in
```

Then wait for Ralph's next round (or restart with a fresh triage run).

---

## General

### The team retraces steps it should already know

**Symptom:** In Module 2, the agents re-explain or re-propose things that were decided in Module 1 (storage choice, folder layout, etc.).

**This is a data point, not a bug.** It means the Scribe didn't capture the decisions usefully, or the agents aren't reading the memory files. Check:

```powershell
Get-Content .squad/decisions.md
Get-Content .squad/identity/wisdom.md
```

If these are thin or generic, the team's memory is decorative. That's valuable information about whether Squad is earning its keep for your use case. See Module 2, Step 9 for the full artifact inspection.

---

## Known Squad bugs and workarounds

These are confirmed upstream bugs in Squad CLI that workshop participants may encounter. Check [bradygaster/squad issues](https://github.com/bradygaster/squad/issues) for current status.

---

### `ERR_MODULE_NOT_FOUND` — `vscode-jsonrpc/node` on Windows

**Symptom:**

```
Error [ERR_MODULE_NOT_FOUND]: Cannot find module
  '.../node_modules/vscode-jsonrpc/node'
  imported from .../node_modules/@github/copilot-sdk/dist/session.js
Did you mean to import "vscode-jsonrpc/node.js"?
```

**Cause:** `@github/copilot-sdk` 0.1.32 had a broken import path that failed on Windows. This was fixed upstream — upgrade to Squad CLI 0.9.4+ to resolve. ([issue #1062](https://github.com/bradygaster/squad/issues/1062) — closed)

**Fix:** Add an override to your lab repo's `package.json` (create one in the root of `reading-list-squad-lab` if it doesn't exist):

```json
{
  "overrides": {
    "@github/copilot-sdk": "0.3.0"
  }
}
```

Then run `npm install` in the lab repo. This forces the patched version to be used.

---

### Squad behaves like vanilla Copilot — no team routing, no governance

**Symptom:** Squad stops dispatching to team members. Work gets done inline by the coordinator. Commits go directly to `main` without branch creation or PR workflow. The session "feels like regular Copilot."

**Cause:** The 92KB coordinator file (`squad.agent.md`) was silently dropped from the Copilot context budget due to pressure from a prior long session's summary. When this happens, Squad degrades to vanilla Copilot with no warning and no error message. This was fixed upstream — upgrade to Squad CLI 0.9.4+ to resolve. ([issue #1017](https://github.com/bradygaster/squad/issues/1017) — closed)

**Fix:** Start a completely fresh Copilot CLI session:

```powershell
# Exit the current session first:
/quit

# Then relaunch:
copilot --agent squad
```

The coordinator file will be fully loaded again in the fresh session. If it happens again quickly, your prior session summaries may be unusually large — consider starting the next session with `/clear`.

---

### All files marked as modified after `squad init` in an existing project

**Symptom:** After running `squad init` inside a project that already had files, `git status` shows every file as modified (even files you didn't touch).

**Cause:** `squad init` writes a `.gitattributes` file. On Windows, git re-normalizes line endings for all tracked files when `.gitattributes` is read, which stages them as modified. Your file content is unchanged. Upstream [issue #1026](https://github.com/bradygaster/squad/issues/1026).

**Fix:** Discard the false-positive staging:

```powershell
git checkout -- .
```

Then verify your real changes are still there and commit normally. The `.gitattributes` file Squad added is intentional and should be committed.

---

### `squad watch --execute` agents don't behave like the assigned specialist

**Symptom:** You labeled an issue `squad:backend` (or `squad:bishop`, etc.) and Ralph's `--execute` mode picked it up — but the spawned agent behaves like a generic assistant, not like your Backend agent with its specific charter and personality.

**Cause:** `squad watch --execute` uses the `squad:{member}` label only as a routing filter. When it spawns a Copilot session to work on the issue, it uses a **generic Ralph prompt** — the specialist's charter is never injected into the spawn prompt. This is by design in the current release (upstream [issue #1081](https://github.com/bradygaster/squad/issues/1081) — closed).

**Workaround:** For work that requires specialist quality (code architecture, nuanced review, expert domain knowledge), use interactive mode instead:

```powershell
copilot --agent squad
```

Then ask directly: `Backend agent, implement the feature from issue #42.`

Use `--execute` only for small, well-scoped tasks where specialist nuance doesn't matter much.

---

### Agents fail mid-task with model rate-limit errors

**Symptom:**

```
[agent] error: model rate limit reached
Lane completed with a model rate-limit failure
```

**Cause:** Copilot Pro+ plans include 1,500 premium requests per month. Heavy multi-agent sessions — especially with concurrent spawns — can exhaust this budget quickly. Upstream [issue #992](https://github.com/bradygaster/squad/issues/992).

**Fix options:**

1. Wait for the monthly rate limit to reset.
2. Reduce concurrent agents: add `--max-concurrent 1` to triage/watch commands.
3. Use smaller tasks per session — batching large work into many small issues burns more requests than one well-scoped task.
4. Check your remaining budget at `github.com/settings/copilot`.

---

### `squad upgrade` destroys your `.github/agents/squad.agent.md` customizations

**Symptom:** After running `squad upgrade`, any customizations you made to `.github/agents/squad.agent.md` (custom agent names, removed sections, team-specific rules) are overwritten with the upstream version.

**Cause:** `squad upgrade` replaces `squad.agent.md` with no merge strategy. Upstream [issue #1052](https://github.com/bradygaster/squad/issues/1052).

**Workaround:** Before running `squad upgrade`, save your customizations:

```powershell
Copy-Item .github/agents/squad.agent.md .github/agents/squad.agent.md.backup
squad upgrade
# Then re-apply your changes manually by diffing against the backup
```
