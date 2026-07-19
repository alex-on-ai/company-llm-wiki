[CmdletBinding()]
param(
    [switch]$NpxIntegration
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$TestRoot = Join-Path ([IO.Path]::GetTempPath()) ("company-llm-wiki-smoke-" + [guid]::NewGuid().ToString("N"))
$ProjectRoot = Join-Path $TestRoot "HighCraft"
$GlobalRoot = Join-Path $TestRoot "home"
$OriginalUserProfile = $env:USERPROFILE

function Assert-True {
    param(
        [Parameter(Mandatory = $true)]
        [bool]$Condition,
        [Parameter(Mandatory = $true)]
        [string]$Message
    )
    if (-not $Condition) {
        throw $Message
    }
}

function Assert-InstallShape {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Root
    )

    foreach ($Runtime in @(".claude", ".agents")) {
        foreach ($Skill in @("build-context-model", "process-meeting", "ingest")) {
            Assert-True (Test-Path -LiteralPath (Join-Path $Root "$Runtime/skills/$Skill/SKILL.md")) "Missing $Runtime skill: $Skill"
        }
        Assert-True (Test-Path -LiteralPath (Join-Path $Root "$Runtime/skills/build-context-model/llm-wiki.md")) "Missing build bootstrap asset"
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $Root "$Runtime/skills/process-meeting/llm-wiki.md"))) "process-meeting carries a duplicate llm-wiki.md"
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $Root "$Runtime/skills/ingest/llm-wiki.md"))) "ingest carries a duplicate llm-wiki.md"
    }
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $Root "agent"))) "Installer created an unrequested agent/ directory"
}

try {
    New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null
    Push-Location $ProjectRoot
    try {
        & (Join-Path $RepoRoot "install.ps1") | Out-Null
    }
    finally {
        Pop-Location
    }
    Assert-InstallShape -Root $ProjectRoot

    New-Item -ItemType Directory -Path $GlobalRoot -Force | Out-Null
    $env:USERPROFILE = $GlobalRoot
    & (Join-Path $RepoRoot "install.ps1") -Global | Out-Null
    Assert-InstallShape -Root $GlobalRoot

    $AgentsHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $RepoRoot "AGENTS.md")).Hash
    $ClaudeHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $RepoRoot "CLAUDE.md")).Hash
    Assert-True ($AgentsHash -eq $ClaudeHash) "AGENTS.md and CLAUDE.md differ"

    $PatternCopies = @(Get-ChildItem -LiteralPath (Join-Path $RepoRoot "skills") -Filter "llm-wiki.md" -File -Recurse)
    Assert-True ($PatternCopies.Count -eq 1) "Expected exactly one packaged llm-wiki.md"

    $Readme = Get-Content -LiteralPath (Join-Path $RepoRoot "README.md") -Raw
    Assert-True ($Readme.Contains('--skill "*" --agent codex claude-code -y')) "README lacks the cross-platform install command"
    Assert-True (-not $Readme.Contains('npx skills@latest add alex-on-ai/company-llm-wiki --all')) "README recommends the all-agents install"

    $Plugin = Get-Content -LiteralPath (Join-Path $RepoRoot ".claude-plugin/plugin.json") -Raw | ConvertFrom-Json
    Assert-True ($Plugin.name -eq "company-llm-wiki") "Unexpected Claude plugin name"

    if ($NpxIntegration) {
        $NpxRoot = Join-Path $TestRoot "npx-project"
        New-Item -ItemType Directory -Path $NpxRoot -Force | Out-Null
        Push-Location $NpxRoot
        try {
            & npx skills@latest add $RepoRoot --skill "*" --agent codex claude-code -y
            if ($LASTEXITCODE -ne 0) {
                throw "npx skills install failed with exit code $LASTEXITCODE"
            }
        }
        finally {
            Pop-Location
        }
        Assert-InstallShape -Root $NpxRoot
    }

    Write-Host "PowerShell smoke checks passed"
}
finally {
    $env:USERPROFILE = $OriginalUserProfile
    if (Test-Path -LiteralPath $TestRoot) {
        Remove-Item -LiteralPath $TestRoot -Recurse -Force
    }
}
