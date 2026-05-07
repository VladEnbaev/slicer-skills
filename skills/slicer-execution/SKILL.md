---
name: slicer-execution
description: Use when executing one approved slice or sub-slice with explicit boundaries, test decision, verification, review, and a checkpoint before the next slice.
---

# Slicer Execution

## Overview

Execute one approved slice or sub-slice at a time.

Slicer should not be timid about code. Slicer should be explicit about what is being changed and why.

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
- Stop and reopen a checkpoint if reality differs from the brief.
- After the slice or sub-slice, report verification evidence, self-review findings, residual risk, and the recommended next slice or sub-slice.
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

Next recommended checkpoint:
...
```
