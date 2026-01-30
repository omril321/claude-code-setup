---
name: Canvas Size
description: Control slide aspect ratio and dimensions
---

# Canvas Size

Configure the aspect ratio and dimensions of your slides.

## Setting Canvas Size

In headmatter:

```yaml
---
canvasWidth: 980
aspectRatio: 16/9
---
```

## Common Aspect Ratios

| Ratio | Use Case |
|-------|----------|
| `16/9` | Widescreen monitors, modern projectors (default) |
| `16/10` | MacBook displays |
| `4/3` | Older projectors, traditional presentations |
| `1/1` | Square, social media |
| `21/9` | Ultra-wide displays |

## Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `canvasWidth` | Width in pixels | `980` |
| `aspectRatio` | Width/height ratio | `16/9` |

The height is calculated automatically: `height = canvasWidth / aspectRatio`

## Examples

### Standard Widescreen

```yaml
---
canvasWidth: 980
aspectRatio: 16/9
---
```

Results in 980 × 551 canvas.

### Classic 4:3

```yaml
---
canvasWidth: 980
aspectRatio: 4/3
---
```

Results in 980 × 735 canvas.

### Ultra-Wide

```yaml
---
canvasWidth: 1260
aspectRatio: 21/9
---
```

### Custom Dimensions

```yaml
---
canvasWidth: 1920
aspectRatio: 16/9
---
```

Results in 1920 × 1080 (Full HD) canvas.

## How It Works

1. Slides are authored at canvas dimensions
2. Slidev scales the canvas to fit the viewport
3. Aspect ratio is preserved during scaling
4. Content remains crisp at any display size

## Tips

- Match your target display's aspect ratio
- 16/9 is safe for most modern displays
- Use 4/3 if presenting on older projectors
- Export respects canvas dimensions
- Higher `canvasWidth` = more detail in exports

## Viewing at Different Sizes

Slidev automatically scales to fit:
- Browser window resizing
- Different monitor resolutions
- Projector output

Content positioning uses relative units, so layouts adapt correctly.
