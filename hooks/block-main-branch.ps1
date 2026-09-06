# PreToolUse hook — HARD main-branch protection (1427-checkpoint — checkpoint gate)
# Blocks Edit/Write/NotebookEdit/Bash/PowerShell when HEAD is on main/master
# unless the user granted per-step access via ALLOW MAIN: <reason>.
#
# Wiring (in settings.json):
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "Edit|Write|NotebookEdit|Bash|PowerShell",
#       "hooks": [{ "type": "command", "command": "powershell -File \"C:/Users/yanga/.claude/skills/1427-checkpoint/hooks/block-main-branch.ps1\"" }]
#     }]
#   }
#
# Unlock protocol:
#   User types exactly  ALLOW MAIN: <reason>  in session.
#   The agent creates file  .allow-main  with  "<step>:<reason>"  before retrying.
#   This hook checks that file; if absent/invalid, it exits 2 (block).

$ErrorActionPreference = "SilentlyContinue"

# Read hook input (JSON on stdin) if available
$inputJson = ""
try { $inputJson = [Console]::In.ReadToEnd() } catch { $inputJson = "" }
$toolName = ""
$toolInput = $null
if ($inputJson -and $inputJson.Trim().Length -gt 0) {
    try {
        $parsed = $inputJson | ConvertFrom-Json
        $toolName = $parsed.tool_name
        $toolInput = $parsed.tool_input
    } catch {}
}

# Resolve current git branch (best effort)
$branch = ""
try {
    # Try from tool_input cwd or current directory
    $cwd = (Get-Location).Path
    # If hook provides cwd in input, prefer it
    if ($toolInput -and $toolInput.cwd) { $cwd = $toolInput.cwd }
    Push-Location $cwd -ErrorAction SilentlyContinue
    $branch = (git rev-parse --abbrev-ref HEAD 2>$null)
    if (-not $branch) { $branch = "" }
    else { $branch = $branch.Trim() }
    Pop-Location -ErrorAction SilentlyContinue
} catch { $branch = "" }

# Only enforce on main/master
if ($branch -ne "main" -and $branch -ne "master") { exit 0 }

# Allow-list: check for .allow-main flag in skill dir or repo root
$skillDir = "C:\Users\yanga\.claude\skills\1427-checkpoint"
$flagFiles = @(
    (Join-Path $skillDir ".allow-main"),
    (Join-Path (Get-Location).Path ".allow-main"),
    (Join-Path $env:USERPROFILE ".claude\skills\1427-checkpoint\.allow-main")
)
$allowed = $false
foreach ($f in $flagFiles) {
    if (Test-Path $f) {
        $content = (Get-Content $f -Raw -ErrorAction SilentlyContinue)
        if ($content -and $content.Trim().Length -gt 0) {
            # Flag must contain ALLOW MAIN and a reason (non-empty after colon)
            if ($content -match "ALLOW MAIN\s*:\s*\S+") { $allowed = $true; break }
        }
    }
}
# Also check env var (set by agent after user typed ALLOW MAIN)
if ($env:ALLOW_MAIN -and $env:ALLOW_MAIN -match ":\s*\S+") { $allowed = $true }

if ($allowed) { exit 0 }

# BLOCK — halted at checkpoint
Write-Output "BLOCKED: checkpoint — main branch is protected — HARD gate."
Write-Output "Current branch: $branch | Tool: $toolName"
Write-Output "To proceed, user must type exactly:  ALLOW MAIN: <short reason>"
Write-Output "Then the agent creates .allow-main with that line and retries."
Write-Output "Per-step, per-session only. Silence or 'A' alone does NOT unlock main."
exit 2
