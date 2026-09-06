---
name: 1427-checkpoint
description: Session checkpoint that displays a change framework before the AI performs any action that modifies code, files, configuration, or systems, ensuring the user approves every change before it is executed. Use only when the user requests session monitoring or when an action would modify code, files, or systems. Do not use for read-only tasks such as skill explanations, general analysis without modification, or Q&A unless the user explicitly requests monitoring — the skill requires active approval authority for every change.
---

# Checkpoint

Stop, display, and wait — no change passes the checkpoint without explicit permission.

## Core rule

Before **every** action that modifies code, files, configuration, or systems,
you MUST display a change framework first (see `references/framework-schema.md`).
NEVER perform a change without the user's explicit written approval.
When in doubt whether an action modifies something, assume it does —
display the framework first.

## Session monitor behavior

The skill is invoked once at the start of a session and remains active
for the entire session. When persistent auto-load is enabled (see
Persistent Monitor below), the skill is also auto-activated at SessionStart
so no manual `/1427-checkpoint` invoke is needed.

1. On each user request, scan for trigger intent — language-agnostic
   (see `references/trigger-keywords.md` §0 Universal Intent Gate).
   Keyword lists are fallback evidence only.
2. If a mutating intent is detected — in ANY language — display the
   framework and pause. Flag `[CRITICAL — MAIN PROTECTED]` when the target
   is `main`/`master`; flag `[ENGLISH-ONLY]` when a code-writing step
   would otherwise be non-English.
3. Wait for the user response: **Agree** / **Disagree** / **Modify**.
   For `main`/`master` steps, additionally require `ALLOW MAIN: <reason>`.
4. Only after explicit approval in this session — execute the action.
5. On "Disagree" — stop; do nothing.
6. On "Modify" — display the revised framework and wait again.

## Language policy

- **Human discussion:** any language is welcome (Indonesian, Malay, Arabic,
  Chinese, Japanese, etc.). Framework display text may be in the user's language.
- **Trigger detection:** language-agnostic intent gate — mutating intent
  triggers regardless of language (`hapus` = `delete` = `删除` = `削除`).
- **Code writing (HARD):** English only — see `references/framework-schema.md`
  §2b. Identifiers, comments, commit messages, and docs written to code are
  always English. Non-English drafts must be self-rejected and rewritten.

## Hard Main-Branch Protection (CRITICAL)

This skill **never** writes to `main` / `master` unless the user grants
explicit per-step, per-session access via `ALLOW MAIN: <reason>`.

- Protected: `main`, `master`, `origin/main`, `origin/master`.
- Blocked by two layers: prompt gate (`[CRITICAL — MAIN PROTECTED]` in the
  framework) and system hook (`hooks/block-main-branch.ps1` / `.sh` via
  `PreToolUse` on `Edit|Write|NotebookEdit|Bash|PowerShell`).
- Unlock: user types exactly `ALLOW MAIN: <short reason>` for the step.
  `A` / `Agree all` alone does NOT unlock main steps.
- See `references/risk-and-authority.md` § Hard Main-Branch Protection
  and `hooks/block-main-branch.ps1` for the full protocol.

## Persistent Monitor

- When wired via `settings.json` `hooks.SessionStart` or `CLAUDE.md`,
  the skill auto-activates each session without manual invoke.
- The monitor persists for the entire session; `/resume` or new session
  re-activates via SessionStart.
- See `references/risk-and-authority.md` and `references/framework-schema.md`
  for the authority and schema that the persistent monitor enforces.

## Forbidden behavior

- Do not skip the framework and act directly.
- Do not assume the user has already agreed.
- Do not exceed the scope shown in the displayed framework.
- Do not call any modifying tool before approval.
- Do not write non-English identifiers/comments/commit messages to code.
- Do not write to `main`/`master` without `ALLOW MAIN: <reason>`.

## Engine contracts

This skill composes the following required engines:

- **Intent-to-Command Engine** — interpret the user's request as intent to
  modify something; convert it into a concrete planned action list before
  display. Never treat ambiguous phrases ("fix it", "make it work", "update
  everything", "bereskan", "buat jalan", "全部改一下") as executable commands;
  always expand them into explicit steps with targets (mark uninspected as
  `[UNVERIFIED]` and risk `HIGH`/`CRITICAL`), then display the framework.
  Detection is intent-first, language-agnostic.
- **Stagnation Breaker** — if the user repeatedly disagrees, declines to
  choose, or the session stalls, surface the blocker explicitly instead of
  repeating the same framework. Offer revised alternatives, narrower scope,
  or a graceful exit. Do not loop the same display without new information.
- **Evidence Integrity Gate** — every framework step must cite its source:
  label claims as `USER FACT`, `WORKING ASSUMPTION`, or `RECOMMENDATION`.
  Do not fabricate file paths, line numbers, or impact statements. If a
  target has not been inspected, mark it as unverified in the framework.
  Never fabricate `ALLOW MAIN`.
- **Completion Gate** — a change is complete only when every approved step
  has been executed, verified, and reported back. The user acknowledges the
  result; partial execution must be reported as partial, never as complete.
- **Authority Gate** — no modifying action proceeds without the user's
  explicit written approval in the current session. Silence, implication,
  or approval given in a different context does not transfer. HIGH-risk
  steps require explicit per-step approval. CRITICAL (main) steps require
  `ALLOW MAIN: <reason>` per-step, per-session — `A` alone is insufficient.
- **English-Only Gate (HARD)** — any code-writing step that would produce
  non-English identifiers, comments, commit messages, or docs is rejected
  and rewritten in English before delivery. Discuss in any language, write
  code in English only.

## Autonomous loop

For framework revisions, refinements, and follow-up changes, run the loop:

```text
INSPECT → PLAN → BUILD → VALIDATE → DIAGNOSE → REPAIR → REVALIDATE
```

- INSPECT: read the current request, context, and prior framework state.
- PLAN: decide which steps change, which stay, and what new evidence is needed.
- BUILD: compose the revised framework display.
- VALIDATE: check that every step has target, type, justification, impact,
  risk, and alternative; check that the decision matrix and authority
  question are present; check English-only and main-protection gates.
- DIAGNOSE: if validation fails or the user modified/rejected, identify why.
- REPAIR: fix the missing or rejected portion.
- REVALIDATE: confirm the revised framework passes all checks, then display it.

## Acceptance tests

Read `references/acceptance-tests.md` for the positive-trigger,
non-trigger, edge-case, and failure-case scenarios this skill must satisfy.

Read `references/trigger-keywords.md` for the language-agnostic intent gate
and fallback keyword lists that pause the flow and trigger a framework display.

Read `references/framework-schema.md` for the mandatory display format:
change title, numbered action list (action, target file, change type,
justification, impact, risk, alternative), decision matrix, authority
question, and a statement that no change occurs until explicit approval.

Read `references/risk-and-authority.md` for risk classification
(`LOW`, `MODERATE`, `HIGH`, `CRITICAL — MAIN PROTECTED`), authority categories
(`USER FACT`, `WORKING ASSUMPTION`, `RECOMMENDATION`), the hard main-branch
protection protocol, and the hard English-only code-writing rule.

Read `hooks/block-main-branch.ps1` (and `.sh` fallback) for the system-level
PreToolUse enforcement that makes the main-branch gate non-bypassable.

## Status

HARDENED — checkpoint rebrand. Branch `feat/hardening-multilang-mainprotect-english`
holds the hardened checkpoint. Main holds the checkpoint baseline.
Installation (hook wiring + persistent auto-load) completes on explicit
user choice via `ALLOW MAIN` flow when touching settings.
