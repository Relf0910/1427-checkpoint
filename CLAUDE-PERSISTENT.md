# Persistent Checkpoint — Wiring Guide (HARDENED branch)

This file documents how the hardened `1427-checkpoint` stays
active every session without manual `/1427-checkpoint` invoke.

## What "persistent" means
- Every SessionStart auto-activates the language-agnostic intent gate +
  hard main-branch protection + hard English-only code gate.
- No user action needed. `/resume` keeps it; new session re-arms it.
- The checkpoint is the session-level gate — no mutating intent passes without the framework.

## Wiring (choose ONE)

### Option A — Global settings.json (recommended)
Add to `C:\Users\yanga\.claude\settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|NotebookEdit|Bash|PowerShell",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \"C:/Users/yanga/.claude/skills/1427-checkpoint/hooks/block-main-branch.ps1\"",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -Command \"Write-Host '[1427-checkpoint] persistent checkpoint active — language-agnostic intent gate + main-branch HARD protect + English-only code gate armed.'\"",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

Bash fallback for non-Windows (same file, add second matcher):
`bash "C:/Users/yanga/.claude/skills/1427-checkpoint/hooks/block-main-branch.sh"`

### Option B — Project-level
Same JSON but in `<project>/.claude/settings.json` or
`<project>/.claude/settings.local.json` to scope per-repo.

## Verification (acceptance-tests.md § Session monitoring continuity)
1. New session → SessionStart checkpoint message appears.
2. Send read-only prompt (e.g. "jelaskan fungsi ini") → no framework, passes checkpoint as read-only.
3. Send mutating prompt in ANY language ("hapus file X" / "请删除文件") → halted at checkpoint — framework appears before any tool runs.
4. Attempt Edit/Write/Bash while on `main` → blocked at checkpoint — hook exits 2, BLOCKED, requires `ALLOW MAIN: <reason>`.
5. Deliver code while discussing in Indonesian → delivered identifiers/comments/commit message are English-only.

## UNINSTALLED vs INSTALLED
- HARDENED (current branch) = checkpoint code ready, wiring documented.
- INSTALLED = the JSON above is actually merged into your settings.json
  (requires explicit user approval via framework authority question when
  this file's wiring is applied).
