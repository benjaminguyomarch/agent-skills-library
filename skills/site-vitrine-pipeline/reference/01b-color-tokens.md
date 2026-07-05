# Agent 01b — Color Tokens (enfant de 01-css-foundation)

## Rôle

Agent autonome et itérable. Périmètre strict : modifier les tokens couleur via `content/theme.json`.
Peut être relancé à chaque itération design sans risque pour le reste du code.

## Prérequis

- Agent 01 terminé (`src/styles/tokens.css` généré, `global.css` importé)
- `build.js` contient `generateTokens()` (appel en début de `main()`)

## Références visuelles (à lire avant de modifier)

| Maquette | Couleurs à extraire |
|---|---|
| `docs/assets/components/hero-home.jpg` | cta (bouton Réserver), heading (titres) |
| `docs/assets/components/navbar.jpg` | cta (bouton), active nav pill |
| `docs/assets/components/footer.jpg` | footer-bg (dark navy) |
| `docs/assets/components/content-engagement.jpg` | heading, surface, cta |
| `docs/assets/components/faq.jpg` | heading, on-surface |
| `docs/assets/maquettes/home-desktop.jpg` | vue d'ensemble de la palette |

## Fichier à modifier

`content/theme.json` — **seul fichier à éditer**. Ne pas toucher à `tokens.css` (généré), ni à `global.css`, ni aux composants.

## Structure de `theme.json`

5 groupes — chaque groupe génère un préfixe CSS différent :

```json
{
  "foundations": {        // → --color-*   | bg-*, text-*, border-*
    "surface":          "oklch(97.3% 0.003 67)",
    "surface-card":     "#ffffff",
    "on-surface":       "oklch(20.5% 0.012 49)",
    "on-surface-muted": "oklch(55.6% 0.012 58)",
    "heading":          "oklch(20% 0.08 320)",
    "accent":           "var(--color-amber-600)",
    "border":           "oklch(88.3% 0.006 53)"
  },
  "components": {         // → --color-*   | bg-cta, bg-success...
    "cta":              "oklch(42% 0.12 65)",
    "cta-hover":        "oklch(36% 0.12 65)",
    "success":          "oklch(52% 0.17 145)"
  },
  "sections": {           // → --color-*   | bg-footer-bg...
    "footer-bg":        "oklch(15% 0.04 250)"
  },
  "radius": {             // → --radius-*  | rounded-card, rounded-photo...
    "card":   "0.75rem",
    "photo":  "1rem",
    "pill":   "9999px"
  },
  "spacing": {            // → --spacing-* | py-section, py-section-lg...
    "section":    "3rem",
    "section-lg": "5rem"
  },
  "fonts": {              // → --font-*    | font-sans, font-serif
    "sans":  "'Outfit', ui-sans-serif, system-ui",
    "serif": "'Instrument Serif', ui-serif, serif"
  }
}
```

## Palette Tailwind v4 disponible

Pour référencer une couleur de la palette standard Tailwind :

```json
"cta": "var(--color-amber-700)"
```

Palette utile : `amber-*`, `stone-*`, `purple-*`, `slate-*`.

## Workflow d'itération

1. Lire les maquettes référencées ci-dessus
2. Identifier la couleur à corriger par rôle (cta, heading, etc.)
3. Modifier `content/theme.json`
4. Lancer `npm run build`
5. Vérifier sur `http://localhost:3000` après `npm run preview`
6. Répéter si nécessaire

## Vérification

```bash
npm run build
# src/styles/tokens.css est régénéré automatiquement
grep "cta" src/styles/tokens.css   # vérifier la valeur
npm run preview                     # http://localhost:3000
```

## Ne pas faire

- Ne pas modifier `src/styles/tokens.css` directement — il est écrasé à chaque build
- Ne pas modifier `src/styles/global.css` ni les fichiers `src/styles/components/`
- Ne pas modifier `build.js` — `generateTokens()` est déjà en place
