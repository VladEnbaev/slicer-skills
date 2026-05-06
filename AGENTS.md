# Jarvis Skills Agent Guide

This repository contains reusable Codex skills. Keep them universal: do not add project-specific, company-specific, language-specific, framework-specific, or product-specific rules.

## Principles

- Keep each `SKILL.md` compact and action-oriented.
- Put trigger conditions in frontmatter `description`.
- Do not create large spec files or process documents unless they are needed by the skill itself.
- Prefer clear behavioral rules over long examples.
- Preserve the core model: senior copilot, read-first scouting, decision gates, agreed slices, evidence-based debugging.
- If an external planning mode requires a complete plan, express that plan through Jarvis slice boundaries instead of one monolithic execution plan.

## Editing Skills

- Use lowercase hyphen-case skill names.
- Keep `agents/openai.yaml` in sync with each `SKILL.md`.
- Do not duplicate the same workflow across multiple skills. If behavior belongs everywhere, put it in `jarvis-copilot`.
- When changing `jarvis-slices`, preserve the rule that each slice has a test decision and verification strategy.
- When changing `jarvis-debugging`, preserve the rule: no fix before root cause.

## Validation

After edits, run:

```bash
./scripts/validate.sh
```

If validation cannot run because local Codex skill tooling is unavailable, manually check every `SKILL.md` has valid YAML frontmatter with `name` and `description`.
