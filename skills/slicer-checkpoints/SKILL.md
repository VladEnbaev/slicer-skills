---
name: slicer-checkpoints
description: Use for continue checkpoints after verified slices, or when an agent must stop before choosing an approach, expanding scope, changing public contracts, moving between slices, or continuing after meaningful uncertainty or risk.
---

# Slicer Checkpoints

## Overview

Use checkpoints to keep the human in control of meaningful engineering choices without slowing down low-value mechanics.

The agent should be opinionated: present options, recommend one, and explain why.

## Checkpoint Triggers

Open a checkpoint before:

- selecting between multiple plausible approaches;
- starting implementation after exploration or planning;
- moving from one slice to the next;
- changing public APIs, module boundaries, schemas, migrations, lifecycle, concurrency, persistence, or error handling;
- expanding scope beyond what was approved;
- continuing after evidence contradicts the original plan.

After every verified slice or sub-slice, use a continue checkpoint. This is the normal stop between slices.

## Checkpoint Format

Use this compact format:

```text
What I found:
- ...

Options:
A. ...
B. ...
C. ...

Recommendation:
I recommend ... because ...

Next proposed step:
...

Approval needed:
Confirm ... before I continue.
```

For simple binary decisions, use two options. For architectural tradeoffs, use up to three. Do not invent filler options.

## Approval Semantics

Continue only after explicit approval such as "yes", "confirmed", "choose B", "go ahead", or an equivalent instruction.

If the user gives new constraints instead of approval, incorporate them and reopen the checkpoint.

## Continue Checkpoint

Use this compact format after a slice or sub-slice is verified:

```text
Verification:
- ...

Options:
A. Continue with the next slice/sub-slice.
B. Revise the slice map.
C. Return to scouting because assumptions changed or the work went off track.
D. Stop here.

Recommendation:
I recommend ... because ...

Approval needed:
Confirm ... before I continue.
```
