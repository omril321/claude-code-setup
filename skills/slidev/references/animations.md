---
name: Animations
description: v-click, v-motion, click ranges, and slide transitions
---

# Animations

## v-click (Reveal on Click)

Basic usage:

```html
<v-click>Appears on click</v-click>

<div v-click>Also works as directive</div>
```

Specific click number:

```html
<div v-click="3">Appears on 3rd click</div>
```

## v-clicks (Animate List Items)

Automatically animates each child:

```html
<v-clicks>

- Item 1
- Item 2
- Item 3

</v-clicks>
```

With depth control:

```html
<v-clicks depth="2">
  <div>
    <p>Level 1</p>
    <p>Level 2</p>
  </div>
</v-clicks>
```

## v-after (With Previous)

Appears with the previous v-click:

```html
<div v-click>First</div>
<div v-after>Appears with First</div>
```

## Hide on Click

```html
<div v-click.hide>Visible initially, hides on click</div>

<div v-click.hide="3">Hides on 3rd click</div>
```

## Click Ranges

Show elements only during specific click range:

```html
<div v-click="[2, 4]">Visible from click 2 to 4</div>

<div v-click="[3, null]">Visible from click 3 onwards</div>
```

## v-motion (Motion Animations)

Animate with @vueuse/motion:

```html
<div
  v-motion
  :initial="{ x: -80, opacity: 0 }"
  :enter="{ x: 0, opacity: 1 }"
  :leave="{ x: 80, opacity: 0 }"
>
  Animated content
</div>
```

### Click-Triggered Motion

```html
<div
  v-motion
  :initial="{ x: -100 }"
  :click-1="{ x: 0 }"
  :click-2="{ x: 100 }"
>
  Moves on clicks
</div>
```

## Slide Transitions

Set default in headmatter:

```yaml
---
transition: slide-left
---
```

Override per slide:

```yaml
---
transition: fade
---
```

### Available Transitions

| Transition | Description |
|------------|-------------|
| `fade` | Fade in/out |
| `fade-out` | Fade out only |
| `slide-left` | Slide from right |
| `slide-right` | Slide from left |
| `slide-up` | Slide from bottom |
| `slide-down` | Slide from top |
| `view-transition` | Browser View Transitions API |

### Directional Transitions

Different transitions based on navigation direction:

```yaml
---
transition: slide-left | slide-right
---
```

Format: `forward-transition | backward-transition`

## Ghost Preview (Show Hidden as Faded)

Override default v-click behavior to show upcoming content as faint preview.

Add to `styles/index.css`:

```css
/* Ghost preview for v-click elements */
.slidev-layout .slidev-vclick-hidden,
.slidev-page .slidev-vclick-hidden {
  opacity: 0.15 !important;
  pointer-events: none !important;
}
```

**Note:** Must use `.slidev-layout` or `.slidev-page` prefix AND `!important` to override Slidev's default `opacity: 0 !important`.
