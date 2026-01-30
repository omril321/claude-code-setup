---
name: Global Layers
description: Persistent overlays and content across all slides
---

# Global Layers

Create content that persists across all slides, like watermarks, navigation, or persistent UI elements.

## Layer Files

Create these files in your project root:

| File | Position | Z-Index |
|------|----------|---------|
| `global-top.vue` | Above all slides | Highest |
| `global-bottom.vue` | Below all slides | Lowest |

## global-top.vue

Content rendered on top of every slide:

```vue
<!-- global-top.vue -->
<template>
  <div class="absolute top-4 right-4 text-sm opacity-50">
    My Company
  </div>
</template>
```

## global-bottom.vue

Content rendered below every slide:

```vue
<!-- global-bottom.vue -->
<template>
  <div class="absolute bottom-4 left-4">
    <img src="/logo.png" class="h-8" />
  </div>
</template>
```

## Accessing Slide Context

Use Slidev's navigation composables:

```vue
<!-- global-top.vue -->
<script setup>
import { useNav } from '@slidev/client'

const { currentSlideNo, total } = useNav()
</script>

<template>
  <div class="absolute bottom-4 right-4 text-sm">
    {{ currentSlideNo }} / {{ total }}
  </div>
</template>
```

## Conditional Display

Show content only on certain slides:

```vue
<!-- global-top.vue -->
<script setup>
import { useNav } from '@slidev/client'
import { computed } from 'vue'

const { currentSlideNo } = useNav()
const showLogo = computed(() => currentSlideNo.value > 1)
</script>

<template>
  <div v-if="showLogo" class="absolute top-4 left-4">
    <img src="/logo.png" class="h-10" />
  </div>
</template>
```

## Common Use Cases

### Company Branding

```vue
<!-- global-bottom.vue -->
<template>
  <div class="absolute bottom-4 left-4 flex items-center gap-2">
    <img src="/logo.png" class="h-6" />
    <span class="text-sm opacity-60">Confidential</span>
  </div>
</template>
```

### Slide Progress

```vue
<!-- global-top.vue -->
<script setup>
import { useNav } from '@slidev/client'

const { currentSlideNo, total } = useNav()
</script>

<template>
  <div
    class="absolute top-0 left-0 h-1 bg-blue-500 transition-all"
    :style="{ width: `${(currentSlideNo / total) * 100}%` }"
  />
</template>
```

### Watermark

```vue
<!-- global-bottom.vue -->
<template>
  <div class="absolute inset-0 flex items-center justify-center pointer-events-none">
    <span class="text-8xl font-bold opacity-5 rotate-[-30deg]">
      DRAFT
    </span>
  </div>
</template>
```

## Tips

- Use `absolute` positioning to place elements
- Add `pointer-events-none` to prevent blocking interactions
- Access `$slidev` context for slide metadata
- Global layers work in both slide and presenter views
- Test on first and last slides to ensure proper display
