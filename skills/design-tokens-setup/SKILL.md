---
name: design-tokens-setup
description: >
  Sets up a three-tier design token architecture (primitives → semantics → components)
  as JSON collections, and outputs it for the target platform: Figma variables,
  Tailwind CSS config, Style Dictionary, or Webflow variables. Use when creating or
  restructuring design tokens, syncing Figma variables with code, or when the user
  mentions "design tokens", "variables Figma", "collections", "primitives/semantics",
  or "theme setup".
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
  source: ressources/collections-variables-setup/
---

# Design tokens setup

Architecture de tokens en 3 niveaux, réutilisable sur tout projet, avec déclinaisons par plateforme.

## When to use this skill

- Démarrage d'un projet nécessitant un thème cohérent (site, app, design system)
- Synchronisation Figma variables ↔ code
- Trigger phrases : "design tokens", "collections de variables", "setup thème"

Ne **pas** utiliser pour un simple choix de palette ponctuel sans système.

## Architecture (3 niveaux)

1. **Primitives** : valeurs brutes, sans opinion (`blue-600: #2563eb`, échelles 50-950, spacing, radii). Jamais consommées directement par les composants.
2. **Semantics** : rôles (`primary`, `background`, `foreground`, `destructive`, `muted`…) qui pointent vers des primitives. C'est ici que vivent les modes clair/sombre.
3. **Layout/Typography** : échelles typo et grilles, mêmes principes.

Références JSON prêtes à copier : `Documents/ressources/collections-variables-setup/generique/` (`primitives.json`, `semantics.json`, `typography.json`, `layout.json`, et `structure-collection-variables.md` pour la doc).

Ce skill produit la couche « source de vérité » (`theme.json` ou équivalent par projet) ; les fichiers générés au build (ex. `tokens.css`) ne s'éditent jamais à la main — voir la chaîne complète dans `AGENTS.md` (§ Design tokens — chaîne de source de vérité).

## Process

### Step 1 — Choisir la cible
Figma (variables/collections), Tailwind (`tailwindcss/`), Style Dictionary (`style-dictionary/`), ou Webflow (`webflow2/`) — chaque dossier de la ressource contient le format adapté.

### Step 2 — Adapter les primitives
Partir de `generique/primitives.json`, remplacer les échelles de couleurs par celles de la marque. Ne jamais renommer les clés d'échelle (50-950).

### Step 3 — Mapper les semantics
Adapter `semantics.json` : chaque rôle pointe vers une primitive (`primary → blue-600`). Définir les deux modes si nécessaire.

### Step 4 — Générer et verrouiller
Générer la sortie cible (CSS variables, config Tailwind, collections Figma). Règle absolue : le JSON est la source de vérité, les fichiers générés ne s'éditent jamais à la main.

## Vérification

Un composant témoin (bouton + carte) rendu dans les deux modes ; aucun hex codé en dur hors primitives.
