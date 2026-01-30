# Subagent Prompts for Research Phase

## When to Use Subagents

Use subagents during planning when:
- Exploring multiple files or directories
- Searching for existing patterns
- Understanding integration points
- Gathering context from documentation

**Key rule:** Know your success criteria BEFORE dispatching research subagents.

## Research Subagent Template

```markdown
Research [AREA] for the planning phase.

Context: We are planning to [TASK]. Success means [SUCCESS CRITERIA].

Find:
1. Existing patterns for [TASK TYPE]
2. Integration points with [COMPONENT]
3. Potential pitfalls or edge cases

Return:
- File paths containing relevant patterns
- Code snippets showing the approach
- Any warnings or considerations
```

## Parallel Research Pattern

When multiple areas need exploration, dispatch parallel agents:

```markdown
Agent 1: "Search for [component A] implementation patterns"
Agent 2: "Find all usages of [API/function] to understand integration"
Agent 3: "Look for existing tests to understand expected behavior"
```

## Aggregating Results

After subagents return:
1. Summarize findings relevant to success criteria
2. Identify any conflicts or concerns
3. Update plan with discovered constraints
4. Ask user if findings change the approach
