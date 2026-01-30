# Code Example Guidelines

## Core Principle

**One excellent example beats many mediocre ones.**

## Good Example Qualities

- Complete and runnable
- Well-commented explaining WHY
- From real scenario
- Ready to adapt
- In most relevant language (TypeScript for testing, Python for data, etc.)

## What NOT to Do

- Implement in 5+ languages
- Create generic templates
- Use placeholder values
- Skip comments

## Anti-Patterns

| Anti-Pattern | Why Bad |
|--------------|---------|
| Narrative example | Too specific, not reusable |
| Multi-language examples | Mediocre quality, maintenance burden |
| Code in flowcharts | Can't copy-paste, hard to read |
| Generic labels (helper1) | Labels should have semantic meaning |

## Flowchart Usage

**Use flowcharts ONLY for:**
- Non-obvious decision points
- Process loops where you might stop too early

**Never use for:**
- Reference material (use tables)
- Code examples (use markdown)
- Linear instructions (use numbered lists)

See `graphviz-conventions.dot` for style rules.
