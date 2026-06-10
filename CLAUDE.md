# Agent Skills Library — Instructions pour Claude Code

Tu es l'assistant principal de ce dépôt. Ce repo est une **bibliothèque personnelle d'agents et de skills** organisée selon le standard Agent Skills (agentskills.io), inspirée de `anthropics/skills`.

---

## Structure du repo

```
agent-skills-library/
├── CLAUDE.md                  ← ce fichier (instructions globales)
├── README.md                  ← documentation humaine du repo
├── template/
│   └── SKILL.md               ← template de départ obligatoire
├── skills/
│   ├── mon-skill-1/
│   │   ├── SKILL.md
│   │   ├── scripts/           ← optionnel
│   │   ├── references/        ← optionnel
│   │   └── assets/            ← optionnel
│   └── mon-skill-2/
│       └── SKILL.md
└── .claude-plugin/            ← optionnel, pour Claude Code plugin
```

---

## Règles impératives

### Quand tu crées un nouveau skill

1. **Toujours partir du template** situé dans `template/SKILL.md`
2. **Créer un dossier** dont le nom correspond exactement au champ `name` du frontmatter
3. **Valider le frontmatter** selon les règles ci-dessous avant d'écrire quoi que ce soit
4. **Ne jamais modifier** un skill existant sans lire son `SKILL.md` en entier d'abord

### Format SKILL.md obligatoire

Chaque skill doit commencer par un frontmatter YAML **strict** :

```yaml
---
name: nom-du-skill          # requis — voir règles ci-dessous
description: |              # requis — voir règles ci-dessous
  Ce que fait le skill et dans quels cas l'utiliser.
license: Apache-2.0         # optionnel
compatibility: |            # optionnel
  Environnement requis (ex: Python 3.10+, accès réseau, etc.)
metadata:
  author: benjaminguyomarch
  version: "1.0"
---
```

**Règles pour `name` :**
- Uniquement minuscules, chiffres, tirets
- Entre 1 et 64 caractères
- Ne commence pas et ne finit pas par un tiret
- Pas de doubles tirets (`--`)
- Doit correspondre exactement au nom du dossier parent

**Règles pour `description` :**
- Entre 1 et 1024 caractères
- Doit décrire **ce que fait** le skill ET **quand l'utiliser**
- Inclure des mots-clés précis pour aider à l'activation automatique

---

## Template de référence

Quand tu crées un skill, utilise systématiquement cette structure :

```markdown
---
name: nom-du-skill
description: >
  [Ce que fait le skill — verbes d'action concrets].
  Utiliser quand [conditions / mots-clés déclencheurs].
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Nom du Skill

Résumé en 1-2 phrases de ce que ce skill accomplit.

## Quand utiliser ce skill

- Cas d'usage 1
- Cas d'usage 2
- Mots-clés déclencheurs : [liste]

## Instructions

### Étape 1 — [Nom de l'étape]
[Instructions détaillées]

### Étape 2 — [Nom de l'étape]
[Instructions détaillées]

## Exemples

**Exemple 1 :**
- Input : [description]
- Output attendu : [description]

## Edge cases et précautions

- [Cas limite 1]
- [Cas limite 2]

## Références

- Voir [references/REFERENCE.md](references/REFERENCE.md) si applicable
```

---

## Chargement progressif (progressive disclosure)

Respecte toujours cette hiérarchie de taille :

| Niveau | Contenu | Taille recommandée |
|---|---|---|
| Métadonnées | `name` + `description` | ~100 tokens |
| Instructions | Corps du `SKILL.md` | < 5000 tokens / 500 lignes |
| Ressources | `scripts/`, `references/`, `assets/` | chargé à la demande |

Si un `SKILL.md` dépasse 500 lignes, **extraire** le contenu détaillé dans `references/REFERENCE.md`.

---

## Quand on te demande d'utiliser un skill existant

1. Lire le `SKILL.md` du skill concerné en entier
2. Identifier si des fichiers dans `scripts/` ou `references/` sont nécessaires
3. Suivre les instructions du skill à la lettre
4. Si le skill est incomplet ou ambigu, le signaler avant de continuer

---

## Quand on te demande de créer un nouveau skill

1. Demander : quel est l'objectif précis ? quels mots-clés doivent déclencher ce skill ?
2. Copier `template/SKILL.md` dans `skills/[nom-du-skill]/SKILL.md`
3. Remplir tous les champs
4. Proposer 2-3 prompts de test réalistes pour valider le skill
5. Ne pas commit tant que les tests ne sont pas validés

---

## Conventions Git

- Un commit par skill créé ou modifié
- Message de commit : `skill(nom-du-skill): [action]`
- Ex: `skill(pdf-reader): initial version`

---

## Priorités en cas de conflit

1. Les instructions dans le `SKILL.md` d'un skill activé priment sur ce `CLAUDE.md`
2. Ce `CLAUDE.md` prime sur le comportement par défaut de Claude Code
3. En cas de doute, demander plutôt qu'assumer
