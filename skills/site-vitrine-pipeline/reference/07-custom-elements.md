# Agent 07 — Custom Elements : faq-item.js, mobile-nav.js

## Contexte

Crée les deux Custom Elements vanilla JS qui gèrent l'interactivité du site. Ces fichiers sont chargés via `<script type="module">` dans `head.html`. Aucun framework, aucune dépendance.

Référence : `docs/50_behavior/interactions.md` (spec complète + code)
Référence : `docs/50_behavior/state.md` (gestion d'état)

## Prérequis

- Agent 02 terminé (`head.html` contient les balises `<script>` qui les chargent)

## Fichiers à créer

- `src/js/faq-item.js`
- `src/js/mobile-nav.js`

## Implémentation

### `src/js/faq-item.js`

```js
class FAQItem extends HTMLElement {
  connectedCallback() {
    this.button = this.querySelector('button')
    this.panel  = this.querySelector('[role="region"]')

    if (!this.button || !this.panel) return

    this.button.addEventListener('click', () => this.toggle())
  }

  toggle() {
    const expanded = this.hasAttribute('expanded')
    if (expanded) {
      this.removeAttribute('expanded')
      this.button.setAttribute('aria-expanded', 'false')
      this.panel.setAttribute('aria-hidden', 'true')
    } else {
      this.setAttribute('expanded', '')
      this.button.setAttribute('aria-expanded', 'true')
      this.panel.setAttribute('aria-hidden', 'false')
    }
  }
}

customElements.define('faq-item', FAQItem)
```

### `src/js/mobile-nav.js`

```js
class MobileNav extends HTMLElement {
  connectedCallback() {
    this.trigger = this.querySelector('[slot="trigger"]')
    this.menu    = this.querySelector('[slot="menu"]')
    this.closeBtn = this.querySelector('.mobile-nav-close')

    if (!this.trigger || !this.menu) return

    this.trigger.addEventListener('click', () => this.open())
    this.closeBtn?.addEventListener('click',  () => this.close())

    // Fermer sur clic d'un lien du menu
    this.menu.querySelectorAll('a').forEach(a => {
      a.addEventListener('click', () => this.close())
    })

    // Fermer avec Échap
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && this.isOpen) this.close()
    })
  }

  get isOpen() {
    return this.hasAttribute('open')
  }

  open() {
    this.setAttribute('open', '')
    this.menu.classList.remove('hidden')
    this.trigger.setAttribute('aria-expanded', 'true')
    document.body.style.overflow = 'hidden'
    this._trapFocus()

    // Focus sur le premier élément du menu
    const first = this._focusable()[0]
    first?.focus()
  }

  close() {
    this.removeAttribute('open')
    this.menu.classList.add('hidden')
    this.trigger.setAttribute('aria-expanded', 'false')
    document.body.style.overflow = ''
    this.trigger.focus()
  }

  _focusable() {
    return [...this.menu.querySelectorAll(
      'a, button, input, [tabindex]:not([tabindex="-1"])'
    )]
  }

  _trapFocus() {
    const focusable = this._focusable()
    if (focusable.length === 0) return

    const first = focusable[0]
    const last  = focusable[focusable.length - 1]

    this.menu.addEventListener('keydown', (e) => {
      if (e.key !== 'Tab') return
      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault()
        last.focus()
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault()
        first.focus()
      }
    })
  }
}

customElements.define('mobile-nav', MobileNav)
```

## Ne pas faire

- Ne pas utiliser `localStorage` ou état global
- Ne pas importer de librairies externes
- Ne pas modifier le DOM en dehors du Custom Element lui-même

## Vérification locale

```bash
# Après npm run build + npm run preview :
# 1. Ouvrir localhost:3000 en vue mobile (DevTools < 768px)
# 2. Cliquer hamburger → menu s'ouvre
# 3. Touche Échap → menu se ferme, focus revient sur le bouton
# 4. Tab dans le menu → focus reste dans le menu
# 5. Ouvrir une page avec FAQ → cliquer une question → accordion s'ouvre
# 6. aria-expanded sur le bouton doit être "true" / "false"
```

---

## 3. `<tarif-filter>` — Filtrage de la grille tarifaire

**Fichier :** `src/js/tarif-filter.js`

Gère les boutons de filtre sur la page `/tarifs` (Tous / Gynécologie / Douleurs / Acupuncture / Hypnose). Aucun JS framework, uniquement des attributs `data-*` et du CSS.

### Markup HTML attendu (dans `src/pages/tarifs.html`)

```html
<tarif-filter class="flex flex-wrap gap-2 mb-8">
  <button data-filter="tous"         class="btn-primary text-sm">Tous</button>
  <button data-filter="gynécologie"  class="btn-secondary text-sm">Gynécologie</button>
  <button data-filter="douleurs"     class="btn-secondary text-sm">Douleurs</button>
  <button data-filter="acupuncture"  class="btn-secondary text-sm">Acupuncture</button>
  <button data-filter="hypnose"      class="btn-secondary text-sm">Hypnose</button>
</tarif-filter>

<table class="w-full">
  <tbody>
    <!-- Lignes générées par build.js, chacune avec data-group -->
    <tr data-group="gynécologie">...</tr>
    <tr data-group="acupuncture">...</tr>
    <!-- ... -->
  </tbody>
</table>
```

### Implémentation

```js
// src/js/tarif-filter.js
class TarifFilter extends HTMLElement {
  connectedCallback() {
    this.buttons = [...this.querySelectorAll('button')]
    this.rows    = [...document.querySelectorAll('tr[data-group]')]

    this.buttons.forEach(btn => {
      btn.addEventListener('click', () => this.filter(btn.dataset.filter))
    })
  }

  filter(value) {
    // Mettre à jour les boutons
    this.buttons.forEach(btn => {
      const active = btn.dataset.filter === value
      btn.className = active ? 'btn-primary text-sm' : 'btn-secondary text-sm'
    })

    // Afficher/masquer les lignes
    this.rows.forEach(row => {
      if (value === 'tous' || row.dataset.group === value) {
        row.style.display = ''
      } else {
        row.style.display = 'none'
      }
    })
  }
}

customElements.define('tarif-filter', TarifFilter)
```

### Copie vers dist/

Ajouter dans `copyAssets()` de `build.js` :

```js
fs.copyFileSync('src/js/tarif-filter.js', 'dist/js/tarif-filter.js')
```

Et ajouter le script dans `head.html` :

```html
<script type="module" src="/js/tarif-filter.js"></script>
```

### Vérification

Sur `localhost:3000/tarifs` :
- Cliquer "Acupuncture" → seule la ligne acupuncture visible
- Cliquer "Tous" → toutes les lignes visibles
- Le bouton actif passe en `.btn-primary`, les autres en `.btn-secondary`

## Prochaine étape

→ `docs/agents/08a-page-home.md`
