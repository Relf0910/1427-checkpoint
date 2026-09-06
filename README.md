# 1427-framework-showup

> **Stop, display, and wait** — no change proceeds without explicit user approval.

Session monitor for Claude Code that enforces a mandatory **change framework** before every action that modifies code, files, configuration, or systems.

## Why this exists

AI assistants can act too eagerly. This skill inserts a hard gate between intent and execution:

```
User request
  → Intent gate (language-agnostic)
    → Framework display (what, where, why, impact, risk, alternative)
      → Wait for [A] Agree / [D] Disagree / [M] Modify
        → Only then execute — and only what was approved
```

**No framework, no tool call. Silence is never approval.**

## Three hardening pillars

### 1. Language-agnostic intent gate

Mutating intent triggers **in any language**, not just English keywords.

| Language | Example | Intent | Result |
|---|---|---|---|
| Indonesian | `hapus semua sesi` | delete | **TRIGGER** |
| Indonesian | `buatkan fitur login` | create | **TRIGGER** |
| Malay | `padam modul lama` | delete | **TRIGGER** |
| Chinese | `请删除测试文件` | delete | **TRIGGER** |
| Arabic | `إنشاء ملف جديد` | create | **TRIGGER** |
| Japanese | `バグを修正して` | fix | **TRIGGER** |

Intent detection is **primary**; keyword lists (`trigger-keywords.md`) are fallback evidence only. Vague phrases (`fix it`, `bereskan`, `buat jalan`, `全部改一下`) are expanded by the Intent-to-Command Engine into explicit steps with `[UNVERIFIED]` targets before display.

See [`references/trigger-keywords.md`](references/trigger-keywords.md).

### 2. Hard main-branch protection — `CRITICAL`

The skill **never** writes to `main` / `master` unless the user grants explicit per-step, per-session access:

```
ALLOW MAIN: <short reason>
```

- Two-layer enforcement: **prompt gate** (`[CRITICAL — MAIN PROTECTED]` in the framework) + **system hook** (`hooks/block-main-branch.ps1` via `PreToolUse`).
- `A` / `Agree all` alone does **not** unlock main-targeting steps.
- Prior-session `ALLOW MAIN` does not carry over.

See [`references/risk-and-authority.md`](references/risk-and-authority.md) and [`hooks/block-main-branch.ps1`](hooks/block-main-branch.ps1).

### 3. Hard English-only code writing

- **Discuss in any language.** Framework text may be in the user's language.
- **Code is always English.** Identifiers, comments, commit messages, and docs written to code are English only. Non-English drafts are self-rejected and rewritten.

See [`references/framework-schema.md`](references/framework-schema.md) §2b.

## Installation

### Branch map

| Branch | Content |
|---|---|
| `main` | Original baseline — 7 files, untouched |
| `feat/hardening-multilang-mainprotect-english` | Hardened — intent gate + main protection + English-only + hooks |

### Persistent wiring (auto-active every session)

Add to your global `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|NotebookEdit|Bash|PowerShell",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \"C:/Users/yanga/.claude/skills/1427-framework-showup/hooks/block-main-branch.ps1\"",
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
            "command": "powershell -NoProfile -Command \"Write-Host '[1427-framework-showup] persistent monitor active — language-agnostic intent gate + main-branch HARD protect + English-only code gate armed.'\"",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

Bash fallback: `bash "C:/Users/yanga/.claude/skills/1427-framework-showup/hooks/block-main-branch.sh"`

Full guide: [`CLAUDE-PERSISTENT.md`](CLAUDE-PERSISTENT.md)

After wiring, a new session prints:

```
[1427-framework-showup] persistent monitor active — language-agnostic intent gate + main-branch HARD protect + English-only code gate armed.
```

Manual invoke still works: `/1427-framework-showup`

## Usage

Every mutating request triggers a **Framework Display**:

```markdown
## Change Title

### Action List
| # | Action | Target | Type | Justification | Impact | Risk | Alternative |
|---|---|---|---|---|---|---|---|
| 1 | ... | ... | CREATE/MODIFY/DELETE | USER FACT / ASSUMPTION / RECOMMENDATION | ... | LOW/MODERATE/HIGH/CRITICAL | ... |

### Decision Matrix
| # | Step Summary | Agree | Disagree | Modify |
|---|---|---|---|---|

Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)
For main-branch steps, also required: ALLOW MAIN: <reason>

⚠️ No change will be made until you give explicit written approval.
```

**Responses:**

- `A` — execute all non-main steps
- `D` — stop, no change
- `M: agree step 1, skip step 2` — partial, reported as partial
- `ALLOW MAIN: hotfix prod outage` — unlock that main-targeting step for this session only

## Acceptance tests

See [`references/acceptance-tests.md`](references/acceptance-tests.md) — covers:

- Positive triggers in BI / Malay / AR / ZH / JP
- Non-triggers (read-only in any language)
- Vague-phrase expansion
- `CRITICAL` main-branch gate
- English-only enforcement
- Session continuity and persistence

## Engine contracts

- **Intent-to-Command** — expand vague intents into explicit steps
- **Stagnation Breaker** — surface blockers, offer alternatives
- **Evidence Integrity Gate** — label `USER FACT` / `WORKING ASSUMPTION` / `RECOMMENDATION`; never fabricate `ALLOW MAIN`
- **Completion Gate** — partial execution reported as partial
- **Authority Gate** — per-step, per-session approval; `CRITICAL` requires `ALLOW MAIN`
- **English-Only Gate (HARD)** — non-English code rejected and rewritten

## References

| File | Purpose |
|---|---|
| [`SKILL.md`](SKILL.md) | Skill definition and engine contracts |
| [`references/trigger-keywords.md`](references/trigger-keywords.md) | Language-agnostic intent gate + fallback keyword lists |
| [`references/risk-and-authority.md`](references/risk-and-authority.md) | Risk levels + hard main-branch protocol + authority categories |
| [`references/framework-schema.md`](references/framework-schema.md) | Mandatory framework display format |
| [`references/acceptance-tests.md`](references/acceptance-tests.md) | Hardened test matrix |
| [`hooks/block-main-branch.ps1`](hooks/block-main-branch.ps1) | PreToolUse hard gate (PowerShell) |
| [`hooks/block-main-branch.sh`](hooks/block-main-branch.sh) | PreToolUse hard gate (Bash) |
| [`CLAUDE-PERSISTENT.md`](CLAUDE-PERSISTENT.md) | Wiring guide for persistence |

## License

MIT — see [LICENSE](LICENSE).

---

**Status:** `HARDENED` on `feat/hardening-multilang-mainprotect-english`. `main` holds the original baseline. Installation completes on explicit user choice.
