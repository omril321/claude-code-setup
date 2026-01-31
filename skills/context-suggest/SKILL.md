---
name: context-suggest
description: Discovers relevant skills, agents, commands, and MCP tools by scanning project context and tool capabilities. Use when entering planning mode, starting work on a new codebase, or when user asks about available tools. Auto-triggers with thorough-planning skill.
allowed-tools: Read, Glob, ListMcpResourcesTool
---

# Context Suggest

## Overview

Discover and ensure relevant components are incorporated into plans. Scans project context and all available Claude components (skills, agents, commands, MCPs) to identify which should be used for the current task.

**Core principle:** Ensure nothing relevant is missed. Every applicable component should be in the plan.

## When to Use

| Use when | Don't use when |
|----------|----------------|
| Planning complex tasks | Simple single-file changes |
| Starting work on new codebase | Mid-implementation |
| Unfamiliar with project's tools | Trivial one-step tasks |

## Invocation

**Automatic:** Triggers when thorough-planning skill activates
**Manual:** User asks "what tools should I use?" or invokes `/context-suggest`

## Process

### Step 1: Gather Project Context

For detection patterns, see [references/project-detection.md](references/project-detection.md).

**Run these in parallel:**

```bash
Read: ./package.json                    # Dependencies
Glob: **/vitest.config.*, **/jest.config.*  # Test framework
Glob: **/*.test.*, **/*.spec.*          # Test file patterns
Glob: **/*.stories.*                    # Storybook presence
ListMcpResourcesTool                    # Available MCPs
```

Extract and note:
- All dependencies (dependencies + devDependencies)
- Test framework (vitest/jest/other)
- Available MCP tools
- Project patterns (monorepo, microfrontend)

### Step 2: Discover All Available Components

**Run these in parallel:**

```bash
# Skills (read frontmatter from each)
Glob: ~/.claude/skills/*/SKILL.md
Glob: ./.claude/skills/*/SKILL.md

# Agents (read frontmatter from each)
Glob: ~/.claude/agents/*.md
Glob: ./.claude/agents/*.md

# Commands
Glob: ~/.claude/commands/*.md
Glob: ./.claude/commands/*.md
```

For each discovered file, read its frontmatter to get `name` and `description`.

**MCP Capability Analysis:**
After ListMcpResourcesTool, for each MCP:
1. Read tool descriptions from available tool list
2. Extract key capabilities (navigate, debug, execute, screenshot, etc.)
3. Match capabilities against current task type

### Step 3: Determine Relevance

For each discovered skill/agent/command, evaluate:

1. **Does the description match the project context?**
   - Read the "Use when..." in description
   - Compare against detected dependencies, file patterns, MCPs

2. **Does the description match the current task?**
   - Testing task → testing-related skills
   - Debugging task → debugging skills
   - Planning task → planning skills
   - PR prep → pre-PR skills

3. **Are required dependencies/MCPs available?**
   - If description mentions a library → is it in package.json?
   - If description mentions MCP → is it available?

**Use your judgment.** Descriptions are self-documenting. If a skill says "Use when writing tests for [framework X]", determine if this project uses that framework by checking package.json for related packages.

### Step 4: Output Required Components

For format examples, see [references/output-templates.md](references/output-templates.md).
For priority ordering, see [references/priority-rules.md](references/priority-rules.md).

Generate a section for the plan with **mandatory inclusions**:

```markdown
## Components to Use in This Plan

### Required Skills
- **[skill name]**: [why relevant] - [how to use it]

### Required Agents
- **[agent name]**: [why relevant] - [when to invoke]

### Required Commands
- **/[command]**: [why relevant] - [when to use]

### Available MCPs
- **[mcp name]**: [relevant capabilities]
```

This section becomes part of the implementation plan, not a suggestion.

**If no relevant components found:**
Output: "No specialized components match this task context. Proceeding with standard Claude Code capabilities."

### Step 5: Verify Integration

1. Count: discovered components vs. components in output
2. For each plan step, confirm a component is assigned if applicable
3. If discovered > assigned, re-evaluate or note as "not applicable for this task"

## Ensuring Usage

**The goal is enforcement, not suggestion.**

When generating the plan:
1. Include discovered components in the plan steps
2. Reference which skill/agent to use for each step
3. Specify commands to run at appropriate phases

Example plan integration:
```markdown
## Implementation Steps

1. Write tests for the new feature
   → Use **testing** skill for test patterns and mocking

2. Debug any failing tests
   → Use **systematic-debugging** skill if root cause unclear

3. Prepare PR
   → Run **/code-quality-gate** before creating PR
   → Use **/commit** for commit message
   → Use **/create-pr** for PR creation
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Only suggesting, not ensuring | Include components directly in plan steps |
| Missing project-specific components | Check project-level .claude/ directory |
| Ignoring MCP availability | Run ListMcpResourcesTool |
| Hardcoding component lists | Always scan dynamically - new components are auto-discovered |

