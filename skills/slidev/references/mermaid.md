---
name: Mermaid Diagrams
description: All Mermaid diagram types with configuration options
---

# Mermaid Diagrams

## Basic Usage

````markdown
```mermaid
graph LR
    A[Start] --> B{Decision}
    B -->|Yes| C[Action]
    B -->|No| D[Other]
```
````

## With Configuration

````markdown
```mermaid {theme: 'neutral', scale: 0.8}
sequenceDiagram
    Alice->>Bob: Hello
    Bob-->>Alice: Hi
```
````

## Diagram Types

### Flowchart

```mermaid
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Do Something]
    B -->|No| D[Do Something Else]
    C --> E[End]
    D --> E
```

Directions: `TD` (top-down), `LR` (left-right), `BT` (bottom-top), `RL` (right-left)

### Sequence Diagram

```mermaid
sequenceDiagram
    participant A as Alice
    participant B as Bob
    A->>B: Hello John
    B-->>A: Hi Alice
    A->>B: How are you?
    B-->>A: Great!
```

### Class Diagram

```mermaid
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal : +int age
    Animal : +String gender
    Animal : +isMammal()
    Duck : +swim()
    Duck : +quack()
```

### State Diagram

```mermaid
stateDiagram-v2
    [*] --> Still
    Still --> Moving : start
    Moving --> Still : stop
    Moving --> Crash : collision
    Crash --> [*]
```

### Entity Relationship

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER {
        string name
        string email
    }
    ORDER {
        int orderNumber
        date created
    }
```

### Gantt Chart

```mermaid
gantt
    title Project Schedule
    dateFormat YYYY-MM-DD
    section Phase 1
    Task 1 :a1, 2024-01-01, 30d
    Task 2 :after a1, 20d
    section Phase 2
    Task 3 :2024-02-15, 25d
```

### Pie Chart

```mermaid
pie title Distribution
    "Category A" : 40
    "Category B" : 30
    "Category C" : 20
    "Category D" : 10
```

### Git Graph

```mermaid
gitGraph
    commit
    commit
    branch develop
    checkout develop
    commit
    commit
    checkout main
    merge develop
    commit
```

## Configuration Options

| Option | Description | Values |
|--------|-------------|--------|
| `theme` | Diagram theme | `default`, `neutral`, `dark`, `forest` |
| `scale` | Scale factor | `0.5`, `0.8`, `1.0`, etc. |
| `themeVariables` | Custom theme colors | Object with color values |

Example with theme variables:

````markdown
```mermaid {themeVariables: {primaryColor: '#ff0000'}}
graph LR
    A --> B
```
````
