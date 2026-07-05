# Agent 02 — Partials : head.html, header.html, footer.html

## Contexte

Crée les 3 partials HTML qui constituent le shell de toutes les pages. Ces fichiers sont du markup pur — aucune logique. Le build script les injecte dans chaque page via des marqueurs `{{head}}`, `{{header}}`, `{{footer}}`.

## Prérequis

- Agent 01 terminé (`src/styles/global.css` existe)
- `content/navigation.json` existe (source des liens de nav)

## Fichiers à créer

- `src/partials/head.html` — `<head>` HTML complet
- `src/partials/header.html` — navigation sticky
- `src/partials/footer.html` — pied de page

## Implémentation

### `src/partials/head.html`

```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{{title}}</title>
<meta name="description" content="{{description}}">
<link rel="canonical" href="https://www.morgane-jacques-sages-femmes.fr{{slug}}">

<!-- Open Graph -->
<meta property="og:title"       content="{{ogTitle}}">
<meta property="og:description" content="{{ogDescription}}">
<meta property="og:url"         content="https://www.morgane-jacques-sages-femmes.fr{{slug}}">
<meta property="og:type"        content="website">
<meta property="og:locale"      content="fr_FR">
<meta property="og:site_name"   content="Morgane Jacques — Sage-femme, Acupunctrice, Hypnothérapeute">

<!-- Fonts Google -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Instrument+Serif:ital,wght@0,400;1,400&display=swap" rel="stylesheet">

<!-- Material Icons -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- Styles -->
<link rel="stylesheet" href="/styles.css">

<!-- Custom Elements -->
<script type="module" src="/js/faq-item.js"></script>
<script type="module" src="/js/mobile-nav.js"></script>
```

Les slots `{{title}}`, `{{description}}`, `{{slug}}`, `{{ogTitle}}`, `{{ogDescription}}` sont remplacés par le build script depuis le frontmatter de chaque page `.md`.

---

### `src/partials/header.html`

Lire `content/navigation.json` pour les liens. Le build script les injecte dans `{{nav-links}}` et `{{cta-href}}`.

```html
<header class="sticky top-0 z-50 bg-surface/90 backdrop-blur-sm border-b border-border">
  <div class="container-page flex items-center justify-between h-16">

    <!-- Logo — desktop uniquement -->
    <a href="/" class="hidden md:block font-serif text-lg text-on-surface hover:text-accent transition-colors">
      Morgane Jacques
    </a>

    <!-- Nav desktop -->
    <nav aria-label="Navigation principale" class="hidden md:flex items-center gap-1">
      {{nav-links}}
    </nav>

    <!-- CTA desktop -->
    <a href="{{cta-href}}"
       target="_blank"
       rel="noopener noreferrer"
       aria-label="Réserver un rendez-vous (s'ouvre dans un nouvel onglet)"
       class="btn-primary hidden md:inline-flex">
      Réserver
    </a>

    <!-- Menu mobile -->
    <mobile-nav class="md:hidden">
      <button slot="trigger"
              class="p-2 text-on-surface"
              aria-label="Ouvrir le menu de navigation"
              aria-expanded="false"
              aria-controls="mobile-menu">
        <span class="material-icons text-2xl" aria-hidden="true">menu</span>
      </button>

      <div slot="menu"
           id="mobile-menu"
           role="dialog"
           aria-modal="true"
           aria-label="Menu principal"
           class="fixed inset-0 bg-surface z-50 flex flex-col p-6 hidden">

        <button class="mobile-nav-close self-end p-2 text-on-surface mb-6"
                aria-label="Fermer le menu">
          <span class="material-icons text-2xl" aria-hidden="true">close</span>
        </button>

        <nav class="flex flex-col gap-2">
          {{nav-links-mobile}}
        </nav>

        <a href="{{cta-href}}"
           target="_blank"
           rel="noopener noreferrer"
           class="btn-primary mt-auto self-start">
          Réserver un rendez-vous
        </a>
      </div>
    </mobile-nav>

  </div>
</header>
```

**Rendu de `{{nav-links}}` par le build script (desktop) :**
```html
<a href="/gynecologie" class="nav-link">Gynécologie</a>
```

**Rendu de `{{nav-links-mobile}}` par le build script :**
```html
<a href="/gynecologie" class="block py-3 text-on-surface font-sans text-lg border-b border-border">Gynécologie</a>
```

---

### `src/partials/footer.html`

```html
<footer role="contentinfo" class="bg-surface border-t border-border mt-auto">
  <div class="container-page py-10 flex flex-col md:flex-row justify-between gap-6">

    <div>
      <p class="font-serif text-on-surface text-lg">Morgane Jacques</p>
      <p class="text-on-surface-muted text-sm mt-1">Sage-femme · Acupunctrice · Hypnothérapeute</p>
      <p class="text-on-surface-muted text-sm">263 Av. Jean Monnet, 69300 Caluire-et-Cuire</p>
      <p class="text-on-surface-muted text-sm">Lun–Jeu : 8h–13h / 14h–19h</p>
      <a href="tel:+33481914630" class="text-accent text-sm hover:underline">04 81 91 46 30</a>
    </div>

    <nav aria-label="Navigation secondaire" class="flex flex-col gap-1">
      <a href="/" class="text-on-surface-muted text-sm hover:text-on-surface">Accueil</a>
      <a href="/gynecologie" class="text-on-surface-muted text-sm hover:text-on-surface">Gynécologie</a>
      <a href="/acupuncture" class="text-on-surface-muted text-sm hover:text-on-surface">Acupuncture</a>
      <a href="/hypnose" class="text-on-surface-muted text-sm hover:text-on-surface">Hypnose</a>
      <a href="/douleurs" class="text-on-surface-muted text-sm hover:text-on-surface">Douleurs</a>
      <a href="/tarifs" class="text-on-surface-muted text-sm hover:text-on-surface">Tarifs</a>
      <a href="/contact" class="text-on-surface-muted text-sm hover:text-on-surface">Contact</a>
    </nav>

    <div class="flex flex-col gap-2">
      <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
         target="_blank"
         rel="noopener noreferrer"
         class="btn-primary self-start">
        Réserver sur Doctolib
      </a>
      <p class="text-on-surface-muted text-xs mt-2">RPPS : à compléter</p>
    </div>

  </div>
  <div class="border-t border-border">
    <p class="container-page py-3 text-on-surface-muted text-xs">
      © 2025 Morgane Jacques — Mentions légales
    </p>
  </div>
</footer>
```

## Ne pas faire

- Ne pas ajouter de logique (conditions, boucles) dans les partials
- Ne pas hard-coder l'URL Doctolib — utiliser `{{cta-href}}` injecté depuis `content/navigation.json`
- Ne pas créer de CSS inline

## Vérification locale

```bash
ls src/partials/
# Résultat attendu : head.html  header.html  footer.html
```

Les partials ne peuvent pas être testés isolément — ils le seront lors de l'agent 03 (build.js).

## Prochaine étape

→ `docs/agents/03-build-script.md` (bloquant — nécessaire pour toute prévisualisation)
