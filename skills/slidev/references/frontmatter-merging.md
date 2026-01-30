---
name: Frontmatter Merging
description: Inherit and override frontmatter settings across slides
---

# Frontmatter Merging

Control how frontmatter settings are inherited and overridden.

## Default Behavior

Headmatter (first block) sets defaults for all slides:

```yaml
---
theme: seriph
transition: slide-left
class: text-center
---
```

Individual slides inherit and can override:

```yaml
---
transition: fade
---

# This slide uses fade, but inherits theme and class
```

## Explicit Inheritance

Use spread syntax to explicitly inherit:

```yaml
---
# Inherit all defaults, then override
layout: two-cols
transition: fade
---
```

## Defaults Block

Set defaults that apply to subsequent slides:

```markdown
---
theme: seriph
---

# Slide 1

Uses theme defaults

---
defaults:
  layout: center
  class: text-white
---

# Slide 2

Now uses center layout with text-white

---

# Slide 3

Also uses center layout with text-white
```

## Per-Slide Override

Override anything for a single slide:

```yaml
---
layout: image
image: /bg.jpg
class: ''
transition: none
---
```

Empty string (`''`) clears inherited values.

## Frontmatter Hierarchy

1. **Headmatter** - Deck-wide defaults (first block)
2. **Defaults** - Section-wide defaults
3. **Slide frontmatter** - Per-slide overrides

Later settings override earlier ones.

## Practical Patterns

### Section-Based Styling

```markdown
---
theme: seriph
---

# Intro
<!-- Default styling -->

---
defaults:
  class: bg-blue-900 text-white
---

# Blue Section
<!-- All slides now have blue background -->

---

# Still Blue

---
defaults:
  class: bg-green-900 text-white
---

# Green Section
<!-- Switches to green -->
```

### Transition Sections

```markdown
---
transition: slide-left
---

# Normal slides use slide-left

---
defaults:
  transition: fade
---

# This section fades

---

# Also fades

---
transition: slide-up
---

# This one slides up (override)
```

## Merging Objects

Object properties are merged:

```yaml
# Headmatter
---
fonts:
  sans: Poppins
  mono: Fira Code
---

# Slide frontmatter
---
fonts:
  sans: Inter  # Overrides sans, keeps mono
---
```

## Tips

- Use headmatter for presentation-wide settings
- Use `defaults` for section-wide styling
- Override per-slide only when needed
- Test inherited values with browser DevTools
- Clear values with empty string when needed

## Common Settings to Inherit

| Setting | Typical Inheritance |
|---------|-------------------|
| `theme` | Headmatter only |
| `transition` | Often overridden per section |
| `class` | Varies by section |
| `layout` | Usually per-slide |
| `background` | Usually per-slide |
