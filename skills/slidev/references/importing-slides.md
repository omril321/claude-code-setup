---
name: Importing Slides
description: Include slides from other markdown files
---

# Importing Slides

Include slides from other markdown files to organize large presentations or reuse content.

## Basic Import

Use the `src` frontmatter property:

```markdown
---
src: ./intro.md
---
```

This imports all slides from `intro.md` at this position.

## Import Specific Slides

Import a range of slides:

```markdown
---
src: ./chapter1.md
range: 1-5
---
```

## Multiple Imports

Structure a presentation from multiple files:

```markdown
---
theme: seriph
title: Full Presentation
---

# Welcome

---
src: ./intro.md
---

---
src: ./chapter1.md
---

---
src: ./chapter2.md
---

---
src: ./conclusion.md
---
```

## Nested Imports

Imported files can also import other files:

```markdown
<!-- chapter1.md -->
# Chapter 1

---
src: ./chapter1-part1.md
---

---
src: ./chapter1-part2.md
---
```

## File Organization

```
presentation/
├── slides.md           # Main entry point
├── intro.md            # Introduction slides
├── chapters/
│   ├── chapter1.md
│   ├── chapter2.md
│   └── chapter3.md
├── shared/
│   ├── about-us.md     # Reusable slides
│   └── contact.md
└── conclusion.md
```

Main `slides.md`:

```markdown
---
theme: seriph
---

# My Presentation

---
src: ./intro.md
---

---
src: ./chapters/chapter1.md
---

---
src: ./shared/contact.md
---
```

## Import with Frontmatter

The imported file's frontmatter is merged:

```markdown
<!-- intro.md -->
---
layout: center
---

# Introduction

This slide uses center layout from its own frontmatter.
```

## Use Cases

### Modular Presentations

Split by topic:

```
modules/
├── architecture.md
├── performance.md
├── security.md
└── testing.md
```

### Reusable Sections

Common slides across presentations:

```
shared/
├── company-intro.md
├── team.md
└── qa-slide.md
```

### Version Control

Easier to review changes in smaller files.

## Tips

- Use relative paths from the importing file
- Imported slides maintain their own frontmatter
- Headmatter (first block) only applies in main `slides.md`
- Test imports work by checking slide count
- Circular imports are not allowed

## Limitations

- Headmatter settings don't propagate to imported files
- Each imported file should be valid on its own
- Paths must be relative (no absolute paths)
