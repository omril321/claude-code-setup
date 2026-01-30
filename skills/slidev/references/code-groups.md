---
name: Code Groups
description: Tabbed code blocks with automatic package manager icons
---

# Code Groups

Code Groups display multiple code blocks as tabs, commonly used for showing the same command across different package managers.

## Basic Usage

Use bracket notation `[tab-name]` after the language:

````markdown
```bash [npm]
npm install slidev
```

```bash [yarn]
yarn add slidev
```

```bash [pnpm]
pnpm add slidev
```
````

This renders as a tabbed interface where users can switch between npm, yarn, and pnpm.

## Auto Icons

Package manager tabs automatically get their icons:

| Tab Name | Icon |
|----------|------|
| `npm` | npm icon |
| `yarn` | yarn icon |
| `pnpm` | pnpm icon |
| `bun` | bun icon |

## Different Languages

Tabs can have different languages:

````markdown
```ts [TypeScript]
const name: string = 'hello'
```

```js [JavaScript]
const name = 'hello'
```
````

## With Line Highlighting

Combine with highlighting:

````markdown
```ts {2,3} [TypeScript]
interface User {
  name: string
  email: string
}
```

```python {2,3} [Python]
class User:
    name: str
    email: str
```
````

## Use Cases

### Installation Instructions

````markdown
```bash [npm]
npm install @slidev/cli
```

```bash [yarn]
yarn add @slidev/cli
```

```bash [pnpm]
pnpm add @slidev/cli
```

```bash [bun]
bun add @slidev/cli
```
````

### Multi-Language Examples

````markdown
```ts [TypeScript]
function greet(name: string): string {
  return `Hello, ${name}!`
}
```

```python [Python]
def greet(name: str) -> str:
    return f"Hello, {name}!"
```

```rust [Rust]
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}
```
````

### Configuration Files

````markdown
```json [package.json]
{
  "scripts": {
    "dev": "slidev"
  }
}
```

```yaml [docker-compose.yml]
services:
  app:
    command: slidev
```
````
