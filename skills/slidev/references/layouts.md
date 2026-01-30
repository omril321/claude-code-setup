---
name: Layouts
description: All 19 built-in Slidev layouts with props and usage examples
---

# Layouts

## All Built-in Layouts (19)

| Layout | Description | Required Props |
|--------|-------------|----------------|
| `center` | Content centered | - |
| `cover` | Title/cover page | - |
| `default` | Basic layout | - |
| `end` | Final slide | - |
| `fact` | Prominent data display | - |
| `full` | Full screen content | - |
| `image` | Image as main content | `image: /path.png` |
| `image-left` | Image left, content right | `image: /path.png` |
| `image-right` | Image right, content left | `image: /path.png` |
| `iframe` | Embed web page | `url: https://...` |
| `iframe-left` | Web page left, content right | `url: https://...` |
| `iframe-right` | Web page right, content left | `url: https://...` |
| `intro` | Title + author intro | - |
| `none` | No styling | - |
| `quote` | Quotation display | - |
| `section` | Section divider | - |
| `statement` | Bold statement | - |
| `two-cols` | Two columns | Use `::right::` |
| `two-cols-header` | Header + two columns | Use `::left::` `::right::` |

## Layout Examples

### Two Columns

```markdown
---
layout: two-cols
---

# Left Side

Content on left

::right::

# Right Side

Content on right
```

### Two Columns with Header

```markdown
---
layout: two-cols-header
---

# Header Spans Both Columns

::left::

Left column content

::right::

Right column content
```

### Image Layouts

**Full-screen image:**

```markdown
---
layout: image
image: /full-screen-image.png
---
```

**Image with content:**

```markdown
---
layout: image-right
image: /diagram.png
---

# Title

Explanation appears on the left
```

### iFrame Layout

```markdown
---
layout: iframe-right
url: https://sli.dev
---

# Embedded Website

The iframe appears on the right
```

### Quote Layout

```markdown
---
layout: quote
---

"The best way to predict the future is to invent it."

— Alan Kay
```

### Fact Layout

```markdown
---
layout: fact
---

# 99.9%

Uptime achieved this quarter
```

### Section Divider

```markdown
---
layout: section
---

# Part 2

Advanced Topics
```

## Custom Layouts

Create custom layouts in `layouts/` directory:

```vue
<!-- layouts/my-layout.vue -->
<template>
  <div class="my-layout">
    <slot />
  </div>
</template>

<style scoped>
.my-layout {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}
</style>
```

Use:

```yaml
---
layout: my-layout
---
```
