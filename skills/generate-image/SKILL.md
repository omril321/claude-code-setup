---
name: generate-image
description: Generates images using gemini-image script. Use when user asks to generate, create, or make an image.
allowed-tools: Bash(gemini-image:*), Bash(~/scripts/gemini-image:*)
---

# Generate Image

## Overview

Generate images using `~/scripts/gemini-image`. For multi-image work, maintain visual consistency with theme prompts.

## Command Reference

| Usage        | Command                                           |
| ------------ | ------------------------------------------------- |
| Basic        | `gemini-image "prompt"`                           |
| Output path  | `gemini-image "prompt" -o output.png`             |
| Aspect ratio | `gemini-image "prompt" -a 16:9`                   |
| Edit image   | `gemini-image "add X" -i input.png -o output.png` |

**Aspect ratios:** 1:1, 16:9, 4:3, 3:2, 2:3, 9:16

## Single Image

Execute directly:

```bash
~/scripts/gemini-image "a futuristic city at sunset" -o city.png
```

## Multi-Image Work (Critical)

When generating multiple images (presentations, blogs, image series):

1. **Establish a theme prompt** - A style descriptor used on ALL images
2. **Ask upfront** for presentations or when user mentions "series"
3. **Suggest a theme** when you detect multi-image context

### Theme Prompt Examples

| Context           | Theme Prompt                                                   |
| ----------------- | -------------------------------------------------------------- |
| Tech presentation | "flat vector illustration, vibrant gradients, dark background" |
| Blog post         | "soft watercolor style, warm earth tones, organic shapes"      |
| Product series    | "clean product photography, white background, soft shadows"    |

### Execution Pattern

```bash
THEME="minimalist illustration, soft blue palette, clean lines"

~/scripts/gemini-image "home office setup, $THEME" -o slide1.png
~/scripts/gemini-image "video call meeting, $THEME" -o slide2.png
~/scripts/gemini-image "work-life balance, $THEME" -o slide3.png
```

## Common Mistakes

| Mistake                              | Fix                                                          |
| ------------------------------------ | ------------------------------------------------------------ |
| Generating multi-image without theme | Always ask/suggest theme for 2+ related images               |
| Forgetting theme mid-series          | Track theme, append to every prompt                          |
| Generic themes                       | Match theme to content context (tech→modern, nature→organic) |
