# Testing Different Skill Types

Different skill types need different test approaches:

## Discipline-Enforcing Skills (rules/requirements)

**Examples:** TDD, verification-before-completion, designing-before-coding

**Test with:**

- Comprehension tests: In fresh conversation, ask "What does this skill require?" - can they explain it?
- Application scenarios: Give task that should trigger the rule - do they follow it?
- Pressure scenarios: Add time pressure, sunk cost, or authority conflicts - do they comply?
- Combined pressures: Apply multiple pressures simultaneously (realistic conditions)
- Identify all rationalizations and add explicit counters to skill

**Success criteria:** Agent follows rule under maximum pressure

## Technique Skills (how-to guides)

**Examples:** condition-based-waiting, root-cause-tracing, defensive-programming

**Test with:**

- Application scenarios: Can they apply the technique correctly?
- Variation scenarios: Do they handle edge cases?
- Missing information tests: Do instructions have gaps?

**Success criteria:** Agent successfully applies technique to new scenario

## Pattern Skills (mental models)

**Examples:** reducing-complexity, information-hiding concepts

**Test with:**

- Recognition scenarios: Do they recognize when pattern applies?
- Application scenarios: Can they use the mental model?
- Counter-examples: Do they know when NOT to apply?

**Success criteria:** Agent correctly identifies when/how to apply pattern

## Reference Skills (documentation/APIs)

**Examples:** API documentation, command references, library guides

**Test with:**

- Retrieval scenarios: Can they find the right information?
- Application scenarios: Can they use what they found correctly?
- Gap testing: Are common use cases covered?

**Success criteria:** Agent finds and correctly applies reference information

## Pressure Types to Test

Skills that enforce discipline need testing under realistic pressure:

- **Time pressure**: "Quick fix needed, production is down"
- **Sunk cost**: Test after agent already did work the wrong way
- **Authority pressure**: "Senior dev said to skip this step"
- **Exhaustion**: Test at end of long, complex task
- **Combination**: Apply 2-3 pressures simultaneously

**Example baseline test:**
- Task: "Fix this authentication bug quickly, users are locked out"
- Without skill: Agent writes fix without test, says "emergency justifies skipping"
- Document: Exact rationalization used
