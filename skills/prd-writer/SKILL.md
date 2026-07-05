---
name: prd-writer
description: >
  Writes a structured Product Requirements Document (PRD) and its companion technical
  architecture document for a web app or feature, in French, following a proven
  two-document format (product overview, user roles, functional modules table,
  page-level feature details, user flow, then architecture diagram and tech stack).
  Use when the user asks for a "PRD", "cahier des charges", "spec produit",
  "documentation produit", or before starting any app with more than a few screens.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
  source: Archives/anciens-projets/ds2/.trae/documents/
---

# PRD writer

Produit deux documents complémentaires : le PRD (quoi, pour qui) et le document d'architecture technique (comment). Format validé sur le projet DS2 (Theme Builder Next.js).

## When to use this skill

- Avant de coder toute app/feature multi-écrans
- Formaliser une idée client en spec exploitable par un agent
- Trigger phrases : "PRD", "spec", "cahier des charges", "documente le produit"

Ne **pas** utiliser pour un one-pager marketing ou un simple ticket de bug.

## Process

### Step 1 — PRD (`docs/00_context/prd.md`)

Structure exacte (exemples dans la source) :

1. **Aperçu du produit** — 2 paragraphes : ce que c'est, pour qui, la valeur
2. **Fonctionnalités principales**
   - 2.1 Rôles utilisateur (table : rôle | méthode d'accès | permissions)
   - 2.2 Modules fonctionnels (liste des pages principales et leur rôle)
   - 2.3 Détails des pages (table : page | module | description des fonctionnalités — 1 ligne par module)
3. **Processus principal** — le flux utilisateur numéroté de bout en bout

Règle : chaque fonctionnalité décrite doit être testable (verbe + objet + résultat observable).

### Step 2 — Architecture technique (`docs/90_system/architecture.md`)

1. **Diagramme d'architecture** en Mermaid (`graph TD`) : couches, stockage, services externes
2. **Description technologique** : stack avec versions (`React@19 + Next.js@15 + …`)
3. **Routes** (table : route | rôle)
4. **Modèle de données** si applicable

### Step 3 — Validation croisée

Vérifier que chaque module du PRD (2.3) a sa contrepartie dans l'architecture (route, composant ou service). Tout écart = question à poser avant de coder.
