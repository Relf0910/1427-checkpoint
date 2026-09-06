# Risk and Authority — 1427-framework-showup

## Risk classification

| Level | Description | Action |
|---|---|---|
| **LOW** | Read-only or purely informational (no files, configs, or systems changed). | Framework display is still required, but proceeds after the display itself (which is also low-risk). |
| **MODERATE** | Adds files, modules, routes, or non-destructive changes (e.g., `create`, `add`, `init`). | Framework is shown; execution waits for explicit user approval. |
| **HIGH** | Deletes, overwrites, rewrites, system configuration changes, permission changes, or production operations (e.g., `delete`, `replace`, `chmod`, `deploy`). | Framework is shown; execution strictly requires explicit written approval. No assumptions. |

## Mandatory gates that always require a framework display

Regardless of keyword matching, always display a framework before:

- Any file edit, write, rename, or delete operation
- Any shell command that changes the system (Bash, PowerShell, sh, etc.)
- Any external API call with side effects
- Any package installation, update, or removal
- Any database write, permission, or schema operation
- Any version-control commit, push, merge, or revert

## Authority categories

Label every claim in the framework as one of:

| Category | Meaning | Example |
|---|---|---|
| **USER FACT** | Provided directly by the user | "Color should be #E53935" |
| **WORKING ASSUMPTION** | Inferred by the AI without explicit confirmation | "Assuming login.css is the primary stylesheet" |
| **RECOMMENDATION** | Suggested by the AI, alternative available | "Recommend using a CSS variable instead of hardcoding" |

Do not present a `WORKING ASSUMPTION` as a `USER FACT`.

## Authority gate rules

1. If the next action is `HIGH` risk, the framework must explicitly
   highlight it with `[HIGH]` beside the step.
2. If multiple high-risk steps are present, display them as a
   separate grouped warning before the decision matrix.
3. The framework must not invent authority: do not claim the user
   said something they did not.
4. The user may reply with partial agreement:
   `M: agree step 1, skip step 2` — honor exactly as stated.
5. After any disagreement or modification, re-display the updated
   framework and re-ask the authority question before proceeding.
