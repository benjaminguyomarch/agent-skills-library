# Agent 04 — Atoms : button.html, badge.html

## Contexte

Crée la **bibliothèque de snippets HTML** de référence pour les atoms. Ces fichiers ne sont **pas inclus automatiquement** par build.js — ils servent de modèles à copier-coller dans les templates de pages (agents 08a/08b/08c) et facilitent la cohérence visuelle.

> Rôle exact : documentation vivante + source de vérité pour les patterns markup. L'agent 08 copie ces snippets directement dans les templates `src/pages/*.html`.

## Prérequis

- Agent 01 terminé (classes `.btn-primary`, `.btn-secondary`, `.btn-ghost` définies dans global.css)

## Fichiers à créer

- `src/components/atoms/button.html`
- `src/components/atoms/button-external.html` (pour les liens externes type Doctolib)
- `src/components/atoms/badge.html`

## Implémentation

### `src/components/atoms/button.html`

Bouton interne (lien vers une page du site) :

```html
<a href="{{href}}" class="{{variant}}">
  {{label}}
</a>
```

`{{variant}}` = `btn-primary`, `btn-secondary`, ou `btn-ghost`

### `src/components/atoms/button-external.html`

Bouton externe (Doctolib) :

```html
<a href="{{href}}"
   target="_blank"
   rel="noopener noreferrer"
   aria-label="{{label}} (s'ouvre dans un nouvel onglet)"
   class="{{variant}}">
  <span class="material-icons text-base mr-1" aria-hidden="true">calendar_today</span>
  {{label}}
</a>
```

### `src/components/atoms/badge.html`

```html
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
             bg-surface border border-border text-on-surface-muted">
  {{label}}
</span>
```

## Ne pas faire

- Ne pas créer de CSS inline
- Ne pas mettre de logique conditionnelle dans les fichiers HTML

## Vérification locale

Après l'agent 03, inclure un bouton dans une page de test et vérifier l'affichage via `npm run preview`.

## Prochaine étape

→ `docs/agents/05-molecules.md`
