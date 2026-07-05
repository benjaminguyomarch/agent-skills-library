# Agent 06 — Organisms : hero.html, cta-banner.html, service-grid.html, faq-list.html, contact-form.html

## Contexte

Crée la **bibliothèque de snippets HTML** de référence pour les sections de pages (organisms). Ces fichiers ne sont **pas inclus automatiquement** — ils servent de modèles à copier-coller dans les templates de pages (agents 08a/08b/08c).

> Rôle exact : documentation vivante + source de vérité pour les patterns de sections. L'agent 08 copie et adapte ces snippets dans les templates `src/pages/*.html`.

Référence visuelle : `docs/assets/maquettes/` (home-desktop.jpg, home-mobile.jpg, etc.)

## Prérequis

- Agents 01, 04, 05 terminés

## Fichiers à créer

- `src/components/organisms/hero.html`
- `src/components/organisms/cta-banner.html`
- `src/components/organisms/service-grid.html`
- `src/components/organisms/testimonial-strip.html`
- `src/components/organisms/faq-section.html`
- `src/components/organisms/contact-form.html`

## Implémentation

### `src/components/organisms/hero.html`

```html
<section class="section-spacing bg-surface">
  <div class="container-page grid md:grid-cols-2 gap-8 md:gap-12 items-center">
    <div class="flex flex-col gap-6">
      <div>
        <p class="text-sm font-semibold uppercase tracking-widest text-accent mb-3">{{surtitle}}</p>
        <h1 class="font-serif text-3xl md:text-4xl text-on-surface leading-tight">
          {{heading}}
        </h1>
      </div>
      <p class="text-on-surface-muted text-lg">{{subheading}}</p>
      <a href="{{cta-href}}"
         target="_blank"
         rel="noopener noreferrer"
         aria-label="{{cta-label}} (s'ouvre dans un nouvel onglet)"
         class="btn-primary self-start">
        <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
        {{cta-label}}
      </a>
    </div>
    <div class="hidden md:block">
      {{hero-visual}}
    </div>
  </div>
</section>
```

### `src/components/organisms/cta-banner.html`

```html
<section class="bg-cta text-white py-14 md:py-20">
  <div class="container-page text-center flex flex-col items-center gap-6">
    <h2 class="font-serif text-2xl md:text-3xl">{{heading}}</h2>
    <p class="text-white/80 max-w-xl">{{subheading}}</p>
    <a href="{{cta-href}}"
       target="_blank"
       rel="noopener noreferrer"
       class="inline-flex items-center px-6 py-3 bg-white text-cta rounded-full font-semibold hover:bg-surface transition-colors">
      <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
      {{cta-label}}
    </a>
  </div>
</section>
```

### `src/components/organisms/service-grid.html`

```html
<section class="section-spacing">
  <div class="container-page flex flex-col gap-10">
    <header class="text-center">
      <p class="text-sm font-semibold uppercase tracking-widest text-accent mb-2">Au service des femmes</p>
      <h2 class="section-title">Une approche <em class="not-italic font-serif">globale</em> des soins</h2>
    </header>
    <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
      {{service-cards}}
    </div>
  </div>
</section>
```

`{{service-cards}}` = 4 cards générées depuis les données de `content/pages/home.md` section 1.3.

### `src/components/organisms/testimonial-strip.html`

```html
<section class="section-spacing bg-surface-card">
  <div class="container-page flex flex-col gap-10">
    <header class="text-center">
      <p class="text-sm font-semibold uppercase tracking-widest text-accent mb-2">Testimonials</p>
      <h2 class="section-title">Ils m'ont fait <em class="not-italic font-serif italic">confiance</em></h2>
    </header>
    <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-4">
      {{testimonials}}
    </div>
  </div>
</section>
```

`{{testimonials}}` = injecté par `build.js` via `renderTestimonialCard()`.

### `src/components/organisms/faq-section.html`

```html
<section class="section-spacing">
  <div class="container-page max-w-3xl flex flex-col gap-8">
    <header class="text-center">
      <p class="text-sm font-semibold uppercase tracking-widest text-accent mb-2">FAQ</p>
      <h2 class="section-title">Des <em class="not-italic font-serif italic">réponses</em> à vos questions</h2>
    </header>
    <div class="flex flex-col">
      {{faq}}
    </div>
    <div class="text-center mt-4">
      <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
         target="_blank"
         rel="noopener noreferrer"
         class="btn-primary">
        Réserver un rendez-vous
      </a>
    </div>
  </div>
</section>
```

`{{faq}}` = injecté par `build.js` via `renderFAQItem()`.

### `src/components/organisms/contact-form.html`

```html
<section class="section-spacing">
  <div class="container-page max-w-xl">
    <form name="contact"
          method="POST"
          data-netlify="true"
          class="flex flex-col gap-6">
      <input type="hidden" name="form-name" value="contact">

      <div class="flex flex-col gap-1">
        <label for="nom" class="form-label">Nom</label>
        <input id="nom" name="nom" type="text" required class="form-input" placeholder="Votre nom">
      </div>
      <div class="flex flex-col gap-1">
        <label for="email" class="form-label">Email</label>
        <input id="email" name="email" type="email" required class="form-input" placeholder="votre@email.fr">
      </div>
      <div class="flex flex-col gap-1">
        <label for="message" class="form-label">Message</label>
        <textarea id="message" name="message" rows="5" required class="form-input" placeholder="Votre message..."></textarea>
      </div>

      <button type="submit" class="btn-primary self-start">
        Envoyer le message
      </button>
    </form>
  </div>
</section>
```

## Vérification locale

Après agent 08 (pages), vérifier visuellement chaque section sur localhost:3000 en comparant avec les maquettes dans `docs/assets/maquettes/`.

## Prochaine étape

→ `docs/agents/07-custom-elements.md`
