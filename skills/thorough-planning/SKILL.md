---
name: thorough-planning
description: Use when planning complex tasks, encountering "plan" keywords, or detecting multi-step implementation - enforces context gathering before coding through mandatory success criteria and feedback loops
allowed-tools: Bash(ls:*), Bash(grep:*), Read, mcp__sequential-thinking__sequentialthinking
hooks:
  PreToolUse:
    - matcher: "ExitPlanMode"
      hooks:
        - type: command
          command: "~/.claude/skills/thorough-planning/pre-exit-plan-reminder.sh"
---

# Thorough Planning

## Overview

Planning without success criteria is hoping. Before writing any code, you must know:

1. **How will we know it worked?** (Success criteria)
2. **How will we know we're on track?** (Feedback loops)

**Core principle:** Define "done" before starting. Measurable outcomes before implementation.

## When to Use

**Use when:**

- User says "plan", "design", "implement", "build", "refactor"
- Task requires 3+ steps or multiple files
- Success/done criteria are unclear
- You don't know how to verify progress

**Don't use when:**

- Single-line fix with clear error message
- User provides explicit success criteria already
- Trivial change (rename, format, small edit)

## Quick Reference

| Situation            | Action                                             |
| -------------------- | -------------------------------------------------- |
| "Build X feature"    | Define success criteria FIRST                      |
| Multi-step task      | Establish feedback loop                            |
| "Just make it work"  | Clarify what "work" means measurably               |
| Unclear requirements | Ask user (don't assume)                            |
| "Simple" task        | Simple tasks get simple criteria - still need them |

## Surface Assumptions First

Before proceeding, state explicitly:
- **Interpretation:** If multiple ways to read the request, present them - don't pick silently
- **Approach:** If a simpler approach exists, say so. Push back when warranted.
- **Unknowns:** If something is unclear, stop. Name what's confusing. Ask.

Template:
```
My assumptions:
- User wants: [interpretation]
- Tech approach: [framework/pattern assumed]
- Scope: [what's included/excluded]

If any assumption is wrong, let me know before I proceed.
```

## The Pattern

### 1. Define Success Criteria (MANDATORY)

Before ANY implementation, answer explicitly:

| Question                    | Template                                          |
| --------------------------- | ------------------------------------------------- |
| What does "done" look like? | "Task complete when [observable outcome]"         |
| How will user verify?       | "User can verify by [action] and seeing [result]" |
| What's the acceptance test? | "If [condition] then [expected behavior]"         |

**If you can't answer these, ASK THE USER.** Do not proceed without at least one measurable criterion.

### Transform Vague Tasks to Verifiable Goals

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |
| "Make it faster" | "Benchmark before/after, target: X% improvement" |

### 2. Define Feedback Loops (MANDATORY)

How will you know you're on track DURING implementation?

| Loop Type           | When to Use                                |
| ------------------- | ------------------------------------------ |
| Test-driven         | New feature/bug - write failing test first |
| Incremental         | Multi-step - verify each step before next  |
| Build check         | Code changes - run build after each file   |
| Manual verification | UI changes - preview at each stage         |

**At least one feedback loop required before starting.**

### 3. Research Phase

Prefer researching before coding. Use subagents for:

- Exploring multiple files in parallel
- Searching documentation
- Understanding existing patterns

**Discover available tools (MANDATORY):** Invoke the **context-suggest** skill to discover all available skills, agents, commands, and MCP tools for this project. This is required - the discovered tools will be displayed in the Tools Summary (Step 7).

**For complex plans:** When breaking down intricate problems, use the `sequential_thinking` MCP tool to decompose step by step with revision support.

### 4. Handle Uncertainty

| Uncertainty Type     | Action                                          |
| -------------------- | ----------------------------------------------- |
| Requirements unclear | ASK USER - do not guess                         |
| Technical unknown    | Use systematic-debugging skill                  |
| Multiple approaches  | Ask user, then document with **decision-journal** |

**Default:** When uncertain, ask user.

**Document decisions:** When choosing between approaches, use the **decision-journal** skill to capture context, options, rationale, and trade-offs in the plan file.

### 5. Surface Quality Considerations (Advisory)

Use the **code-quality-gate** skill to surface relevant quality considerations before implementation:

| Category     | Consider                                        |
| ------------ | ----------------------------------------------- |
| Simplicity   | Minimum code, no speculative features           |
| Change Scope | Touch only what's needed, match existing style  |
| Architecture | Pattern consistency, separation of concerns     |
| Correctness  | Edge cases, error handling, type safety         |
| Readability  | Naming, complexity, single responsibility       |

Not all apply to every task. Identify which are relevant and note them in the plan.

### 6. Document Brief Plan

```markdown
## Assumptions

- User wants: [interpretation]
- Tech approach: [framework/pattern assumed]
- Scope: [what's included/excluded]

## Success Criteria

- [ ] [Criterion 1 - observable/testable]

## Feedback Loop

- [How you'll verify during implementation]

## Decisions

### [Decision Title]
**Chose** [X] **over** [Y] **because** [reason]. **Trade-off:** [cost].

## Quality Considerations

- **Simplicity:** [minimum code, no speculative features]
- **Change Scope:** [touch only what's needed]
- **Architecture:** [relevant considerations]
- **Correctness:** [edge cases, error handling]
- **Readability:** [naming, complexity notes]

## Steps (with inline verification)

1. [Step] → verify: [how you'll know it worked]
```

### 7. Display Tools Summary (MANDATORY)

After completing the plan, display a prominent summary of all tools that will be used.

**Invoke the `context-suggest` skill** to discover available components, then output:

```markdown
## 🛠️ Tools & Skills for This Plan (TOOLS_SKILLS_SUMMARY)

### 🎯 Skills

- **[skill-name]**: [when it will be used in the plan]

### 🤖 Agents

- **[agent-name]**: [when it will be used in the plan]

### ⌨️ Commands

- **/[command]**: [when it will be used in the plan]

### 🔌 MCP Tools

- **[mcp-name]**: [when it will be used in the plan]
```

**Rules:**

- Only list components that ARE actually used in the plan steps
- Each entry must reference WHEN in the plan it's used
- Skip empty categories (don't show "Agents" section if none are used)
- This summary is the LAST thing shown before implementation begins

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| "It's simple, no need to plan" | Simple tasks = simple criteria. 30 seconds. Do it. |
| "I asked questions" | Questions ≠ success criteria. Frame them explicitly. |
| "I'll know done when I see it" | That's discovery, not planning. Define upfront. |
| "User wants speed" | Fast + wrong = slower than planned + right |
| "Research first" | Know what "done" looks like BEFORE researching |
| Exploring before defining "done" | Define what you're looking FOR before searching |

## Extended Content

- **references/question-bank.md** - Question templates by category
- **references/subagent-prompts.md** - Research subagent prompts
- **references/examples.md** - Good vs bad planning examples

## Related Skills

- **decision-journal** - Capture architectural decisions with context and rationale
- **code-quality-gate** - Architecture, correctness, and readability checklist

## Before Exiting Plan Mode

Verify: Tools Summary section displayed. If missing, invoke `/context-suggest` first.
