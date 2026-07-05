# Agent 01 — CSS Foundation : global.css

## Contexte

Crée le fichier CSS central du projet. Il contient les tokens de design (couleurs, fonts) via `@theme` Tailwind v4 et les classes sémantiques réutilisables via `@apply`. Aucun autre fichier CSS ne doit exister — tout passe par celui-ci.

## Prérequis

- Agent 00 terminé (`tailwindcss` installé)

## Fichiers à créer

- `src/styles/global.css` — fichier CSS unique du projet

## Implémentation

### Source de vérité des tokens couleur

Les tokens de design (couleurs et fonts) sont définis dans **`content/theme.json`** — ne jamais les hard-coder dans le CSS.

`build.js` appelle `generateTokens()` en première ligne de `main()` : cette fonction lit `content/theme.json` et génère automatiquement `src/styles/tokens.css` à chaque build.

**Pour itérer sur les couleurs** : modifier `content/theme.json` et relancer `npm run build`. Aucune modification du CSS ni du build script n'est nécessaire.

### Pattern `global.css`

`src/styles/global.css` importe `tokens.css` au lieu de définir les valeurs en dur :

```css
@import "tailwindcss";

/* ── Design Tokens ── */
@import "./tokens.css";

/* ── Base ── */
@layer base {
  :focus-visible {
    @apply outline-none ring-2 ring-cta ring-offset-2;
  }
}

/* ── Classes sémantiques ── */
@layer components {
  /* ... classes @apply ... */
  .section-title { @apply font-serif text-2xl md:text-3xl text-heading; }
}
```

### Fichier généré `src/styles/tokens.css`

Généré par `build.js generateTokens()` depuis `content/theme.json` — **ne pas éditer manuellement** :

```css
/* Généré par build.js depuis content/theme.json — ne pas éditer */
@theme {
  --color-surface: oklch(97.3% 0.003 67);
  --color-surface-card: #ffffff;
  --color-on-surface: oklch(20.5% 0.012 49);
  --color-on-surface-muted: oklch(55.6% 0.012 58);
  --color-heading: oklch(20% 0.08 320);
  --color-accent: var(--color-amber-600);
  --color-border: oklch(88.3% 0.006 53);
  --color-cta: oklch(42% 0.12 65);
  --color-cta-hover: oklch(36% 0.12 65);
  --color-footer-bg: oklch(15% 0.04 250);
  --color-success: oklch(52% 0.17 145);

  --font-sans: 'Outfit', ui-sans-serif, system-ui;
  --font-serif: 'Instrument Serif', ui-serif, serif;
}
```

## Références maquettes

Les valeurs de couleurs ont été extraites des captures suivantes :

- `docs/assets/components/hero-home.jpg`
- `docs/assets/components/footer.jpg`
- `docs/assets/components/content-engagement.jpg`
- `docs/assets/components/faq.jpg`

## Ne pas faire

- Ne pas créer d'autres fichiers CSS
- Ne pas utiliser `tailwind.config.ts` — Tailwind v4 utilise `@theme` dans le CSS
- Ne pas hard-coder de valeurs de couleurs dans les composants — toujours utiliser les classes générées (`bg-surface`, `text-on-surface`, etc.)

## Vérification locale

```bash
npm run build
# Résultat attendu : src/styles/tokens.css généré, dist/styles.css compilé sans erreur

grep "bg-surface" dist/styles.css
# Résultat attendu : la classe .bg-surface est présente dans le CSS compilé

grep "oklch(42%" dist/styles.css
# Résultat attendu : --color-cta: oklch(42% 0.12 65) présent dans le CSS compilé
```

## Prochaine étape

→ `docs/agents/02-partials.md`
