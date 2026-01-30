---
name: Styling
description: UnoCSS utilities, scoped styles, global styles, and theming
---

# Styling

## UnoCSS (Tailwind-Compatible)

Slidev includes UnoCSS with Tailwind-compatible utilities:

```html
<div class="text-center text-2xl font-bold text-blue-500">
  Styled content
</div>

<div class="flex items-center justify-between gap-4 p-4">
  <span class="bg-green-100 rounded-lg px-2 py-1">Tag</span>
</div>
```

### Common Utilities

| Category | Examples |
|----------|----------|
| Text | `text-sm`, `text-xl`, `text-2xl`, `font-bold`, `italic` |
| Color | `text-blue-500`, `bg-gray-100`, `border-red-300` |
| Spacing | `p-4`, `m-2`, `px-6`, `my-8`, `gap-4` |
| Layout | `flex`, `grid`, `items-center`, `justify-between` |
| Size | `w-full`, `h-64`, `max-w-md`, `min-h-screen` |
| Border | `rounded`, `rounded-lg`, `border`, `border-2` |

## Scoped CSS (Per-Slide)

Add styles that only apply to the current slide:

```markdown
# My Slide

Content here

<style>
h1 {
  color: red;
  font-size: 3em;
}

.custom-class {
  background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
}
</style>
```

## Global Styles

Create `styles/index.css` in your project:

```css
/* styles/index.css */
h1 {
  font-weight: 800;
}

.slidev-layout {
  /* Applied to all slide layouts */
}

.slidev-page {
  /* Applied to all pages */
}
```

## V-Click Ghost Preview

Override v-click behavior to show upcoming content as faint preview:

```css
/* styles/index.css */
.slidev-layout .slidev-vclick-hidden,
.slidev-page .slidev-vclick-hidden {
  opacity: 0.15 !important;
  pointer-events: none !important;
}
```

**Important:** Must use `.slidev-layout` or `.slidev-page` prefix AND `!important` to override Slidev's default `opacity: 0 !important`.

Adjust opacity (0.1-0.2 range works well for dark themes).

## Themes

### Using a Theme

```yaml
---
theme: seriph
---
```

### Popular Themes

| Theme | Package |
|-------|---------|
| Default | `@slidev/theme-default` |
| Seriph | `@slidev/theme-seriph` |
| Apple Basic | `slidev-theme-apple-basic` |
| Dracula | `slidev-theme-dracula` |

Install:

```bash
pnpm add slidev-theme-dracula
```

Search themes: https://www.npmjs.com/search?q=keywords%3Aslidev-theme

## CSS Variables

Themes typically define CSS variables you can override:

```css
/* styles/index.css */
:root {
  --slidev-theme-primary: #3b82f6;
  --slidev-code-font-size: 0.9em;
  --slidev-code-line-height: 1.5;
}
```

## Dark Mode

Force color scheme in headmatter:

```yaml
---
colorSchema: dark
---
```

Or let it auto-detect:

```yaml
---
colorSchema: auto
---
```
