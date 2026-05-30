# Prerequisites

> **Runs on PowerShell 7 (cross-platform).** The workshop's commands are PowerShell, and PowerShell 7 (`pwsh`) runs on **Windows, macOS, and Linux**. Install commands below are given for all three. On Windows we use `winget`; on macOS `brew`; on Linux `apt`/official feeds.
>
> **Path note for macOS/Linux:** command examples in the modules use Windows-style `\` separators (e.g. `.squad\decisions.md`) and `$env:USERPROFILE`. PowerShell accepts `/` on every OS, so on macOS/Linux use `/` (e.g. `.squad/decisions.md`) and `$HOME` instead.
>
> Run `pwsh ./scripts/Verify-Prerequisites.ps1` from the repo root to check all tools in one pass (on Windows, `.\scripts\Verify-Prerequisites.ps1`).

This page is the authoritative prerequisites reference for the Squad Workshop. All modules link here. If you're starting fresh, read this before opening any module.

---

## Summary

| Tool | Minimum version | Check command | Install (see §below for macOS/Linux) |
|---|---|---|---|
| Node.js | 22.5.0 | `node --version` | `winget install OpenJS.NodeJS.22` |
| .NET SDK | 10.0.0 | `dotnet --version` | `winget install Microsoft.DotNet.SDK.10` |
| Git | any recent | `git --version` | `winget install Git.Git` |
| GitHub CLI | 2.89.0 | `gh version` | `winget install GitHub.cli` |
| GitHub CLI auth | logged in | `gh auth status` | `gh auth login` |
| GitHub Copilot CLI | 1.0.24 | `copilot --version` | `winget install GitHub.Copilot` |
| Squad CLI | 0.9.4 | `squad --version` | `npm install -g @bradygaster/squad-cli` |
| PowerShell 7 | 7.x | `pwsh --version` | bundled with Copilot CLI on Windows; install separately on macOS/Linux |

> **Install Node.js first** — both the Squad CLI and the npm route for the Copilot CLI require Node ≥ 22.5.0.

---

## Detailed install instructions

### 1. Node.js 22.5.0 or later

Squad requires Node.js 22.5.0+ for the built-in `node:sqlite` module.

```powershell
node --version       # Expected: v22.5.0 or later
```

- **Windows:** `winget install OpenJS.NodeJS.22 --accept-source-agreements --accept-package-agreements`
- **macOS:** `brew install node@22` (or `brew install node` for the latest line) — or use `nvm`: `brew install nvm` then `nvm install 22`
- **Linux (Debian/Ubuntu):** `curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt-get install -y nodejs`

> Ubuntu's default `apt install nodejs` is too old and lacks `node:sqlite` — use the NodeSource feed above (or `nvm`). After installing, **restart your terminal** so the new `node` is on your PATH.

---

### 2. .NET 10 LTS or later

.NET 10 is a Long-Term Support (LTS) release supported through November 2028.

```powershell
dotnet --version     # Expected: 10.x.x (e.g. 10.0.102)
```

- **Windows:** `winget install Microsoft.DotNet.SDK.10 --accept-source-agreements --accept-package-agreements`
- **macOS:** `brew install --cask dotnet-sdk` — or Microsoft's script: `curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0`
- **Linux (Debian/Ubuntu):** `sudo apt-get update && sudo apt-get install -y dotnet-sdk-10.0` (Ubuntu 24.04+ ships .NET 10 in Canonical's feed; on 22.04 run `sudo add-apt-repository ppa:dotnet/backports` first) — or the script above with `--channel 10.0`

> If you use `dotnet-install.sh`, it does **not** add `dotnet` to your PATH automatically — add `$HOME/.dotnet` to your PATH. Always pass `--channel 10.0` with the script; its default channel does not reliably resolve to .NET 10.

---

### 3. Git

```powershell
git --version        # Expected: any recent (e.g. git version 2.x)
```

- **Windows:** `winget install Git.Git --accept-source-agreements --accept-package-agreements`
- **macOS:** `brew install git` (macOS also ships Git via `xcode-select --install`)
- **Linux (Debian/Ubuntu):** `sudo apt-get update && sudo apt-get install -y git`

---

### 4. GitHub CLI (`gh`) — 2.89.0 or later

```powershell
gh version           # Expected: 2.89.0 or later
```

- **Windows:** `winget install GitHub.cli` (upgrade: `winget upgrade GitHub.cli`)
- **macOS:** `brew install gh` (upgrade: `brew upgrade gh`)
- **Linux (Debian/Ubuntu):** use the official `cli.github.com` apt repo (Ubuntu's default `gh` is often too old). Follow [GitHub CLI's Linux install guide](https://github.com/cli/cli/blob/trunk/docs/install_linux.md), then `sudo apt update && sudo apt install gh`.

---

### 5. GitHub CLI authentication

```powershell
gh auth status       # Expected: ✓ Logged in to github.com account <your-username>
```

**If not authenticated** (all OSes): `gh auth login` — follow the browser flow (`GitHub.com`, `HTTPS`, authenticate).

---

### 6. GitHub Copilot CLI (standalone) — 1.0.24 or later

This is the standalone `copilot` binary — the primary interface for the workshop — **not** the old `gh copilot` extension and **not** VS Code Chat.

```powershell
copilot --version    # Expected: GitHub Copilot CLI 1.0.24 or later
```

- **Windows:** `winget install GitHub.Copilot --accept-source-agreements --accept-package-agreements`
- **macOS:** `brew install copilot-cli` *(Homebrew formula is `copilot-cli`; the installed binary is `copilot`)* — or `npm install -g @github/copilot` (needs Node 22+)
- **Linux:** `curl -fsSL https://gh.io/copilot-install | sudo bash` *(official script — installs the `copilot` binary, no Node needed)* — or `npm install -g @github/copilot` (needs Node 22+)

> **Naming gotcha:** winget package `GitHub.Copilot`, Homebrew formula `copilot-cli`, npm package `@github/copilot` — all install the same `copilot` binary.
> **PowerShell note:** on **Windows**, the winget install also pulls in PowerShell 7. On **macOS/Linux it does not** — install PowerShell 7 separately (§8). After installing, restart your terminal.

---

### 7. Squad CLI — 0.9.4 or later

```powershell
squad --version      # Expected: 0.9.4 or later
```

**All OSes** (requires Node 22.5.0+ from §1):

```powershell
npm install -g @bradygaster/squad-cli
# upgrade:
npm install -g @bradygaster/squad-cli@latest
```

> Earlier versions (0.9.1 and below) had two rough edges in `squad doctor` — a missing `casting/registry.json` and noisy false-positive warnings. Both are fixed in 0.9.4, so just upgrade and move on.

---

### 8. PowerShell 7 + (Windows) execution policy

The workshop's commands run in **PowerShell 7** (`pwsh`). Check it's present:

```powershell
pwsh --version       # Expected: PowerShell 7.x
```

- **Windows:** PowerShell 7 is installed alongside the Copilot CLI (§6). To install/upgrade directly: `winget install Microsoft.PowerShell`.
- **macOS:** `brew install powershell` *(run with `pwsh`)*
- **Linux (Debian/Ubuntu):** install via Microsoft's apt feed — see [Install PowerShell on Ubuntu](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu) (the package is `powershell`, the command is `pwsh`).

**Windows-only — execution policy.** If you see `UnauthorizedAccess` errors running `squad`:

```powershell
Get-ExecutionPolicy -Scope CurrentUser    # Expected: RemoteSigned or Unrestricted
# If Restricted or AllSigned:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

> Execution policy is a Windows concept; macOS/Linux `pwsh` has no equivalent step.

---

## Verify all tools in one pass

From the repo root:

```powershell
pwsh ./scripts/Verify-Prerequisites.ps1     # Windows: .\scripts\Verify-Prerequisites.ps1
```

The checker runs under `pwsh` on all three OSes and prints an install hint matching your platform. All lines should show `PASS` and the summary should show `0 failed`. Fix any that don't before opening any module.

---

## Troubleshooting install problems

See [troubleshooting.md](troubleshooting.md) for known failure patterns, exact error text, and fixes.
