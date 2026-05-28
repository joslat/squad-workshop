<#
.SYNOPSIS
    Copies the Squad Workshop coach agent and reusable prompts into the lab repo
    so they are discoverable by Copilot CLI / VS Code Copilot Chat when working
    from inside the lab.

.DESCRIPTION
    Run this from the workshop repo root, passing the path to your lab repo
    (default: ..\reading-list-squad-lab).

    The script copies:
      .github/agents/squad-coach.agent.md
      .github/prompts/debug-step.prompt.md
      .github/prompts/inspect-squad-artifacts.prompt.md
    into the lab repo's matching .github/agents/ and .github/prompts/ folders,
    creating them if needed.

    By default the script refuses to overwrite existing files; pass -Force to
    overwrite, e.g. when picking up coach updates after a `git pull`.

.PARAMETER LabPath
    Path to the lab repo. Defaults to ..\reading-list-squad-lab.

.PARAMETER Force
    Overwrite any existing files in the lab repo's .github/agents/ or .github/prompts/.

.EXAMPLE
    .\scripts\Install-WorkshopAgents.ps1

.EXAMPLE
    .\scripts\Install-WorkshopAgents.ps1 -LabPath ..\reading-list-squad-lab

.EXAMPLE
    .\scripts\Install-WorkshopAgents.ps1 -Force
#>

[CmdletBinding()]
param(
    [string]$LabPath = "..\reading-list-squad-lab",
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $LabPath)) {
    Write-Error "Lab repo not found at: $LabPath"
    Write-Host  "Pass -LabPath to point at your reading-list-squad-lab directory."
    exit 1
}

$agentSrc   = Join-Path $PSScriptRoot "..\.github\agents\squad-coach.agent.md"
$promptsSrc = @(Get-ChildItem (Join-Path $PSScriptRoot "..\.github\prompts\*.prompt.md"))

if (-not (Test-Path $agentSrc)) {
    Write-Error "Coach agent source not found at: $agentSrc"
    exit 1
}
if ($promptsSrc.Count -eq 0) {
    Write-Error "No prompt files found in $(Join-Path $PSScriptRoot '..\.github\prompts')"
    exit 1
}

$agentDst   = Join-Path $LabPath ".github\agents"
$promptsDst = Join-Path $LabPath ".github\prompts"

New-Item -ItemType Directory -Path $agentDst   -Force | Out-Null
New-Item -ItemType Directory -Path $promptsDst -Force | Out-Null

# Refuse to overwrite local customizations unless -Force is passed.
$conflicts = @()
$agentTarget = Join-Path $agentDst (Split-Path $agentSrc -Leaf)
if (Test-Path $agentTarget) { $conflicts += $agentTarget }
foreach ($p in $promptsSrc) {
    $t = Join-Path $promptsDst $p.Name
    if (Test-Path $t) { $conflicts += $t }
}

if ($conflicts.Count -gt 0 -and -not $Force) {
    Write-Warning "These files already exist in the lab repo and would be overwritten:"
    $conflicts | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    Write-Host "Re-run with -Force to overwrite, or back them up first." -ForegroundColor Yellow
    exit 1
}

Copy-Item $agentSrc   $agentDst   -Force
Copy-Item $promptsSrc $promptsDst -Force

Write-Host ""
Write-Host "Installed into $LabPath\.github\:" -ForegroundColor Green
Write-Host "  agents\$(Split-Path $agentSrc -Leaf)"
foreach ($p in $promptsSrc) {
    Write-Host "  prompts\$($p.Name)"
}
Write-Host ""
Write-Host "Now from inside the lab repo you can run:" -ForegroundColor Cyan
Write-Host "  copilot --agent squad-coach"
Write-Host ""

exit 0
