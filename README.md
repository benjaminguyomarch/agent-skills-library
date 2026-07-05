# agent-skills-library

**A personal library of Agent Skills, portable across AI coding agents.**

<!-- Bibliothèque personnelle de skills, portable entre différents agents IA -->

Skills are packaged instructions that extend an AI agent's capabilities. Each skill is a
self-contained folder with a `SKILL.md` file that the agent loads on demand. This repo follows
the [Agent Skills](https://agentskills.io) specification, so its content works with any agent
that accepts instruction files — Claude Code, Cursor, Gemini CLI, Copilot, OpenCode, and more.

## Why this structure is portable

<!-- Le contenu de valeur (skills, règles) reste en Markdown standard.
     Les fichiers spécifiques à un outil ne sont qu'une fine couche d'adaptation. -->

| File / folder | Portable? | Notes |
| --- | --- | --- |
| `skills/*/SKILL.md` | ✅ Universal | Plain Markdown, read by any agent |
| `AGENTS.md` | ✅ Multi-tool standard | Read natively by Cursor, OpenCode, Copilot… |
| `CLAUDE.md` | ⚠️ Claude Code only | Thin adapter layer; mirror as `GEMINI.md` etc. |
| `hooks/` | ❌ Tool-specific | Claude Code lifecycle scripts (see `hooks/README.md`) |

The rule: your real value (skills, conventions) stays in standard Markdown. Tool-specific files
are thin adapters that point to that content — never unique content. Switch agents tomorrow and
you only rewrite the adapter, not your library.

## Structure

```
agent-skills-library/
├── README.md                  # this file
├── AGENTS.md                  # cross-agent guidance (the portable brain)
├── CLAUDE.md                  # Claude Code adapter (short, points to AGENTS.md)
├── CONTRIBUTING.md            # checklist before adding a skill
├── template/
│   └── SKILL.md               # starting point for every new skill
├── skills/                    # skills maison
│   ├── example-skill/         # reference skill in the correct format
│   ├── seo-audit/             # audit SEO post-déploiement (PageSpeed, pa11y, headers)
│   ├── visual-diagram/        # flowcharts & mind maps Whimsical
│   ├── site-vitrine-pipeline/ # pipeline 16 étapes site vitrine statique (ex-morgane)
│   ├── design-tokens-setup/   # tokens 3 niveaux → Figma/Tailwind/Style Dictionary/Webflow
│   ├── prd-writer/            # PRD + doc architecture technique (format ds2)
│   ├── css-architecture/      # CSS modulaire + Web Components natifs (ex-portfolionew2)
│   ├── emil-design-eng/       # vendoré (MIT) — UI polish & animation, philosophie Emil Kowalski
│   ├── review-animations/     # vendoré (MIT) — revue stricte d'animations, invocation explicite
│   └── animation-vocabulary/  # vendoré (MIT) — glossaire d'effets d'animation
├── external/                  # librairies tierces clonées (lecture/inspiration)
│   ├── anthropics-skills/     # officiel : frontend-design, theme-factory, docx/pdf/pptx/xlsx…
│   └── superpowers/           # méthodologie : brainstorm→plan→TDD→debug (installer en plugin)
├── install-user-skills.sh     # copie les indispensables dans ~/.claude/skills
├── docs/
│   └── skill-anatomy.md       # how to write a good skill
└── hooks/
    └── README.md              # when/how to add hooks (no active hook)
```

## Quick start

**Claude Code**

```
/plugin marketplace add benjaminguyomarch/agent-skills-library
```

**Cursor** — copy a `SKILL.md` into `.cursor/rules/`, or reference the `skills/` directory.

**Gemini CLI** — add skills to `GEMINI.md`, or `gemini skills install` from this repo.

**Any other agent** — skills are plain Markdown; paste the relevant `SKILL.md` into context.

## Create a new skill

```bash
cp -r template/ skills/my-new-skill/
# then edit skills/my-new-skill/SKILL.md following docs/skill-anatomy.md
```

## References

- [Agent Skills Specification](https://agentskills.io)
- [Anthropic — Skill authoring best practices](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices)
- [anthropics/skills](https://github.com/anthropics/skills)
