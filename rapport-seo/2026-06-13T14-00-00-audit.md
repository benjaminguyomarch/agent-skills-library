# Audit SEO — https://morgane-jacques-sage-femme.fr
_2026-06-13T14:00:00 — 7 URLs auditées_

---

## Résumé exécutif

**Statut global : ❌ FAIL**

| Catégorie | Résultat |
|---|---|
| URLs auditées | 7 |
| Checks bloquants en échec | **3** |
| Alertes informatives | 3 |
| Infos | 1 |

Le site est globalement bien construit (titres présents, balises canonical, TLS valide, HSTS activé, images accessibles). Les problèmes bloquants concernent deux lacunes critiques : **l'absence de pages légales obligatoires** (conformité RGPD/loi française) et des **balises meta description manquantes** sur deux pages importantes.

---

## Checks bloquants

| URL | Check | Statut | Détail |
|-----|-------|--------|--------|
| `/` | `<meta description>` | ❌ | Absent |
| `/gynecologie.html` | `<meta description>` | ❌ | Absent |
| Site entier | Mentions légales | ❌ | Aucune URL ne répond 200 (testé : /mentions-legales, /mentions-legales.html, /legal…). Aucun lien dans le HTML |
| Site entier | Politique de confidentialité | ❌ | Aucune URL ne répond 200 (testé : /politique-de-confidentialite, /politique-confidentialite, /privacy…). Aucun lien dans le HTML |

**Autres pages — checks bloquants : ✅ PASS**

| URL | HTTP | Title | Description | Canonical | Noindex |
|-----|------|-------|-------------|-----------|---------|
| `/` | ✅ 200 | ✅ | ❌ | ✅ | ✅ OK |
| `/gynecologie.html` | ✅ 200 | ✅ | ❌ | ✅ | ✅ OK |
| `/acupuncture.html` | ✅ 200 | ✅ | ✅ | ✅ | ✅ OK |
| `/hypnose.html` | ✅ 200 | ✅ | ✅ | ✅ | ✅ OK |
| `/douleurs.html` | ✅ 200 | ✅ | ✅ | ✅ | ✅ OK |
| `/tarifs.html` | ✅ 200 | ✅ | ✅ | ✅ | ✅ OK |
| `/contact.html` | ✅ 200 | ✅ | ✅ | ✅ | ✅ OK |

robots.txt : ✅ `Allow: /` — sitemap déclaré.

---

## Checks informatifs

| Check | Valeur mesurée | Seuil | Statut |
|-------|---------------|-------|--------|
| HSTS | `max-age=31536000` | présent | ✅ |
| X-Frame-Options | `DENY` | présent | ✅ |
| X-Content-Type-Options | `nosniff` | présent | ✅ |
| Referrer-Policy | `strict-origin-when-cross-origin` | présent | ✅ |
| Permissions-Policy | `camera=(), microphone=(), geolocation=()` | présent | ✅ |
| Content-Security-Policy | absent | présent | ⚠️ |
| TLS | expire le 07/09/2026 | > 30 jours | ✅ |
| Mixed content | 0 ressource HTTP | 0 | ✅ |
| JSON-LD / Schema.org | `MedicalBusiness` présent | présent | ✅ |
| Balise H1 | 1 H1 présente | 1 | ✅ |
| Images avec attribut alt | 8/8 | 100 % | ✅ |
| og:title | Présent sur toutes les pages | toutes | ✅ |
| og:description | Absent sur `/` et `/gynecologie.html` | toutes | ⚠️ |
| Core Web Vitals (PageSpeed) | Non testé — quota API dépassé | score ≥ 80 | ℹ️ |

---

## Recommandations priorisées

### 🔴 CRITIQUE

**1. Mentions légales manquantes**

Le site ne dispose d'aucune page de mentions légales accessible, et aucun lien vers une telle page n'est présent dans le HTML. C'est une **obligation légale** en France (loi pour la confiance dans l'économie numérique, 2004) pour tout professionnel de santé. Un contrôle CNIL ou une plainte peut entraîner une mise en demeure.

> Créer une page `/mentions-legales.html` contenant : nom et prénom du praticien, adresse professionnelle, numéro RPPS, hébergeur du site (Netlify), et adresse de contact. Ajouter un lien dans le pied de page.

**2. Politique de confidentialité manquante**

Aucune page de politique de confidentialité (RGPD) n'est trouvée. Le site collecte potentiellement des données via le formulaire de contact (`/contact.html`). Sans cette page, le site n'est pas conforme au RGPD.

> Créer une page `/politique-de-confidentialite.html` précisant : quelles données sont collectées, la durée de conservation, les droits des patients (accès, rectification, suppression), le responsable de traitement. Lien obligatoire dans le pied de page à côté des mentions légales.

**3. Balise `<meta description>` absente sur la homepage et /gynecologie.html**

La page d'accueil et la page gynécologie n'ont pas de meta description. Google génère alors un extrait automatique souvent peu attractif, ce qui réduit le taux de clic dans les résultats de recherche — surtout critique pour la homepage.

> Ajouter sur `/` : `<meta name="description" content="Morgane Jacques, sage-femme diplômée d'État à Caluire-et-Cuire. Consultations en gynécologie, acupuncture, hypnose et prise en charge des douleurs féminines.">` (150 caractères max).
> Ajouter sur `/gynecologie.html` une description dédiée aux soins gynécologiques proposés.

---

### 🟡 ATTENTION

**4. `og:description` absent sur la homepage et /gynecologie.html**

Sans `og:description`, le partage sur les réseaux sociaux (Facebook, LinkedIn, WhatsApp) affichera un aperçu incomplet ou généré automatiquement.

> Ajouter `<meta property="og:description" content="…">` identique à la meta description sur ces deux pages. Ajouter également `og:image` sur toutes les pages (photo du cabinet ou portrait professionnel) pour des partages visuellement attractifs.

**5. Content-Security-Policy (CSP) absent**

L'en-tête CSP manque. Il protège contre les injections de scripts malveillants (XSS). Bien que le site soit statique (faible risque), c'est une bonne pratique recommandée et prise en compte par certains outils de scoring.

> Configurer un en-tête CSP dans les paramètres Netlify (`netlify.toml`) adapté aux ressources du site (scripts Google Fonts, éventuellement Google Analytics).

**6. Core Web Vitals non mesurés**

La clé API PageSpeed Insights n'était pas disponible lors de cet audit. Les performances réelles (LCP, CLS, INP) ne sont pas connues.

> Relancer l'audit avec une clé `PAGESPEED_API_KEY` valide (gratuite sur Google Cloud Console) ou consulter PageSpeed Insights manuellement sur https://pagespeed.web.dev/.

---

### 🔵 INFO

**7. TLS expire le 07/09/2026**

Le certificat est valide pour l'instant (> 30 jours). Netlify renouvelle automatiquement les certificats Let's Encrypt — aucune action requise, mais à surveiller si le domaine est transféré.
