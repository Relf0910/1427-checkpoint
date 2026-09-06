#!/usr/bin/env bash
# PreToolUse hook — HARD main-branch protection (POSIX fallback)
# Same logic as block-main-branch.ps1, for Bash environments.
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/1427-framework-showup"

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
branch="$(echo "$branch" | tr -d '[:space:]')"

if [[ "$branch" != "main" && "$branch" != "master" ]]; then
  exit 0
fi

# Check allow flag
check_flag() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  grep -qE 'ALLOW MAIN\s*:\s*\S+' "$f" 2>/dev/null
}

if check_flag "$SKILL_DIR/.allow-main" || check_flag "./.allow-main" || check_flag "$HOME/.claude/skills/1427-framework-showup/.allow-main"; then
  exit 0
fi
if [[ -n "${ALLOW_MAIN:-}" ]] && echo "$ALLOW_MAIN" | grep -qE ':\s*\S+'; then
  exit 0
fi

echo "BLOCKED: main branch is protected — HARD gate."
echo "Current branch: $branch"
echo "To proceed, user must type exactly:  ALLOW MAIN: <short reason>"
echo "Per-step, per-session only. Silence or 'A' alone does NOT unlock main."
exit 2
