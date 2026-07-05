# Agent 08c — Pages tarifs + contact

## Contexte

Crée les 2 derniers templates de pages. Ces pages ont des structures spécifiques : grille tarifaire avec filtres interactifs pour tarifs, infos pratiques + CTA Doctolib pour contact.

## Prérequis

- Agent 07 terminé (`<tarif-filter>` disponible dans `src/js/tarif-filter.js`)
- Agent 08a terminé (pattern shell établi)

## Fichiers à créer

- `src/pages/tarifs.html`
- `src/pages/contact.html`

---

## `src/pages/tarifs.html`

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
    <div class="container-page max-w-3xl flex flex-col gap-4">
      <h1 class="font-serif text-3xl md:text-4xl text-on-surface leading-tight">
        Tarifs, conventionnement<br>
        <em class="not-italic italic">et prise en charge</em>
      </h1>
      <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
         target="_blank" rel="noopener noreferrer"
         aria-label="Réserver un rendez-vous (s'ouvre dans un nouvel onglet)"
         class="btn-primary self-start">
        <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
        Réserver un rendez-vous
      </a>
    </div>
  </section>

  <!-- ── Section 2 : Conventionnement + Grille ── -->
  <section class="section-spacing">
    <div class="container-page flex flex-col gap-10">
      <header class="text-center">
        <h2 class="section-title">Des tarifs <em class="not-italic italic font-serif">transparents</em></h2>
      </header>

      <!-- Bloc conventionnement (depuis content via {{content}}) -->
      <div class="max-w-2xl mx-auto content-body text-sm md:text-base">
        {{content}}
      </div>

      <!-- Filtres -->
      <tarif-filter class="flex flex-wrap gap-2">
        <button data-filter="tous"         class="btn-primary text-sm">Tous</button>
        <button data-filter="gynécologie"  class="btn-secondary text-sm">Gynécologie</button>
        <button data-filter="douleurs"     class="btn-secondary text-sm">Douleurs</button>
        <button data-filter="acupuncture"  class="btn-secondary text-sm">Acupuncture</button>
        <button data-filter="hypnose"      class="btn-secondary text-sm">Hypnose</button>
      </tarif-filter>

      <!-- Grille responsive (1 col mobile, 2 cols tablette, 3 cols desktop) -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {{tarifs}}
      </div>

    </div>
  </section>

</main>

{{footer}}
</body>
</html>
```

> Note : `renderTarifCard()` est défini dans l'agent 03 et génère des `<div class="card">` filtrables via `data-group`. La grille est responsive via CSS — aucun rendu double nécessaire.

---

## `src/pages/contact.html`

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
    <div class="container-page max-w-3xl">
      <h1 class="section-title text-3xl md:text-4xl">
        Prenez rendez-vous<br>
        <em class="not-italic italic font-serif">en toute simplicité</em>
      </h1>
    </div>
  </section>

  <!-- ── Section 2 : Infos pratiques ── -->
  <section class="section-spacing">
    <div class="container-page max-w-2xl flex flex-col gap-8">

      <h2 class="section-title text-xl">Informations pratiques</h2>

      <dl class="flex flex-col gap-4 text-sm">
        <div>
          <dt class="font-semibold text-on-surface">Adresse</dt>
          <dd class="text-on-surface-muted">263 Avenue Jean Monnet<br>Résidence CAP OUEST, Allée 263 (Rez-de-chaussée)<br>69300 Caluire-et-Cuire</dd>
        </div>
        <div>
          <dt class="font-semibold text-on-surface">Horaires</dt>
          <dd class="text-on-surface-muted">Lundi au jeudi : 8h00–13h00 / 14h00–19h00</dd>
        </div>
        <div>
          <dt class="font-semibold text-on-surface">Téléphone</dt>
          <dd><a href="tel:+33481914630" class="text-accent hover:underline">04 81 91 46 30</a></dd>
        </div>
      </dl>

      <div class="pt-4 border-t border-border">
        <p class="text-sm text-on-surface-muted mb-3">Prise de rendez-vous en ligne :</p>
        <a href="https://www.doctolib.fr/sage-femme/caluire-et-cuire/morgane-jacques"
           target="_blank" rel="noopener noreferrer"
           aria-label="Réserver sur Doctolib (s'ouvre dans un nouvel onglet)"
           class="btn-primary self-start">
          <span class="material-icons text-base mr-2" aria-hidden="true">calendar_today</span>
          Réserver sur Doctolib
        </a>
      </div>

    </div>
  </section>

</main>

{{footer}}
</body>
</html>
```

## Vérification locale

```bash
node build.js && npm run preview
# localhost:3000/tarifs   → grille tarifaire, filtres fonctionnels
# localhost:3000/contact  → infos pratiques + CTA Doctolib
# Tester filtre "Acupuncture" sur tarifs → seule ligne acupuncture visible
```

## Prochaine étape

→ `docs/agents/09-seo-build.md`
