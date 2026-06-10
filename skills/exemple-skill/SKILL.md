---
name: exemple-skill
description: >
  Exemple de skill fonctionnel pour illustrer la structure de la bibliothèque.
  Génère un résumé structuré d'un texte ou document fourni.
  Utiliser quand on demande un résumé, une synthèse, ou un condensé d'un contenu.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# Exemple Skill — Résumé Structuré

Ce skill produit un résumé structuré en 3 parties à partir de n'importe quel texte ou document fourni.

## Quand utiliser ce skill

- L'utilisateur demande un résumé, une synthèse, un condensé
- L'utilisateur partage un texte long et veut en extraire l'essentiel
- Mots-clés déclencheurs : résumé, synthèse, condensé, résume, récapitule, TL;DR

## Instructions

### Étape 1 — Lire le contenu en entier

Lire l'intégralité du texte ou document fourni avant de produire quoi que ce soit.

### Étape 2 — Identifier les 3 éléments clés

Extraire :
1. **L'idée principale** (1 phrase max)
2. **Les points clés** (3 à 5 bullet points)
3. **La conclusion ou recommandation** (1-2 phrases)

### Étape 3 — Produire le résumé structuré

Utiliser ce format de sortie :

```
## Idée principale
[1 phrase]

## Points clés
- [point 1]
- [point 2]
- [point 3]

## Conclusion
[1-2 phrases]
```

## Exemples

**Exemple 1 :**
- Input : article de blog de 1500 mots sur le machine learning
- Output : résumé en 3 sections, ~150 mots

**Exemple 2 :**
- Input : compte-rendu de réunion
- Output : idée principale = décision prise, points clés = actions à faire, conclusion = prochaine étape

## Edge cases et précautions

- Si le texte est trop court (< 100 mots), indiquer qu'un résumé n'est pas nécessaire et restituer le texte tel quel
- Si plusieurs sujets distincts, faire un résumé par sujet
