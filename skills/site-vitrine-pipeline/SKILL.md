---
name: site-vitrine-pipeline
description: >
  Builds a complete static showcase website (site vitrine) through a proven 16-step
  agent pipeline: setup, content check, CSS foundation, color tokens, partials, build
  script, atomic components (atoms/molecules/organisms), custom elements, pages, SEO
  and review. Stack: static HTML + Tailwind CSS v4 CLI + Node build script + native
  Custom Elements, no frontend framework. Use when building or restructuring a
  showcase/marketing site for a client, or when the user says "site vitrine",
  "nouveau site client", "static site", or "pipeline morgane".
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
  source: Projets/morgane/site (pipeline validé, rapatrié dans reference/)
---

# Site vitrine pipeline

Pipeline de production d'un site vitrine statique orienté conversion, validé sur le projet Morgane (sage-femme, Lyon). Chaque étape est un agent/une session avec entrées et sorties définies.

## When to use this skill

- Nouveau site vitrine client (thérapeute, artisan, indépendant, TPE)
- Refonte d'un site statique existant vers cette stack — y compris un projet déjà fonctionnel qui avait délibérément écarté Tailwind (ex. `veille-ux-ui`, DEC-001 revenue sur DEC-003) : dans ce cas, ne pas copier les snippets Morgane tels quels (booking Doctolib, testimonials, hero thérapeute) — le pattern (tokens `@theme` depuis `theme.json`, classes sémantiques via `@apply`, atoms/molecules/organisms comme documentation vivante) s'applique, le contenu des composants doit refléter le domaine réel du site cible
- Trigger phrases : "site vitrine", "site client", "comme morgane"

Ne **pas** utiliser pour une app avec état serveur ou authentification — cette stack est volontairement sans framework.

## Stack imposée

HTML statique + Tailwind CSS v4 CLI + build script Node (partials, Markdown→HTML via `marked`, injection JSON) + Custom Elements natifs pour l'interactivité. Contenus dans `content/` (`pages/*.md`, `faq.json`, `tarifs.json`, `navigation.json`, `theme.json` = source des tokens).

## Process

Suivre les étapes dans l'ordre. La référence détaillée de chaque étape est dans `reference/` (à côté de ce fichier, `00-setup.md` → `10-review-monitor.md`) — les lire avant d'exécuter l'étape correspondante. Ces fichiers sont le pipeline tel qu'exécuté sur le projet Morgane : les étapes 00 à 07 et 09-10 sont directement réutilisables, les étapes 08* (pages) restent un exemple concret à adapter au contenu du nouveau client plutôt qu'à copier tel quel.

### Phase 0 — Fondations
1. **00-setup** : `setup.sh` (Node 18+, tailwindcss, marked, gray-matter, chokidar-cli, http-server) + scripts npm `build`/`dev`/`preview`
2. **00b-content-check** : vérifier que tous les contenus sources existent et sont cohérents AVANT de coder
3. **01-css-foundation** + **01b-color-tokens** : `global.css`, génération `tokens.css` depuis `content/theme.json` (ne jamais l'éditer à la main)

### Phase 1 — Assemblage
4. **02-partials** : header/footer/sections en HTML pur, sans logique
5. **03-build-script** : `build.js` assemble partials + convertit Markdown + injecte JSON

### Phase 2 — Composants (atomic design)
6. **04-atoms** → **05-molecules** → **06-organisms** : classes sémantiques (`.btn-primary`, `.card`) via `@apply`
7. **07-custom-elements** : interactivité isolée (`<faq-item>`, `<mobile-nav>`), état dans l'élément, jamais en JS global

### Phase 3 — Pages et livraison
8. **08-pages** (home, services, tarifs, contact) depuis les maquettes `docs/assets/maquettes/`
9. **09-seo-build** : meta, sitemap, robots, perf
10. **10-review-monitor** : revue finale — enchaîner avec le skill `seo-audit` de cette bibliothèque

## Vérification

Chaque phase se termine par `npm run build` sans erreur + contrôle visuel via `npm run preview`. Pas de passage à la phase suivante si la précédente ne build pas.
