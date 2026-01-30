---
name: Code Highlighting
description: Syntax highlighting, line highlighting, Monaco editor, and TwoSlash
---

# Code Highlighting

## Basic Syntax Highlighting

````markdown
```ts
const hello = "world";
```
````

## Line Highlighting

Highlight specific lines:

````markdown
```ts {2,3}
const a = 1;
const b = 2;  // highlighted
const c = 3;  // highlighted
```
````

Line ranges:

````markdown
```ts {2-4}
const a = 1;
const b = 2;  // highlighted
const c = 3;  // highlighted
const d = 4;  // highlighted
const e = 5;
```
````

## Animated Line Highlighting

Use `|` to step through highlights on click:

````markdown
```ts {2|3|4}
const a = 1;
const b = 2;  // click 1
const c = 3;  // click 2
const d = 4;  // click 3
```
````

Combined ranges:

````markdown
```ts {1|2-3|4-5|all}
const a = 1;  // click 1
const b = 2;  // click 2
const c = 3;  // click 2
const d = 4;  // click 3
const e = 5;  // click 3
```
````

## Line Numbers

````markdown
```ts {lines:true}
const a = 1;
const b = 2;
```
````

Start from specific line:

````markdown
```ts {lines:true,startLine:5}
const a = 1;  // shows as line 5
const b = 2;  // shows as line 6
```
````

## Max Height (Scrollable)

````markdown
```ts {maxHeight:'200px'}
// Long code that becomes scrollable
// when it exceeds 200px height
```
````

## Monaco Editor (Live Coding)

Editable code block with full IDE features:

````markdown
```ts {monaco}
// Editable code block
const hello = 'world'
```
````

Read-only with Monaco features:

````markdown
```ts {monaco-readonly}
// Read-only but with Monaco features
// like hover tooltips
```
````

## TwoSlash (TypeScript Hints)

Show TypeScript type information inline:

````markdown
```ts twoslash
const a = 1
//    ^?
```
````

The `^?` shows the inferred type at that position.

## Code Block Options Summary

| Option | Description | Example |
|--------|-------------|---------|
| `{2,3}` | Highlight lines | `{2,3,5-7}` |
| `{2\|3}` | Animated highlights | `{1\|2-3\|all}` |
| `{lines:true}` | Show line numbers | - |
| `{startLine:5}` | Start line numbering at | - |
| `{maxHeight:'200px'}` | Scrollable height | - |
| `{monaco}` | Editable Monaco editor | - |
| `{monaco-readonly}` | Read-only Monaco | - |
| `twoslash` | TypeScript hints | - |
