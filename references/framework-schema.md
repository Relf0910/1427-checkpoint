# Framework Display Schema — 1427-framework-showup

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
| **Justification** | Why this step is necessary |
| **Impact** | What changes as a result of this step |
| **Risk** | What could break or be affected |
| **Alternative** | Other options that could achieve the same goal |

---

## Section 3: Decision Matrix

| # | Step Summary | Agree | Disagree | Modify |
|---|---|---|---|---|
| 1 | ... | [ ] | [ ] | [ ] |
| 2 | ... | [ ] | [ ] | [ ] |
| 3 | ... | [ ] | [ ] | [ ] |

---

## Section 4: Authority Question

Ask this exact question after the matrix:

```
Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)
```

- On **[A]**: proceed with all steps in order.
- On **[D]**: stop completely. Do nothing. Report that no change was made.
- On **[M]**: wait for user to specify which step(s) to modify, then
  display a revised framework and re-ask the authority question.

---

## Section 5: Authority Statement

Close every framework display with this verbatim statement:

```
⚠️ No change will be made until you give explicit written approval.
```

---

## Example Full Display

```
## Update login.css — change primary color to red

### Action List

| # | Action | Target | Type | Justification | Impact | Risk | Alternative |
|---|---|---|---|---|---|---|---|
| 1 | Change color value | styles/login.css line 14 | MODIFY | User requested red theme | All components using .primary-color turn red | None | Use a CSS variable instead |
| 2 | Verify usage | All .css and .scss files | READ | Confirm no unintended side effects | None | None | — |

### Decision Matrix

| # | Step Summary | Agree | Disagree | Modify |
|---|---|---|---|---|
| 1 | Change color value | [ ] | [ ] | [ ] |
| 2 | Verify usage | [ ] | [ ] | [ ] |

Do you agree with the steps above?
Choose: [A] Agree all / [D] Disagree all / [M] Modify specific step(s)

⚠️ No change will be made until you give explicit written approval.
```

---

## Rules

- Display the framework **before** any tool call.
- Do not collapse or summarize the action list into a single line.
- If the change involves more than 5 steps, group related steps
  and display a summary first, then the full detail.
- If a step has no meaningful alternative, write `None` — do not omit the field.
- If a step has no identified risk, write `Low` — do not omit the field.
