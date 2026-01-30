---
name: Zoom
description: Zoom into content within slides
---

# Zoom

Zoom into specific areas or content within slides.

## Zoom Component

```html
<Zoom scale="2">
  Content displayed at 2x zoom
</Zoom>
```

## Props

| Prop | Type | Description |
|------|------|-------------|
| `scale` | `number` | Zoom factor (1 = normal, 2 = 2x zoom) |

## Use Cases

### Highlighting Details

```html
<div class="grid grid-cols-2 gap-4">
  <img src="/full-image.png" />

  <Zoom scale="3">
    <img src="/full-image.png" class="object-cover"
         style="object-position: 20% 30%;" />
  </Zoom>
</div>
```

### Code Focus

```html
<Zoom scale="1.5">

```ts
const key = "focus on this"
```

</Zoom>
```

### Text Emphasis

```html
<Zoom scale="1.3">
  <span class="text-red-500 font-bold">Important!</span>
</Zoom>
```

## With v-click

Zoom on reveal:

```html
<v-click>
  <Zoom scale="2">
    Zooms in when revealed
  </Zoom>
</v-click>
```

## Zoom vs Transform

| Zoom | Transform |
|------|-----------|
| Enlarges content | Scales container |
| Content may overflow | Container scales with content |
| Good for emphasis | Good for fitting content |

## CSS Zoom Alternative

For browser-native zoom:

```html
<div style="zoom: 1.5;">
  Zoomed with CSS
</div>
```

Note: CSS `zoom` is non-standard but widely supported.

## Keyboard Zoom

During presentation:
- Browser zoom (`Cmd/Ctrl + +/-`) affects the whole page
- Overview mode (`o`) shows slide thumbnails

## Tips

- Use zoom sparingly for emphasis
- Combine with cropping for detail callouts
- Test on different screen sizes
- High zoom values may pixelate raster images
