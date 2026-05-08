# Prerequisites

> **Windows only:** This workshop uses `winget` for installation. macOS and Linux users will need to substitute equivalent package manager commands.
>
> Run `.\scripts\Verify-Prerequisites.ps1` from the repo root to check all tools in one pass.

This page is the authoritative prerequisites reference for the Squad Workshop. All modules link here. If you're starting fresh, read this before opening any module.

---

## Summary

| Tool | Minimum version | Check command | Install |
|---|---|---|---|
| Node.js | 22.5.0 | `node --version` | `winget install OpenJS.NodeJS.22` |
| .NET SDK | 10.0.0 | `dotnet --version` | `winget install Microsoft.DotNet.SDK.10` |
| Git | any recent | `git --version` | `winget install Git.Git` |
| GitHub CLI | 2.89.0 | `gh version` | `winget install GitHub.cli` |
| GitHub CLI auth | logged in | `gh auth status` | `gh auth login` |
| GitHub Copilot CLI | 1.0.24 | `copilot --version` | `winget install GitHub.Copilot` |
| Squad CLI | 0.9.4 | `squad --version` | `npm install -g @bradygaster/squad-cli` |
| PowerShell exec policy | RemoteSigned | `Get-ExecutionPolicy -Scope CurrentUser` | `Set-ExecutionPolicy ...` |

---

## Detailed install instructions

### 1. Node.js 22.5.0 or later

Squad requires Node.js 22.5.0+ for the built-in `node:sqlite` module.

```powershell
node --version
```

**Expected:** `v22.x.x` (22.5.0 or later)

**If not installed or too old:**

```powershell
winget install OpenJS.NodeJS.22 --accept-source-agreements --accept-package-agreements
```

> After installing, **restart your terminal** so the new `node` is on your PATH.

---

### 2. .NET 10 LTS or later

.NET 10 is a Long-Term Support (LTS) release supported through November 2028.

```powershell
dotnet --version
```

**Expected:** `10.x.x` or later (e.g. `10.0.102`)

**If not installed:**

```powershell
winget install Microsoft.DotNet.SDK.10 --accept-source-agreements --accept-package-agreements
```

---

### 3. Git

```powershell
git --version
```

**Expected:** Any recent version (e.g. `git version 2.x`)

**If not installed:**

```powershell
winget install Git.Git --accept-source-agreements --accept-package-agreements
```

---

### 4. GitHub CLI (`gh`) — 2.89.0 or later

```powershell
gh version
```

**Expected:** `2.89.0` or later

**If not installed or outdated:**

```powershell
# Install
winget install GitHub.cli --accept-source-agreements --accept-package-agreements

# Or upgrade
winget upgrade GitHub.cli --accept-source-agreements --accept-package-agreements
```

---

### 5. GitHub CLI authentication

```powershell
gh auth status
```

**Expected:** `✓ Logged in to github.com account <your-username>`

**If not authenticated:**

```powershell
gh auth login
```

Follow the browser-based flow. Select `GitHub.com`, `HTTPS`, and authenticate.

---

### 6. GitHub Copilot CLI (standalone) — 1.0.24 or later

This is the primary interface for the workshop — **not** VS Code Chat.

```powershell
copilot --version
```

**Expected:** `GitHub Copilot CLI 1.0.24` or later

**If not installed:**

```powershell
winget install GitHub.Copilot --accept-source-agreements --accept-package-agreements
```

> This also installs PowerShell 7+ as a dependency if you don't have it.
> After installing, **restart your terminal** to pick up the new `copilot` command.

---

### 7. Squad CLI — 0.9.4 or later

```powershell
squad --version
```

**Expected:** `0.9.4` or later

**If not installed:**

```powershell
npm install -g @bradygaster/squad-cli
```

**If outdated:**

```powershell
npm install -g @bradygaster/squad-cli@latest
```

> Earlier versions (0.9.1 and below) had two rough edges in `squad doctor` — a missing `casting/registry.json` and noisy false-positive warnings. Both are fixed in 0.9.4, so just upgrade and move on.

---

### 8. PowerShell execution policy (Windows only)

If you see `UnauthorizedAccess` errors when running `squad`, fix the execution policy:

```powershell
Get-ExecutionPolicy -Scope CurrentUser
```

**Expected:** `RemoteSigned` or `Unrestricted`

**If it shows `Restricted` or `AllSigned`:**

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

---

## Verify all tools in one pass

Run the standalone checker script from the repo root:

```powershell
.\scripts\Verify-Prerequisites.ps1
```

All lines should show `PASS` and a summary line should show `0 failed`. Fix any that don't before opening any module.

---

## Troubleshooting install problems

See [troubleshooting.md](troubleshooting.md) for known failure patterns, exact error text, and fixes.
