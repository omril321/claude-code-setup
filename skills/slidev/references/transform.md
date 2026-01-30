---
name: Transform
description: Scale, rotate, and transform content within slides
---

# Transform

Scale, rotate, and transform content using the Transform component.

## Basic Scaling

```html
<Transform scale="0.5">
  Content at half size
</Transform>

<Transform scale="1.5">
  Content at 150%
</Transform>
```

## Rotation

```html
<Transform :rotate="45">
  Rotated 45 degrees
</Transform>

<Transform :rotate="-10">
  Slightly tilted
</Transform>
```

## Combined Transforms

```html
<Transform :scale="0.8" :rotate="5">
  Scaled and rotated
</Transform>
```

## Props

| Prop | Type | Description |
|------|------|-------------|
| `scale` | `number` | Scale factor (1 = 100%) |
| `rotate` | `number` | Rotation in degrees |

## Use Cases

### Fitting Large Content

```html
<Transform scale="0.7">
  <div class="text-4xl">
    Large content that needs to fit
  </div>
</Transform>
```

### Stylistic Effects

```html
<Transform :rotate="-3">
  <div class="bg-yellow-100 p-4 shadow-lg">
    A "sticky note" effect
  </div>
</Transform>
```

### Thumbnail Previews

```html
<Transform scale="0.3">
  <img src="/full-diagram.png" />
</Transform>
```

### Before/After with Rotation

```html
<div class="flex gap-8">
  <Transform :rotate="-5">
    <img src="/before.png" class="w-64" />
    <p class="text-center">Before</p>
  </Transform>

  <Transform :rotate="5">
    <img src="/after.png" class="w-64" />
    <p class="text-center">After</p>
  </Transform>
</div>
```

## With Animations

Combine with v-click:

```html
<v-click>
  <Transform :scale="1.2">
    Zooms in on reveal
  </Transform>
</v-click>
```

## CSS Alternative

For more control, use CSS transforms directly:

```html
<div class="transform scale-75 rotate-12 origin-center">
  CSS-transformed content
</div>
```

UnoCSS/Tailwind utilities:
- `scale-50`, `scale-75`, `scale-100`, `scale-125`, `scale-150`
- `rotate-0`, `rotate-45`, `rotate-90`, `rotate-180`
- `-rotate-45`, `-rotate-90`
- `origin-center`, `origin-top-left`, etc.

## Tips

- Transform component is simpler for basic scaling/rotation
- Use CSS for complex transforms (skew, translate, 3D)
- Content remains interactive after transform
- Combine with absolute positioning for overlays
