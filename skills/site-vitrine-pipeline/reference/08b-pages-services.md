# Agent 08b — Pages de service : gynécologie, douleurs, acupuncture, hypnose

## Contexte

Crée les 4 templates de pages de service. Elles partagent toutes la même structure (hero → contenu spécifique → témoignages → FAQ). Le contenu textuel vient des fichiers `content/pages/*.md` via `{{content}}`.

## Prérequis

- Agent 08a terminé (pattern de page établi)
- Maquettes : `docs/assets/maquettes/service-*.jpg`

## Fichiers à créer

- `src/pages/gynecologie.html`
- `src/pages/douleurs.html`
- `src/pages/acupuncture.html`
- `src/pages/hypnose.html`

## Structure commune (à dupliquer pour chaque page)

```html
{{head}}
<body class="bg-surface font-sans text-on-surface min-h-screen flex flex-col">

<a href="#main-content" class="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:bg-surface focus:px-3 focus:py-2 focus:rounded">
  Aller au contenu principal
</a>

{{header}}

<main id="main-content" class="flex-1">

  <!-- ── Section 1 : Hero ── -->
  <section class="section-spacing bg-surface">
    <div class="container-page max-w-3xl flex flex-col gap-6">
      <h1 class="section-title text-3xl md:text-4xl">{{accroche}}</h1>
      <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
         target="_blank" rel="noopener noreferrer"
         aria-label="Réserver un rendez-vous (s'ouvre dans un nouvel onglet)"
         class="btn-primary self-start">
        <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
        Réserver un rendez-vous
      </a>
    </div>
  </section>

  <!-- ── Section 2 : Contenu ── -->
  <section class="section-spacing">
    <div class="container-page max-w-3xl content-body">
      {{content}}
    </div>
  </section>

  <!-- ── Section 3 : CTA intermédiaire ── -->
  <section class="bg-cta text-white py-12 md:py-16">
    <div class="container-page text-center flex flex-col items-center gap-4">
      <h2 class="font-serif text-2xl">Prenez rendez-vous</h2>
      <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
         target="_blank" rel="noopener noreferrer"
         class="inline-flex items-center px-6 py-3 bg-white text-cta rounded-full font-semibold hover:bg-surface transition-colors">
        <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
        Réserver un rendez-vous
      </a>
    </div>
  </section>

  <!-- ── Section 4 : Témoignages ── -->
  <section class="section-spacing">
    <div class="container-page flex flex-col gap-10">
      <header class="text-center">
        <p class="text-xs font-semibold uppercase tracking-widest text-accent mb-2">Testimonials</p>
        <h2 class="section-title">Ils m'ont fait <em class="not-italic italic font-serif">confiance</em></h2>
      </header>
      <div class="grid sm:grid-cols-2 md:grid-cols-3 gap-4">
        {{testimonials}}
      </div>
    </div>
  </section>

  <!-- ── Section 5 : FAQ ── -->
  <section class="section-spacing bg-surface-card">
    <div class="container-page max-w-3xl flex flex-col gap-8">
      <header class="text-center">
        <p class="text-xs font-semibold uppercase tracking-widest text-accent mb-2">FAQ</p>
        <h2 class="section-title">Des <em class="not-italic italic font-serif">réponses</em> à vos questions</h2>
      </header>
      <div class="flex flex-col border-t border-border">
        {{faq}}
      </div>
      <div class="text-center">
        <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
           target="_blank" rel="noopener noreferrer"
           class="btn-primary">
          Réserver un rendez-vous
        </a>
      </div>
    </div>
  </section>

</main>

{{footer}}
</body>
</html>
```

## Accroches hero par page

| Page | `{{accroche}}` | Maquette |
|---|---|---|
| gynecologie.html | "Un suivi gynécologique adapté à chaque étape de votre vie" | `service-gynécologie.jpg` |
| douleurs.html | "Prise en charge des douleurs féminines" | `service-douleurs.jpg` |
| acupuncture.html | "L'acupuncture pour votre bien-être" | `service-acupuncture.jpg` |
| hypnose.html | "L'hypnose pour mieux vous accompagner" | `service-hypnose.jpg` |

Les accroches peuvent être ajustées depuis `content/pages/*.md` si nécessaire.

## Ne pas faire

- Ne pas copier les textes des fichiers `.md` dans les templates — `{{content}}` les injecte automatiquement
- Garder la même structure pour les 4 pages (seule l'accroche hero change)

## Vérification locale

```bash
node build.js && npm run preview
# Vérifier chaque page :
# localhost:3000/gynecologie → contre service-gynécologie.jpg
# localhost:3000/acupuncture → contre service-acupuncture.jpg
# localhost:3000/hypnose     → contre service-hypnose.jpg
# localhost:3000/douleurs    → contre service-douleurs.jpg
```

## Prochaine étape

→ `docs/agents/09-seo-build.md` (après 08c terminé)
