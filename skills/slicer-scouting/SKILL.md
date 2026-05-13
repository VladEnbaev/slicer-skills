---
name: slicer-scouting
description: Use when existing context must be understood in a read-only pass before recommendations, planning, debugging, refactoring, implementation, or approval questions; applies to codebases, docs, issues, logs, configs, APIs, and prior decisions.
---

# Slicer Scouting

## Overview

Perform read-first context scouting before asking avoidable questions or proposing changes.

The goal is not to read everything. The goal is to learn enough true context to ask better questions and avoid confident guesses.

This skill is a discovery gate, not an implementation mode.

## Hard Gate

Scouting stays read-only and non-mutating.

- Do not edit files, scaffold code, apply patches, format, generate, install, migrate, update snapshots, stage, commit, or invoke implementation.
- Do not use `slicer-execution` from scouting.
- Do not turn a discovered obvious fix into an edit. Record it as a finding or likely route.
- Run commands only when they are evidence gathering and low risk. If a command may write build output, caches, lockfiles, snapshots, or generated files, defer it or ask first.

The terminal state of scouting is a context brief, question, route recommendation, or approval checkpoint. Implementation requires an explicit next-phase approval, usually through `slicer-planning`, `slicer-debugging`, or `slicer-execution`.

## Scouting Pass

Complete a targeted pass before recommendations:

1. Restate the active goal and what context would change the answer.
2. Locate relevant files, entry points, tests, docs, configs, schemas, logs, and recent changes.
3. Find similar working implementations or prior decisions.
4. Inspect call sites, ownership boundaries, public contracts, data flow, and lifecycle assumptions.
5. Identify constraints from project instructions, tooling, dependency manifests, tests, and platform limits.
6. Stop when enough context is known to ask a sharper question, propose routes, or plan slices.

Avoid generated artifacts, dependency checkouts, and build output unless they are directly relevant.

## Output Format

After scouting, summarize:

```text
Context found:
- ...

Relevant patterns:
- ...

Constraints:
- ...

Risks or disputed points:
- ...

Questions for the human:
- ...

Recommended next phase:
...

Approval needed:
...
```

Ask only questions that cannot be answered from the environment and materially affect goal, scope, approach, risk, or acceptance criteria.

If no question is needed, make the approval checkpoint concrete:

```text
Recommended next phase:
Use slicer-planning to map slices / use slicer-debugging to prove root cause / use slicer-execution for the approved narrow change.

Approval needed:
Confirm before I leave scouting and edit files.
```

## Quality Bar

- Prefer primary sources in the repo over assumptions.
- Use precise file/type/module names when available.
- Mark uncertainty explicitly.
- If multiple plausible sources of truth conflict, show the conflict and recommend how to resolve it.
- Separate facts, inferences, and recommendations.
- Treat explicit requests to "look first", "scout", or "understand context" as permission to gather context, not permission to edit afterward.
