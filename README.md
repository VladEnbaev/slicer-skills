# Jarvis Skills

Jarvis Skills is a platform-neutral workflow for working with AI coding agents as senior technical copilots, not command executors.

The goal is to let an agent move quickly through real engineering work while keeping important technical decisions explicit and under human control. The agent should understand context, compare routes, challenge weak assumptions, and implement agreed changes without silently choosing risky architecture, ownership boundaries, or test strategy.

This repository currently packages the workflow as Codex-compatible skills. The workflow itself is intended to be language-, framework-, and codebase-agnostic.

## Workflow

```text
scouting -> decision gates -> slices -> verification -> next slice
```

Jarvis work starts with scouting: reading the relevant code, docs, tests, configs, logs, and existing patterns before asking avoidable questions or proposing changes.

When there are multiple plausible approaches, the agent opens a decision gate: it states what it found, presents realistic options, explains tradeoffs, and recommends one path.

Approved work is split into slices. Each slice has a goal, boundaries, a test decision, verification strategy, and a checkpoint before the next slice. The point is not bureaucracy. The point is to keep large changes reviewable and prevent hidden scope expansion.

Verification is evidence-based. A slice is not done because the code was edited; it is done when the agreed checks pass and remaining risk is stated clearly.

## Why

AI agents can produce a lot of code quickly. In production code, the bigger risk is often not speed or volume. It is writing the wrong code in the wrong place with the wrong responsibility boundary and no clear understanding of the consequences.

Jarvis Skills is designed to avoid common agent failure modes:

- starting implementation before understanding the system;
- asking questions that the repository could answer;
- making architectural decisions implicitly;
- turning a refactor into one large hard-to-review diff;
- treating big spec files as a substitute for live engineering judgment;
- writing tests mechanically or skipping them where they matter;
- fixing bugs from guesses instead of root cause;
- leaving the human as a reviewer of a large surprise diff instead of the owner of the important decisions.

## Skills

- `jarvis-copilot`: overall workflow for non-trivial features, refactors, investigations, and important code changes.
- `jarvis-scouting`: read-first context scouting before recommendations, plans, or changes.
- `jarvis-decision-gates`: options, recommendations, and approval checkpoints for meaningful engineering choices.
- `jarvis-slices`: implementation slices with explicit boundaries, test decisions, verification, and checkpoints.
- `jarvis-debugging`: evidence-based debugging where root cause must be established before fixing.

## Installation for Codex

Run:

```bash
./scripts/install.sh
```

The script links every skill from `skills/*` into `${CODEX_HOME:-$HOME/.codex}/skills`.

If a Codex session was already running, start a new session so the skill list is refreshed.

## Usage

For non-trivial engineering work, start with:

```text
$jarvis-copilot
```

For bugs, regressions, failing tests, CI failures, flaky behavior, or broken integrations, start with:

```text
$jarvis-debugging
```

You can also invoke the narrower skills directly when the current phase is already clear:

```text
$jarvis-scouting
$jarvis-decision-gates
$jarvis-slices
```

## Project Rules

Jarvis Skills should stay universal. Do not add rules tied to a specific company, repository, product, programming language, framework, runtime, or deployment stack.

Keep each skill compact and action-oriented. If a workflow rule belongs everywhere, put it in `jarvis-copilot`; do not duplicate it across all skills.
