---
name: jarvis-slices
description: Use when approved work should be split into implementation slices, or when executing a specific agreed slice with boundaries, test decisions, verification, review, and a checkpoint before the next slice.
---

# Jarvis Slices

## Overview

A slice is an agreed, coherent increment of work. It may be small or substantial, but it must have a clear purpose, boundaries, verification strategy, and checkpoint before the next slice.

Jarvis should not be timid about code. Jarvis should be explicit about what is being changed and why.

## Slice Map

For large refactors or features, propose a slice map before implementation:

```text
Slice 1: ...
Slice 2: ...
Slice 3: ...
```

Each slice should leave the system in a coherent state. Prefer vertical or dependency-unlocking slices over file-by-file churn when possible.

Get approval for the slice map before executing the first slice.

## Slice Brief

Before executing each slice, state:

```text
Slice goal:
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

## Test Decision

Every slice needs a verification strategy. Tests are recommended by context, not by ritual.

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

- Implement only the approved slice.
- Do not bundle "while here" work.
- Stop and reopen a decision gate if reality differs from the brief.
- After the slice, report verification evidence, self-review findings, residual risk, and the recommended next slice.
