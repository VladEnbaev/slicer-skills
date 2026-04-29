---
name: jarvis-debugging
description: Use when investigating a bug, regression, failing test, CI failure, performance issue, flaky behavior, broken integration, or any unexpected system behavior where root cause must be established before fixing.
---

# Jarvis Debugging

## Overview

Debug through evidence, not guesses. No fix before root cause.

Use this as the Jarvis-style wrapper for systematic debugging: proactive, concise, and checkpointed.

## Debugging Flow

1. **Reproduce**: identify exact failure, command, scenario, log, or user-visible symptom.
2. **Gather evidence**: inspect error messages, stack traces, recent changes, data flow, environment, and relevant boundaries.
3. **Compare patterns**: find similar working code or prior fixes.
4. **State root cause**: explain where the bad state/behavior originates and why.
5. **Offer fix options**: use `jarvis-decision-gates` when multiple fixes are plausible or risk differs.
6. **Execute bugfix slice**: use `jarvis-slices`; usually include a regression test unless there is a clear reason not to.
7. **Verify**: prove the failure is gone and note remaining risk.

## Stop Rules

Stop and ask for direction when:

- the issue cannot be reproduced and more data is needed;
- evidence contradicts the current hypothesis;
- the fix would change architecture, public contracts, data migrations, lifecycle, or concurrency assumptions;
- two attempted fixes fail;
- the next step would be speculative.

## Output Format

Use concise checkpoints:

```text
Evidence:
- ...

Root cause:
...

Fix options:
A. ...
B. ...

Recommendation:
...

Next:
...
```
