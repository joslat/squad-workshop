<#
.SYNOPSIS
    Verifies all tools required for the Squad Workshop are installed and at the
    correct minimum version.

.DESCRIPTION
    Checks Node.js, .NET SDK, Git, GitHub CLI, GitHub CLI auth, GitHub Copilot CLI,
    Squad CLI, and PowerShell execution policy.

    Run this script before starting any workshop module. All checks should show PASS.
    Fix any that show FAIL before proceeding.

.EXAMPLE
    .\scripts\Verify-Prerequisites.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'SilentlyContinue'

$pass  = 0
$fail  = 0
$results = @()

function Test-Result {
    param(
        [string]$Tool,
        [bool]$Ok,
        [string]$Found,
        [string]$Required,
        [string]$Fix
    )

    $status = if ($Ok) { 'PASS' } else { 'FAIL' }
    $color  = if ($Ok) { 'Green' } else { 'Red' }

    $line = "{0,-8} {1,-22} {2}" -f $status, $Tool, $Found
    Write-Host $line -ForegroundColor $color

    if (-not $Ok -and $Fix) {
        Write-Host "         Fix: $Fix" -ForegroundColor DarkYellow
    }

    return [PSCustomObject]@{ Tool = $Tool; Ok = $Ok; Found = $Found; Required = $Required }
}

Write-Host ""
Write-Host "=== Squad Workshop — Prerequisites Check ===" -ForegroundColor Cyan
Write-Host ""
Write-Host ("{0,-8} {1,-22} {2}" -f "Status", "Tool", "Found") -ForegroundColor DarkGray
Write-Host ("-" * 60) -ForegroundColor DarkGray

# --- 1. Node.js ---
$nodeRaw = node --version 2>&1
$nodeOk  = $false
if ($nodeRaw -match 'v(\d+)\.(\d+)\.(\d+)') {
    $major = [int]$Matches[1]; $minor = [int]$Matches[2]; $patch = [int]$Matches[3]
    $nodeOk = ($major -gt 22) -or ($major -eq 22 -and $minor -gt 5) -or ($major -eq 22 -and $minor -eq 5 -and $patch -ge 0)
}
$r = Test-Result 'Node.js' $nodeOk ($nodeRaw -join '') '22.5.0+' `
    'winget install OpenJS.NodeJS.22 --accept-source-agreements --accept-package-agreements'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 2. .NET SDK ---
$dotnetRaw = dotnet --version 2>&1
$dotnetOk  = $false
if ($dotnetRaw -match '^(\d+)\.') {
    $dotnetOk = [int]$Matches[1] -ge 10
}
$r = Test-Result '.NET SDK' $dotnetOk ($dotnetRaw -join '') '10.0.0+' `
    'winget install Microsoft.DotNet.SDK.10 --accept-source-agreements --accept-package-agreements'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 3. Git ---
$gitRaw = git --version 2>&1
$gitOk  = $gitRaw -match 'git version'
$r = Test-Result 'Git' $gitOk ($gitRaw -join '') 'any recent' `
    'winget install Git.Git --accept-source-agreements --accept-package-agreements'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 4. GitHub CLI ---
$ghRaw = gh version 2>&1 | Select-Object -First 1
$ghOk  = $false
if ($ghRaw -match 'gh version (\d+)\.(\d+)\.(\d+)') {
    $major = [int]$Matches[1]; $minor = [int]$Matches[2]
    $ghOk = ($major -gt 2) -or ($major -eq 2 -and $minor -ge 89)
}
$r = Test-Result 'GitHub CLI' $ghOk ($ghRaw -join '') '2.89.0+' `
    'winget install GitHub.cli --accept-source-agreements --accept-package-agreements'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 5. GitHub CLI auth ---
$ghAuthRaw = gh auth status 2>&1
$ghAuthOk  = ($ghAuthRaw | Select-String 'Logged in') -ne $null
$ghAuthMsg = if ($ghAuthOk) { ($ghAuthRaw | Select-String 'Logged in').ToString().Trim() } else { 'not authenticated' }
$r = Test-Result 'GH auth' $ghAuthOk $ghAuthMsg 'logged in' `
    'gh auth login'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 6. GitHub Copilot CLI ---
$copilotRaw = copilot --version 2>&1
$copilotOk  = $false
if ($copilotRaw -match '(\d+)\.(\d+)\.(\d+)') {
    $major = [int]$Matches[1]; $minor = [int]$Matches[2]; $patch = [int]$Matches[3]
    $copilotOk = ($major -gt 1) -or ($major -eq 1 -and $minor -gt 0) -or ($major -eq 1 -and $minor -eq 0 -and $patch -ge 24)
}
$r = Test-Result 'Copilot CLI' $copilotOk ($copilotRaw -join '') '1.0.24+' `
    'winget install GitHub.Copilot --accept-source-agreements --accept-package-agreements'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 7. Squad CLI ---
$squadRaw = squad --version 2>&1
$squadOk  = $false
if ($squadRaw -match '(\d+)\.(\d+)\.(\d+)') {
    $major = [int]$Matches[1]; $minor = [int]$Matches[2]; $patch = [int]$Matches[3]
    $squadOk = ($major -gt 0) -or ($minor -gt 9) -or ($minor -eq 9 -and $patch -ge 4)
}
$r = Test-Result 'Squad CLI' $squadOk ($squadRaw -join '') '0.9.4+' `
    'npm install -g @bradygaster/squad-cli@latest'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- 8. PowerShell execution policy ---
$policy   = Get-ExecutionPolicy -Scope CurrentUser
$policyOk = $policy -in @('RemoteSigned', 'Unrestricted', 'Bypass')
$r = Test-Result 'PS ExecPolicy' $policyOk $policy.ToString() 'RemoteSigned' `
    'Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force'
if ($r.Ok) { $pass++ } else { $fail++ }

# --- Summary ---
Write-Host ("-" * 60) -ForegroundColor DarkGray

$summaryColor = if ($fail -eq 0) { 'Green' } else { 'Red' }
Write-Host ""
Write-Host "Summary: $pass passed, $fail failed" -ForegroundColor $summaryColor

if ($fail -gt 0) {
    Write-Host ""
    Write-Host "Fix the FAIL items above, then re-run this script before proceeding." -ForegroundColor Yellow
    Write-Host "See docs/prerequisites.md for detailed install instructions." -ForegroundColor Yellow
}

Write-Host ""

# Exit with non-zero code if any check failed (useful for CI or scripted use)
if ($fail -gt 0) { exit 1 }
