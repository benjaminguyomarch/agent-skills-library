---
name: supabase-sync
description: >
  Provisions or re-links a Supabase project non-interactively via the Supabase CLI and personal
  access token, applies an existing supabase/schema.sql as a migration, wires the resulting
  project URL and keys into a gitignored .env, and fixes any import script that references
  undeclared npm scripts or missing docs. Use when a project has a supabase/ folder or a
  Supabase import script that isn't wired up, when the user asks to "brancher Supabase",
  "créer un projet Supabase", or wants a database backend instead of (or alongside) a static
  site. Do not use this skill to design a schema from scratch — it assumes schema.sql already
  exists or is written first.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Supabase Sync

Connects a project's local Supabase artifacts (`schema.sql`, an import script) to a real,
running Supabase project — fully via CLI, without ever requiring an interactive OAuth login —
and leaves behind the wiring (env vars, npm script, docs, decision record) so the integration
doesn't rot into an orphaned script nobody can run.

## When to use this skill

- A repo contains `supabase/schema.sql` and/or a script that calls the Supabase REST/Admin API,
  but there is no real Supabase project behind it (no `.env`, no project ref anywhere).
- The user asks to "créer un projet Supabase", "brancher Supabase", or wants a database backend
  added to a project that was previously static-only.
- An existing Supabase integration is broken: the import script references an npm command or a
  doc file that doesn't exist, or nobody remembers why Supabase is in the repo at all.

Do **not** use this skill to invent a schema — if `schema.sql` doesn't exist yet, design and
write it first (with the user, based on the actual data shape), then run this skill to provision
the project and wire it up.

## Process

### Step 1 — Confirm the access token, don't try to log in interactively

Project creation belongs to a Supabase account; the CLI's normal `supabase login` opens a browser
OAuth flow that an agent cannot complete on the user's behalf. Instead, ask the user to generate a
**personal access token** at `supabase.com/dashboard/account/tokens` and export it themselves:
`export SUPABASE_ACCESS_TOKEN=sbp_...`. Never ask the user to paste the token into the
conversation — a token in chat history is a leaked credential. Verify it's present with
`supabase projects list` (fails cleanly if unset) before doing anything else. This matters because
skipping straight to `supabase projects create` produces a confusing interactive prompt or a
silent failure that looks like a bug in the skill rather than a missing prerequisite.

### Step 2 — Install the CLI if needed, then create or link the project

`brew install supabase/tap/supabase` if `which supabase` is empty. List orgs
(`supabase orgs list`) to get an org id, then create the project non-interactively:
`supabase projects create <name> --org-id <id> --db-password <generated> --region <closest>`.
If a project already exists for this repo (ask the user, don't guess), use
`supabase link --project-ref <ref>` instead of creating a duplicate.

### Step 3 — Apply schema.sql as a migration, not an ad-hoc script

Copy the existing `supabase/schema.sql` into `supabase/migrations/<timestamp>_init.sql` and run
`supabase db push`. Applying it as a tracked migration (rather than pasting SQL into the dashboard
or running it once by hand) means the next re-provision or teammate can replay the exact same
schema — the whole point of using a CLI-driven workflow instead of clicking through a dashboard.

### Step 4 — Retrieve keys and write a gitignored .env

`supabase projects api-keys --project-ref <ref>` gives the URL and anon/service keys. Write them
to a new `.env` at the project root. Before writing it, check `.gitignore` already excludes `.env`
— if it doesn't, add it **first**, in its own commit if git history matters, because a secret
committed even briefly stays in history after the fact.

### Step 5 — Fix the import script and register its npm command

Any script that calls the Supabase API should read credentials from `process.env` (populated by
`.env`, e.g. via `node --env-file=.env`) and should be reachable by the exact npm command its own
usage comment advertises — grep the script for the command it claims to run
(`npm run import:...`) and add that entry to `package.json` if it's missing. An orphaned script
that references a command nobody registered is worse than no script: it looks wired up but silently
never runs.

### Step 6 — Document and record the decision

Write (or update) `docs/90_system/supabase.md`: what the project is for, the env vars required,
the schema, the RLS policy, and when to re-run the import (e.g. after every content re-export).
Then add an entry to the project's decision log (e.g. `.claude/memory/DECISIONS.md` if present)
stating *why* Supabase exists alongside any other data source — which one is authoritative, and
whether the other is a mirror, a future API surface, or something else. A schema.sql sitting in a
repo with no recorded rationale is exactly the kind of debt this skill exists to prevent from
recurring.

## Common mistakes

- Mistake: assuming the agent can create a Supabase account/project with zero user involvement.
  Excuse: "I have Bash, I'll just run the CLI." Correct behavior: stop at Step 1 and ask for the
  access token — there is no account-creation path that doesn't involve the human.
- Mistake: writing keys directly into `package.json`, a script, or a doc "just for now." Correct
  behavior: `.env` only, confirmed gitignored before the file is even created.
- Mistake: leaving the npm script or docs file referenced-but-missing because "the code technically
  works if you set env vars manually." Correct behavior: the script's own usage message is the
  spec — make it true.
- Mistake: skipping the decision-log entry because "it's just infra, not a real decision." Correct
  behavior: if a project already documents its architecture decisions, a new backend is exactly the
  kind of thing that belongs there — future readers (human or agent) need the why, not just the diff.

## Verification

The task is done only when:

- [ ] `supabase projects list` (or `supabase status` for the linked project) shows the project exists.
- [ ] A REST query against the project (e.g. `curl "$SUPABASE_URL/rest/v1/<table>?select=*" -H "apikey: $SUPABASE_ANON_KEY"`) returns the expected rows after running the import script.
- [ ] `git status --short` never shows `.env` as trackable (it's gitignored before creation).
- [ ] The import script's own usage comment names an npm command that actually exists in `package.json` and runs successfully.
- [ ] `docs/90_system/supabase.md` (or equivalent) exists and matches what the script/docs actually reference.
- [ ] A decision-log entry exists explaining why the database exists and which source is authoritative.
