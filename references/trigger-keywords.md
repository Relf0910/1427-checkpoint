# Trigger Keywords — 1427-framework-showup

## HARD STOP — Display framework, wait for approval

Any request containing these keywords (or their equivalents in other
languages) triggers a mandatory framework display before the AI acts:

**Create / Add**
`create`, `add`, `make`, `write`, `new`, `generate`, `build`, `init`

**Modify**
`edit`, `modify`, `change`, `update`, `replace`, `patch`, `refactor`,
`restructure`, `format`, `format`

**Delete / Remove**
`delete`, `remove`, `drop`, `trash`, `uninstall`, `purge`

**Fix / Repair**
`fix`, `repair`, `heal`, `correct`, `resolve`, `patch`

**System / Config**
`install`, `setup`, `configure`, `deploy`, `migrate`, `upgrade`,
`downgrade`, `rollback`, `chmod`, `mkdir`, `rm`, `cp`, `mv`

**Version Control**
`push`, `pull`, `merge`, `commit`, `revert`, `reset`, `branch`

**Database**
`insert`, `update`, `delete from`, `drop table`, `create table`,
`alter table`, `grant`, `revoke`

## SOFT STOP — Display framework, but execution may continue after review

`plan`, `discuss`, `propose`, `what if`, `should i`, `do i need`,
`analyze`, `check`, `verify`, `review`, `audit`, `assess`

## NOT a trigger — proceed directly

`show`, `list`, `explain`, `what is`, `who is`, `how to`, `why`,
`tell me`, `find`, `search`, `look up`, `what does`, `what are`,
`clarify`, `describe`, `define`, `compare`, `summarize`, `translate`

## Guidance

- Trigger detection is based on **intent**, not exact word matching.
  "Can you initialize the project?" triggers because `init` matches.
- Compound phrases count: "set up and configure" triggers `setup` and `configure`.
- Negated forms still count if the overall request intent is to perform
  the action: "delete the test file" → trigger. "Do not delete the test file"
  → not a trigger, but still display a brief confirmation.
- When a request mixes trigger and non-trigger content, treat only the
  trigger portion as requiring a framework. The non-trigger portion can
  proceed while the framework is displayed for the trigger portion.
