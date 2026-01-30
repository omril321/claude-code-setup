---
name: Components
description: Built-in Slidev components - Arrow, Link, Toc, Transform, Tweet, Youtube, and more
---

# Components

## Arrow

Draw arrows between points:

```html
<Arrow x1="10" y1="20" x2="100" y2="200" />
<Arrow x1="10" y1="20" x2="100" y2="200" two-way />
```

| Prop | Description | Default |
|------|-------------|---------|
| `x1`, `y1` | Start point (required) | - |
| `x2`, `y2` | End point (required) | - |
| `width` | Line width | `2` |
| `color` | Arrow color | `currentColor` |
| `two-way` | Double-headed arrow | `false` |

## Link (Slide Navigation)

```html
<Link to="42" title="Go to slide 42"/>
<Link to="summary" title="Jump to Summary"/>
```

Use slide number or slide name (set via frontmatter `name` property).

## Toc (Table of Contents)

```html
<Toc />
<Toc columns="2" maxDepth="2" />
```

| Prop | Description | Default |
|------|-------------|---------|
| `columns` | Number of columns | `1` |
| `maxDepth` | Maximum heading depth | `Infinity` |
| `minDepth` | Minimum heading depth | `1` |
| `mode` | Display mode | `all` |

Modes: `all`, `onlyCurrentTree`, `onlySiblings`

## Transform (Scaling)

```html
<Transform scale="0.5">
  Content at half size
</Transform>

<Transform :scale="1.2" :rotate="10">
  Scaled and rotated
</Transform>
```

| Prop | Description |
|------|-------------|
| `scale` | Scale factor |
| `rotate` | Rotation in degrees |

## LightOrDark (Theme Conditional)

```html
<LightOrDark>
  <template #dark>Dark mode content</template>
  <template #light>Light mode content</template>
</LightOrDark>
```

## Tweet

Embed a tweet:

```html
<Tweet id="1234567890" />
<Tweet id="1234567890" scale="0.8" />
```

## Youtube

Embed YouTube video:

```html
<Youtube id="dQw4w9WgXcQ" />
<Youtube id="dQw4w9WgXcQ?start=60" width="600" height="400" />
```

## SlidevVideo

Custom video player:

```html
<SlidevVideo autoplay controls>
  <source src="/video.mp4" type="video/mp4" />
</SlidevVideo>
```

| Prop | Description | Values |
|------|-------------|--------|
| `controls` | Show controls | boolean |
| `autoplay` | Auto-play behavior | `true`, `'once'`, `false` |
| `autoreset` | Reset timing | `'slide'`, `'click'` |
| `poster` | Poster image | path |
| `timestamp` | Start time | number |

## SlideCurrentNo / SlidesTotal

Display slide numbers:

```html
Slide <SlideCurrentNo /> of <SlidesTotal />
```

## RenderWhen

Conditionally render based on context:

```html
<RenderWhen context="presenter">
  Only visible in presenter mode
</RenderWhen>

<RenderWhen context="slide">
  Only visible in slide view
</RenderWhen>
```

Contexts: `presenter`, `slide`, `overview`, `print`

## Custom Components

Create components in `components/` directory:

```vue
<!-- components/Counter.vue -->
<script setup>
import { ref } from 'vue'
const count = ref(0)
</script>

<template>
  <button @click="count++">Count: {{ count }}</button>
</template>
```

Use in slides:

```html
<Counter />
```
