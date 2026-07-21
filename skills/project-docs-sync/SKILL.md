---
name: project-docs-sync
description: >
  Audits a CLAUDE.md-driven project's documentation surface (README.md, CLAUDE.md's own
  Structure/Commandes sections, .claude/rules/*.md, .claude/memory/{BLOCKERS,DECISIONS,
  LEARNINGS}.md) against the actual code and fixes concrete factual drift — stale
  terminology, renamed features, wrong commands, undocumented conventions, an empty
  BLOCKERS.md that project history suggests shouldn't be. Use when the user says "mets à
  jour la doc du projet", "audit de la doc", "les docs sont à jour ?", "vérifie que le
  README/CLAUDE.md/les rules sont à jour", after a large multi-session feature build where
  terminology or structure shifted, or as the doc-sync step referenced by bootstrap.md's
  Capitalisation section. Do not use this skill to rewrite JOURNAL/DECISIONS/LEARNINGS
  history, invent blocker entries, or touch generated files/secrets.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Project Docs Sync

Documentation drifts from code a little at a time — a facet gets relabeled, a rule never
catches up to a convention established three sessions later, a decision references a file
that got renamed. None of these individually block anything, so they never surface on their
own; they just quietly make the docs a worse map of the actual territory until someone
(human or agent) trusts a stale line and wastes time on it. This skill is the deliberate,
periodic pass that catches that drift — read the code, diff it against what the docs claim,
fix what's concretely wrong.

## When to use this skill

- The user asks to audit, refresh, or verify project documentation ("mets à jour la doc",
  "audit de la doc", "les docs sont à jour ?").
- Right after a feature/refactor session that renamed something user-facing (a UI label, a
  command, a file) — the exact moment drift gets introduced, so the cheapest moment to fix it.
- As the doc-sync step `.claude/bootstrap.md`'s Capitalisation section points to for larger
  sessions — bootstrap.md itself stays generic and doesn't carry this project-specific logic.
- `.claude/memory/BLOCKERS.md` is empty or template-only and the project has clearly hit real
  friction before (check JOURNAL.md) — that combination is itself a signal worth surfacing.

Do **not** use this skill to rewrite or delete existing entries in JOURNAL.md, DECISIONS.md,
or LEARNINGS.md — those are append-only historical records by design (see DECISIONS.md's own
header: "ne jamais supprimer, marquer [REMPLACÉE PAR DEC-XXX] si obsolète"). This skill only
flags staleness in them and may append a new entry; it never edits the past. It also isn't a
code linter or a test runner — it only touches documentation/meta files, never `src/`,
generated output, or `.env`.

## Process

### Step 1 — Read CLAUDE.md first, it's the ground truth to diff against

Find the project's `CLAUDE.md` (walk up from the working directory if not at the root). Its
"Stack technique", "Commandes", and "Structure" sections are the canonical description of
what the project is — everything else (README, rules) should agree with it, not the other way
around. If CLAUDE.md itself looks wrong against the actual repo, fix CLAUDE.md first; fixing
README against a stale CLAUDE.md just propagates the error one file further.

### Step 2 — Verify CLAUDE.md's own claims before trusting it

Before using CLAUDE.md as ground truth, spot-check it: does every path in its "Structure"
table actually exist (`ls`/`find` each one)? Does every command in "Commandes" match an actual
`package.json` script (or equivalent)? A constitution that references a deleted file or a
renamed script is worse than no constitution — it actively misdirects. Fix mismatches here
before moving on, since Step 3+ trusts this file.

### Step 3 — Diff README.md against the same ground truth

README is usually the most user-facing and the most likely to fall behind, because updating
it doesn't feel as load-bearing as updating the code that shipped. Concretely: read
`package.json` scripts and compare against README's documented commands; read the actual
current feature set (grep the live UI's copy/labels, or a project's `docs/00_context/` brief
if one exists) and compare against README's description of what the project does. Fix
wording that's factually wrong (a renamed filter label, a command that no longer exists, a
data source that changed) — don't rewrite tone or restructure sections that are still
accurate, this is a drift-fix pass, not a rewrite.

Concrete example of the kind of drift this catches: a site's filter facets got relabeled from
"type, catégorie, étape" to "workflow, domaine, type" across several sessions; the internal
brief doc got updated at the time, but README.md — one directory over, edited less often —
still said the old names. Nothing broke, nobody noticed, and it would have stayed wrong
indefinitely without a pass that explicitly diffs README against current reality.

### Step 4 — Check `.claude/rules/*.md` against what the code actually does now

For each rule file, grep the codebase for the pattern it claims to enforce. Two failure modes
to look for: (a) a rule that no longer matches — code has moved on and the rule would tell a
new agent something false; (b) a real, consistently-followed convention that was established
*after* the rules were last written and was never captured — e.g. a project builds up a
"living-doc component" comment format (anatomy notes, framework-equivalence mapping) across
many files without ever writing down that this is the expected shape for a new one. The second
kind is easy to miss because nothing is technically wrong, the rule file is just silent on
something that later became load-bearing practice. Propose or add a rule capturing it,
scoped the same way the existing rules are (check for frontmatter `paths:` globs and match
that convention).

### Step 5 — Check memory files for staleness signals, without rewriting history

Read `DECISIONS.md` and `LEARNINGS.md`: does every file path or component name they reference
still exist? If a decision names a file that was since renamed or removed, that's a stale
pointer — but the fix is to mark it per the file's own existing convention (e.g. append
`[fichier renommé → nouveau-nom]` as a note), never to silently edit or delete the original
entry. Then check `BLOCKERS.md`: if it's empty or still the placeholder template, skim
`JOURNAL.md` for language suggesting real friction happened (an incident, a leaked credential,
a long back-and-forth resolving something) that never got logged as a blocker. Flag this to
the user rather than fabricating a blocker entry after the fact — you weren't there for the
original friction, and a backfilled blocker invented after the fact defeats the point of the
file (a real-time record of what actually cost time, for the next agent to avoid).

### Step 6 — Report before you consider it done

Summarize, in two clearly separated groups: (a) what you changed, with a one-line reason each
— this is a drift-fix, the user should be able to sanity-check it in seconds, not re-derive
your reasoning; (b) what you're only flagging for a human call — anything ambiguous, anything
touching how the team should work going forward (a new rule, a philosophy question like
"should this be automatic"), or anything near secrets. Showing evidence (the actual grep
output, the actual mismatched line) rather than asserting "docs are now in sync" mirrors the
project's own no-claim-without-proof principle — apply it to your own output too.

## Common mistakes

- Mistake: treating this as a chance to also restyle or restructure docs that were already
  accurate. Excuse: "while I'm in here, this section could read better." Correct behavior:
  fix drift only — a docs-sync pass that also does unrelated rewrites makes the actual diff
  harder to review and buries the real fixes in noise.
- Mistake: backfilling `BLOCKERS.md` with entries invented from reading JOURNAL.md after the
  fact. Excuse: "the friction clearly happened, may as well log it now." Correct behavior:
  flag the gap to the user; only they (or the agent that was actually present) can write an
  accurate symptom/cause/workaround, and a fabricated entry pollutes a file whose whole value
  is being a trustworthy record of real time lost.
- Mistake: editing or removing an existing DECISIONS.md/LEARNINGS.md entry that turned out to
  be wrong or outdated. Correct behavior: these files are explicitly append-only/mark-obsolete
  by convention — respect the format already in use in the file rather than "cleaning it up."
- Mistake: trusting CLAUDE.md's Structure/Commandes tables without checking them, and fixing
  README/rules to match a CLAUDE.md that was itself already stale. Correct behavior: verify
  CLAUDE.md first (Step 2) — it's the thing everything else gets diffed against.
- Mistake: running a broad `grep`/rewrite across the whole repo including generated output
  (`dist/`, build artifacts) or `.env`. Correct behavior: scope strictly to documentation/meta
  files — this skill has no business touching anything a build script produces or any secret.

## Verification

The task is done only when:

- [ ] Every path/command named in CLAUDE.md's Structure/Commandes sections was actually
      checked against the filesystem/`package.json`, not assumed correct.
- [ ] Every factual claim changed in README.md (or elsewhere) is backed by something you
      actually read (a grep result, a file's real content) — not inferred from memory of the
      conversation.
- [ ] No entry in JOURNAL.md, DECISIONS.md, or LEARNINGS.md was edited or deleted — only
      appended to, and only following that file's own existing entry format.
- [ ] `BLOCKERS.md` was not backfilled with invented entries — at most flagged as suspiciously
      empty given project history, left for the user/agent-in-the-moment to fill in.
- [ ] The final report separates "changed" from "flagged for human judgment" — the user
      doesn't have to guess which is which.
- [ ] No file under a build output directory, `.env`, or other secret was touched.
