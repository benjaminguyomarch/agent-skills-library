---
name: audit-mes-skills
description: >
  Audits every skill in the workspace by cross-referencing five sources of truth — declared
  (README.md's tree + AGENTS.md's Intent→skill table), on disk (skills/*/SKILL.md in
  agent-skills-library), committed (git status/log of agent-skills-library), copied (real
  .claude/skills/<name>/ folders under every projets/*/ and ressources/template-*/), and globally
  installed (~/.claude/skills/) — to surface orphaned skills, undeclared skills, stale/diverged
  copies, missing routing entries, and a per-project skill-usage matrix. Produces a grid
  (description, spécificité, fraîcheur, taille, duplication, placement, scripts) plus a concrete
  fix list. Use when the user says "audit mes skills", "vérifier les skills", "skills obsolètes",
  "des skills orphelins", before creating a new skill (per CONTRIBUTING.md's "no existing skill
  already covers this" check), or periodically to catch drift between the library and reality.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Audit mes skills

Cross-checks five independent records of "what skills exist" — a project's `.claude/skills/`
folder can silently diverge from the library, a README's skill list can go stale the moment a
skill is added or removed, and nothing today compares them. This skill runs that comparison and
turns five separate, un-synced sources into one accurate picture plus a fix list.

## When to use this skill

- The user asks to audit, inventory, or clean up skills — "audit mes skills", "vérifier les
  skills", "skills obsolètes", "des skills orphelins ou dupliqués".
- Before creating a new skill, to check `CONTRIBUTING.md`'s first checklist item ("No existing
  skill already covers this") against the *actual* current inventory, not memory of it.
- After a skill is added, renamed, or removed, to check whether `README.md`/`AGENTS.md`/the global
  install (`~/.claude/skills/`) still reflect reality.
- Periodically, since nothing else re-checks this — drift only ever gets caught by accident
  otherwise (see Common mistakes).

Do **not** use this skill to review a single skill's *content quality* (clarity of trigger phrases,
whether the Process steps are actionable) — that's a manual read against
`docs/skill-anatomy.md`/`CONTRIBUTING.md`, not a cross-referencing task. This skill is about
*inventory consistency* across sources, not prose quality.

## Process

### Step 1 — Inventory the library on disk

List every folder under `ressources/agent-skills-library/skills/`. For each: read the frontmatter
(`name`, `description` — flag if either is missing or if `name` doesn't match the folder name),
count `SKILL.md`'s lines, get the last-modified date, and note any sibling files (`LICENSE`,
`reference/`, example configs, `scripts/`). This is the baseline everything else gets compared to.

### Step 2 — Compare against what's declared

Read `README.md`'s `skills/` tree and `AGENTS.md`'s "Intent → skill mapping" table. For every skill
found in Step 1: is it listed in both? For every skill listed in either doc: does the folder still
exist? A skill present on disk but undeclared is invisible to routing (the description alone
decides triggering, so an undeclared skill still fires, but a human scanning the docs won't know
it exists). A skill declared but deleted from disk is a dangling reference that will confuse the
next reader.

### Step 3 — Compare against git state

If `agent-skills-library` is a git repository (check with `git rev-parse --is-inside-work-tree`),
run `git status --short`. Flag any skill folder that's untracked (never committed — invisible to
anyone who clones/pulls the repo) or whose deletion is unstaged (still declared as removed in
Step 2 territory but not actually finalized in history). This step is skipped, not failed, if the
folder isn't a git repo.

### Step 4 — Compare against real copies in projects and templates

For every `projets/*/.claude/skills/` and `ressources/template-*/.claude/skills/`: list the
**actual skill subfolders** present (containing a `SKILL.md`), not the recommendations written in
that directory's own `README.md` — a README can recommend a skill that was never actually copied,
and a skill can be copied without the README ever having mentioned it (both happen in practice).
For every real copy found, `diff` it against the Step 1 source in the library: identical, or
diverged? A diverged copy means someone edited the local copy directly instead of the library
source — worth flagging even if intentional, since it's the kind of fork that silently drifts
further with each edit. Build the per-project matrix here: one row per project/template, one
column per skill, marking real copies.

### Step 5 — Compare against the global install

List `~/.claude/skills/`. Compare each installed skill's content against the Step 1 library source
(same diff logic as Step 4) and its last-modified date against the library's. Flag: skills
installed but removed from the library since (dangling), skills in the library's
`install-user-skills.sh` list that aren't actually installed, and — separately — check whether
`install-user-skills.sh`'s own hardcoded skill list still matches what the library recommends
installing globally (it's a plain shell loop over names, so it drifts exactly like a README does).

### Step 6 — Detect duplication and orphans, with judgment

Two skills are a **real duplicate** only if they'd both plausibly fire on the same request and do
overlapping work — not just because they share a topic word. Before flagging anything as a
duplicate, check `AGENTS.md` for an existing explanation: this library already documents at least
one deliberate multi-skill pipeline (design tokens: `collections-variables-setup` →
`design-tokens-setup` → generated CSS consumed by `css-architecture`) and a deliberately
un-merged vendored cluster (`emil-design-eng`/`review-animations`/`animation-vocabulary`, kept
separate because each has a distinct trigger and rewriting them would violate the "don't touch
vendored content" rule). Only flag what isn't already accounted for.

An **orphan** is a skill on disk that is (a) never listed as a recommendation in any project or
template `.claude/skills/README.md`, and (b) never actually copied into any project (Step 4). Some
orphans are orphans *by design* — a skill meant to be installed globally rather than per-project
(check the global-install list from Step 5 before flagging), or the format-reference skeleton skill
(`example-skill`), or a skill that operates at the workspace root rather than inside any project
(like `nouveau-projet` itself). Only flag what has no such explanation.

### Step 7 — Report

Produce: (1) the grid the user asked for — one row per skill, columns *description* (present/clear
from Step 1), *spécificité* (project-specific vs. broadly reusable — a judgment call, state your
reasoning), *fraîcheur* (last-modified date + how stale relative to the rest of the library),
*taille* (line count, flagged only if over ~500 lines **and** not a documented vendored exception),
*duplication* (from Step 6), *placement* (declared/disk/git/copied/installed — which of the 5
sources have it, from Steps 1-5), *scripts* (sibling files present, from Step 1); (2) the orphan
list with the "by design" ones explicitly separated from real candidates for review; (3) the
per-project skill matrix from Step 4; (4) a short, concrete fix list (e.g. "commit skill X", "add
row to AGENTS.md for Y", "README lists Z which no longer exists on disk") — not vague advice, each
item actionable in one sentence.

## Common mistakes

- Treating a skill *mentioned* in a `.claude/skills/README.md`'s prose as if it were actually
  copied. Excuse: "the README says it's used here." Correct behavior: check for the real
  `.claude/skills/<name>/SKILL.md` folder — recommendation and adoption are different facts, and
  conflating them is exactly how `stationbest`'s README ended up recommending 3 skills that were
  never actually copied in.
- Flagging a documented exception as a violation — e.g. a vendored skill over 500 lines, or two
  skills that are actually a deliberate pipeline. Excuse: "the rule says under 500 lines / no
  overlapping skills." Correct behavior: read `AGENTS.md` first for existing explanations before
  flagging anything as a problem — the rule has documented exceptions, and re-flagging them wastes
  the reader's trust in the rest of the report.
- Skipping the global install (`~/.claude/skills/`) because it's outside the library repo. Excuse:
  "that's not really part of the library." Correct behavior: it's one of the five sources by
  design — a skill can look perfectly healthy in the library while being stale or entirely absent
  where it's actually invoked from in daily use.
- Reporting "no drift found" between a copy and its source without actually running a diff.
  Excuse: "they were probably copied together, should still match." Correct behavior: diff every
  real copy found in Steps 4-5 against the library source — a copy that diverged silently is the
  exact failure mode this skill exists to catch.

## Verification

The task is done only when:

- [ ] Every skill folder under `agent-skills-library/skills/` appears as a row in the final grid —
      none silently skipped.
- [ ] Every claim of "undeclared", "untracked", "orphaned", or "diverged" is backed by a concrete
      check (a file existence test, a `diff` output, a `git status` line) — not an assumption.
- [ ] The orphan list separates "by design" orphans from real candidates, each with its reasoning
      stated in one sentence.
- [ ] The per-project matrix covers every `projets/*/.claude/skills/` and every
      `ressources/template-*/.claude/skills/` — none silently skipped.
- [ ] The fix list contains only concrete, one-sentence-actionable items — no vague "consider
      reviewing X" entries.
