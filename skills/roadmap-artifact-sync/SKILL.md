---
name: roadmap-artifact-sync
description: >
  Keeps a published HTML roadmap Artifact (chantiers/checklist with status pills and a
  progress bar) in sync with the real state of a multi-step remediation or build plan.
  Use whenever a plan's todo list has a companion roadmap Artifact and a tracked step
  (chantier) just got marked completed, blocked, or started — redeploy the same
  Artifact URL with updated statuses immediately, don't batch updates for later. Also
  use when first creating a roadmap Artifact for a multi－chantier plan, to set up the
  convention from the start.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Roadmap Artifact Sync

A roadmap Artifact that silently drifts from the real state of the plan is worse than no
roadmap at all — the user checks it to know where things stand, and a stale checklist reads as
"still blocked" or "not started" for work that actually finished. This skill is the discipline
that keeps the two in lock-step, since there's no engine-level hook that can call the Artifact
tool automatically (hooks run shell commands; publishing an Artifact is a model action).

## When to use this skill

- A multi-step plan (chantiers, phases, milestones) has a roadmap Artifact published via the
  Artifact tool, and a `TodoWrite` status change just happened (a todo flipped to
  `in_progress`, `completed`, or a new blocker surfaced).
- Setting up a roadmap Artifact for the first time on a plan with 3+ tracked steps — wire this
  convention in from the start rather than bolting it on later.

Do **not** use this skill for a todo list with no companion Artifact — updating `TodoWrite` alone
is enough there; only plans that already externalized status into a shareable Artifact need this.

## Process

### Step 1 — Treat the Artifact update as part of finishing the step, not a follow-up

The moment a `TodoWrite` call marks a chantier `completed` (or moves it to `in_progress`, or a
step becomes blocked on a manual action), update and redeploy the Artifact in the same turn,
before moving on to the next step. Batching these "for later" is exactly how the Artifact goes
stale — the user has already asked for this once because it wasn't happening automatically.

### Step 2 — Update state in the HTML, not just the label

Each chantier card carries three things that must move together: the status pill (`pill-done` /
`pill-active` / `pill-blocked` / `pill-pending`), the per-task checkmarks inside it, and the
aggregate progress bar/count in the header. Updating only the pill and leaving stale checkboxes
or a stale aggregate count produces a page that contradicts itself.

### Step 3 — Redeploy to the same URL

Call the Artifact tool again with the **same `file_path`** used originally (never a new path) so
it updates in place at the same URL — a new path mints a new URL, which defeats the point of a
single roadmap link the user can keep open. Give each redeploy a short `label` describing what
changed (e.g. "git terminé, skill supabase-sync créé") so the version history is legible.

## Common mistakes

- Mistake: updating `TodoWrite` and moving on, planning to "sync the artifact at the end."
  Excuse: "I'll batch the visual updates so I'm not redeploying constantly." Correct behavior:
  redeploy after every status change — the cost of a redeploy call is far lower than the cost of
  the user distrusting the roadmap.
- Mistake: publishing to a new `file_path` each time "to keep versions separate." Correct
  behavior: same path, same URL, every time — that's what makes it a single roadmap the user can
  bookmark.
- Mistake: flipping the pill to done but leaving the sub-task checklist and the header progress
  count showing the old numbers. Correct behavior: all three move together, checked against each
  other before redeploying.

## Verification

The task is done only when:

- [ ] The Artifact URL is unchanged from the first publish (same `file_path`).
- [ ] The status pill, the sub-task checkmarks, and the header progress count all agree with each
      other and with the actual `TodoWrite` state.
- [ ] The redeploy happened in the same turn as the status change that triggered it, not queued
      for later.
