# Agent 00 — Setup : setup.sh + package.json

## Contexte

Configure les **outils de build** uniquement. Node.js n'est pas un framework frontend — il joue le rôle d'un compilateur : il lit les sources et génère les fichiers HTML/CSS statiques dans `dist/`. Ce que le navigateur reçoit est 100% vanilla (HTML + CSS + Custom Elements natifs), sans aucune trace de Node.

**Séparation claire :**
- `node_modules/` + `build.js` → existent uniquement en dev, sur ta machine
- `dist/` → ce qui est déployé sur Netlify : HTML pur, CSS compilé, JS vanilla

C'est le même principe que Tailwind CLI : Node compile `global.css`, le navigateur ne voit que le CSS final.

## Prérequis

- Node.js 18+ installé
- Être à la racine du projet (`/morgane-jacques-site-vitrine 2/`)

## Fichiers à créer

- `setup.sh` — script d'installation automatisé
- `package.json` — configuration npm avec tous les scripts

## Implémentation

### `setup.sh`

```bash
#!/bin/bash
set -e

echo "Vérification Node.js..."
NODE_MAJOR=$(node -v | cut -d. -f1 | tr -d 'v')
[ "$NODE_MAJOR" -lt 18 ] && echo "❌ Node.js 18+ requis. Version actuelle : $(node -v)" && exit 1
echo "✅ Node.js $(node -v)"

echo "Initialisation du projet..."
npm init -y

echo "Installation des dépendances..."
npm install -D tailwindcss          # Tailwind v4 (CLI inclus)
npm install -D marked               # Markdown → HTML
npm install -D gray-matter          # Parsing frontmatter YAML
npm install -D chokidar-cli         # Watch mode
npm install -D http-server          # Serveur local

echo ""
echo "✅ Installation terminée."
echo ""
echo "Commandes disponibles :"
echo "  npm run build    → build complet vers dist/"
echo "  npm run dev      → watch mode (rebuild automatique)"
echo "  npm run preview  → serveur local → localhost:3000"
```

### `package.json`

```json
{
  "name": "morgane-jacques-site",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "build":   "node build.js && tailwindcss -i src/styles/global.css -o dist/styles.css --minify",
    "dev":     "chokidar 'src/**/*' 'content/**/*' -c 'node build.js' & tailwindcss -i src/styles/global.css -o dist/styles.css --watch",
    "css":     "tailwindcss -i src/styles/global.css -o dist/styles.css",
    "preview": "http-server dist -p 3000 -o"
  },
  "devDependencies": {}
}
```

> Note : `devDependencies` sera rempli automatiquement par `npm install -D`.

## Ne pas faire

- Ne pas installer `@tailwindcss/cli` — Tailwind v4 inclut son propre CLI dans le package `tailwindcss`
- Ne pas initialiser de dépôt git (le projet peut déjà en avoir un)
- Ne pas créer de fichiers autres que `setup.sh` et `package.json`

## Vérification locale

```bash
bash setup.sh
# Résultat attendu : "✅ Installation terminée."

node -e "require('marked'); require('gray-matter'); console.log('✅ Dépendances OK')"
# Résultat attendu : "✅ Dépendances OK"

npx tailwindcss --version
# Résultat attendu : version 4.x.x
```

## Prochaine étape

→ `docs/agents/01-css-foundation.md`
