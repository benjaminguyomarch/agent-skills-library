# Agent 03 — Build Script : build.js

## Contexte

C'est la pièce centrale du projet. `build.js` lit les sources (`content/`, `src/`), assemble les pages HTML et génère `dist/`. Sans ce script, rien ne peut être prévisualisé. Il doit être implémenté en entier dans cette session.

## Prérequis

- Agents 00, 01, 02 terminés
- `content/` complet (navigation.json, temoignages.json, faq.json, tarifs.json, pages/*.md)
- `src/partials/` complet (head.html, header.html, footer.html)

## Fichiers à créer

- `build.js` — à la racine du projet

## Architecture du script

```
build.js
├── Helpers utilitaires
│   ├── readFile(path)         → string
│   ├── writeFile(path, html)  → void (crée les dossiers si nécessaire)
│   └── inject(template, vars) → remplace {{key}} par vars[key]
│
├── Données globales (chargées une fois)
│   ├── navigation   ← content/navigation.json
│   ├── temoignages  ← content/temoignages.json
│   ├── faq          ← content/faq.json
│   └── tarifs       ← content/tarifs.json
│
├── Partials globaux (chargés une fois)
│   ├── headPartial    ← src/partials/head.html
│   ├── headerPartial  ← src/partials/header.html
│   └── footerPartial  ← src/partials/footer.html
│
├── Factory functions (HTML depuis JSON)
│   ├── renderNavLinks(links, activePath, mobile)
│   ├── renderTestimonialCard(temoignage)
│   ├── renderFAQItem(faqItem)
│   └── renderTarifRow(tarif)
│
├── buildPage(pageSlug)
│   ├── Lire content/pages/{slug}.md
│   ├── Parser frontmatter + body (gray-matter)
│   ├── Convertir body en HTML (marked)
│   ├── Assembler head + header + main + footer
│   └── Écrire dist/{slug}.html
│
├── generateRedirects()  → dist/_redirects
├── generateSitemap()    → dist/sitemap.xml
├── generateRobots()     → dist/robots.txt
│
└── main()               → buildPage × 7 + generateRedirects + Sitemap + Robots
```

## Implémentation complète

```js
// build.js
import fs   from 'fs'
import path from 'path'
import { marked }    from 'marked'
import matter        from 'gray-matter'

// ── Helpers ──────────────────────────────────────────────────────────────────

function readFile(filePath) {
  return fs.readFileSync(filePath, 'utf-8')
}

function writeFile(filePath, content) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true })
  fs.writeFileSync(filePath, content, 'utf-8')
}

// Remplace toutes les occurrences de {{key}} par vars[key]
function inject(template, vars) {
  return template.replace(/\{\{(\w[\w-]*)\}\}/g, (_, key) => vars[key] ?? '')
}

// ── Données globales ──────────────────────────────────────────────────────────

const navigation  = JSON.parse(readFile('content/navigation.json'))
const temoignages = JSON.parse(readFile('content/temoignages.json'))
const faqItems    = JSON.parse(readFile('content/faq.json'))
const tarifs      = JSON.parse(readFile('content/tarifs.json'))

// ── Partials ──────────────────────────────────────────────────────────────────

const headPartial   = readFile('src/partials/head.html')
const headerPartial = readFile('src/partials/header.html')
const footerPartial = readFile('src/partials/footer.html')

// ── Factory functions ─────────────────────────────────────────────────────────

function renderNavLinks(links, activePath = '/', mobile = false) {
  return links.map(link => {
    const isActive = link.href === activePath
    const ariaCurrent = isActive ? ' aria-current="page"' : ''
    if (mobile) {
      return `<a href="${link.href}" class="block py-3 text-on-surface font-sans text-lg border-b border-border"${ariaCurrent}>${link.label}</a>`
    }
    return `<a href="${link.href}" class="nav-link"${ariaCurrent}>${link.label}</a>`
  }).join('\n      ')
}

function renderTestimonialCard({ auteur, date, extrait, note }) {
  const stars = '★'.repeat(note)
  return `
    <div class="card flex flex-col gap-3">
      <p class="text-on-surface-muted text-sm">${auteur} · ${date}</p>
      <p class="text-on-surface italic">"${extrait}"</p>
      <span class="text-accent text-sm" aria-label="${note} étoiles sur 5">${stars}</span>
    </div>`
}

function renderFAQItem({ question, reponse }, index) {
  const panelId = `faq-panel-${index}`
  return `
    <faq-item class="block border-b border-border">
      <button class="w-full text-left flex justify-between items-center py-4 font-sans font-semibold text-on-surface"
              aria-expanded="false"
              aria-controls="${panelId}">
        <span>${question}</span>
        <span class="material-icons text-on-surface-muted" aria-hidden="true">expand_more</span>
      </button>
      <div id="${panelId}" role="region" aria-hidden="true" class="faq-panel">
        <p class="pb-4 text-on-surface-muted">${reponse}</p>
      </div>
    </faq-item>`
}

function renderTarifCard({ groupe, service, conventionne, prix }) {
  const badge = conventionne
    ? '<span class="text-xs bg-green-50 text-green-700 border border-green-200 px-2 py-0.5 rounded-full">Conventionné</span>'
    : '<span class="text-xs bg-surface border border-border px-2 py-0.5 rounded-full text-on-surface-muted">Non conventionné</span>'
  return `
    <div class="card flex flex-col gap-2" data-group="${groupe.toLowerCase()}">
      <p class="font-semibold text-on-surface">${service}</p>
      ${badge}
      <p class="text-on-surface font-bold text-lg mt-auto">${prix}</p>
    </div>`
}

// ── Build d'une page ──────────────────────────────────────────────────────────

function buildPage(slug, contentFile) {
  const raw = readFile(`content/pages/${contentFile}.md`)
  const { data: meta, content: body } = matter(raw)
  const htmlContent = marked(body)

  // Injection nav avec lien actif
  const navLinks       = renderNavLinks(navigation.links, meta.slug || `/${slug === 'index' ? '' : slug}`)
  const navLinksMobile = renderNavLinks(navigation.links, meta.slug || `/${slug === 'index' ? '' : slug}`, true)
  const ctaHref        = navigation.cta.href

  const head = inject(headPartial, {
    title:          meta.title       || 'Morgane Jacques',
    description:    meta.description || '',
    slug:           meta.slug        || (slug === 'index' ? '/' : `/${slug}`),
    ogTitle:        meta.ogTitle     || meta.title || '',
    ogDescription:  meta.ogDescription || meta.description || '',
  })

  const header = inject(headerPartial, {
    'nav-links':        navLinks,
    'nav-links-mobile': navLinksMobile,
    'cta-href':         ctaHref,
  })

  // Sections spécifiques à la page (depuis src/pages/{slug}.html si il existe)
  const pageTemplatePath = `src/pages/${slug}.html`
  let mainContent = htmlContent  // fallback : corps MD converti

  if (fs.existsSync(pageTemplatePath)) {
    const pageTemplate = readFile(pageTemplatePath)

    // Injection des données dynamiques dans le template de page
    const filteredTemoignages = slug === 'index'
      ? temoignages.slice(0, 6)
      : temoignages.filter(t => t.tag === slug).slice(0, 4)

    const filteredFaq = slug === 'index'
      ? faqItems.filter(f => f.tag === 'home')
      : faqItems.filter(f => f.tag === slug)

    const accroches = {
      gynecologie: 'Un suivi gynécologique adapté à chaque étape de votre vie',
      douleurs:    'Prise en charge des douleurs féminines',
      acupuncture: "L'acupuncture pour votre bien-être",
      hypnose:     "L'hypnose pour mieux vous accompagner",
    }

    mainContent = inject(pageTemplate, {
      content:      htmlContent,
      accroche:     accroches[slug] || '',
      testimonials: filteredTemoignages.map(renderTestimonialCard).join(''),
      faq:          filteredFaq.map((f, i) => renderFAQItem(f, i)).join(''),
      tarifs:       slug === 'tarifs'
                      ? tarifs.map(renderTarifCard).join('')
                      : '',
    })
  }

  const page = `<!DOCTYPE html>
<html lang="fr">
<head>
${head}
</head>
<body class="bg-surface font-sans text-on-surface min-h-screen flex flex-col">
<a href="#main-content" class="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:bg-surface focus:px-3 focus:py-2 focus:rounded">
  Aller au contenu principal
</a>
${header}
<main id="main-content" class="flex-1">
${mainContent}
</main>
${footerPartial}
</body>
</html>`

  const outFile = slug === 'index' ? 'dist/index.html' : `dist/${slug}.html`
  writeFile(outFile, page)
  console.log(`✅ ${outFile}`)
}

// ── Fichiers statiques ────────────────────────────────────────────────────────

function generateRedirects() {
  const lines = navigation.links
    .filter(l => l.href !== '/')
    .map(l => `${l.href}    ${l.href.slice(1)}.html    200`)
    .join('\n')
  writeFile('dist/_redirects', lines)
  console.log('✅ dist/_redirects')
}

function generateSitemap() {
  const base = 'https://www.morgane-jacques-sages-femmes.fr'
  const urls = navigation.links.map(l => `  <url>
    <loc>${base}${l.href === '/' ? '' : l.href}</loc>
    <priority>${l.href === '/' ? '1.0' : '0.9'}</priority>
    <changefreq>monthly</changefreq>
  </url>`).join('\n')
  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls}
</urlset>`
  writeFile('dist/sitemap.xml', xml)
  console.log('✅ dist/sitemap.xml')
}

function generateRobots() {
  const content = `User-agent: *
Allow: /
Sitemap: https://www.morgane-jacques-sages-femmes.fr/sitemap.xml`
  writeFile('dist/robots.txt', content)
  console.log('✅ dist/robots.txt')
}

// ── Main ──────────────────────────────────────────────────────────────────────

function main() {
  console.log('🔨 Build en cours...\n')

  const pages = [
    { slug: 'index',       file: 'home' },
    { slug: 'gynecologie', file: 'gynecologie' },
    { slug: 'douleurs',    file: 'douleurs' },
    { slug: 'acupuncture', file: 'acupuncture' },
    { slug: 'hypnose',     file: 'hypnose' },
    { slug: 'tarifs',      file: 'tarifs' },
    { slug: 'contact',     file: 'contact' },
  ]

  pages.forEach(({ slug, file }) => buildPage(slug, file))

  generateRedirects()
  generateSitemap()
  generateRobots()
  copyAssets()

  console.log('\n✅ Build terminé → dist/')
}

// ── Copie des assets statiques ─────────────────────────────────────────────

function copyAssets() {
  fs.mkdirSync('dist/js', { recursive: true })
  fs.readdirSync('src/js').forEach(file => {
    fs.copyFileSync(`src/js/${file}`, `dist/js/${file}`)
  })
  console.log('✅ dist/js/ (Custom Elements)')
}

main()
```

## Ne pas faire

- Ne pas utiliser `require()` — le projet utilise ES modules (`import`), `"type": "module"` est dans package.json
- Ne pas rendre le Markdown côté client — `marked()` s'exécute uniquement dans ce script
- Ne pas modifier les fichiers dans `content/` — lecture seule
- Ne pas créer de fichiers en dehors de `dist/`

## Note sur package.json

Ajouter `"type": "module"` dans `package.json` pour activer les ES modules :

```json
{
  "type": "module",
  ...
}
```

## Vérification locale

```bash
node build.js
# Résultat attendu :
# ✅ dist/index.html
# ✅ dist/gynecologie.html
# ... (7 pages + _redirects + sitemap.xml + robots.txt)
# ✅ Build terminé → dist/

npm run preview
# Résultat attendu : navigateur s'ouvre sur localhost:3000
# La page d'accueil affiche le contenu de content/pages/home.md
```

## Prochaine étape

→ `docs/agents/04-atoms.md` (parallélisable avec 05 et 06 après que le build fonctionne)
