# Agent 00b — Vérification du contenu : content/

## Contexte

Vérifie que tous les fichiers `content/` sont valides et complets avant de démarrer le développement. Empêche des erreurs silencieuses dans `build.js` (JSON malformé, frontmatter manquant, champs "À compléter").

Ce script Node.js pur — aucune dépendance, uniquement `fs` et `path`.

## Prérequis

- Node.js 18+ installé (pas besoin de `npm install`)

## Fichier à créer

- `check-content.js` à la racine

## Implémentation

```js
// check-content.js
import fs   from 'fs'
import path from 'path'

let errors   = 0
let warnings = 0

function ok(msg)   { console.log(`  ✅ ${msg}`) }
function warn(msg) { console.warn(`  ⚠️  ${msg}`); warnings++ }
function fail(msg) { console.error(`  ❌ ${msg}`); errors++ }

// ── 1. Fichiers JSON ──────────────────────────────────────────────────────────

console.log('\n📂 JSON files\n')

const jsonFiles = [
  'content/navigation.json',
  'content/temoignages.json',
  'content/faq.json',
  'content/tarifs.json',
]

for (const file of jsonFiles) {
  try {
    const raw  = fs.readFileSync(file, 'utf-8')
    const data = JSON.parse(raw)
    ok(`${file} — JSON valide (${Array.isArray(data) ? data.length + ' items' : 'object'})`)
  } catch (e) {
    fail(`${file} — ${e.message}`)
  }
}

// ── 2. Champs "À compléter" dans faq.json ────────────────────────────────────

console.log('\n📋 FAQ — champs incomplets\n')

try {
  const faq = JSON.parse(fs.readFileSync('content/faq.json', 'utf-8'))
  for (const item of faq) {
    if (!item.question || item.question.includes('compléter')) {
      warn(`faq.json ID ${item.id} (tag: ${item.tag}) — question manquante`)
    }
    if (!item.reponse || item.reponse.includes('compléter')) {
      warn(`faq.json ID ${item.id} (tag: ${item.tag}) — réponse manquante`)
    }
  }
  if (warnings === 0) ok('Toutes les FAQ sont renseignées')
} catch {}

// ── 3. Témoignages tronqués ───────────────────────────────────────────────────

console.log('\n💬 Témoignages — textes tronqués\n')

try {
  const temoignages = JSON.parse(fs.readFileSync('content/temoignages.json', 'utf-8'))
  for (const t of temoignages) {
    if (t.texte && t.texte.endsWith('...')) {
      warn(`temoignages.json ID ${t.id} (${t.auteur}) — texte tronqué`)
    }
    if (!t.texte || !t.extrait) {
      fail(`temoignages.json ID ${t.id} — champ texte ou extrait manquant`)
    }
  }
} catch {}

// ── 4. Fichiers Markdown ──────────────────────────────────────────────────────

console.log('\n📝 Pages Markdown\n')

const requiredPages = [
  'content/pages/home.md',
  'content/pages/gynecologie.md',
  'content/pages/douleurs.md',
  'content/pages/acupuncture.md',
  'content/pages/hypnose.md',
  'content/pages/tarifs.md',
  'content/pages/contact.md',
]

const requiredFrontmatter = ['title', 'description', 'slug']

for (const file of requiredPages) {
  if (!fs.existsSync(file)) {
    fail(`${file} — fichier manquant`)
    continue
  }
  const raw = fs.readFileSync(file, 'utf-8')

  // Extraire frontmatter YAML manuellement (entre les --- )
  const match = raw.match(/^---\r?\n([\s\S]*?)\r?\n---/)
  if (!match) {
    fail(`${file} — frontmatter YAML absent`)
    continue
  }

  const frontmatter = match[1]
  for (const field of requiredFrontmatter) {
    if (!frontmatter.includes(`${field}:`)) {
      fail(`${file} — champ frontmatter manquant : ${field}`)
    }
  }

  if (raw.includes('À compléter') || raw.includes('A compléter')) {
    warn(`${file} — contient "À compléter"`)
  }

  ok(`${file}`)
}

// ── Résumé ────────────────────────────────────────────────────────────────────

console.log('\n─────────────────────────────────────────')
console.log(`Résultat : ${errors} erreur(s), ${warnings} avertissement(s)\n`)

if (errors > 0) {
  console.error('❌ Des erreurs bloquantes ont été trouvées. Corriger avant de lancer le build.')
  process.exit(1)
} else if (warnings > 0) {
  console.warn('⚠️  Des avertissements ont été trouvés. Le build fonctionnera mais le contenu est incomplet.')
} else {
  console.log('✅ Tout le contenu est valide. Prêt pour le build.')
}
```

## Ajouter dans `package.json`

```json
"check": "node check-content.js"
```

## Ne pas faire

- Ne pas modifier les fichiers `content/` — ce script est read-only
- Ne pas installer de dépendances supplémentaires

## Vérification

```bash
node check-content.js
# Résultat attendu :
# ✅ content/navigation.json — JSON valide (object)
# ✅ content/temoignages.json — JSON valide (50 items)
# ⚠️  faq.json ID 19 (tag: hypnose) — question manquante
# ⚠️  temoignages.json ID 3 (Jessim Rahab) — texte tronqué
# ...
# Résultat : 0 erreur(s), 3 avertissement(s)
```

## Prochaine étape

→ `docs/agents/00-setup.md`
