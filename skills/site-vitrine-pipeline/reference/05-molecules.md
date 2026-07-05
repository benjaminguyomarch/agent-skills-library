# Agent 05 — Molecules : card.html, section-title.html, testimonial-card.html, form-field.html

## Contexte

Crée la **bibliothèque de snippets HTML** de référence pour les molecules. Ces fichiers ne sont **pas inclus automatiquement** — ils servent de modèles à copier-coller dans les templates de pages (agents 08a/08b/08c).

> Rôle exact : documentation vivante + source de vérité pour les patterns markup. L'agent 08 copie ces snippets dans les templates `src/pages/*.html`.

## Prérequis

- Agent 01 terminé (`.card`, `.section-title`, `.section-subtitle`, `.form-label`, `.form-input` définis)
- Agent 04 terminé (atoms disponibles)

## Fichiers à créer

- `src/components/molecules/card.html`
- `src/components/molecules/section-title.html`
- `src/components/molecules/testimonial-card.html`
- `src/components/molecules/form-field.html`

## Implémentation

### `src/components/molecules/card.html`

```html
<a href="{{href}}" class="card flex flex-col gap-3 hover:shadow-md transition-shadow group">
  <div class="flex items-center gap-2">
    <span class="material-icons text-accent text-xl" aria-hidden="true">{{icon}}</span>
    <h3 class="font-sans font-semibold text-on-surface group-hover:text-accent transition-colors">
      {{title}}
    </h3>
  </div>
  <p class="text-on-surface-muted text-sm flex-1">{{description}}</p>
  <div class="flex flex-wrap gap-1 mt-1">
    {{keywords}}
  </div>
  <span class="text-accent text-sm font-semibold flex items-center gap-1 mt-auto">
    Découvrir
    <span class="material-icons text-base" aria-hidden="true">arrow_forward</span>
  </span>
</a>
```

`{{keywords}}` = badges générés depuis les mots-clés du service (voir `content/pages/home.md` section 1.3)

### `src/components/molecules/section-title.html`

```html
<header class="{{centered}}">
  <p class="text-sm font-semibold uppercase tracking-widest text-accent mb-2">{{surtitle}}</p>
  <h2 class="section-title">{{heading}}</h2>
  <p class="section-subtitle mt-2 max-w-2xl {{centered}}">{{subheading}}</p>
</header>
```

`{{centered}}` = `text-center mx-auto` si centré, vide sinon
`{{surtitle}}` est optionnel (ex : "AU SERVICE DES FEMMES")

### `src/components/molecules/testimonial-card.html`

```html
<div class="card flex flex-col gap-3">
  <div class="flex items-center justify-between">
    <p class="font-sans text-sm font-semibold text-on-surface">{{auteur}}</p>
    <p class="text-on-surface-muted text-xs">{{date}}</p>
  </div>
  <p class="text-on-surface italic text-sm flex-1">"{{extrait}}"</p>
  <div class="flex gap-0.5" aria-label="{{note}} étoiles sur 5">
    <span class="material-icons text-accent text-sm" aria-hidden="true">star</span>
    <span class="material-icons text-accent text-sm" aria-hidden="true">star</span>
    <span class="material-icons text-accent text-sm" aria-hidden="true">star</span>
    <span class="material-icons text-accent text-sm" aria-hidden="true">star</span>
    <span class="material-icons text-accent text-sm" aria-hidden="true">star</span>
  </div>
</div>
```

### `src/components/molecules/form-field.html`

```html
<div class="flex flex-col gap-1">
  <label for="{{id}}" class="form-label">{{label}}</label>
  {{input}}
</div>
```

Pour un `<input>` :
```html
<input id="{{id}}" name="{{name}}" type="{{type}}" required class="form-input" placeholder="{{placeholder}}">
```

Pour un `<textarea>` :
```html
<textarea id="{{id}}" name="{{name}}" rows="5" required class="form-input" placeholder="{{placeholder}}"></textarea>
```

## Vérification locale

Après agent 03 + agent 08, vérifier que les cards de la page d'accueil s'affichent correctement.

## Prochaine étape

→ `docs/agents/06-organisms.md`
