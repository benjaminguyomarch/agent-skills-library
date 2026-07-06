---
name: project-guard
description: >
  Hardens a Node build script against malformed content JSON with fail-fast validation and
  clear error messages, derives every URL (canonical, sitemap, robots) from a single SITE_URL
  variable instead of duplicating it, and runs a pre-deploy checklist (git clean, .env never
  tracked, docs not stale versus the last logged decision). Use before a first deploy, when a
  build script crashes with a raw Node stack trace on bad content data, when a canonical URL
  or similar value is hard-coded in HTML separately from the build script's URL variable, or
  when the user says "éviter cette erreur au prochain build", "garde-fou avant déploiement",
  "valider le build".
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Project Guard

A static-site build script that trusts its content JSON blindly works fine until someone edits
`content/*.json` by hand and gets a raw Node stack trace instead of a message that says what's
wrong. This skill closes that gap and adds a short pre-deploy checklist, so the failure mode for
bad data or a forgotten secret is a clear error, not a confusing crash or a leaked file.

## When to use this skill

- A build script (`build.js` or equivalent) reads JSON content files with no shape validation —
  a missing or mistyped field crashes with a Node stack trace instead of a clear message.
- A canonical URL, og:url, or similar value is written directly in HTML while the build script
  separately computes the same URL from an env var (`SITE_URL`) for the sitemap/robots — the two
  can drift when the domain changes.
- Right before a first deploy, or when setting up CI, to add a pre-deploy checklist.
- Trigger phrases: "éviter cette erreur au prochain build", "garde-fou avant déploiement",
  "valider le build", "build robuste".

Do **not** use this skill to add a testing framework or a generic linter — it's specifically
about content-shape validation and pre-deploy hygiene for the kind of small, dependency-light
static-site builds this library targets, not a replacement for real test coverage on complex apps.

## Process

### Step 1 — Validate content shape before using it, fail with a specific message

Before the build script maps over `items` or resolves tokens, check the shape it actually needs
and throw with a message naming the file, the field, and the item index — not just "Cannot read
property of undefined". This matters because the person hitting this later (often future-you,
months after writing the build script) has to guess at the cause otherwise; a message like
`content/veille.json: item 12 ("Foo") missing required field "date"` turns a debugging session
into a 10-second fix.

```js
function assertShape(items, requiredFields, fileLabel) {
  items.forEach((item, i) => {
    for (const field of requiredFields) {
      if (item[field] === undefined) {
        throw new Error(`${fileLabel}: item ${i} ("${item.name ?? "?"}") missing required field "${field}"`);
      }
    }
  });
}
```

Apply the same idea to token/theme JSON: if a `{token.reference}` fails to resolve, fail the
build rather than silently emitting `/*MISSING:token.reference*/` into shipped CSS — a build that
succeeds with broken tokens is a worse failure mode than one that stops and says why.

### Step 2 — One URL variable, everywhere a URL is derived

Grep the HTML source and the build script for the production domain as a literal string. Every
occurrence other than the single `SITE_URL` (or equivalent) constant is a future drift bug: the
day the domain changes, whoever updates it will reasonably assume grepping the build script and
env config is enough, and won't think to check a `<link rel="canonical">` hard-coded in the HTML
template. Route canonical URLs, `og:url`, sitemap entries, and robots.txt through the same
variable via the templating mechanism the build already uses (e.g. `{{canonical}}`).

### Step 3 — Pre-deploy checklist

Before triggering a deploy (or as the last step of `npm run build` in CI), check:

- `git status --short` is clean, or only contains files meant to be committed.
- `.env` (or any credentials file) never appears in `git status` as trackable — confirms
  `.gitignore` is actually working, not just present.
- The build's own output (item count, entity count, etc.) matches expectations — a build that
  "succeeds" with 0 items because a content file failed to load silently is still a failure.
- If the project keeps a decision log (e.g. `.claude/memory/DECISIONS.md`), skim it for entries
  newer than the last time `docs/` was touched — an undocumented architecture change is exactly
  the kind of debt this skill exists to catch before it compounds.

## Common mistakes

- Mistake: validating only the top-level JSON parses (`JSON.parse` succeeds) and assuming the
  shape is fine. Excuse: "if it parses, the data is probably fine." Correct behavior: parsing
  succeeding says nothing about whether required fields exist — validate shape separately from
  syntax.
- Mistake: fixing the one hard-coded URL you found and calling it done. Correct behavior: grep
  for the literal domain string across the whole source tree, not just the file you were already
  editing — drift bugs hide in partials and meta tags nobody thought to check.
- Mistake: treating the pre-deploy checklist as optional "if there's time." Correct behavior: it
  runs every time, specifically because it's cheap and the failure modes it catches (leaked
  secret, silent empty build) are expensive.

## Verification

The task is done only when:

- [ ] Deliberately breaking a required content field (rename it, delete it) produces a clear
      thrown error naming the file/field/item, not a raw stack trace.
- [ ] Deliberately breaking a token reference in the theme JSON fails the build instead of
      shipping a `MISSING` comment into production CSS.
- [ ] Grepping the built HTML output for the production domain shows it only ever came from the
      single `SITE_URL`-derived template value, not a second hard-coded literal.
- [ ] `git status --short` after a build shows no credentials file as trackable.
