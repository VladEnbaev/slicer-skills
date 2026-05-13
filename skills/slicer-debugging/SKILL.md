---
name: slicer-debugging
description: Use when investigating a bug, regression, failing test, CI failure, performance issue, flaky behavior, broken integration, or unexpected behavior where root cause must be established before any fix or implementation.
---

# Slicer Debugging

## Overview

Debug through evidence, not guesses. No fix before root cause.

This is an investigation gate. It prevents patching symptoms, even when the fix looks obvious.

## Hard Gate

Until root cause is stated and supported by evidence, stay in investigation mode.

- Do not edit source, tests, configs, lockfiles, snapshots, generated files, or docs as a fix.
- Do not run formatters, generators, migrations, update commands, or broad rewrite tools.
- Do not apply an "obvious" one-line fix before proving why it is correct.
- Diagnostic instrumentation counts as an edit. Use it only after a checkpoint that states the probe, location, expected evidence, and rollback/keep plan.

Implementation may start only after a root-cause checkpoint has been presented and the human has approved the fix route or bugfix slice. Then use `slicer-execution`.

## Phases

Complete each phase before moving to the next.

### Phase 1: Reproduce and Read

- Identify the exact symptom, command, scenario, log, trace, or user-visible behavior.
- Read error messages, warnings, stack traces, file paths, line numbers, and error codes carefully.
- Check whether the failure is consistent. If it is not reproducible, gather more data instead of guessing.
- Check recent relevant changes: diffs, commits, dependencies, config, environment, inputs, and timing.

### Phase 2: Trace Evidence

- Trace bad data, state, timing, or control flow backward to its origin.
- Inspect component boundaries: caller to callee, API to service, service to storage, job to queue, build step to script, or similar boundaries in the current system.
- Find similar working code, prior fixes, or reference implementations in the same project.
- Compare working and broken paths. List meaningful differences before choosing one as causal.

### Phase 3: State Root Cause

State a single concrete hypothesis:

```text
I think the root cause is ... because evidence A, B, and C show ...
```

Test the hypothesis with the smallest non-mutating check available. If the check contradicts the hypothesis, return to Phase 2. If proving the hypothesis requires an edit, open a diagnostic checkpoint first.

### Phase 4: Fix Checkpoint

Only after root cause is established, present:

- evidence gathered;
- root cause and why the failure originates there;
- fix options, if more than one route is plausible;
- recommended route and tradeoff;
- test decision and verification strategy.

Use `slicer-checkpoints` when the route changes architecture, public contracts, lifecycle, concurrency, data migration, persistence, or ownership boundaries. Use `slicer-planning` when the fix needs multiple reviewable slices.

### Phase 5: Execute and Verify

Use `slicer-execution` for the approved fix slice.

- Prefer a regression test for behavior bugs unless there is a clear reason not to.
- Make one root-cause fix at a time. Do not bundle refactors or "while here" work.
- Verify the original failure is gone and relevant existing checks still pass.
- If the fix fails, stop and return to evidence. After two failed fix attempts, do not try another without a checkpoint that questions the hypothesis or architecture.

## Stop Rules

Stop and ask for direction when:

- the issue cannot be reproduced and more data is needed;
- evidence contradicts the current hypothesis;
- the fix would change architecture, public contracts, data migrations, lifecycle, or concurrency assumptions;
- two attempted fixes fail;
- the next step would be speculative.

## Red Flags

If you catch yourself thinking any of these, stop and return to Phase 1 or Phase 2:

- "This is probably it, I will just patch it."
- "I can read the rest after the fix."
- "Let me try a few changes and see what passes."
- "The symptom is obvious, so the root cause is obvious."
- "I will add tests after confirming the fix."
- "One more fix attempt" after prior fixes failed.

## Output Format

Use concise investigation checkpoints:

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

Approval needed:
Confirm the fix route or slice before I edit files.
```

If there is no root cause yet:

```text
Evidence:
- ...

Unknowns:
- ...

Next evidence step:
...

Approval needed:
Only needed if the next diagnostic step edits files or runs a mutating command.
```
