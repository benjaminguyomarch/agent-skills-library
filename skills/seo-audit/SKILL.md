---
name: seo-audit
description: >
  Runs a post-deployment SEO and compliance audit on a website: checks HTTP status,
  meta tags (title/description/canonical), robots.txt, legal pages (mentions légales,
  politique de confidentialité), Core Web Vitals via the PageSpeed Insights API,
  WCAG accessibility via pa11y, and HTTP security headers. Writes a prioritised
  Markdown report to rapport-seo/ in the current project. Use when asked to "audit SEO",
  "vérifier le SEO", "audit post-déploiement", "conformité SEO", "run seo-audit", or
  when called from CI/CD after a deploy. Requires AUDIT_BASE_URL env var;
  PAGESPEED_API_KEY is needed for Core Web Vitals field data.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# SEO & Compliance Audit

Audits a website post-deployment and writes a structured Markdown report to `rapport-seo/`.
Blocking issues cause an exit code 1 in CI. The agent uses CLI tools for data collection
and its own reasoning to interpret results and write actionable recommendations.

## When to use this skill

- Triggered from CI/CD after a deployment (`claude --print "audit SEO pour $URL"`)
- User asks to audit SEO, check compliance, or verify a site is production-ready
- Trigger phrases: audit SEO, vérifier le SEO, conformité, post-déploiement, seo-audit

Do **not** use this skill for keyword research, backlink analysis, or content strategy —
it covers technical SEO and compliance only.

## Process

### Step 1 — Read configuration from environment

Read these variables (never hardcode values):

| Variable | Required | Default |
|---|---|---|
| `AUDIT_BASE_URL` | Yes | — |
| `PAGESPEED_API_KEY` | For CWV | — |
| `AUDIT_SITEMAP_URL` | No | `{BASE_URL}/sitemap.xml` |
| `AUDIT_URLS` | No | overrides sitemap |
| `AUDIT_MAX_URLS` | No | 50 |
| `AUDIT_REPORT_RETENTION_DAYS` | No | 90 |

If `AUDIT_BASE_URL` is not set and no URL was passed in the prompt, stop and ask for it.

### Step 2 — Resolve URL list

```bash
# Try sitemap first
curl -s "$AUDIT_SITEMAP_URL" | grep -oP '(?<=<loc>)[^<]+'
```

If the sitemap returns an error or is empty, fall back to `[AUDIT_BASE_URL]` alone.
Cap at `AUDIT_MAX_URLS` URLs. Log how many URLs will be audited.

### Step 3 — Blocking checks (per URL)

Run these for every URL in the list. Any failure = blocking.

**3a. HTTP status**
```bash
STATUS=$(curl -o /dev/null -s -w "%{http_code}" -L --max-redirs 5 "$URL")
REDIRECTS=$(curl -o /dev/null -s -w "%{num_redirects}" -L --max-redirs 5 "$URL")
```
Fail if status != 200 or redirects > 2.

**3b. Meta tags** — fetch the HTML and check:
```bash
HTML=$(curl -s -L "$URL")
echo "$HTML" | grep -i '<title'        # must be present and non-empty
echo "$HTML" | grep -i 'name="description"'   # must be present
echo "$HTML" | grep -i 'rel="canonical"'      # must be present
```

**3c. robots.txt**
```bash
ROBOTS=$(curl -s "$BASE_URL/robots.txt")
echo "$ROBOTS" | grep -A1 'User-agent: \*' | grep 'Disallow: /$'
```
Fail if `Disallow: /` found under `User-agent: *`.

**3d. Noindex check** (for each URL)
```bash
echo "$HTML" | grep -i 'name="robots"' | grep -i 'noindex'
```
Fail if noindex found on a URL that should be indexed.

**3e. Legal pages** — check HTTP 200 for standard French legal paths:
```bash
for PATH in /mentions-legales /politique-de-confidentialite /politique-confidentialite /mentions-légales; do
  curl -o /dev/null -s -w "%{http_code}" "$BASE_URL$PATH"
done
```
At least one mentions légales page and one politique de confidentialité page must return 200.

### Step 4 — Informative checks

**4a. Core Web Vitals — field data (real users)**

Only if `PAGESPEED_API_KEY` is set:
```bash
curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=${BASE_URL}&key=${PAGESPEED_API_KEY}&strategy=mobile" > /tmp/psi.json
```
Extract from the JSON: `lighthouseResult.categories.performance.score`, LCP, CLS, INP.
Alert thresholds: performance < 0.80, LCP > 2.5s, CLS > 0.1, INP > 200ms.

If no API key, note it in the report and skip.

**4b. Core Web Vitals — synthetic (Lighthouse CI)**

Only if `npx lhci --version` succeeds (tool available):
```bash
npx lhci autorun --collect.url="$BASE_URL" --upload.target=filesystem --upload.outputDir=/tmp/lhci
```
Thresholds come from `lighthouserc.json` if present, otherwise use defaults (performance ≥ 80).

**4c. Accessibility + compliance (pa11y)**

Only if `npx pa11y --version` succeeds:
```bash
npx pa11y "$BASE_URL" --standard WCAG2AA --reporter json > /tmp/pa11y.json 2>/dev/null
```
Flag any errors (not just warnings). Pay attention to missing cookie consent banner.

**4d. Security headers**
```bash
HEADERS=$(curl -s -I "$BASE_URL")
```
Check for presence of: `Strict-Transport-Security`, `Content-Security-Policy`,
`X-Frame-Options`, `X-Content-Type-Options`. Flag each missing one.

**4e. TLS certificate**
```bash
EXPIRY=$(echo | openssl s_client -connect "${DOMAIN}:443" -servername "$DOMAIN" 2>/dev/null \
  | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
```
Alert if cert expires in < 30 days.

### Step 5 — Interpret and prioritise

Read all collected data. Group findings into:
- **CRITIQUE** — blocking check that failed (anything from Step 3)
- **ATTENTION** — informative threshold exceeded (Step 4)
- **INFO** — missing best-practice header or minor issue

For each finding write a one-sentence **recommendation** explaining what to fix and why it matters.
Order by: CRITIQUE first, then ATTENTION, then INFO.

### Step 6 — Write the report

Create `rapport-seo/` in the current directory if it does not exist.

Write two files:

```
rapport-seo/<ISO-DATETIME>-audit.md   ← timestamped archive
rapport-seo/latest.md                  ← always the most recent run (overwrite)
```

Use this structure:

```markdown
# Audit SEO — <BASE_URL>
_<ISO datetime> — <N> URLs auditées_

## Résumé exécutif
**Statut global : ✅ PASS** / **❌ FAIL**
<N> bloquants · <N> alertes · <N> infos

## Checks bloquants
| URL | Check | Statut | Détail |
|-----|-------|--------|--------|
| … | title | ❌ | Balise <title> absente |

## Checks informatifs
| Check | Valeur mesurée | Seuil | Statut |
|-------|---------------|-------|--------|
| Performance (mobile) | 72/100 | ≥ 80 | ⚠️ |

## Recommandations priorisées
### 🔴 CRITIQUE
1. **[Page X] Balise title absente** — Ajouter une balise `<title>` unique…

### 🟡 ATTENTION
2. **Score performance mobile 72/100** — Optimiser les images…

### 🔵 INFO
3. **En-tête CSP manquant** — Ajouter un Content-Security-Policy…
```

### Step 7 — Clean old reports

```bash
find rapport-seo/ -name "*-audit.md" -mtime +${AUDIT_REPORT_RETENTION_DAYS:-90} -delete
```

Do **not** delete `latest.md`.

### Step 8 — Exit code

If any blocking check (Step 3) failed → print a summary of failures and exit with code 1.
Otherwise exit with code 0.

## Common mistakes

- Mistake: running all checks even when `AUDIT_BASE_URL` is not set. Correct behavior:
  stop immediately and ask for the URL before doing anything else.
- Mistake: marking the audit as PASS when a legal page returned 404. Excuse: "it might
  exist under a different path". Correct behavior: only PASS if at least one path per
  category returned 200.
- Mistake: skipping pa11y or Lighthouse CI silently when they're not installed. Correct
  behavior: note clearly in the report that the check was skipped and why.
- Mistake: writing generic recommendations ("fix your SEO"). Correct behavior: every
  recommendation names the specific URL or element and the exact action to take.
- Mistake: stopping after the first blocking failure. Correct behavior: run all checks
  on all URLs, collect everything, then report at the end.

## Verification

The task is done only when:

- [ ] `rapport-seo/latest.md` exists and contains all three report sections
- [ ] Every URL from the resolved list appears in the blocking checks table
- [ ] Statut global matches the actual check results (FAIL if any blocking failure)
- [ ] Each recommendation is specific (names a URL or element, not vague advice)
- [ ] Exit code is 1 if any blocking check failed, 0 otherwise

## References

- See [github-actions-example.yml](github-actions-example.yml) for CI integration
- See [lighthouserc.example.json](lighthouserc.example.json) for Lighthouse CI thresholds
- PageSpeed Insights API: https://developers.google.com/speed/docs/insights/v5/get-started
- Lighthouse CI docs: https://github.com/GoogleChrome/lighthouse-ci
