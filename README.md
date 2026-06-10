# agent-skills-library

Bibliothèque personnelle d'agents et skills pour Claude Code, organisée selon le standard [Agent Skills](https://agentskills.io) — inspirée de [anthropics/skills](https://github.com/anthropics/skills).

## Structure

```
agent-skills-library/
├── CLAUDE.md                  ← instructions globales pour Claude Code
├── README.md                  ← ce fichier
├── template/
│   └── SKILL.md               ← template de départ obligatoire
└── skills/
    └── [nom-du-skill]/
        ├── SKILL.md
        ├── scripts/           ← optionnel
        ├── references/        ← optionnel
        └── assets/            ← optionnel
```

## Utilisation avec Claude Code

Enregistre ce repo comme plugin marketplace :

```bash
/plugin marketplace add benjaminguyomarch/agent-skills-library
```

## Créer un nouveau skill

Copie le template et édite-le :

```bash
cp -r template/ skills/mon-nouveau-skill/
# puis édite skills/mon-nouveau-skill/SKILL.md
```

## Ressources

- [Agent Skills Specification](https://agentskills.io/specification)
- [anthropics/skills](https://github.com/anthropics/skills)
- [Claude Code Docs](https://docs.claude.com)
