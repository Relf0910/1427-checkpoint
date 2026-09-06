---
name: 1427-framework-showup
description: Session monitor that displays a change framework before the AI performs any action that modifies code, files, configuration, or systems, ensuring the user approves every change before it is executed. Use only when the user requests session monitoring or when an action would modify code, files, or systems. Do not use for read-only tasks such as skill explanations, general analysis without modification, or Q&A unless the user explicitly requests monitoring — the skill requires active approval authority for every change.
---

# Framework Showup

Stop, display, and wait — make no change until the user gives explicit permission.

## Core rule

Before **every** action that modifies code, files, configuration, or systems,
you MUST display a change framework first (see `references/framework-schema.md`).
NEVER perform a change without the user's explicit written approval.
When in doubt whether an action modifies something, assume it does —
display the framework first.

## Session monitor behavior

The skill is invoked once at the start of a session and remains active
for the entire session:

1. On each user request, scan for trigger keywords
   (see `references/trigger-keywords.md`).
2. If a trigger keyword is detected, display the framework and pause.
3. Wait for the user response: **Agree** / **Disagree** / **Modify**.
4. Only after "Agree" — execute the action.
5. On "Disagree" — stop; do nothing.
6. On "Modify" — display the revised framework and wait again.

## Forbidden behavior

- Do not skip the framework and act directly.
- Do not assume the user has already agreed.
- Do not exceed the scope shown in the displayed framework.
- Do not call any modifying tool before approval.

## Engine contracts

This skill composes the following required engines:

- **Intent-to-Command Engine** — interpret the user's request as intent to
  modify something; convert it into a concrete planned action list before
  display. Never treat ambiguous phrases ("fix it", "make it work", "update
  everything") as executable commands; always expand them into explicit
  steps with targets, then display the framework.
- **Stagnation Breaker** — if the user repeatedly disagrees, declines to
  choose, or the session stalls, surface the blocker explicitly instead of
  repeating the same framework. Offer revised alternatives, narrower scope,
  or a graceful exit. Do not loop the same display without new information.
- **Evidence Integrity Gate** — every framework step must cite its source:
  label claims as `USER FACT`, `WORKING ASSUMPTION`, or `RECOMMENDATION`.
  Do not fabricate file paths, line numbers, or impact statements. If a
  target has not been inspected, mark it as unverified in the framework.
- **Completion Gate** — a change is complete only when every approved step
  has been executed, verified, and reported back. The user acknowledges the
  result; partial execution must be reported as partial, never as complete.
- **Authority Gate** — no modifying action proceeds without the user's
  explicit written approval in the current session. Silence, implication,
  or approval given in a different context does not transfer. HIGH-risk
  steps require explicit per-step approval.

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
  question are present.
- DIAGNOSE: if validation fails or the user modified/rejected, identify why.
- REPAIR: fix the missing or rejected portion.
- REVALIDATE: confirm the revised framework passes all checks, then display it.

## Acceptance tests

Read `references/acceptance-tests.md` for the positive-trigger,
non-trigger, edge-case, and failure-case scenarios this skill must satisfy.

Read `references/trigger-keywords.md` for the keyword list that pauses
the flow and triggers a framework display.

Read `references/framework-schema.md` for the mandatory display format:
change title, numbered action list (action, target file, change type,
justification, impact, risk, alternative), decision matrix, authority
question, and a statement that no change occurs until explicit approval.

Read `references/risk-and-authority.md` for risk classification
(`LOW`, `MODERATE`, `HIGH`), authority categories
(`USER FACT`, `WORKING ASSUMPTION`, `RECOMMENDATION`), and the
mandatory gates that require a framework display.

## Status

DRAFT — not installed. Installation only occurs on explicit user choice.
