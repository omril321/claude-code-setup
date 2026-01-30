# Task Priority Rules

When multiple components could apply to a task, use these heuristics to determine priority ordering.

## Contents
- General Priority Heuristics
- Task-Specific Ordering
- Conflict Resolution

## General Priority Heuristics

1. **Specificity wins** - A skill mentioning the exact library in package.json beats a generic skill
2. **Description match** - Skills whose "Use when..." closely matches the task get priority
3. **Dependency availability** - Skip skills requiring unavailable dependencies

## Task-Specific Ordering

### Testing Tasks
1. Framework-specific skills (description mentions library found in package.json)
2. Generic testing skills (description mentions "testing" without specific framework)
3. Debugging skills (add as fallback if tests might fail)

### Debugging Tasks
1. Methodology skills (descriptions mentioning "systematic", "hypothesis", "root cause")
2. Tool-specific skills (descriptions mentioning available MCPs or browser tools)
3. Framework-specific debugging (if framework detected)

### Planning Tasks
1. Planning methodology skills (descriptions mentioning "planning", "success criteria")
2. Architecture/expert agents (for strategic or type system decisions)

### PR Preparation
1. Validation skills (descriptions mentioning "check", "validate", "pre-PR")
2. Commit/PR creation skills (descriptions mentioning "commit", "PR", "pull request")

## Conflict Resolution

When multiple skills match equally:
- **Include all applicable** - List all, note primary recommendation
- **Let context decide** - More specific task description → more specific skill
- **Check recency** - Recently added skills may supersede older ones for same purpose
