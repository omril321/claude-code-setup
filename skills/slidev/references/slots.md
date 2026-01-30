---
name: Layout Slots
description: Named slots for complex layout customization
---

# Layout Slots

Use named slots to place content in specific areas of layouts.

## Slot Syntax

Use `::slot-name::` to define content for named slots:

```markdown
---
layout: two-cols
---

# Left Title

Left content here

::right::

# Right Title

Right content here
```

## Common Slot Names

| Layout | Available Slots |
|--------|-----------------|
| `two-cols` | `default` (left), `right` |
| `two-cols-header` | `default` (header), `left`, `right` |
| `image-right` | `default` (left content) |
| `image-left` | `default` (right content) |

## Two-Cols Layout

```markdown
---
layout: two-cols
---

# Features

<v-clicks>

- Fast
- Simple
- Powerful

</v-clicks>

::right::

```ts
const slidev = 'awesome'
```
```

## Two-Cols-Header Layout

```markdown
---
layout: two-cols-header
---

# Main Title

Spans both columns

::left::

## Left Section

Content for left column

::right::

## Right Section

Content for right column
```

## Custom Layout with Slots

Create layouts with custom slots:

```vue
<!-- layouts/three-cols.vue -->
<template>
  <div class="slidev-layout grid grid-cols-3 gap-4 p-8">
    <div class="col1">
      <slot name="left" />
    </div>
    <div class="col2">
      <slot />  <!-- default slot -->
    </div>
    <div class="col3">
      <slot name="right" />
    </div>
  </div>
</template>
```

Use it:

```markdown
---
layout: three-cols
---

::left::

Column 1

::default::

Column 2

::right::

Column 3
```

## Slot with Props

Layouts can pass props to slots:

```vue
<!-- layouts/with-context.vue -->
<script setup>
import { computed } from 'vue'
const context = computed(() => ({ theme: 'dark' }))
</script>

<template>
  <div class="slidev-layout">
    <slot :context="context" />
  </div>
</template>
```

## Tips

- The default slot captures content before any named slot
- Slot content inherits the slide's frontmatter context
- Use slots to create reusable layout patterns
- Combine with v-click for animated multi-column reveals

## Slot Order

Content flows in document order:

```markdown
---
layout: two-cols
---

This goes to default (left) slot
because it comes before any ::slot::

::right::

This goes to right slot
```
