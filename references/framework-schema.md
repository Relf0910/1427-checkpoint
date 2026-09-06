# Framework Display Schema — 1427-checkpoint

Every framework display must follow this exact structure.
Do not skip, reorder, or omit any section.

---

## Section 1: Change Title

A one-line summary of the planned change.

**Format:** `## [Title]`
**Example:** `## Update login.css — change primary color to red`

---

## Section 2: Action List (numbered)

For each action, state all of the following:

| Field | Description |
|---|---|
| **Step** | Sequential step number |
| **Action** | What will be done (imperative verb) |
| **Target** | Files, directories, or systems affected |
| **Type** | `CREATE` / `MODIFY` / `DELETE` / `REPLACE` |
| **Justification** | Why this step is necessary (label `USER FACT` / `WORKING ASSUMPTION` / `RECOMMENDATION`) |
| **Impact** | What changes as a result of this step |
| **Risk** | `LOW` / `MODERATE` / `HIGH` / `CRITICAL — MAIN PROTECTED` |
| **Alternative** | Other options that could achieve the same goal |

For `CRITICAL — MAIN PROTECTED` steps (any write toward `main`/`master`),
append `[CRITICAL — MAIN PROTECTED]` to the Risk field and include the
grouped warning described in `risk-and-authority.md`. Those steps require
`ALLOW MAIN: <reason>` — `A` alone is not enough.

---

## Section 2b: English-Only Code Writing Enforcement (HARD — non-bypassable)

> **Discuss in any language. Write code in English only. This is a HARD gate.**

Every framework that includes a code-writing step (Edit, Write, NotebookEdit,
commit message, docs generated into the repo) MUST enforce:

- **Identifiers:** variables, functions, classes, files — English only.
- **Comments:** inline and block comments — English only.
- **Commit messages:** English only.
- **Docs written to code:** README, JSDoc, docstrings — English only.
- **No transliteration of non-English words as identifiers** (e.g. `hapusData` → `deleteData`).

Discussion, explanations, and framework display text itself MAY be in the
user's language — but the **delivered code artifact is always English.**

**Enforcement:**
- If the agent drafts non-English code text, it must self-reject and rewrite
  before presenting or writing.
- If a code-writing step would violate this, flag the step `[ENGLISH-ONLY]`
  in the Action List and rewrite to English.
- This rule is independent of trigger language — a request in Indonesian
  (`buatkan fungsi hapus data`) still delivers `function deleteData()`.

---

## Section 3: Decision Matrix

| # | Step Summary | Agree | Disagree | Modify |
|---|---|---|---|---|
| 1 | ... | [ ] | [ ] | [ ] |
| 2 | ... | [ ] | [ ] | [ ] |
| 3 | ... | [ ] | [ ] | [ ] |

For `CRITICAL — MAIN PROTECTED` rows, add a note under the matrix:

```
⚠️ Step(s) [N] target main/master — require: ALLOW MAIN: <reason>
   "A" alone will NOT unlock them. See risk-and-authority.md § Hard Main-Branch Protection.
```

---

## Section 4: Authority Question

Ask this exact question after the matrix:

```
Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)
```

- On **[A]**: proceed with all steps **except** any `CRITICAL — MAIN PROTECTED` step,
  which additionally requires `ALLOW MAIN: <reason>` for that step number.
- On **[D]**: stop completely. Do nothing. Report that no change was made.
- On **[M]**: wait for user to specify which step(s) to modify, then
  display a revised framework and re-ask the authority question.
- On **`ALLOW MAIN: <reason>`** (with optional `A` for other steps): unlock
  the specified main-targeting step(s) and proceed.

For main-targeting frameworks, the full prompt is:

```
Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)
For main-branch steps, also required: ALLOW MAIN: <reason> (per-step, per-session)
```

---

## Section 5: Authority Statement

Close every framework display with this verbatim statement:

```
⚠️ No change will be made until you give explicit written approval.
For main-branch steps: ALLOW MAIN: <reason> is required — "A" alone is insufficient.
```

---

## Example Full Display

```
## Update login.css — change primary color to red

### Action List

| # | Action | Target | Type | Justification | Impact | Risk | Alternative |
|---|---|---|---|---|---|---|---|
| 1 | Change color value | styles/login.css line 14 | MODIFY | USER FACT: User requested red theme | All components using .primary-color turn red | LOW | Use a CSS variable instead |
| 2 | Verify usage | All .css and .scss files | READ | RECOMMENDATION: Confirm no side effects | None | LOW | — |

### Decision Matrix

| # | Step Summary | Agree | Disagree | Modify |
|---|---|---|---|---|
| 1 | Change color value | [ ] | [ ] | [ ] |
| 2 | Verify usage | [ ] | [ ] | [ ] |

Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)

⚠️ No change will be made until you give explicit written approval.
For main-branch steps: ALLOW MAIN: <reason> is required — "A" alone is insufficient.
```

### Example with main-branch protection

```
## Hotfix: bump version on main

### Action List

| # | Action | Target | Type | Justification | Impact | Risk | Alternative |
|---|---|---|---|---|---|---|---|
| 1 | Bump version | package.json on branch main | MODIFY | USER FACT: release v2.1 | Production release | CRITICAL — MAIN PROTECTED | Bump on feature branch + PR |

⚠️ Step 1 targets main/master — requires: ALLOW MAIN: <reason>
   "A" alone will NOT unlock it.

### Decision Matrix

| # | Step Summary | Agree | Disagree | Modify |
|---|---|---|---|---|
| 1 | Bump version on main | [ ] | [ ] | [ ] |

Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)
For main-branch steps, also required: ALLOW MAIN: <reason> (per-step, per-session)

⚠️ No change will be made until you give explicit written approval.
For main-branch steps: ALLOW MAIN: <reason> is required — "A" alone is insufficient.
```

---

## Rules

- Display the framework **before** any tool call.
- Do not collapse or summarize the action list into a single line.
- If the change involves more than 5 steps, group related steps
  and display a summary first, then the full detail.
- If a step has no meaningful alternative, write `None` — do not omit the field.
- If a step has no identified risk, write `LOW` — do not omit the field.
- Every code-writing step is English-only — flag `[ENGLISH-ONLY]` if rewritten.
- `CRITICAL — MAIN PROTECTED` outranks all other risk levels.
