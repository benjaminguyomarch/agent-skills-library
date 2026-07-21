---
name: nouveau-projet
description: >
  Scaffolds a new client or personal project into projets/<slug>/ from one of the four project
  templates in ressources/ (template-projet-react, template-projet-web, template-workflow,
  template-produit-no-code). Asks every setup question upfront (project name, which template,
  optional context folder, optional reference folder) before creating anything, copies the chosen
  template while excluding leaked build artifacts, resets its memory files to empty, synthesizes
  the context/reference folders into CLAUDE.md/brief-metier.md/docs/, auto-copies the template's
  recommended skills, and runs git init + setup.sh. Use when the user says "nouveau projet",
  "démarrer un projet", "scaffolder un projet", "créer un projet client", or asks to set up a new
  project from a template.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Nouveau projet

Turns one of the four templates in `ressources/` into a real, personalized project under
`projets/<slug>/` — copy, rename, memory reset, recommended-skill install, and git/setup all in
one pass, instead of the manual multi-step README each template ships with today.

## When to use this skill

- The user wants to start a new client or personal project ("nouveau projet", "démarrer un
  projet", "scaffolder un projet", "créer un projet client").
- The user names a template directly ("un projet React", "un site vitrine", "un workflow n8n",
  "un produit no-code") or describes what they're building and needs help picking one.
- The user has been working in a scratch folder (notes, a brief, exported no-code config) and
  wants that turned into a proper project — that folder becomes the "dossier de contexte" input.

Do **not** use this skill to add a project *inside* an existing scaffolded project (e.g. wiring
Supabase into an already-running app) — that's `supabase-sync` or a direct edit, not a new
`projets/` folder. Do not use it to restructure or "fix" an existing project's `.claude/`/`docs/`
layout after the fact — this skill only creates new projects, never migrates existing ones.

## Process

### Step 1 — Ask everything upfront, before creating anything

Gather all four inputs before touching the filesystem:

1. **Project name / slug** (lowercase, hyphens, no accents — this becomes `projets/<slug>/`).
2. **Which template**, using this selection rubric if the user hasn't already named one directly:
   - Static showcase site, no real backend → `template-projet-web`
   - App with real server state / auth / database → `template-projet-react`
   - Deliverable is one or more n8n automations → `template-workflow`
   - No-code product (app builder + data + automation trio) → `template-produit-no-code`
3. **Optional "dossier de contexte"** — a folder the user was working in before invoking the
   skill, to personalize the generated project (a brief, notes, an existing no-code export).
4. **Optional "dossier de référence"** — onboarding/starter documentation to file into `docs/`.

This matters because the pipeline that follows has real side effects (file copies, `git init`,
`setup.sh` which may install dependencies) — if the template choice changes after step 3 already
ran, unwinding a half-applied scaffold cleanly is expensive. Asking everything first means every
later step runs exactly once, on final answers.

### Step 2 — Safety check before any write

Confirm `projets/<slug>/` does not already exist. If it does, **stop and ask** how to proceed —
never merge or overwrite silently. A silent merge would clobber a real project's `CLAUDE.md` or
`.claude/memory/` history with template stubs, with no clean undo if it hasn't been committed
recently.

### Step 3 — Copy the template, excluding leaked artifacts

Copy `ressources/<template>/` into `projets/<slug>/`, explicitly excluding: `.git/`,
`node_modules/`, `.next/`, `.DS_Store`, any real `.env`, `.claude/settings.local.json`. This
matters concretely for `template-projet-react`: it has been run at least once and carries a real
`.git/`, `.next/` build cache, and `node_modules/` — copying `.git/` would corrupt the new
project's own identity/history, and the other two are stale cache that `setup.sh` regenerates
fresh.

### Step 4 — Reset `.claude/memory/*.md` to genuinely empty

Strip every filled entry from `BLOCKERS.md`, `DECISIONS.md`, `JOURNAL.md`, `LEARNINGS.md`, keeping
only each file's header/legend + one blank numbered TODO stub. This includes entries that aren't
explicitly labeled "exemple à supprimer" — `template-projet-react`'s `DEC-000`/`DEC-001` and
`template-produit-no-code`'s `DEC-000`/`BLK-000`/`LRN-000`/`LRN-001` are real-sounding but are
about *the template's own* design choices, not the new project's. A new project's memory should
start from zero, not inherit the template author's decision history.

### Step 5 — Read and synthesize the context/reference folders, if provided

Read the content of both folders and use judgment to pre-fill `CLAUDE.md`'s `<!-- TODO -->`
sections and `docs/00_context/brief-metier.md`'s fields with synthesized prose. File the
reference folder's material into the correct `docs/` subfolder per the chosen template's
taxonomy (not always the same slot — e.g. a data schema goes in `20_data`, a screen mockup in
`30_ecrans`/`40_ui`). Copy a source file as-is only when it's worth preserving verbatim (a PDF
brief, an image, an existing no-code export/JSON) — never for markdown notes that should instead
be incorporated into prose. A raw-copy "source/" dump creates a second, competing source of truth
that will drift from the polished docs over time — exactly the "one source of truth per datum"
rule already stated in every template's `CLAUDE.md`.

### Step 6 — Auto-copy the template's recommended skills

Read the copied project's own `.claude/skills/README.md`. Extract only the **backtick-fenced
names that resolve to a real folder** in `ressources/agent-skills-library/skills/<name>/`, and
copy each one into `projets/<slug>/.claude/skills/<name>/`. Some of these READMEs (e.g.
`template-workflow`'s) also list plain-prose ideas for skills that don't exist yet — skip those,
report them as skipped, and never fabricate a folder for them.

### Step 7 — Rename project-identifying strings

Update `package.json`'s `name` field (where present — `template-produit-no-code` and
`template-workflow` may or may not have one) to the slug. Leave any `CLAUDE.md`/`README.md`
`<!-- TODO -->` marker that step 5 couldn't confidently fill — don't silently delete a marker just
because it's still open.

### Step 8 — Run `git init` and `bash setup.sh`

Initialize the repo and run the template's setup script. Do **not** create a commit — leave the
first commit to the user after they've reviewed the synthesized content, consistent with never
committing without explicit request.

### Step 9 — Report the remaining manual steps

List what still needs a live Claude Code session inside the new folder and can't be done by this
skill: running `/init` (which should merge with the pre-filled `CLAUDE.md` rather than overwrite
it), deleting the template's own `README.md`, `vercel link`/Netlify link if the chosen template
needs one, and any `<!-- TODO -->` markers left open.

## Common mistakes

- Copying `.git/`, `node_modules/`, or `.next/` along with the template. Excuse: "faster than
  reinstalling, it already works." Correct behavior: always exclude them and let `setup.sh`
  regenerate what's needed — a leaked `.git/` corrupts the new project's own history.
- Treating the "dossier de référence" as a raw dump instead of synthesizing it into `docs/`.
  Excuse: "safer to keep everything, I don't want to lose information." Correct behavior: read
  and file it into the right subfolder — a raw copy becomes a second, drifting source of truth.
- Skipping the "does `projets/<slug>` already exist" check, or merging into it anyway. Excuse:
  "the copy will just merge harmlessly." Correct behavior: hard-stop and ask — a merge can
  silently overwrite real `DECISIONS.md`/`JOURNAL.md` history with template stubs.
- Copying every bullet listed in a `.claude/skills/README.md`, including plain-prose ideas that
  aren't real skill folders. Excuse: "the README told me to copy what it lists." Correct
  behavior: only copy backtick-fenced names that resolve to a real folder; report the rest as
  skipped.
- Starting the template copy before every question from Step 1 is answered. Excuse: "I'll start
  copying while waiting to hear about the reference folder." Correct behavior: gather all inputs
  first — a template choice that changes mid-way leaves an inconsistent partial scaffold.

## Verification

The task is done only when:

- [ ] `projets/<slug>/` did not exist before this run (confirmed via the Step 2 check, not
      assumed).
- [ ] No `.git/`, `node_modules/`, `.next/`, or real `.env` is present beyond what the fresh
      `git init`/`setup.sh` in Step 8 created.
- [ ] `.claude/memory/*.md` contain no filled decision/blocker/learning entries — header/legend +
      blank stub only.
- [ ] Every backtick-fenced, resolvable skill name in the project's `.claude/skills/README.md` has
      a matching `.claude/skills/<name>/SKILL.md`.
- [ ] `package.json`'s `name` (if present) matches the slug.
- [ ] `git log`/`git status` shows a real repo initialized, and `setup.sh` ran without error.
- [ ] `CLAUDE.md`/`brief-metier.md` TODOs are either filled with synthesized content from the
      context/reference folders or intentionally left open.
- [ ] The final report to the user lists every remaining manual step (`/init`, delete README,
      vercel/netlify link if relevant).
