---
name: context-suggest
description: This skill discovers relevant skills, agents, commands, and MCP tools by scanning project context and tool capabilities. This skill should be used when entering planning mode, starting work on a new codebase, or when the user asks "what tools should I use?" Auto-triggers with thorough-planning skill.
allowed-tools: Read, Glob, ListMcpResourcesTool, Task
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

### Step 0: Generate Task Summary

Before dispatching subagents, analyze the conversation to create a structured task summary. This summary enables subagents to filter relevant skills efficiently.

**Task Summary Template:**
```markdown
## Task Summary for Skill Analysis

**Task Type:** [planning | debugging | testing | implementation | refactoring | documentation | presentation | PR-prep]
**Task Description:** [1-2 sentence summary of what the user wants to accomplish]
**Key Signals:**
- Technologies: [mentioned frameworks, libraries, tools from conversation]
- Keywords: [test, debug, plan, slides, PR, commit, etc.]
- Domain: [frontend, backend, API, CLI, infrastructure, etc.]
```

**How to determine Task Type:**
| Signal in Conversation | Task Type |
|------------------------|-----------|
| "write tests", "test coverage", "failing test" | testing |
| "bug", "not working", "error", "debug" | debugging |
| "plan", "implement", "build", "add feature" | planning / implementation |
| "refactor", "clean up", "improve structure" | refactoring |
| "slides", "presentation", "demo" | presentation |
| "PR", "pull request", "review" | PR-prep |
| "README", "docs", "document" | documentation |

This task summary will be passed to all subagents to enable relevance-aware filtering.

### Step 1: Parallel Discovery with Task Context

Dispatch up to 3 Explore subagents in parallel, passing the task summary to each:

**Subagent 1: Project Context**
- Read package.json for dependencies
- Glob for test configs (vitest.config.*, jest.config.*)
- Glob for test files (*.test.*, *.spec.*)
- Return: dependencies list, test framework, project patterns

**Plugin Discovery (applies to Subagents 2 and 3):**
Read `~/.claude/plugins/installed_plugins.json` to discover installed plugins. Each key is `{plugin-name}@{marketplace}` mapping to an array of installation entries. Use the `installPath` from each entry to discover plugin capabilities. Label all plugin capabilities as `{plugin-name}:{capability-name}`. If the file is missing or unparseable, skip plugin discovery and continue.

**Subagent 2: Skills & Commands (Progressive Disclosure)**

This subagent uses progressive disclosure to minimize token usage:

1. **First pass - Frontmatter only:**
   - Glob ~/.claude/skills/*/SKILL.md and ./.claude/skills/*/SKILL.md
   - For each installed plugin (from installed_plugins.json), glob {installPath}/skills/*/SKILL.md. Label as "{plugin-name}:{skill-name}".
   - Glob ~/.claude/commands/*.md and ./.claude/commands/*.md
   - For each installed plugin, glob {installPath}/commands/*.md. Label as "{plugin-name}:{command-name}".
   - For each file, read ONLY the frontmatter (content between first `---` and second `---`)
   - Extract: name, description

2. **Evaluate relevance against task summary:**
   - Compare each skill's description against Task Type and Key Signals
   - Mark as RELEVANT if description keywords match task context
   - Mark as NOT_RELEVANT if no connection to task

3. **Return structured results:**
```yaml
relevant_skills:
  - name: testing
    description: "Comprehensive testing skill..."
    reason: "Task type is testing, matches skill purpose"
  - name: cf-internal-claude-plugin:commit
    description: "Create a git commit with a concise, accurate message"
    reason: "Code changes planned, plugin provides commit message generation"

not_relevant_skills:
  - name: slidev
    reason: "No presentation keywords in task"
  - name: blog-writer
    reason: "Task is implementation, not content creation"
```

**Subagent prompt template:**
```
Given the following task context:
{TASK_SUMMARY}

Discover all skills and commands, then evaluate relevance:

1. Glob ~/.claude/skills/*/SKILL.md and ./.claude/skills/*/SKILL.md
2. Glob ~/.claude/commands/*.md and ./.claude/commands/*.md
3. Read ~/.claude/plugins/installed_plugins.json. Each key is "{plugin-name}@{marketplace}" mapping to an array of entries. For each entry, glob {installPath}/skills/*/SKILL.md and {installPath}/commands/*.md. Label as "{plugin-name}:{name}" (plugin-name = part before @). If file missing or unparseable, skip.
4. For EACH discovered file (user-level and plugin), read ONLY the frontmatter (lines between --- markers)
5. Compare each skill's description against the task summary
6. Return YAML with relevant_skills, not_relevant_skills, relevant_commands lists

Important: Do NOT read full skill files. Only read frontmatter for efficiency.
Return structured YAML output as shown in the template.
```

**Subagent 3: Agents & MCPs (Progressive Disclosure)**

Same progressive disclosure pattern as Subagent 2:

1. **First pass - Frontmatter only:**
   - Glob ~/.claude/agents/*.md and ./.claude/agents/*.md
   - For each installed plugin (from installed_plugins.json), glob {installPath}/agents/*.md. Label as "{plugin-name}:{agent-name}".
   - Read ONLY frontmatter from each agent
   - ListMcpResourcesTool for available MCPs

2. **Evaluate relevance against task summary:**
   - Compare agent descriptions against Task Type and Key Signals
   - Evaluate MCP capabilities against task needs

3. **Return structured results:**
```yaml
relevant_agents:
  - name: test-runner
    reason: "Task involves testing"

not_relevant_agents:
  - name: presentation-builder
    reason: "No presentation keywords"

relevant_mcps:
  - name: chrome-devtools
    reason: "Task mentions browser debugging"
```

**Subagent prompt template:**
```
Given the following task context:
{TASK_SUMMARY}

Discover all agents and MCPs, then evaluate relevance:

1. Glob ~/.claude/agents/*.md and ./.claude/agents/*.md
2. Read ~/.claude/plugins/installed_plugins.json. Each key is "{plugin-name}@{marketplace}" mapping to an array of entries. For each entry, glob {installPath}/agents/*.md. Label as "{plugin-name}:{agent-name}" (plugin-name = part before @). If file missing or unparseable, skip.
3. For EACH discovered agent file, read ONLY the frontmatter (lines between --- markers)
4. Use ListMcpResourcesTool to discover available MCP servers
5. Compare each agent/MCP against the task summary
6. Return YAML with relevant_agents, not_relevant_agents, relevant_mcps lists

Important: Do NOT read full agent files. Only read frontmatter for efficiency.
Return structured YAML output as shown in the template.
```

**Why subagents with task context:** Subagents can filter irrelevant skills at discovery time, avoiding loading full SKILL.md content for skills that won't be used. This achieves 75-90% token reduction.

**Efficiency pattern:**
```
Task(subagent_type=Explore, prompt="Given task summary: {...}. Gather project context...")
Task(subagent_type=Explore, prompt="Given task summary: {...}. Discover skills using progressive disclosure...")
Task(subagent_type=Explore, prompt="Given task summary: {...}. Discover agents/MCPs using progressive disclosure...")
```
All three run in parallel, results pre-filtered by relevance.

For detection patterns, see [references/project-detection.md](references/project-detection.md).

### Step 2: Aggregate and Selectively Load

Combine subagent results, then load full content ONLY for relevant skills:

**From Subagent 1 (Project Context):**
- All dependencies (dependencies + devDependencies)
- Test framework (vitest/jest/other)
- Project patterns (monorepo, microfrontend)

**From Subagent 2 (Skills - Pre-filtered):**
- `relevant_skills`: Read FULL SKILL.md for these only
- `not_relevant_skills`: Keep skip reason, don't load full content

**From Subagent 3 (Agents/MCPs - Pre-filtered):**
- `relevant_agents`: Read full agent file if needed
- `relevant_mcps`: Record capabilities
- `not_relevant_agents`: Keep skip reason

**Selective Loading Pattern:**
```
For each skill in relevant_skills:
  - Read full SKILL.md (beyond frontmatter)
  - Extract: detailed instructions, reference file paths
  - Do NOT load reference files yet (lazy loading in Step 4)

For each skill in not_relevant_skills:
  - Use pre-determined skip reason from subagent
  - No additional file reads needed
```

This ensures only relevant skills consume context tokens.

### Step 3: Validate and Refine Relevance

Subagents have pre-filtered skills by relevance. Now validate and refine:

**For relevant_skills (from Subagent 2):**

1. **Cross-check with project context (from Subagent 1):**
   - If skill mentions a library → verify it's in package.json
   - If skill mentions MCP → verify it's in relevant_mcps
   - Downgrade to SKIP if dependency missing

2. **Verify task alignment:**
   - Re-read the full skill content loaded in Step 2
   - Confirm the "Use when..." matches current task
   - Some skills may have been over-eagerly marked relevant

**For not_relevant_skills (from Subagent 2):**

1. **Quick sanity check:**
   - Review skip reasons
   - Override if subagent made obvious error
   - Usually trust subagent judgment (they have the context)

**Refinement criteria:**
| Check | Action |
|-------|--------|
| Skill requires library not in package.json | Downgrade to SKIP |
| Skill requires MCP not available | Downgrade to SKIP |
| Subagent marked irrelevant but clearly matches task | Upgrade to USE |
| Subagent marked relevant but "Use when" doesn't match | Downgrade to SKIP |

**Exercise judgment.** Subagent decisions are a starting point. You have full project context to make final decisions.

### Step 4: Output Skill Decisions

**MUST output an explicit decision for EVERY discovered skill, not just the ones being used.**

Generate a Decision Matrix showing the reasoning:

```markdown
## Skill Decisions for This Plan

| Skill | Decision | Reasoning |
|-------|----------|-----------|
| code-quality-gate | ✅ USE in Step 3 | Code changes planned, need quality considerations |
| decision-journal | ⏭️ SKIP | Single obvious approach (X), no alternatives to document |
| testing | ✅ USE in Step 4 | Writing new tests for the feature |
| slidev | ⏭️ SKIP | Not a presentation task |
| systematic-debugging | ⏭️ SKIP | No debugging needed, greenfield feature |

## Components to Use in This Plan
[Only the ✅ USE items, with details]
```

**Rules for the Decision Matrix:**
1. List ALL discovered skills (from ~/.claude/skills/, ./.claude/skills/, and installed plugins)
2. Every row needs: skill name, decision (✅ USE / ⏭️ SKIP), reasoning (1 sentence)
3. "USE" decisions must specify which plan step
4. "SKIP" decisions must state why it's not relevant
5. Empty reasoning = lazy compliance = not acceptable

For format examples, see [references/output-templates.md](references/output-templates.md).
For priority ordering, see [references/priority-rules.md](references/priority-rules.md).
For decision examples, see [references/decision-examples.md](references/decision-examples.md).

**Reference File Lazy Loading:**

Reference files (like those linked above) should ONLY be loaded:
- When generating the Decision Matrix requires specific examples
- For skills marked ✅ USE that have reference files

Do NOT load reference files for skills marked ⏭️ SKIP. This saves significant tokens.

After the Decision Matrix, generate a section for the plan with **mandatory inclusions**:

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
Output: "No specialized components match this task context. Proceeding with standard Claude Code capabilities." (But still show the Decision Matrix with SKIP decisions.)

### Step 5: Verify Decisions

Before completing output, verify:

1. **Coverage check:** Every discovered skill has a row in the Decision Matrix
2. **Reasoning check:** No empty or templated reasoning (e.g., "not needed" without context)
3. **Consistency check:** Skills marked USE appear in the plan steps below

If any check fails, revise the Decision Matrix before outputting.

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
| Missing plugin capabilities | Read installed_plugins.json and glob each plugin's installPath |

## Anti-Lazy Patterns

The Decision Matrix prevents these shortcuts:

| Lazy Pattern | What It Looks Like | Why It's Blocked |
|--------------|-------------------|------------------|
| Silent ignoring | Skill not mentioned at all | Matrix requires ALL skills |
| Generic dismissal | "Not applicable" with no context | Reasoning column required |
| Passive listing | "Available: X, Y, Z" without decisions | Decision column required |
| Template reasoning | Same reason for multiple skills | Each skill needs specific reasoning |

**The goal:** Force genuine evaluation of each skill against THIS specific task.

