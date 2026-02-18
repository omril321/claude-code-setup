# Triggering Examples Guide

How to write effective `<example>` blocks in agent descriptions for reliable auto-invocation.

## Example Block Format

```markdown
<example>
Context: [Situation — what led to this interaction]
user: "[Exact user message]"
assistant: "[How Claude responds before triggering]"
<commentary>
[Why this agent should be triggered]
</commentary>
assistant: "I'll use the [agent-name] agent to [task]."
</example>
```

### Required Components

| Component | Purpose | Example |
|-----------|---------|---------|
| Context | Set the scene | "User just implemented authentication" |
| user | Trigger phrase | "Can you check my code?" |
| assistant | Pre-trigger response | "I'll review the implementation." |
| commentary | Reasoning | "Auth code needs security review" |
| assistant (2nd) | Agent invocation | "I'll use the security-analyzer agent..." |

---

## 4 Trigger Types

### Type 1: Explicit Request

User directly asks for what the agent does.

```markdown
<example>
Context: User explicitly requests security analysis
user: "Check my code for security vulnerabilities"
assistant: "I'll use the security-analyzer agent to perform a thorough security review."
<commentary>
Direct security analysis request triggers the security-analyzer agent.
</commentary>
</example>
```

### Type 2: Proactive Triggering

Agent triggers after relevant work without explicit request.

```markdown
<example>
Context: User just implemented database queries
user: "I've added the user search functionality"
assistant: "Great! Let me review it for security."
<commentary>
Database code written. Proactively trigger security-analyzer to check
for SQL injection and other database security issues.
</commentary>
assistant: "I'll use the security-analyzer agent to check the database code."
</example>
```

### Type 3: Implicit Request

User implies need without stating it directly.

```markdown
<example>
Context: User mentions code is hard to understand
user: "This code is confusing and hard to follow"
assistant: "I can help improve the code clarity."
<commentary>
User indicates complexity issues. Trigger code-simplifier agent to
refactor for better readability.
</commentary>
assistant: "I'll use the code-simplifier agent to suggest improvements."
</example>
```

### Type 4: Tool Usage Pattern

Agent triggers based on prior tool usage or activity.

```markdown
<example>
Context: User made multiple edits to test files
user: "I've updated all the tests"
assistant: "Let me verify test quality."
<commentary>
Multiple Edit tools used on test files. Proactively trigger
test-quality-analyzer to ensure tests follow best practices.
</commentary>
assistant: "I'll use the test-quality-analyzer agent to review the tests."
</example>
```

---

## Strategy

### How Many Examples?

| Count | Coverage |
|-------|----------|
| 2 (minimum) | Explicit request + one variation |
| 3-4 (recommended) | Explicit + implicit + proactive + edge case |
| 6 (maximum) | More makes description too long |

### What to Cover

1. **Explicit request** — direct ask using common phrasing
2. **Proactive trigger** — after relevant work is done
3. **Varied phrasing** — different ways to say the same thing
4. **Edge case** — unusual but valid triggering scenario

### Example: Complete Coverage

```markdown
description: "Use this agent when code needs quality review. <example>
Context: User explicitly requests review
user: 'Review my code for issues'
assistant: 'I'll use the code-reviewer agent to perform a comprehensive review.'
<commentary>Explicit review request triggers the agent.</commentary>
</example>

<example>
Context: User just finished implementing a feature
user: 'I've added the payment processing feature'
assistant: 'Let me review the implementation.'
<commentary>Payment code is security-critical. Proactively review.</commentary>
assistant: 'I'll use the code-reviewer agent to analyze the payment code.'
</example>

<example>
Context: User asks for feedback on changes
user: 'Can you look over these changes?'
assistant: 'I'll use the code-reviewer agent to review the modifications.'
<commentary>Implicit review request with different phrasing.</commentary>
</example>"
```

---

## Common Mistakes

### Missing Context

```markdown
<!-- BAD -->
<example>
user: "Review my code"
assistant: "I'll use the code-reviewer agent."
</example>

<!-- GOOD -->
<example>
Context: User just finished implementing authentication
user: "Review my code"
assistant: "I'll use the code-reviewer agent to analyze the auth implementation."
<commentary>Auth code written, review for security and best practices.</commentary>
</example>
```

### No Commentary

```markdown
<!-- BAD: doesn't explain WHY -->
<example>
Context: User requests review
user: "Check my changes"
assistant: "I'll use the reviewer agent."
</example>

<!-- GOOD: explains reasoning -->
<example>
Context: User requests review after making changes
user: "Check my changes"
assistant: "I'll use the code-reviewer agent to analyze the modifications."
<commentary>Code review request triggers agent to check quality and standards.</commentary>
</example>
```

### Showing Agent Output Instead of Invocation

```markdown
<!-- BAD: shows what agent produces -->
<example>
user: "Review my code"
assistant: "I found the following issues: [lists issues]"
</example>

<!-- GOOD: shows triggering -->
<example>
user: "Review my code"
assistant: "I'll use the code-reviewer agent to perform the review."
<commentary>Review request triggers the agent.</commentary>
</example>
```

---

## Quick Templates

### Reviewer Agent

```markdown
<example>
Context: User just implemented a new feature
user: "I've added the [feature]"
assistant: "Let me review the code quality."
<commentary>Code written, proactively trigger review.</commentary>
assistant: "I'll use the [name] agent to analyze the implementation."
</example>

<example>
Context: User explicitly requests review
user: "Can you review my changes?"
assistant: "I'll use the [name] agent to perform a thorough review."
<commentary>Explicit review request triggers the agent.</commentary>
</example>
```

### Generator Agent

```markdown
<example>
Context: User implemented functions without tests
user: "I've added the [functions]"
assistant: "Let me generate tests for these."
<commentary>New code without tests, proactively generate.</commentary>
assistant: "I'll use the [name] agent to create comprehensive tests."
</example>

<example>
Context: User explicitly asks for generation
user: "Generate [output] for my code"
assistant: "I'll use the [name] agent to create [output]."
<commentary>Direct generation request triggers the agent.</commentary>
</example>
```

### Analyzer Agent

```markdown
<example>
Context: User implemented security-critical code
user: "I've added [security-related feature]"
assistant: "Let me check the security."
<commentary>Security-critical code written. Proactively analyze.</commentary>
assistant: "I'll use the [name] agent to review for vulnerabilities."
</example>

<example>
Context: User requests analysis
user: "Check my code for [issues]"
assistant: "I'll use the [name] agent to perform a thorough analysis."
<commentary>Explicit analysis request triggers the agent.</commentary>
</example>
```
