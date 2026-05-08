---
name: slicer-execution
description: Use when executing one approved slice, splitting that slice into sub-slices if needed at execution time, and reporting verification before a continue checkpoint.
---

# Slicer Execution

## Overview

Execute one approved slice or sub-slice at a time.

Slicer should not be timid about code. Slicer should be explicit about what is being changed and why.

Sub-slices belong here, not in the initial slice map. If an approved slice is still too large to execute safely, split only that slice before editing code.

Break the approved slice into sub-slices when it:

- changes multiple contracts, modules, lifecycles, or user-facing paths;
- has phases that can be reviewed or verified independently;
- needs staged human control before the whole slice is complete;
- would otherwise produce a large, hard-to-review diff.

Each sub-slice should be coherent on its own. It should either leave the system working or have an explicit temporary constraint that is safe and understood.

## Slice Brief

Before executing each slice or sub-slice, state:

```text
Slice/sub-slice goal:
...

Included:
- ...

Not included:
- ...

Expected change areas:
- ...

Test decision:
Write tests / do not write tests.
Reason: ...
Verification: ...

Stop conditions:
- ...
```

If there is no approved slice or sub-slice, use `slicer-planning` or open a checkpoint before implementation.

If the approved slice must be split, present the sub-slice map before implementation:

```text
Approved slice:
...

Sub-slices:
1. ...
2. ...
3. ...

Recommended first sub-slice:
...

Approval needed:
Confirm before I execute this sub-slice.
```

## Test Decision

Every executed slice needs a verification strategy. Tests are recommended by context, not by ritual.

Usually write tests when the slice:

- changes behavior;
- fixes a bug;
- moves business logic;
- changes public contracts;
- touches lifecycle, concurrency, caching, persistence, error handling, or user-visible workflows.

Tests may be unnecessary when the slice is purely mechanical:

- renaming;
- moving files without logic changes;
- deleting dead code;
- documentation/comment-only changes;
- import/access-control cleanup.

When not writing tests, explicitly justify the decision and verify through build/typecheck, existing tests, search for old names, lint, or manual diff review as appropriate.

## Execution Rules

- Implement only the approved slice or sub-slice.
- Do not bundle "while here" work.
- Stop and return to scouting if reality differs from the brief enough that the plan is no longer trustworthy.
- After the slice or sub-slice, report verification evidence, self-review findings, residual risk, and the recommended next slice or sub-slice.
- End with a continue checkpoint: continue to the next slice/sub-slice, revise the slice map, stop, or return to scouting if assumptions were wrong.
- If the slice or sub-slice produced changes and verification is complete, offer to commit that completed slice before moving on. Do not stage or commit without explicit user approval; include a concise suggested commit message when useful.

## Completion Report

After execution, report:

```text
Implemented:
- ...

Verification:
- ...

Self-review:
- ...

Residual risk:
- ...

Continue checkpoint:
...
```
