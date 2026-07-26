---
name: css-architecture
description: >
  Structures the CSS of a vanilla or lightly-tooled web project into a modular
  architecture (base/colors/components/layout/sections/effects) with CSS variables as
  design tokens, and defines the workflow for native Web Components (attributes for
  simple components, slots for complex ones, one test page per component). Use when
  starting or refactoring the CSS of a project without framework, or when the user
  mentions "architecture CSS", "organiser le CSS", "web components", or "custom
  elements".
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
  source: Archives/anciens-projets/portfolionew2/ (css/ + docs/components.md)
---

# CSS architecture

Architecture CSS modulaire + workflow Web Components natifs, validés sur portfolionew2.

## When to use this skill

- Projet vanilla HTML/CSS/JS qui grossit au-delà de 2-3 pages
- Refactor d'un `style.css` monolithique
- Création de composants réutilisables sans framework
- Trigger phrases : "organise le CSS", "web component", "custom element"

Ne **pas** utiliser avec Tailwind-only ou un framework à styles co-localisés — l'arborescence ferait doublon.

## Arborescence cible

```
css/
├── main.css          # imports uniquement, dans l'ordre : base → colors → layout → components → sections → effects
├── base/             # variables.css (tokens), theme.css, typography.css, shadows.css
├── colors/           # palettes (échelles type shadcn 50-950)
├── layout/           # grille, conteneurs
├── components/       # 1 fichier par composant (button.css, card.css, modal.css…)
├── sections/         # styles spécifiques aux sections de page (jumbotron, contact…)
└── effects/          # animations, transitions décoratives
```

Règles : les composants consomment uniquement les variables de `base/variables.css` (jamais de hex en dur) ; un composant = un fichier CSS + un fichier JS (`js/components/<nom>.js`) + une page de test (`tests/<nom>.html` avec toutes les variantes).

`base/variables.css` est ici la source de vérité écrite à la main (pas de build de tokens comme sur une stack Tailwind) — si le projet utilise déjà `design-tokens-setup`/`theme.json`, générer `variables.css` depuis cette source plutôt que la dupliquer (voir `AGENTS.md` § Design tokens — chaîne de source de vérité).

## Web Components (workflow)

1. **Définir l'API** : composant simple → attributs (`<custom-button variant="primary">`), composant complexe → slots (`<custom-card><div slot="header">`)
2. **Capitaliser** : composer à partir des composants existants (atomic design), ne pas dupliquer
3. **Isoler l'état** : l'état vit dans l'élément, jamais en variable globale
4. **Tester** : créer `tests/<nom>.html` couvrant toutes les variantes avant d'utiliser le composant en page

## Pièges connus (capitalisés depuis des projets réels)

Pattern récurrent trouvé indépendamment sur 2 projets (`stationbest` BLK-005/BLK-006,
`site-perso-react` LRN-003) — vaut pour CSS vanilla comme pour Tailwind, c'est un
comportement flexbox, pas une question de méthode : **un enfant flex perd sa largeur
attendue dès qu'aucune largeur explicite n'est posée dessus.**

- `max-width` seul (sans `width:100%`) redevient un calcul *shrink-to-fit* dès que le
  parent centre son contenu en flex/inline plutôt qu'en bloc classique — la largeur
  finit par dépendre du contenu réellement visible (ex. un panneau togglé en
  `display:none` change la largeur du panneau resté visible).
- `mx-auto max-w-*` (Tailwind) sans `w-full` sur un enfant direct d'un parent `flex` a
  le même symptôme : la spec CSS fait primer les marges `auto` sur `align-items:
  stretch`, donc l'enfant se dimensionne à son contenu au lieu d'occuper la largeur max.
- `align-items:flex-start` change d'axe avec `flex-direction` : en `column` (typiquement
  un breakpoint mobile), il agit sur la largeur au lieu de la hauteur et peut réduire un
  enfant à sa taille de contenu minimale.

**Règle qui en découle** : sur tout conteneur flex destiné à garder une largeur stable
(surtout avec des panneaux togglés ou un breakpoint qui change `flex-direction`), poser
`width:100%` (ou `w-full` en Tailwind) explicitement sur l'enfant concerné — ne jamais
compter sur le comportement par défaut de `width:auto`. Vérifier en réduisant la fenêtre
sous le breakpoint concerné, pas seulement en desktop.

## Vérification

`grep -r "#[0-9a-fA-F]\{6\}" css/components/` ne doit rien retourner (tokens uniquement) ; chaque composant a sa page de test qui s'affiche sans erreur console.
