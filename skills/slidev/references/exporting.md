---
name: Exporting
description: PDF, PPTX, PNG export with all options and flags
---

# Exporting

## PDF Export

Basic export:

```bash
slidev export
slidev export --output my-slides.pdf
```

With click steps (each v-click becomes a page):

```bash
slidev export --with-clicks
```

Dark mode:

```bash
slidev export --dark
```

Specific slide range:

```bash
slidev export --range 1,6-8,10
```

With table of contents outline:

```bash
slidev export --with-toc
```

## PPTX Export

```bash
slidev export --format pptx
```

**Note:** Slides are exported as images in PPTX format.

## PNG Export

Export each slide as image:

```bash
slidev export --format png
```

With transparent background:

```bash
slidev export --format png --omit-background
```

## Markdown Export

Export clean markdown:

```bash
slidev export --format md
```

## All Export Flags

| Flag | Purpose | Example |
|------|---------|---------|
| `--output [name]` | Output filename | `--output slides.pdf` |
| `--format [type]` | Export format | `pdf`, `pptx`, `png`, `md` |
| `--with-clicks` | Export click steps as pages | - |
| `--dark` | Use dark theme | - |
| `--range [slides]` | Export specific slides | `1,3-5,8` |
| `--timeout [ms]` | Playwright timeout | `60000` |
| `--wait [ms]` | Rendering delay | `1000` |
| `--wait-until [state]` | Wait condition | `networkidle` |
| `--with-toc` | Generate PDF outline | - |
| `--omit-background` | Remove background (PNG) | - |
| `--scale [n]` | Scale factor | `2` |
| `--executable-path` | Custom Chrome path | - |

## Export Examples

High-quality PDF with all clicks:

```bash
slidev export --with-clicks --with-toc --timeout 60000
```

PNG images at 2x resolution:

```bash
slidev export --format png --scale 2
```

Specific slides in dark mode:

```bash
slidev export --range 1-10 --dark --output intro.pdf
```

## Static Build

Build as static SPA (for web hosting):

```bash
slidev build
```

Output goes to `dist/` directory.

Build options:

```bash
slidev build --base /my-slides/  # Custom base path
slidev build --out ./output      # Custom output directory
```
