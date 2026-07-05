#!/bin/bash
# Installe les skills indispensables au niveau utilisateur (~/.claude/skills)
# → disponibles dans toutes les sessions Claude Code.
# Usage : bash ~/Documents/ressources/agent-skills-library/install-user-skills.sh

set -e
LIB="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude/skills"
mkdir -p "$DEST"

# --- Tes skills maison ---
for s in seo-audit visual-diagram site-vitrine-pipeline design-tokens-setup prd-writer css-architecture; do
  rm -rf "$DEST/$s"
  cp -R "$LIB/skills/$s" "$DEST/$s"
  echo "✓ $s"
done

# --- Sélection anthropics/skills (design & front) ---
for s in frontend-design theme-factory web-artifacts-builder webapp-testing skill-creator; do
  rm -rf "$DEST/$s"
  cp -R "$LIB/external/anthropics-skills/skills/$s" "$DEST/$s"
  echo "✓ $s (anthropics)"
done

echo
echo "Installé dans $DEST — vérifie avec /skills dans Claude Code."
echo "Pour superpowers (méthodologie brainstorm→plan→TDD→debug), installe-le en plugin :"
echo "  claude > /plugin marketplace add obra/superpowers-marketplace"
echo "  claude > /plugin install superpowers@superpowers-marketplace"
