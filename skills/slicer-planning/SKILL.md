---
name: slicer-planning
description: Use when the user asks for a plan in slices, when approved work should be decomposed into a readable implementation slice map, or when slice boundaries, test decisions, verification strategies, and stop conditions are needed before execution.
---

# Slicer Planning

## Overview

A slice is an agreed, coherent increment of work. It may be small or substantial, but it must have a clear purpose, boundaries, verification strategy, and stop condition before the next slice.

Planning decides the slice map. Execution belongs to `slicer-execution`.

## Slice Map

For large refactors or features, propose a slice map before implementation:

```text
Slice 1: ...
Slice 2: ...
Slice 3: ...
```

Each slice should leave the system in a coherent state. Prefer vertical or dependency-unlocking slices over file-by-file churn when possible.

Get approval for the slice map before executing the first slice.

If another planning mode or tool requires a complete plan, keep the plan slice-first. The plan is complete only when every slice has a purpose, boundary, test decision, verification strategy, and stop condition. Do not ask for approval to execute a whole multi-slice project at once when the safer approval boundary is the slice map or the next slice.

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

Stop condition:
...
```

Do not replace the slice map with a file list, subsystem plan, phase list, or general roadmap.

Before the final answer, check that each planned slice has an explicit `Slice N:` heading, starting with `Slice 1:`.

## Sub-Slices

Do not decompose every substantial slice into sub-slices during initial planning. That makes the plan harder for a human to evaluate.

The initial slice map should stay readable and milestone-level. Mention that a slice may need sub-slices only when that risk is important for approval.

Sub-slices are normally created by `slicer-execution` when a specific slice has been approved and the agent is about to start that slice. At that point, split only the selected slice, ask approval for the first sub-slice, and execute one sub-slice at a time.

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

## Planning Rules

- Plan only as much detail as needed to make the map and the next approval meaningful.
- Do not bury risky decisions inside a slice title.
- Use `slicer-checkpoints` when selecting an approach, changing scope, or continuing after a verified slice needs explicit approval.
- Use `slicer-execution` after a slice or sub-slice has been approved for implementation.
