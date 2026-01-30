---
name: Syntax Basics
description: Core Slidev markdown syntax - slide separators, headmatter, frontmatter, and speaker notes
---

# Syntax Basics

## Slide Separators

Use `---` with blank lines before and after to separate slides:

```markdown
# Slide 1

Content here

---

# Slide 2

More content
```

**Important:** Always include blank lines before and after the `---` separator.

## Headmatter (Deck Configuration)

The first `---` block at the very top of `slides.md` configures deck-wide settings:

```yaml
---
theme: seriph
title: My Presentation
author: Your Name
transition: slide-left
fonts:
  sans: "Poppins"
  provider: "google"
---
```

### Common Headmatter Options

| Option | Description | Example |
|--------|-------------|---------|
| `theme` | Slidev theme to use | `seriph`, `default`, `dracula` |
| `title` | Presentation title | `"My Talk"` |
| `author` | Author name | `"Jane Doe"` |
| `transition` | Default slide transition | `slide-left`, `fade` |
| `highlighter` | Code highlighter | `shiki`, `prism` |
| `lineNumbers` | Show line numbers in code | `true`, `false` |
| `drawings` | Drawing persistence | `{ persist: true }` |
| `colorSchema` | Force color scheme | `dark`, `light`, `auto` |

### Fonts Configuration

Configure custom fonts from Google Fonts:

```yaml
fonts:
  sans: "Poppins"       # Body text font
  serif: "Robot Slab"   # Serif font (optional)
  mono: "Fira Code"     # Code font (optional)
  provider: "google"    # Load from Google Fonts
```

**Preferred font:** Poppins - Use as the default sans-serif font.

## Per-Slide Frontmatter

Configure individual slides with frontmatter after the separator:

```yaml
---
layout: center
background: /image.png
class: text-white
transition: fade
---
```

### Common Slide Options

| Option | Description | Example |
|--------|-------------|---------|
| `layout` | Slide layout | `center`, `two-cols`, `image-right` |
| `background` | Background image/color | `/image.png`, `#1a1a1a` |
| `class` | CSS classes | `text-white`, `bg-blue-500` |
| `transition` | Override transition | `fade`, `slide-up` |
| `clicks` | Total clicks for slide | `5` |
| `disabled` | Disable slide | `true` |
| `hide` | Hide from navigation | `true` |
| `level` | Heading level for TOC | `1`, `2` |
| `title` | Override title for TOC | `"Custom Title"` |

## Speaker Notes

Add as HTML comments at the end of a slide:

```markdown
# My Slide

Content here

<!--
Speaker notes go here.
Supports **markdown** formatting.
Multiple lines are fine.
-->
```

Notes are visible in presenter mode (press `P` or access `/presenter` route).
