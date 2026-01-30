---
name: Magic Move
description: Animated code transitions between code blocks using Shiki
---

# Magic Move

Magic Move enables smooth animated transitions between code blocks, similar to Keynote's Magic Move. It morphs code changes with syntax highlighting preserved.

## Basic Usage

Use the `magic-move` code block type with multiple fenced code blocks inside:

`````markdown
````md magic-move
```ts
const count = 1
```
```ts
const count = ref(1)
```
```ts
const count = ref(1)
const doubled = computed(() => count.value * 2)
```
````
`````

Each code block represents a step. Click to animate between them.

## With Line Highlighting

Combine with line highlighting:

`````markdown
````md magic-move {lines: true}
```ts
const name = 'hello'
```
```ts {1}
const name = ref('hello')
```
```ts {1-2}
const name = ref('hello')
const upper = computed(() => name.value.toUpperCase())
```
````
`````

## Options

`````markdown
````md magic-move {at: 1, lines: true}
```ts
// code step 1
```
```ts
// code step 2
```
````
`````

| Option | Description |
|--------|-------------|
| `at` | Start at specific click number |
| `lines` | Show line numbers |

## How It Works

1. Each fenced code block is a "frame"
2. Shiki tokenizes all frames with syntax highlighting
3. On click, tokens animate from old positions to new positions
4. Added tokens fade in, removed tokens fade out

## Best Practices

- Keep code blocks focused on the change being demonstrated
- Use to show code evolution (refactoring, adding features)
- Works best for incremental changes
- Large structural changes may animate less smoothly

## Example: Refactoring Journey

`````markdown
````md magic-move
```js
// Before: Callback hell
getData(function(a) {
  getMoreData(a, function(b) {
    getEvenMoreData(b, function(c) {
      console.log(c)
    })
  })
})
```
```js
// After: Promises
getData()
  .then(a => getMoreData(a))
  .then(b => getEvenMoreData(b))
  .then(c => console.log(c))
```
```js
// Even better: async/await
const a = await getData()
const b = await getMoreData(a)
const c = await getEvenMoreData(b)
console.log(c)
```
````
`````
