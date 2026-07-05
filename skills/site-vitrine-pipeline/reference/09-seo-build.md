# Agent 09 — SEO & Build Final

## Contexte

Vérifie et finalise tous les éléments SEO, teste le build complet, et prépare le dossier `dist/` pour le déploiement Netlify. Cette phase n'ajoute pas de nouvelles fonctionnalités — elle vérifie que tout est en ordre.

Référence : `docs/90_system/seo.md`

## Prérequis

- Tous les agents 00 à 08 terminés
- `npm run build` produit `dist/` sans erreur

## Fichiers générés par build.js (à vérifier)

- `dist/index.html` + 6 pages de service
- `dist/styles.css`
- `dist/_redirects`
- `dist/sitemap.xml`
- `dist/robots.txt`
- `dist/js/faq-item.js`
- `dist/js/mobile-nav.js`

> Note : les fichiers JS Custom Elements doivent être **copiés** de `src/js/` vers `dist/js/` par `build.js`. Ajouter cette copie dans le `main()` de `build.js` si ce n'est pas déjà fait :

```js
// Dans build.js, ajouter dans main() :
function copyAssets() {
  fs.mkdirSync('dist/js', { recursive: true })
  fs.copyFileSync('src/js/faq-item.js',   'dist/js/faq-item.js')
  fs.copyFileSync('src/js/mobile-nav.js', 'dist/js/mobile-nav.js')
  console.log('✅ dist/js/ (Custom Elements)')
}
```

## Checklist SEO à vérifier par page

Pour chaque page dans `dist/` :

```bash
# Vérifier title unique
grep "<title>" dist/index.html dist/gynecologie.html dist/tarifs.html

# Vérifier meta description présente
grep 'name="description"' dist/index.html

# Vérifier canonical
grep 'rel="canonical"' dist/index.html

# Vérifier og:tags
grep 'property="og:' dist/index.html
```

## Checklist accessibilité à vérifier

```bash
npm run build && npm run preview
```

Dans le navigateur (DevTools) :
- [ ] Lien d'évitement présent dans le `<body>` (`.sr-only`)
- [ ] `<main id="main-content">` présent
- [ ] Menu mobile : `aria-expanded` change au clic
- [ ] FAQ accordion : `aria-expanded` change au clic
- [ ] Toutes les images ont `alt`
- [ ] Focus visible sur tous les boutons et liens

## Checklist build final

```bash
npm run build
# Vérifier :
# ✅ dist/ contient : index.html + 6 pages + styles.css + _redirects + sitemap.xml + robots.txt + js/
ls dist/

# Vérifier _redirects
cat dist/_redirects
# Attendu : 6 lignes de redirection

# Vérifier sitemap.xml
cat dist/sitemap.xml
# Attendu : 7 <url> entries

# Taille du CSS compilé
wc -c dist/styles.css
# Attendu : < 50KB (indicatif)
```

## Déploiement Netlify

1. `npm run build` → vérifie que `dist/` est propre
2. Aller sur [app.netlify.com](https://app.netlify.com)
3. "Add new site" → "Deploy manually"
4. Glisser-déposer le dossier `dist/`
5. Vérifier les URLs propres : `https://[site].netlify.app/gynecologie` doit fonctionner
6. Vérifier les formulaires : soumettre le formulaire de contact → apparaît dans "Forms" du dashboard

## État final attendu

```
dist/
├── index.html
├── gynecologie.html
├── douleurs.html
├── acupuncture.html
├── hypnose.html
├── tarifs.html
├── contact.html
├── styles.css
├── _redirects
├── sitemap.xml
├── robots.txt
└── js/
    ├── faq-item.js
    └── mobile-nav.js
```

## Prochaine étape

Le projet est terminé et déployable. ✅
