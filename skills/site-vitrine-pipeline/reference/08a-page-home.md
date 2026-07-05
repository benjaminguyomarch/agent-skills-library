# Agent 08a — Page d'accueil : src/pages/index.html

## Contexte

Crée le template de la page d'accueil. C'est la page la plus complexe (6 sections). Le build script injectera les marqueurs `{{head}}`, `{{header}}`, `{{footer}}`, `{{testimonials}}`, `{{faq}}`.

Le contenu textuel vient de `content/pages/home.md` via `{{content}}`.

## Prérequis

- Agents 01 à 07 terminés
- Snippets de référence disponibles dans `src/components/`
- Maquette : `docs/assets/maquettes/home-desktop.jpg` + `home-mobile.jpg`

## Fichier à créer

- `src/pages/index.html`

## Implémentation

```html
{{head}}
<body class="bg-surface font-sans text-on-surface min-h-screen flex flex-col">

<a href="#main-content"
   class="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2
          focus:z-50 focus:bg-surface focus:px-3 focus:py-2 focus:rounded">
  Aller au contenu principal
</a>

{{header}}

<main id="main-content" class="flex-1">

  <!-- ── Section 1 : Hero ── -->
  <section class="section-spacing bg-surface">
    <div class="container-page grid md:grid-cols-2 gap-8 md:gap-16 items-center">
      <div class="flex flex-col gap-6">
        <h1 class="font-serif text-3xl md:text-4xl text-on-surface leading-snug">
          Morgane Jacques<br>
          <span class="text-2xl md:text-3xl font-serif text-on-surface-muted">
            Sage-femme,<br>
            Acupunctrice,<br>
            Hypnothérapeute,<br>
            Spécialiste des douleurs féminines.
          </span>
        </h1>
        <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
           target="_blank" rel="noopener noreferrer"
           aria-label="Réserver un rendez-vous (s'ouvre dans un nouvel onglet)"
           class="btn-primary self-start">
          <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
          Réserver un rendez-vous
        </a>
      </div>
      <div class="hidden md:flex flex-col gap-4">
        <!-- Photos du cabinet — à remplacer par de vraies images -->
        <div class="aspect-square bg-border rounded-lg"></div>
      </div>
    </div>
  </section>

  <!-- ── Section 2 : Partenaires ── -->
  <section class="py-8 border-y border-border bg-surface-card">
    <div class="container-page">
      <p class="text-xs font-semibold uppercase tracking-widest text-on-surface-muted mb-6 text-center">
        Engagée pour la santé des femmes
      </p>
      <ul class="flex flex-wrap justify-center gap-6 md:gap-12 text-sm text-on-surface-muted">
        <li class="font-semibold">EndAURA</li>
        <li>Périnée bien-aimé</li>
        <li>CPTS Caluire</li>
        <li>Maison des femmes de Lyon</li>
      </ul>
    </div>
  </section>

  <!-- ── Section 3 : Services ── -->
  <section class="section-spacing">
    <div class="container-page flex flex-col gap-10">
      <header class="text-center">
        <p class="text-xs font-semibold uppercase tracking-widest text-accent mb-2">
          Au service des femmes
        </p>
        <h2 class="section-title">
          Une approche <em class="not-italic italic font-serif">globale</em> des soins
        </h2>
      </header>
      <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">

        <a href="/gynecologie" class="card flex flex-col gap-3 hover:shadow-md transition-shadow group">
          <h3 class="font-semibold text-on-surface group-hover:text-accent transition-colors">Gynécologie</h3>
          <p class="text-on-surface-muted text-sm flex-1">Suivi gynécologique : contraception, frottis, prévention et accompagnement à chaque étape de votre vie.</p>
          <div class="flex flex-wrap gap-1">
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Suivi gynécologique</span>
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Contraception</span>
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Dépistage</span>
          </div>
          <span class="text-accent text-sm font-semibold flex items-center gap-1 mt-auto">
            Découvrir <span class="material-icons text-base" aria-hidden="true">arrow_forward</span>
          </span>
        </a>

        <a href="/acupuncture" class="card flex flex-col gap-3 hover:shadow-md transition-shadow group">
          <h3 class="font-semibold text-on-surface group-hover:text-accent transition-colors">Acupuncture</h3>
          <p class="text-on-surface-muted text-sm flex-1">Médecine traditionnelle pour rééquilibrer les énergies et soulager les symptômes associés.</p>
          <div class="flex flex-wrap gap-1">
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Douleurs</span>
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Anxiété</span>
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Grossesse</span>
          </div>
          <span class="text-accent text-sm font-semibold flex items-center gap-1 mt-auto">
            Découvrir <span class="material-icons text-base" aria-hidden="true">arrow_forward</span>
          </span>
        </a>

        <a href="/hypnose" class="card flex flex-col gap-3 hover:shadow-md transition-shadow group">
          <h3 class="font-semibold text-on-surface group-hover:text-accent transition-colors">Hypnose</h3>
          <p class="text-on-surface-muted text-sm flex-1">Pratique reconnue médicalement permettant de soulager de nombreux maux : stress, douleurs chroniques, fertilité…</p>
          <div class="flex flex-wrap gap-1">
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Douleurs</span>
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Préparation naissance</span>
          </div>
          <span class="text-accent text-sm font-semibold flex items-center gap-1 mt-auto">
            Découvrir <span class="material-icons text-base" aria-hidden="true">arrow_forward</span>
          </span>
        </a>

        <a href="/douleurs" class="card flex flex-col gap-3 hover:shadow-md transition-shadow group">
          <h3 class="font-semibold text-on-surface group-hover:text-accent transition-colors">Douleurs</h3>
          <p class="text-on-surface-muted text-sm flex-1">Prise en charge des douleurs féminines : douleurs pelviennes, dysménorrhées, douleurs sexuelles.</p>
          <div class="flex flex-wrap gap-1">
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Vulvodynies</span>
            <span class="inline-flex px-2 py-0.5 rounded-full text-xs border border-border text-on-surface-muted">Dysménorrhées</span>
          </div>
          <span class="text-accent text-sm font-semibold flex items-center gap-1 mt-auto">
            Découvrir <span class="material-icons text-base" aria-hidden="true">arrow_forward</span>
          </span>
        </a>

      </div>
    </div>
  </section>

  <!-- ── Section 4 : Bloc rendez-vous ── -->
  <section class="section-spacing bg-surface-card">
    <div class="container-page grid md:grid-cols-2 gap-8 md:gap-16 items-center">
      <div class="hidden md:block aspect-[4/5] bg-border rounded-lg">
        <!-- Photo Morgane -->
      </div>
      <div class="flex flex-col gap-6">
        <header>
          <h2 class="section-title">
            Prenez rendez-vous<br>
            <em class="not-italic italic font-serif">en toute simplicité</em>
          </h2>
        </header>
        <div class="text-on-surface-muted space-y-3 text-sm md:text-base">
          <p>J'assure un <strong class="text-on-surface">suivi gynécologique</strong> complet et personnalisé, incluant la contraception, le dépistage et l'<strong class="text-on-surface">IVG médicamenteuse</strong>, avec une approche attentive et bienveillante.</p>
          <p>Je propose également une <strong class="text-on-surface">prise en charge spécialisée des douleurs féminines</strong>, telles que les dyspareunies, le vaginisme, les vulvodynies, les dysménorrhées et l'endométriose.</p>
          <p>Afin d'offrir un accompagnement global et holistique, je propose des pratiques complémentaires comme <strong class="text-on-surface">l'acupuncture</strong> et <strong class="text-on-surface">l'hypnose</strong>, adaptées aussi bien au suivi gynécologique qu'à la grossesse.</p>
        </div>
        <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
           target="_blank" rel="noopener noreferrer"
           aria-label="Réserver un rendez-vous (s'ouvre dans un nouvel onglet)"
           class="btn-primary self-start">
          <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
          Réserver un rendez-vous
        </a>
      </div>
    </div>
  </section>

  <!-- ── Section 5 : Témoignages ── -->
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

  <!-- ── Section 6 : FAQ ── -->
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

## Ne pas faire

- Ne pas dupliquer les textes de `content/pages/home.md` dans ce template — `{{content}}` n'est pas utilisé ici car le contenu est intégré directement dans les sections ci-dessus
- Ne pas hard-coder l'URL Doctolib autrement que comme attribut `href` — elle est dans `content/navigation.json`

## Vérification locale

```bash
node build.js && npm run preview
# → localhost:3000 affiche la page d'accueil
# Vérifier contre docs/assets/maquettes/home-desktop.jpg (desktop)
# Vérifier contre docs/assets/maquettes/home-mobile.jpg (DevTools < 768px)
```

## Prochaine étape

→ `docs/agents/08b-pages-services.md` et `docs/agents/08c-pages-tarifs-contact.md` (parallélisables)
