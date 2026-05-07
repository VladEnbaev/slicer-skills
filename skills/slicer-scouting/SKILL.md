---
name: slicer-scouting
description: Use when existing context must be understood before recommendations, planning, debugging, refactoring, implementation, or approval questions; applies to codebases, docs, issues, logs, configs, APIs, and prior decisions.
---

# Slicer Scouting

## Overview

Perform read-first context scouting before asking avoidable questions or proposing changes.

The goal is not to read everything. The goal is to learn enough true context to ask better questions and avoid confident guesses.

## Scouting Pass

Start with targeted, non-mutating exploration:

- locate relevant files, entry points, tests, docs, configs, schemas, and recent patterns;
- find similar working implementations;
- inspect call sites and ownership boundaries;
- identify constraints from project instructions, tooling, dependency manifests, and tests;
- avoid generated artifacts, dependency checkouts, and build output unless they are directly relevant.

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
```

Ask only questions that cannot be answered from the environment and materially affect goal, scope, approach, risk, or acceptance criteria.

## Quality Bar

- Prefer primary sources in the repo over assumptions.
- Use precise file/type/module names when available.
- Mark uncertainty explicitly.
- If multiple plausible sources of truth conflict, show the conflict and recommend how to resolve it.
- Do not start implementation from scouting.
