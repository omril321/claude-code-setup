---
name: MDC Syntax
description: Enhanced markdown components syntax for cleaner templates
---

# MDC Syntax

MDC (Markdown Components) provides a cleaner syntax for using Vue components in markdown.

## Basic Syntax

Standard Vue component:

```html
<MyComponent prop="value">
  Content
</MyComponent>
```

MDC equivalent:

```markdown
::my-component{prop="value"}
Content
::
```

## Inline Components

For inline usage:

```markdown
This is :my-inline{prop="value"} component in text.
```

## Props Syntax

```markdown
::component{stringProp="hello" :numberProp="42" boolProp}
Content here
::
```

- String props: `prop="value"`
- Dynamic props: `:prop="expression"`
- Boolean props: `prop` (presence = true)

## Block Components

Multi-line content:

```markdown
::alert{type="warning"}
This is a warning message.

It can have multiple paragraphs.
::
```

## Nested Components

```markdown
::card{title="Outer"}
  ::badge{color="blue"}
  Nested badge
  ::
::
```

## Practical Examples

### Alert Box

```markdown
::alert{type="info"}
**Note:** This is important information.
::
```

### Two Column with MDC

```markdown
::two-cols
Left content

#right
Right content
::
```

### Custom Card

```markdown
::card{title="Features" icon="star"}
- Feature 1
- Feature 2
- Feature 3
::
```

## Slots with MDC

Named slots use `#`:

```markdown
::my-component
Default slot content

#header
Header slot content

#footer
Footer slot content
::
```

## When to Use MDC

| Use MDC | Use HTML |
|---------|----------|
| Cleaner markdown-like syntax | Complex nesting |
| Simple components | Dynamic v-for/v-if |
| Documentation-style content | Event handlers |

## Enabling MDC

MDC is typically enabled by default in Slidev. If not:

```yaml
---
mdc: true
---
```

## Tips

- MDC is great for content-heavy slides
- Use HTML for complex interactive components
- Component names use kebab-case in MDC
- MDC content is processed as markdown
