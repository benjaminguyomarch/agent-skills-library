# Contributing

<!-- Checklist courte avant d'ajouter un skill au dépôt. -->

Before adding or changing a skill, run through this list. Details live in
[`docs/skill-anatomy.md`](./docs/skill-anatomy.md).

## Before you start

- [ ] No existing skill already covers this. If one is close, extend it instead of duplicating.
- [ ] The task is a repeatable process, not a one-off — skills are reusable techniques.

## Writing the skill

- [ ] Started from `template/SKILL.md`.
- [ ] Folder is `kebab-case` and `name` in the frontmatter matches it exactly.
- [ ] `description` is third person, states what + when, and includes trigger terms.
- [ ] Body has all five sections: Overview, When to Use, Process, Common Mistakes, Verification.
- [ ] Rules explain their reasoning instead of stacking ALL-CAPS MUST/NEVER.
- [ ] `SKILL.md` is under ~500 lines; long material moved to a linked sibling file.

## Before committing

- [ ] Frontmatter YAML is valid (`name` + `description` present).
- [ ] You watched a fresh agent actually use the skill on a real task.
- [ ] Added the skill to the Intent → skill table in [`AGENTS.md`](./AGENTS.md).

## Commit convention

```
skill(<skill-name>): <short action>
```

Example: `skill(example-skill): initial version`. One commit per skill created or changed.
