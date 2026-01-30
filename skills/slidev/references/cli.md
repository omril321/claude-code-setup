---
name: CLI Commands
description: Slidev CLI commands, installation, and project structure
---

# CLI Commands

## Core Commands

| Command | Purpose |
|---------|---------|
| `slidev` | Start dev server |
| `slidev --open` | Start and open browser |
| `slidev export` | Export to PDF |
| `slidev build` | Build static SPA |
| `slidev format` | Format slides |
| `slidev --help` | Show help |

## Dev Server Options

```bash
slidev                    # Start on default port
slidev --port 3030        # Custom port
slidev --open             # Open browser automatically
slidev --remote           # Allow remote connections
slidev slides.md          # Specify slide file
```

## Installation

### Create New Project

```bash
# Recommended (pnpm)
pnpm create slidev

# Alternatives
npm init slidev@latest
yarn create slidev
bun create slidev
```

### Global CLI

```bash
pnpm i -g @slidev/cli
slidev slides.md
```

### Add to Existing Project

```bash
pnpm add -D @slidev/cli
```

## Project Structure

```
your-slidev/
├── components/       # Custom Vue components
├── layouts/          # Custom slide layouts
├── public/           # Static assets (images, fonts)
├── setup/            # Configuration hooks
├── styles/           # Custom styling
│   └── index.css     # Global styles
├── slides.md         # Main presentation file
└── vite.config.ts    # Vite configuration (optional)
```

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `components/` | Custom Vue components, auto-imported |
| `layouts/` | Custom slide layouts |
| `public/` | Static assets served at root |
| `styles/` | Global CSS files |
| `setup/` | Setup scripts (shiki, monaco, etc.) |

### Important Files

| File | Purpose |
|------|---------|
| `slides.md` | Main presentation content |
| `global-top.vue` | Component rendered on top of all slides |
| `global-bottom.vue` | Component rendered at bottom of all slides |
| `styles/index.css` | Global styles |
| `vite.config.ts` | Vite/build configuration |

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Space` / `→` | Next step/slide |
| `←` | Previous step/slide |
| `↑` / `↓` | Navigate slides |
| `f` | Toggle fullscreen |
| `o` | Toggle overview |
| `d` | Toggle dark mode |
| `p` | Toggle presenter view |
| `g` | Go to slide |
| `Esc` | Exit current mode |

### Presenter Mode

| Key | Action |
|-----|--------|
| `P` | Enter presenter mode |
| `C` | Toggle drawing canvas |
| `E` | Erase drawings |

## Development Workflow

1. Start dev server: `slidev --open`
2. Edit `slides.md` - changes hot reload
3. View at `http://localhost:3030`
4. Presenter mode at `http://localhost:3030/presenter`
5. Export when ready: `slidev export`
