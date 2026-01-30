# Claude Search Optimization (CSO) - Keywords

## Keyword Coverage

Use words Claude would search for:

**Error messages:**
- "Hook timed out"
- "race condition"
- Specific error text users see

**Symptoms:**
- "flaky", "hanging", "zombie"
- "undefined", "null", "missing"
- "slow", "timeout"

**Tools:**
- Actual command names
- Library names
- Framework names

## Good vs Bad Descriptions

**Bad - Too vague:**
```yaml
description: For async testing
```

**Good - Specific triggers + what it does:**
```yaml
description: Use when tests have race conditions or pass/fail inconsistently - replaces arbitrary timeouts with condition polling
```

## Naming Conventions

**Use gerunds (-ing) with human-readable format:**
- "Creating Skills" not "skill-creation"
- "Condition Based Waiting" not "async-test-helpers"
- "Debugging Flaky Tests" not "test-flakiness"

**Name format:** Human-readable with spaces and capitalization

## Description Format

- Max 1024 characters total for frontmatter
- Third-person voice
- Start with what it does, then "Use when..."
- Include triggering conditions
- Be specific about capabilities

Example:
```yaml
description: Does X and Y in third person. Use when [triggering conditions].
```
