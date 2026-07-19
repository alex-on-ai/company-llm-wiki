[CmdletBinding()]
param(
    [switch]$Global,
    [switch]$ChatGPT,
    [ValidateSet("interview", "ingest")]
    [string]$Pack = "interview"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillNames = @("build-context-model", "process-meeting", "ingest", "file-tasks")

function Copy-Skill {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [string]$DestinationRoot
    )

    $Source = Join-Path $SourceRoot "skills/$Name"
    $Destination = Join-Path $DestinationRoot $Name

    if (Test-Path -LiteralPath $Destination) {
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Get-ChildItem -LiteralPath $Source -Force |
        Copy-Item -Destination $Destination -Recurse -Force
    Write-Host "[OK] Installed: $Destination"
}

if ($ChatGPT) {
    if ($Pack -eq "ingest") {
        $PackText = Get-Content -LiteralPath (Join-Path $SourceRoot "prompts/ingest-prompt.md") -Raw
        $Label = "Ingest pack"
    }
    else {
        $PromptText = Get-Content -LiteralPath (Join-Path $SourceRoot "prompts/interview-prompt.md") -Raw
        $Match = [regex]::Match(
            $PromptText,
            '(?ms)^## The prompt\s*\r?\n(.*?)^## After the interview'
        )
        if (-not $Match.Success) {
            throw "Could not extract the interview prompt section."
        }

        $Template = Get-Content -LiteralPath (Join-Path $SourceRoot "templates/context-model-template.md") -Raw
        $PackText = $Match.Groups[1].Value.TrimEnd() +
            "`r`n`r`n--- TEMPLATE (follow this structure) ---`r`n`r`n" +
            $Template
        $Label = "Interview pack"
    }

    if (Get-Command Set-Clipboard -ErrorAction SilentlyContinue) {
        Set-Clipboard -Value $PackText
        Write-Host "[OK] $Label copied to clipboard."
    }
    else {
        Write-Output $PackText
    }
    exit 0
}

$CurrentRoot = (Get-Location).Path
if (-not $Global -and [string]::Equals($CurrentRoot, $SourceRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Run this installer from the project folder where the company wiki should live, not from the kit repository."
}

if ($Global) {
    $UserRoot = if ($env:USERPROFILE) {
        $env:USERPROFILE
    }
    else {
        [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
    }
    $DestinationRoots = @(
        (Join-Path $UserRoot ".claude/skills"),
        (Join-Path $UserRoot ".agents/skills")
    )
}
else {
    $DestinationRoots = @(
        (Join-Path $CurrentRoot ".claude/skills"),
        (Join-Path $CurrentRoot ".agents/skills")
    )
}

foreach ($DestinationRoot in $DestinationRoots) {
    foreach ($SkillName in $SkillNames) {
        Copy-Skill -Name $SkillName -DestinationRoot $DestinationRoot
    }
}

if ($Global) {
    Write-Host "Installed machine-wide (.claude/skills + .agents/skills)."
}
else {
    Write-Host "Installed into this project (./.claude/skills + ./.agents/skills)."
    Write-Host "This current folder is the wiki root. /build-context-model writes ./context-model.md here."
}

Write-Host ""
Write-Host "Once     : /build-context-model  - build your company's context model"
Write-Host "Meetings : /process-meeting      - transcript to wiki pages, tasks, spec, and drafts"
Write-Host "Anything : /ingest               - file any material into the wiki"
Write-Host "Tracker  : /file-tasks           - create the team tasks in your connected tracker"
Write-Host ""
Write-Host "Restart your agent session, then start with /build-context-model."
