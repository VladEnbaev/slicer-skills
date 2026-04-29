---
name: jarvis-decision-gates
description: Use when an agent is about to choose an approach, move to another phase, start implementation, expand scope, change public contracts, or continue after discovering meaningful uncertainty or risk.
---

# Jarvis Decision Gates

## Overview

Use decision gates to keep the human in control of meaningful engineering choices without slowing down low-value mechanics.

The agent should be opinionated: present options, recommend one, and explain why.

## Gate Triggers

Open a decision gate before:

- selecting between multiple plausible approaches;
- starting implementation after exploration or planning;
- moving from one slice to the next;
- changing public APIs, module boundaries, schemas, migrations, lifecycle, concurrency, persistence, or error handling;
- expanding scope beyond what was approved;
- continuing after evidence contradicts the original plan.

## Gate Format

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

If the user gives new constraints instead of approval, incorporate them and reopen the gate.
