# Risk and Authority — 1427-framework-showup

## Risk classification

| Level | Description | Action |
|---|---|---|
| **LOW** | Read-only or purely informational (no files, configs, or systems changed). | Framework display is still required, but proceeds after the display itself (which is also low-risk). |
| **MODERATE** | Adds files, modules, routes, or non-destructive changes (e.g., `create`, `add`, `init`). | Framework is shown; execution waits for explicit user approval. |
| **HIGH** | Deletes, overwrites, rewrites, system configuration changes, permission changes, or production operations (e.g., `delete`, `replace`, `chmod`, `deploy`). | Framework is shown; execution strictly requires explicit written approval. No assumptions. |
| **CRITICAL** | Any write targeting the protected branch (`main` / `master`). See Hard Main-Branch Protection below. | Framework shows `[CRITICAL — MAIN PROTECTED]`; PreToolUse hook **auto-blocks** the tool call. Only `ALLOW MAIN: <reason>` unlocks that single step. |

## Hard Main-Branch Protection (CRITICAL — non-bypassable)

> **Rule: The skill NEVER writes to `main` / `master` — in any language, by any tool — unless the user grants explicit written access for that exact step. Silence, implication, and prior-session approval do not transfer.**

### Protected branches

- `main`, `master` (exact match, including `origin/main`, `origin/master`, `refs/heads/main`).
- Any repo where the default branch is `main`/`master` — same gate applies.

### What counts as "toward main"

- `git checkout main` / `git switch main` / `git checkout master`
- `git commit` while `HEAD` is on `main`/`master` (any language phrasing: `komit`, `commit`, `提交`, `コミット`)
- `git push origin main` / `git push origin master` / `git push` while on `main`/`master`
- `git merge <branch>` into `main`/`master` (including `git merge` while on `main`)
- `git pull` / `git rebase` / `git cherry-pick` / `git reset --hard` targeting `main`/`master`
- `git branch -D main`, `git push --force origin main`, `gh pr merge` into `main`
- Direct file writes (`Edit`, `Write`, `NotebookEdit`, `Bash` with `>`, `PowerShell` with `Set-Content`) when the current git branch is `main`/`master`

### Enforcement (two layers)

1. **Prompt gate** — Framework flags every main-targeting step as `[CRITICAL — MAIN PROTECTED]` in the Action List and grouped warning before the Decision Matrix. Risk = `CRITICAL`. Authority = `USER FACT` only.
2. **System hook gate** — `PreToolUse` hook on `Bash`, `PowerShell`, `Edit`, `Write`, `NotebookEdit` checks the current branch. If `main`/`master`, the hook exits `2` (block) with message `BLOCKED: main branch is protected — say ALLOW MAIN: <reason> to proceed`. No tool runs.

### Unlock protocol (only way to proceed)

- User must write **exactly** `ALLOW MAIN: <short reason>` in the same session, for the same step number(s).
- Examples: `ALLOW MAIN: hotfix prod outage`, `ALLOW MAIN: initial repo seeding — approved`.
- The unlock is **per-step, per-session**. `ALLOW MAIN` for step 2 does not unlock step 3. New session = re-ask.
- Without that literal phrase, the framework stays blocked — `A` (Agree all) alone is **not enough** for main-targeting steps. The agent must re-prompt: `Step 2 targets main — requires ALLOW MAIN: <reason>.`

### Authority note for main

- `ALLOW MAIN` is treated as `USER FACT` — it must be typed by the user, never inferred or fabricated by the AI.
- The agent must never suggest bypassing the gate, never invent a reason, and never auto-approve.
- Violation = immediate `FAIL` in acceptance tests.

## Mandatory gates that always require a framework display

Regardless of keyword matching, always display a framework before:

- Any file edit, write, rename, or delete operation
- Any shell command that changes the system (Bash, PowerShell, sh, etc.)
- Any external API call with side effects
- Any package installation, update, or removal
- Any database write, permission, or schema operation
- Any version-control commit, push, merge, or revert
- **Any operation that would write to `main`/`master` (CRITICAL — see above)**

## Authority categories

Label every claim in the framework as one of:

| Category | Meaning | Example |
|---|---|---|
| **USER FACT** | Provided directly by the user | "Color should be #E53935" / "ALLOW MAIN: hotfix prod" |
| **WORKING ASSUMPTION** | Inferred by the AI without explicit confirmation | "Assuming login.css is the primary stylesheet" |
| **RECOMMENDATION** | Suggested by the AI, alternative available | "Recommend using a CSS variable instead of hardcoding" |

Do not present a `WORKING ASSUMPTION` as a `USER FACT`.
`ALLOW MAIN` and any main-targeting intent must always be `USER FACT`.

## Authority gate rules

1. If the next action is `HIGH` risk, the framework must explicitly
   highlight it with `[HIGH]` beside the step.
2. If the next action targets `main`/`master`, highlight it with
   `[CRITICAL — MAIN PROTECTED]` and apply the unlock protocol above —
   this outranks `HIGH`.
3. If multiple high/critical steps are present, display them as a
   separate grouped warning before the decision matrix.
4. The framework must not invent authority: do not claim the user
   said something they did not — especially `ALLOW MAIN`.
5. The user may reply with partial agreement:
   `M: agree step 1, skip step 2` — honor exactly as stated.
6. After any disagreement or modification, re-display the updated
   framework and re-ask the authority question before proceeding.
7. Silence, emoji, or empty reply is **never** approval. Only
   `A` / `Agree` (for non-main steps) and `ALLOW MAIN: <reason>` (for main steps)
   count as explicit written approval — in the current session only.

## Hard English-Only Code Writing (see also framework-schema.md)

- **Discuss in any language. Write code in English only.** See `framework-schema.md` § English-Only Enforcement.
- Violation: any identifier, comment, commit message, or docs written to code in non-English must be self-rejected and rewritten before delivery.
