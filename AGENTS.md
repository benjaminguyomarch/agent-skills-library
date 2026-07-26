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
| Audit SEO or compliance post-deployment — "audit SEO", "vérifier le SEO", "conformité SEO", "seo-audit" | `seo-audit` |
| Structure vanilla/lightly-tooled CSS into base/colors/components/layout/sections/effects, or build native Web Components — "architecture CSS", "organiser le CSS", "web components" | `css-architecture` |
| Set up or restructure design tokens (primitives/semantics/components), sync Figma variables with code — "design tokens", "variables Figma", "collections", "theme setup" | `design-tokens-setup` |
| Write a PRD / cahier des charges in French before starting a multi-screen app | `prd-writer` |
| UI polish, component design, or animation/motion decisions — general "make this feel right" front-end craft questions | `emil-design-eng` |
| Review animation/motion code against a strict craft bar (explicit invocation only, does not auto-trigger) | `review-animations` |
| Name an animation effect from a vague description ("what's it called when…") | `animation-vocabulary` |
| Provision/link a Supabase project via CLI + access token, apply schema.sql, wire .env — "brancher Supabase", "créer un projet Supabase", fix an orphaned Supabase import script | `supabase-sync` |
| Fail-fast content JSON validation in a build script, single-source URLs, pre-deploy checklist — "éviter cette erreur au prochain build", "garde-fou avant déploiement" | `project-guard` |
| Building/debugging an n8n Merge, Basic LLM Chain, or Code node — workflow "succeeds" but output is silently wrong/partial | `n8n-gotchas` |
| Scaffold a new client/personal project from a template — "nouveau projet", "démarrer un projet", "scaffolder un projet" | `nouveau-projet` |
| Audit a project's documentation surface (README/CLAUDE.md/rules/memory) against the actual code and fix concrete drift — "mets à jour la doc du projet", "audit de la doc", "les docs sont à jour ?" | `project-docs-sync` |
| Audit the whole skills library for orphans, undeclared/uncommitted/diverged skills, stale global install — "audit mes skills", "vérifier les skills", "skills obsolètes", before creating a new skill | `audit-mes-skills` |
| Build or restructure a static showcase/marketing site for a client — "site vitrine", "nouveau site client", "pipeline morgane" | `site-vitrine-pipeline` |
| _(add your skills here)_ | _(skill name)_ |

`emil-design-eng`, `review-animations` et `animation-vocabulary` sont vendorés tels quels depuis [emilkowalski/skills](https://github.com/emilkowalski/skills) (MIT, non modifiés sauf ajout des métadonnées de source) — ne pas les faire dériver de `template/SKILL.md` ni les réécrire pour coller aux conventions internes (ex. limite de ~500 lignes) : ce sont des skills tiers, pas des skills maison.

## Design tokens — chaîne de source de vérité

<!-- Trois skills touchent les design tokens avec des rôles distincts — ne pas les traiter comme des sources concurrentes. -->

Trois skills manipulent des tokens ; ils forment une chaîne, pas trois sources concurrentes :

1. **`ressources/collections-variables-setup/`** — bibliothèque de primitives réutilisable, indépendante de tout projet (couleurs, spacing, radii en JSON).
2. **`design-tokens-setup`** — à partir des primitives ci-dessus, produit et maintient la source de vérité *par projet* (typiquement `content/theme.json` sur la stack `site-vitrine-pipeline`, ou l'équivalent Style Dictionary/Webflow).
3. **Fichiers générés au build** (`tokens.css`, `variables.css`) — dérivés automatiquement de l'étape 2, jamais édités à la main. `css-architecture` les consomme en lecture pour un projet vanilla CSS ; sur la stack `site-vitrine-pipeline`, c'est `build.js` qui les régénère depuis `theme.json`.

Si un projet a déjà un `theme.json` géré par `design-tokens-setup`, ne pas dupliquer ses valeurs à la main dans `base/variables.css` — le générer depuis la même source.

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

## MCP servers

MCP (Model Context Protocol) servers extend the agent with external tool access. Configuration
lives in `settings.json` — never in markdown files, which are documentation only.

### Configuration locations

| Scope | File |
| --- | --- |
| Global (all projects) | `~/.claude/settings.json` |
| Project-only | `.claude/settings.json` |

### Minimal server entry

```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "npx",
      "args": ["-y", "<npm-package>"],
      "env": { "API_KEY": "${MY_API_KEY}" }
    }
  }
}
```

Prefer `${ENV_VAR}` references over hardcoded secrets. Store actual values in your shell profile or
a `.env` file that is not committed.

### Permissions

Allow specific tools or whole servers under `permissions.allow`:

```json
{
  "permissions": {
    "allow": [
      "mcp__<server-name>__<tool-name>",
      "mcp__<server-name>__*"
    ]
  }
}
```

Use `mcp__<server>__*` wildcards for servers you fully trust. Add granular entries for sensitive
servers (e.g. only allow read tools, not write tools).

### Adding a server for a new skill

When a skill requires an MCP server, add a comment in the skill's `SKILL.md` under a
`## Dependencies` section that lists the server name, the npm package, and the required env vars.
The reader can then add the entry to their `settings.json` without guessing.

### Debugging connections

```bash
# List servers and their current status
claude mcp list

# Check logs for a specific server
claude mcp get <server-name>
```

## Conventions

- One skill per folder: `skills/<name>/SKILL.md`.
- `SKILL.md` is always uppercase and exactly that filename.
- Keep `SKILL.md` under ~500 lines; move long reference material into a sibling file and link it.
- Do not duplicate content between skills — reference the other skill instead.
- Explain the *why* behind a rule rather than stacking ALL-CAPS MUST/NEVER; reasoning lets the
  agent handle cases the skill did not anticipate.
