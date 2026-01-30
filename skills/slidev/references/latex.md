---
name: LaTeX Math
description: Mathematical notation and equations using LaTeX syntax
---

# LaTeX Math

Render mathematical equations and notation using LaTeX/KaTeX syntax.

## Inline Math

Use single `$` for inline math:

```markdown
The formula $E = mc^2$ changed physics forever.

When $n$ approaches infinity, $\lim_{n\to\infty} \frac{1}{n} = 0$.
```

## Block Math

Use double `$$` for centered block equations:

```markdown
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

## Common Notation

### Fractions and Powers

```markdown
$$
\frac{a}{b} \quad x^2 \quad \sqrt{x} \quad \sqrt[3]{x}
$$
```

### Greek Letters

```markdown
$$
\alpha \beta \gamma \delta \epsilon \theta \lambda \mu \pi \sigma \omega
$$
```

### Subscripts and Superscripts

```markdown
$$
x_i \quad x^2 \quad x_i^2 \quad x_{i,j}
$$
```

### Summation and Products

```markdown
$$
\sum_{i=1}^{n} x_i \quad \prod_{i=1}^{n} x_i
$$
```

### Integrals

```markdown
$$
\int_a^b f(x) dx \quad \iint_D f(x,y) dA \quad \oint_C F \cdot dr
$$
```

### Limits

```markdown
$$
\lim_{x \to 0} \frac{\sin x}{x} = 1
$$
```

### Matrices

```markdown
$$
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}

\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6
\end{bmatrix}
$$
```

### Cases (Piecewise Functions)

```markdown
$$
f(x) = \begin{cases}
x^2 & \text{if } x \geq 0 \\
-x^2 & \text{if } x < 0
\end{cases}
$$
```

## Common Operators

| Symbol | LaTeX |
|--------|-------|
| ≤ | `\leq` |
| ≥ | `\geq` |
| ≠ | `\neq` |
| ≈ | `\approx` |
| ∈ | `\in` |
| ∉ | `\notin` |
| ⊂ | `\subset` |
| ∪ | `\cup` |
| ∩ | `\cap` |
| → | `\to` or `\rightarrow` |
| ⇒ | `\Rightarrow` |
| ∀ | `\forall` |
| ∃ | `\exists` |
| ∞ | `\infty` |

## Aligned Equations

```markdown
$$
\begin{aligned}
(a + b)^2 &= a^2 + 2ab + b^2 \\
(a - b)^2 &= a^2 - 2ab + b^2
\end{aligned}
$$
```

## Example Slides

### Algorithm Complexity

```markdown
---
layout: center
---

# Time Complexity

$$
T(n) = 2T\left(\frac{n}{2}\right) + O(n)
$$

By the Master Theorem: $T(n) = O(n \log n)$
```

### Statistics

```markdown
---
layout: center
---

# Normal Distribution

$$
f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2}
$$
```

## Tips

- KaTeX is faster than MathJax but has fewer features
- Preview equations at https://katex.org/
- Use `\text{}` for regular text within equations
- Complex equations may need manual line breaking
