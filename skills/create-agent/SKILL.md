---
name: create-agent
description: "Guides creation of Claude Code subagents with proper frontmatter, system prompts, tool assignments, and triggering descriptions. Use when user says 'create an agent', 'add an agent', 'write a subagent', 'new agent', 'make an agent', or needs help with agent file structure, frontmatter, system prompts, or triggering conditions."
---

# Create Agent

Guide the user through creating a well-designed Claude Code subagent with proper frontmatter, system prompt, tool assignments, and triggering description.

## Agent File Format

Agent files are markdown with YAML frontmatter. The body becomes the system prompt.

### Required Fields

| Field | Format | Constraints | Example |
|-------|--------|-------------|---------|
| `name` | kebab-case | 3-50 chars, alphanumeric start/end | `code-reviewer` |
| `description` | Text + `<example>` blocks | 10-5000 chars | `Use this agent when...` |
| `model` | Enum | `inherit` (default), `sonnet`, `opus`, `haiku` | `inherit` |
| `color` | Enum | `blue`, `cyan`, `green`, `yellow`, `magenta`, `red` | `blue` |

### Optional Fields (ask only when relevant)

| Field | Format | Purpose |
|-------|--------|---------|
| `tools` | Comma-separated list | Tool allowlist (e.g., `Read, Grep, Glob`) |
| `disallowedTools` | Comma-separated list | Tool denylist |
| `skills` | Comma-separated list | Preloaded skills |
| `mcpServers` | Comma-separated list | MCP server access |
| `permissionMode` | Enum | `default`, `acceptEdits`, `delegate`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | Positive integer | Max agentic turns |
| `hooks` | YAML object | Lifecycle hooks (PreToolUse, PostToolUse) |
| `memory` | Enum | `user`, `project`, `local` |

### File Template

```markdown
---
name: agent-name
description: "Use this agent when [triggers]. [What it does]. <example>Context: [situation] user: '[message]' assistant: '[response]' <commentary>[why]</commentary></example>"
model: inherit
color: blue
tools: Read, Grep, Glob
---

[System prompt body]
```

---

## Workflow

### Step 1: Discover

Scan the environment before asking questions.

**Run these discovery commands:**
```bash
# Existing agents
ls ~/.claude/agents/*.md 2>/dev/null
ls .claude/agents/*.md 2>/dev/null

# Available skills
ls ~/.claude/skills/*/SKILL.md 2>/dev/null
ls .claude/skills/*/SKILL.md 2>/dev/null
```

**Also check:**
- `ListMcpResourcesTool` for available MCP tools
- Existing commands via `ls ~/.claude/commands/*.md .claude/commands/*.md 2>/dev/null`

**Present summary:**
```
Environment:
- N existing agents (user: X, project: Y)
- Z MCP servers available
- W skills installed
```

### Step 2: Define

Ask targeted questions to understand the agent. Group related questions together.

**Purpose & Identity:**
- "What problem should this agent solve?" — Get specific about the domain and expertise
- "What is the agent's core task?" — Single responsibility: review, generate, analyze, orchestrate?

**Triggering & Invocation:**
- "When should Claude automatically invoke this agent?" — What user phrases, contexts, or situations?
- "Should it trigger proactively (after code is written) or only on explicit request?"

**Boundaries & Scope:**
- "What should this agent NOT do?" — Explicit negative boundaries, especially relative to existing agents
- "Should this be user-level (`~/.claude/agents/`) or project-level (`.claude/agents/`)?"

| Scope | Location | Use When |
|-------|----------|----------|
| User | `~/.claude/agents/` | General-purpose, reusable across projects |
| Project | `.claude/agents/` | Project-specific, uses project conventions |

### Step 3: Configure

Determine permissions, tools, and access control.

**Tool Access (principle of least privilege):**
- "Does the agent need to read files only, or also write/modify them?"
- "Does it need to execute commands (Bash)?"
- "Does it need web access (WebFetch, WebSearch)?"

| Category | Tools | When to Include |
|----------|-------|-----------------|
| Read-only | `Read, Grep, Glob` | Default for analysis agents |
| Write | `Write, Edit, MultiEdit` | Only if agent modifies files |
| Execution | `Bash` | Only if agent runs commands |
| Web | `WebFetch, WebSearch` | If agent needs external info |
| Notebook | `NotebookEdit` | If working with Jupyter |
| IDE | `mcp__ide__getDiagnostics` | If agent needs LSP diagnostics |

Recommend starting with read-only. Ask about tools that should be explicitly DENIED (`disallowedTools`).

**Model Selection:**

| Model | When to Use |
|-------|-------------|
| `inherit` | Default — matches parent conversation model |
| `haiku` | Simple, fast tasks (linting, formatting checks) |
| `sonnet` | Balanced — most agents |
| `opus` | Complex reasoning (architecture, security analysis) |

Default to `inherit` unless there's a specific reason.

**Skills & MCP:**
- "Should it have access to specific skills?" — List discovered skills
- "Does it need MCP server access?" — List discovered MCP tools

**Advanced (ask only if relevant to the agent's purpose):**
- `permissionMode` — If agent needs auto-approval or restricted mode
- `maxTurns` — If agent should be time-bounded
- `hooks` — If agent needs pre/post tool validation
- `memory` — If agent should persist knowledge across sessions

**Overlap Check:** Compare against discovered agents. Flag conflicts, suggest boundaries.

### Step 4: Engineer Description

Write trigger conditions + 2-4 `<example>` blocks.

**Pattern:**
```
Use this agent when [specific triggers]. [What it does].

<example>
Context: [Situation]
user: "[Typical user message]"
assistant: "[How Claude responds before triggering]"
<commentary>[Why this agent is appropriate]</commentary>
assistant: "I'll use the [agent-name] agent to [task]."
</example>
```

**Requirements:**
- Include 2-4 concrete examples
- Vary phrasing across examples
- Cover both reactive (explicit request) and proactive (after relevant work) triggers
- Commentary must explain WHY the agent triggers
- Show Claude using the Task tool, not the agent's output

Consult `references/triggering-examples.md` for patterns and templates.

### Step 5: Write System Prompt

Follow the structure: role -> responsibilities -> process -> quality -> output -> edge cases.

**Template:**
```markdown
You are [specific role] specializing in [domain].

**Your Core Responsibilities:**
1. [Primary responsibility]
2. [Secondary responsibility]
3. [Additional as needed]

**[Task] Process:**
1. [Concrete step with tool usage]
2. [Next step]
3. [Continue...]

**Quality Standards:**
- [Measurable standard 1]
- [Measurable standard 2]

**Output Format:**
[Specific structure for results]

**Edge Cases:**
- [Situation]: [How to handle]
```

**Writing guidelines:**
- Second person ("You are...", "You will...")
- Specific over vague ("Check for SQL injection" not "look for security issues")
- Concrete steps ("Read files using Read tool" not "analyze the code")
- Defined output format with structure
- Explicit negative boundaries ("You do NOT handle X")

Consult `references/system-prompt-patterns.md` for the 4 agent type patterns.

### Step 6: Validate & Create

1. **Preview** the complete agent file — show the full content for user approval
2. **Run validator:**
   ```bash
   bash ~/.claude/skills/create-agent/scripts/validate-agent.sh <path/to/agent.md>
   ```
3. **Create** at chosen location (`~/.claude/agents/` or `.claude/agents/`)
4. **Test** invocation — try phrasing from the examples to verify triggering

---

## Quick Reference

### Color Semantics

| Color | Typical Use |
|-------|-------------|
| `blue` | Analysis, review, investigation |
| `cyan` | Documentation, information |
| `green` | Generation, creation |
| `yellow` | Validation, warnings, caution |
| `red` | Security, critical analysis |
| `magenta` | Refactoring, transformation, creative |

### Agent Locations

| Location | Scope | Use When |
|----------|-------|----------|
| `~/.claude/agents/` | User (global) | Reusable across all projects |
| `.claude/agents/` | Project | Project-specific workflows |

### Minimal Agent Example

```markdown
---
name: simple-reviewer
description: "Use this agent when... <example>...</example>"
model: inherit
color: blue
tools: Read, Grep, Glob
---

You are a [role]. [System prompt body.]
```

---

## Reference Files

Consult these for detailed guidance:

| Reference | When to Use |
|-----------|-------------|
| `references/system-prompt-patterns.md` | Writing system prompts — 4 agent type patterns with templates |
| `references/triggering-examples.md` | Writing `<example>` blocks — format, types, common mistakes |
| `references/agent-examples.md` | Full production-ready agent files — code reviewer, test generator, security analyzer |
