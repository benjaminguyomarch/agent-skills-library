# Agent 08 — Pages (index de redirection)

> ⚠️ Cet agent a été divisé en 3 pour éviter une session trop longue.
> Exécuter dans l'ordre : **08a → 08b → 08c** (08b et 08c parallélisables entre elles).

## Agents à exécuter

| Agent | Fichier | Pages |
|---|---|---|
| **08a** | `docs/agents/08a-page-home.md` | `src/pages/index.html` (page d'accueil, 6 sections) |
| **08b** | `docs/agents/08b-pages-services.md` | `src/pages/gynecologie.html`, `douleurs.html`, `acupuncture.html`, `hypnose.html` |
| **08c** | `docs/agents/08c-pages-tarifs-contact.md` | `src/pages/tarifs.html`, `contact.html` |

## Prérequis communs

- Agents 01 à 07 terminés
- Agent 03 (build.js) opérationnel : `node build.js` produit `dist/` sans erreur

## Ressources pour tous les agents 08

- Snippets atoms → `src/components/atoms/`
- Snippets molecules → `src/components/molecules/`
- Snippets organisms → `src/components/organisms/`
- Contenu des pages → `content/pages/*.md`
- Maquettes → `docs/assets/maquettes/`

## Vérification globale (après 08a + 08b + 08c)

```bash
npm run build && npm run preview
```

Vérifier visuellement chaque page en comparant avec les maquettes.
