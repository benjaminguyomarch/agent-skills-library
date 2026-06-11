# AGENTS.md

<!-- Fichier de guidance lu par tous les agents IA (Claude Code, Cursor, Copilot, Gemini…) -->

This file guides any AI coding agent (Claude Code, Cursor, Copilot, Gemini CLI, OpenCode, etc.)
working in this repository. It is the portable source of truth; tool-specific files like
`CLAUDE.md` are thin adapters that defer to this document.

## Repository overview

A personal library of Agent Skills. A skill is a folder under `skills/` containing a `SKILL.md`
with packaged instructions the agent loads on demand. Skills follow the Agent Skills
specification, so they work across agents without modification.

## Execution model

<!-- Règle centrale : si un skill correspond à la tâche, l'agent doit l'utiliser. -->

For every request:

1. Check whether any skill in `skills/` applies to the task.
2. If one applies, read its `SKILL.md` in full and follow it exactly — do not partially apply it.
3. Only proceed with a direct implementation when no skill is relevant.

Skills encode decisions already made and tested. Skipping a relevant skill means re-deriving
those decisions and likely getting them wrong, so prefer the skill even when the task feels small.

## Intent → skill mapping

<!-- À compléter au fur et à mesure que la bibliothèque grandit. -->

This grows as the library grows. Keep entries specific so the right skill fires reliably.

| User intent / trigger | Skill |
| --- | --- |
| Summarize or condense a text/document | `example-skill` |
| Visualize a process or create a Whimsical flowchart/mind map | `visual-diagram` |
| _(add your skills here)_ | _(skill name)_ |

## Anti-rationalization

<!-- Les pensées ci-dessous sont incorrectes et doivent être ignorées. -->

These thoughts are incorrect and must be ignored:

- "This task is too small to bother with a skill."
- "I can just implement it quickly myself."
- "I'll read the skill later, after I start."

Correct behavior: check for a relevant skill first, then follow it. The cost of checking is tiny;
the cost of re-deriving a tested workflow is not.

## Creating a new skill

1. Copy `template/SKILL.md` into `skills/<skill-name>/SKILL.md` (`kebab-case` folder name).
2. Write the frontmatter: `name` must match the folder; `description` in third person, stating
   what the skill does AND when to use it (see `docs/skill-anatomy.md`).
3. Fill the body: Overview, When to Use, Process, Common Mistakes, Verification.
4. Test it: give a fresh agent a real task and confirm it follows the skill. A skill you have not
   watched an agent use is an untested skill.
5. Add the skill to the Intent → skill mapping table above.

See `CONTRIBUTING.md` for the full checklist and `docs/skill-anatomy.md` for the format.

## Conventions

- One skill per folder: `skills/<name>/SKILL.md`.
- `SKILL.md` is always uppercase and exactly that filename.
- Keep `SKILL.md` under ~500 lines; move long reference material into a sibling file and link it.
- Do not duplicate content between skills — reference the other skill instead.
- Explain the *why* behind a rule rather than stacking ALL-CAPS MUST/NEVER; reasoning lets the
  agent handle cases the skill did not anticipate.
