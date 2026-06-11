# CLAUDE.md

<!-- Adaptateur Claude Code : court, il délègue à AGENTS.md. -->

This is the Claude Code adapter for this repository. The portable source of truth is
[`AGENTS.md`](./AGENTS.md) — read it first. This file only adds Claude Code specifics.

## Read first

- [`AGENTS.md`](./AGENTS.md) — execution model, intent→skill mapping, conventions.
- [`docs/skill-anatomy.md`](./docs/skill-anatomy.md) — how to write a good skill.
- [`CONTRIBUTING.md`](./CONTRIBUTING.md) — checklist before adding a skill.

## Project structure

```
skills/     → Core skills (one SKILL.md per folder)
template/   → Starting point for new skills
docs/       → Authoring guide
hooks/      → Claude Code lifecycle hooks (none active; see hooks/README.md)
```

## Boundaries

<!-- Règles avec leur justification, pour que Claude généralise aux cas non prévus. -->

- **Always** start a new skill from `template/SKILL.md`, so every skill shares the same
  structure and stays discoverable.
- **Always** write the `description` in third person and include trigger phrases — it is injected
  into the system prompt and is the only signal used to select the skill.
- **Never** add a skill that is vague advice instead of an actionable process; a skill the agent
  cannot act on just spends context for nothing.
- **Never** duplicate content between skills — reference the other skill, because two copies drift
  apart and the agent can't tell which is current.

## Validate

Before committing a skill, check that its `SKILL.md` has valid YAML frontmatter with both `name`
and `description`, and that `name` matches the folder name.
