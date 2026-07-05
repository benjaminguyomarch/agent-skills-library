# Agent 10 — Review Setup

## Rôle

Préparer le prochain dossier de review : créer `docs/0a_reviews/review-NN/` avec les deux fichiers vierges prêts à être complétés manuellement.

## Déclencheur

Lancé manuellement par le product designer avant une nouvelle session de review.

## Ce que l'agent fait

1. Lister `docs/0a_reviews/` pour trouver le dernier `review-NN/` existant → incrémenter de 1
2. Créer `docs/0a_reviews/review-NN/`
3. Y créer deux fichiers vierges :
   - `reviews_N.md` — journal de review à compléter
   - `patch_N.md` — liste de corrections à compléter

## Structure de référence

```
docs/0a_reviews/
├── review-01/         ← baseline manuelle (créée avant l'agent)
│   └── reviews_1.md   ← source de vérité pour la structure des templates
└── review-NN/         ← créé par l'agent (N ≥ 2)
    ├── reviews_N.md   ← à compléter manuellement après la review
    └── patch_N.md     ← à compléter manuellement avec les corrections
```

---

## Template `reviews_N.md`

Structure calquée sur `docs/0a_reviews/review-01/reviews_1.md`.

```markdown
# Retours — review-NN (YYYY-MM-DD)

**Légende :** ✅ point fort · ⚠️ ambigu/manquant · 🔧 ajustement effectué · 💡 suggestion · ❌ non respecté

---

## Suivi des permissions Bash demandées

| # | Commande | Agent | Raison | Statut |
|---|---|---|---|---|
| — | — | — | — | — |

---

## Retours agents

### Agent XX — Nom

#### Permissions demandées
_(à compléter)_

#### Retours
_(à compléter)_

---

## Retours Product Designer

> Observation générale : _(à compléter après vérification visuelle)_

### Analyse du dossier `src/` (état actuel)

_(à compléter)_

### Problèmes UI détaillés

#### Header
_(ref : `docs/assets/components/navbar.jpg`)_

#### Menu mobile
_(ref : `docs/assets/components/menu.jpg`)_

#### Page Home
_(ref : `docs/assets/components/*.jpg`)_

#### Pages services
_(ref : `docs/assets/maquettes/service-*.jpg`)_

#### Témoignages
_(ref : `docs/assets/components/testimonials.jpg`)_

#### Tarifs / Contact
_(ref : `docs/assets/maquettes/page-tarifs.jpg`)_

#### Règle générale
_(observations transversales)_
```

---

## Template `patch_N.md`

```markdown
# Patch review-NN

> Corrections issues de review-(N-1). À implémenter avant review-(N+1).

**Maquettes de référence :** `docs/assets/components/*.jpg` · `docs/assets/maquettes/*.jpg`

---

## Corrections à appliquer

_(reporter ici les [ ] non cochés de patch_(N-1).md, puis ajouter les nouveaux points issus de reviews_N.md)_

- [ ] …

---

## Vérification

```bash
npm run build && npm run preview
```

`npm run preview` ouvre automatiquement `http://localhost:3000`.
Comparer page par page contre les captures dans `docs/assets/`.
```

---

## Règles

- Numérotation : `review-02` → `review-03` etc. (zéro-padded sur 2 chiffres dans le dossier, sans zéro dans le fichier : `reviews_2.md`, `patch_2.md`)
- Ne jamais écraser un dossier existant

## Permissions Bash requises

- `find docs/0a_reviews -maxdepth 1 -name "review-*" -type d | sort` — lister les reviews existantes
- `mkdir` — créer le dossier
