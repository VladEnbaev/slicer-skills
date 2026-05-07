# Slicer Skills

Slicer Skills is a platform-neutral workflow for working with AI coding agents as senior technical copilots, not command executors.

The goal is to let an agent move quickly through real engineering work while keeping important technical decisions explicit and under human control. The agent should understand context, compare routes, challenge weak assumptions, and implement agreed changes without silently choosing risky architecture, ownership boundaries, or test strategy.

This repository currently packages the workflow as Codex-compatible skills. The workflow itself is intended to be language-, framework-, and codebase-agnostic.

## Workflow

```text
scouting -> checkpoints -> slice planning -> slice execution -> verification -> next slice
```

Slicer work starts with scouting: reading the relevant code, docs, tests, configs, logs, and existing patterns before asking avoidable questions or proposing changes.

When there are multiple plausible approaches, the agent opens a checkpoint: it states what it found, presents realistic options, explains tradeoffs, and recommends one path.

Approved work is planned into slices. Each slice has a goal, boundaries, a test decision, verification strategy, and a checkpoint before the next slice. The point is not bureaucracy. The point is to keep large changes reviewable and prevent hidden scope expansion.

Execution happens one approved slice or sub-slice at a time. A slice is not done because the code was edited; it is done when the agreed checks pass and remaining risk is stated clearly.

## Why

AI agents can produce a lot of code quickly. In production code, the bigger risk is often not speed or volume. It is writing the wrong code in the wrong place with the wrong responsibility boundary and no clear understanding of the consequences.

Slicer Skills is designed to avoid common agent failure modes:

- starting implementation before understanding the system;
- asking questions that the repository could answer;
- making architectural decisions implicitly;
- turning a refactor into one large hard-to-review diff;
- treating big spec files as a substitute for live engineering judgment;
- writing tests mechanically or skipping them where they matter;
- fixing bugs from guesses instead of root cause;
- leaving the human as a reviewer of a large surprise diff instead of the owner of the important decisions.

## Skills

- `slicer-copilot`: overall workflow for non-trivial features, refactors, investigations, and important code changes.
- `slicer-scouting`: read-first context scouting before recommendations, plans, or changes.
- `slicer-checkpoints`: options, recommendations, and approval checkpoints for meaningful engineering choices.
- `slicer-planning`: slice maps with explicit boundaries, test decisions, verification strategies, and checkpoints.
- `slicer-execution`: execution of one approved slice or sub-slice with verification and review.
- `slicer-debugging`: evidence-based debugging where root cause must be established before fixing.

## Installation for Codex

Install and enable this repository as a Codex plugin through its `.codex-plugin/plugin.json`.

Do not link `skills/*` into `${CODEX_HOME:-$HOME/.codex}/skills`; these skills are intended to be exposed only through the plugin. If a Codex session was already running, start a new session so the skill list is refreshed.

## Usage

For non-trivial engineering work, start with:

```text
$slicer-copilot
```

For bugs, regressions, failing tests, CI failures, flaky behavior, or broken integrations, start with:

```text
$slicer-debugging
```

You can also invoke the narrower skills directly when the current phase is already clear:

```text
$slicer-scouting
$slicer-checkpoints
$slicer-planning
$slicer-execution
```

## Project Rules

Slicer Skills should stay universal. Do not add rules tied to a specific company, repository, product, programming language, framework, runtime, or deployment stack.

Keep each skill compact and action-oriented. If a workflow rule belongs everywhere, put it in `slicer-copilot`; do not duplicate it across all skills.
