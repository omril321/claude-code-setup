---
name: Draggable Elements
description: Position elements by dragging in development mode
---

# Draggable Elements

Make elements draggable during development for precise positioning.

## Basic Usage

Add `v-drag` directive to any element:

```html
<div v-drag>
  Drag me to position!
</div>
```

## How It Works

1. In development mode, elements with `v-drag` can be dragged
2. Position is saved automatically
3. In production/presentation, elements are fixed at saved position
4. Positions persist across page reloads

## Multiple Draggables

Use unique identifiers:

```html
<div v-drag="'box1'">First box</div>
<div v-drag="'box2'">Second box</div>
<img v-drag="'logo'" src="/logo.png" />
```

## With v-click

Combine with animations:

```html
<div v-drag v-click>
  Appears on click at dragged position
</div>
```

## Practical Examples

### Annotating Diagrams

```html
---
layout: image
image: /architecture.png
---

<div v-drag="'label1'" class="bg-blue-500 text-white px-2 py-1 rounded">
  API Gateway
</div>

<div v-drag="'label2'" class="bg-green-500 text-white px-2 py-1 rounded">
  Database
</div>

<Arrow v-drag="'arrow1'" x1="100" y1="100" x2="200" y2="200" />
```

### Floating Notes

```html
<div v-drag class="bg-yellow-100 p-4 rounded shadow-lg max-w-xs">
  <strong>Note:</strong> This is important!
</div>
```

### Positioned Images

```html
<img v-drag="'photo'" src="/team.jpg" class="w-64 rounded-lg shadow" />
```

## Styling Draggable Elements

Add visual feedback for development:

```css
/* styles/index.css */
[v-drag] {
  cursor: move;
}

/* Optional: show outline during dev */
.slidev-nav-go [v-drag] {
  outline: 2px dashed rgba(0, 100, 255, 0.3);
}
```

## Position Storage

Positions are stored in the slide's frontmatter after dragging:

```yaml
---
dragPos:
  box1: 100,200
  box2: 300,150
---
```

## Tips

- Use meaningful drag IDs for maintainability
- Positions are relative to the slide canvas
- Combine with `position: absolute` for overlay effects
- Works with any HTML element or component
- Reset by removing the `dragPos` from frontmatter

## Limitations

- Dragging only works in development mode
- Positions are slide-specific
- Large elements may need manual CSS adjustments
