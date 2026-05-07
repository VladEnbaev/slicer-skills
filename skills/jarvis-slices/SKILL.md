---
name: jarvis-slices
description: Use when the user asks for a plan in slices, when approved work should be split into implementation slices or sub-slices, or when executing a specific agreed slice with boundaries, test decisions, verification, review, and a checkpoint before the next slice.
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

If another planning mode or tool requires a complete plan, keep the plan slice-first. The plan is complete only when every slice has a purpose, boundary, test decision, verification strategy, and checkpoint. Do not ask for approval to execute a whole multi-slice project at once when the safer approval boundary is the slice map or the next slice.

## Final Answer Contract

When this skill is used for planning, or when the user asks for a plan in slices, the final answer must be slice-first. Start with the slice map before summaries, file lists, subsystem plans, or general roadmap text.

Use this required format for each slice:

```text
Slice N: Title

Goal:
...

Included:
- ...

Not included:
- ...

Test decision / Verification:
...

Checkpoint / Stop condition:
...
```

Do not replace the slice map with a file list, subsystem plan, phase list, or general roadmap.

Before the final answer, check that each planned slice has an explicit `Slice N:` heading, starting with `Slice 1:`.

## Sub-Slices

For substantial slices, make sub-slices the normal execution unit:

```text
Slice 1: ...

Sub-slices:
1.1 ...
1.2 ...
1.3 ...
```

A parent slice is a milestone. A sub-slice is the smallest approved implementation step.

Break a slice into sub-slices when it:

- changes multiple contracts, modules, lifecycles, or user-facing paths;
- has phases that can be reviewed or verified independently;
- needs staged human control before the whole slice is complete;
- would otherwise produce a large, hard-to-review diff.

Each sub-slice should be coherent on its own, but it does not need to deliver the full parent-slice outcome. It should either leave the system working or have an explicit temporary constraint that is safe and understood.

Approval for a parent slice map is approval of the decomposition, not approval to execute every sub-slice. Execute only the requested or approved sub-slice, then stop at a checkpoint and recommend the next sub-slice.

If discovery changes the parent slice, update the remaining sub-slice map before continuing.

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

- Implement only the approved slice or sub-slice.
- Do not bundle "while here" work.
- Stop and reopen a decision gate if reality differs from the brief.
- After the slice or sub-slice, report verification evidence, self-review findings, residual risk, and the recommended next slice or sub-slice.
