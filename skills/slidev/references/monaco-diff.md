---
name: Monaco Diff
description: Side-by-side code comparison with Monaco editor
---

# Monaco Diff

Display side-by-side code comparisons using Monaco's diff editor.

## Basic Usage

Use `monaco-diff` with two code blocks separated by `~~~`:

`````markdown
````md monaco-diff
```ts
const greeting = 'hello'
console.log(greeting)
```
~~~
```ts
const greeting = 'hello world'
console.log(greeting.toUpperCase())
```
````
`````

The left side shows the "before" code, the right side shows "after".

## With Highlighting

Differences are automatically highlighted:
- Removed lines shown in red (left side)
- Added lines shown in green (right side)
- Changed portions within lines are highlighted

## Read-Only Mode

By default, Monaco diff is read-only. The diff view is for presentation, not editing.

## Use Cases

### Code Review

`````markdown
````md monaco-diff
```ts
function processData(data) {
  return data.map(x => x * 2)
}
```
~~~
```ts
function processData(data: number[]): number[] {
  return data.map(x => x * 2)
}
```
````
`````

### Before/After Refactoring

`````markdown
````md monaco-diff
```ts
// Before: Imperative
const results = []
for (let i = 0; i < items.length; i++) {
  if (items[i].active) {
    results.push(items[i].name)
  }
}
```
~~~
```ts
// After: Declarative
const results = items
  .filter(item => item.active)
  .map(item => item.name)
```
````
`````

### Bug Fix Demonstration

`````markdown
````md monaco-diff
```ts
// Bug: Off-by-one error
function getLastItem(arr) {
  return arr[arr.length]
}
```
~~~
```ts
// Fixed
function getLastItem(arr) {
  return arr[arr.length - 1]
}
```
````
`````

## Tips

- Keep diffs focused on the specific change
- Use comments to explain what changed
- Monaco diff works best for small to medium code blocks
- For larger comparisons, consider splitting across multiple slides
