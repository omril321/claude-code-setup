---
name: writing-skills
description: Creates and tests skills using TDD methodology for process documentation. Use when creating new skills, editing existing skills, or verifying skills work before deployment.
allowed-tools: Bash(wc:*), Read
---

# Writing Skills

**Writing skills IS Test-Driven Development applied to process documentation.**

Skills live in `~/.claude/skills`. You write test cases (pressure scenarios), watch them fail (baseline behavior), write the skill, watch tests pass, and refactor (close loopholes).

**Core principle:** If you didn't watch an agent fail without the skill, you don't know if the skill teaches the right thing.

## Token Optimization

Skills consume context tokens. Keep SKILL.md under 500 lines.

| Level      | What Loads         | When                    |
| ---------- | ------------------ | ----------------------- |
| Metadata   | Name + description | Always (~30-100 tokens) |
| SKILL.md   | Full main file     | When triggered          |
| References | Supporting files   | On-demand only          |

**Check size:** `wc -l skills/my-skill/SKILL.md` (target: <500 lines)

**Progressive disclosure:** Keep SKILL.md minimal, move details to `references/` subdirectory.

**Token-saving techniques:** See references/token-saving-techniques.md

## What is a Skill?

A **skill** is a reference guide for proven techniques, patterns, or tools.

**Skills are:** Reusable techniques, patterns, tools, reference guides
**Skills are NOT:** Narratives about how you solved a problem once

## Skill Types

| Type      | Description                | Examples                |
| --------- | -------------------------- | ----------------------- |
| Technique | Concrete method with steps | condition-based-waiting |
| Pattern   | Way of thinking            | flatten-with-flags      |
| Reference | API docs, syntax guides    | library documentation   |

## Directory Structure

```
skills/skill-name/
  SKILL.md       # Main reference (<500 lines)
  references/    # Detailed content
  scripts/       # Executable tools
```

**Flat namespace** - all skills in one searchable namespace

**Separate files for:**

1. Heavy reference (>100 lines)
2. Reusable tools/scripts

## SKILL.md Structure

```markdown
---
name: skill-name
description: Does X and Y in third person. Use when [triggers].
---

# Skill Name

## Overview

Core principle in 1-2 sentences.

## When to Use

Symptoms and use cases. When NOT to use.

## Quick Reference

Table or bullets for scanning.

## Core Pattern

Before/after code comparison.

## Common Mistakes

What goes wrong + fixes.
```

## Claude Search Optimization

Description field is critical for discovery. Format: [what it does] + "Use when..."

**Keywords:** Use error messages, symptoms, tool names that Claude would search for.
**Naming:** Name must match directory name exactly (lowercase, hyphenated): `skill-name`

**Details:** See references/cso-keywords.md

## The Iron Law

```
NO SKILL WITHOUT A FAILING TEST FIRST
```

Write skill before testing? Delete it. Start over. No exceptions.

## RED-GREEN-REFACTOR

1. **RED:** Test WITHOUT skill, document exact behavior
2. **GREEN:** Write minimal skill addressing specific failures
3. **REFACTOR:** Find new rationalizations, add counters, re-test

**Success criteria:**

- Agent follows rule under pressure
- Agent uses language from skill
- Agent doesn't rationalize around the rule

**Testing details:** See references/testing-with-subagents.md
**Bulletproofing:** See references/bulletproofing-skills.md

## STOP: Before Moving to Next Skill

After writing ANY skill, complete deployment before starting next one. Do NOT batch multiple skills without testing each.

## Skill Creation Checklist

**Testing:**

- [ ] Decide: Automated subagent OR manual testing
- [ ] Create 3+ pressure scenarios
- [ ] Run RED phase (baseline without skill)
- [ ] Document rationalizations/failures

**Writing:**

- [ ] Name: matches directory name exactly (e.g., `my-skill-name`)
- [ ] Description: what it does in third person, then "Use when..."
- [ ] SKILL.md under 500 lines
- [ ] Keywords throughout for search
- [ ] One excellent code example
- [ ] Heavy content in references/

**Verification:**

- [ ] Run GREEN phase (verify compliance)
- [ ] Run REFACTOR phase (close loopholes)

## The Bottom Line

**Creating skills IS TDD for process documentation.**

Same Iron Law: No skill without failing test first.
Same cycle: RED → GREEN → REFACTOR.
Same benefits: Better quality, fewer surprises.

**Token optimization:** Keep SKILL.md under 500 lines. Use progressive disclosure. Every token counts.

## Reference Files

- **references/tdd-fundamentals.md** - TDD background
- **references/testing-with-subagents.md** - Automated testing
- **references/bulletproofing-skills.md** - Rationalization patterns
- **references/skill-types-testing.md** - Testing by type
- **references/cso-keywords.md** - Search optimization
- **references/code-example-guidelines.md** - Code examples
- **references/token-saving-techniques.md** - Token optimization
- **anthropic-best-practices.md** - Official Anthropic guidance
