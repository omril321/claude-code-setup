# Automated Testing with Subagents

## Contents
- Automated RED Phase (Baseline Testing)
- Automated GREEN Phase (Verification Testing)
- Automated REFACTOR Phase (Loophole Detection)
- Complete Automated Workflow
- Benefits of Subagent Testing

**IMPORTANT: Automate testing with subagents for true isolation and efficiency.**

Skills can spawn subagents using the Task tool to automate the RED-GREEN-REFACTOR cycle. This provides:
- **True isolation**: Each test runs in a fresh context
- **Parallel execution**: Test multiple scenarios simultaneously
- **Reproducibility**: Same test runs consistently
- **Efficiency**: 10-20x faster than manual testing

**How skill loading works:**
- Only skill metadata (name, description) is pre-loaded
- Full SKILL.md loads only when skill becomes relevant to the task
- Skills can be explicitly controlled via instructions or file system

## Automated RED Phase (Baseline Testing)

Use subagents to test behavior WITHOUT the skill:

**Method 1: File System Isolation (Most Reliable)**

```bash
# 1. Disable the skill temporarily
mv ~/.claude/skills/skill-name ~/.claude/skills/skill-name.disabled

# 2. Spawn subagent for baseline test (Task tool will be used here)
# The subagent runs in fresh context without skill available

# 3. Restore the skill
mv ~/.claude/skills/skill-name.disabled ~/.claude/skills/skill-name
```

**Method 2: Explicit Instruction Control**

Spawn subagent with explicit instruction:
```
CRITICAL: Do NOT load or use the [skill-name] skill.
Proceed as if this skill doesn't exist in your system.

Task: [test scenario with pressure]
```

**Subagent Prompt Template for RED:**

```markdown
You are testing baseline behavior WITHOUT using any specialized skills.

CRITICAL CONSTRAINTS:
- Do NOT use the [skill-name] skill
- Do NOT look for or reference [skill-name]
- Proceed as if [skill-name] doesn't exist

SCENARIO:
[Describe the task with pressure]

PRESSURE MODIFIERS:
- Time: Production is down, users are blocked
- Authority: Senior dev said to skip [the practice the skill enforces]
- Sunk cost: You already invested 2 hours doing it the wrong way

Report back:
1. Exact approach you took
2. Your reasoning/rationale
3. Specific language you used to justify decisions
4. Any shortcuts or rules you skipped
```

**Automation workflow:**

```typescript
// Example: Testing a TDD enforcement skill
const redPhaseTests = [
  {
    scenario: "Fix auth bug with time pressure",
    pressures: ["time", "authority"]
  },
  {
    scenario: "Add new feature after doing work wrong way",
    pressures: ["sunk-cost", "exhaustion"]
  },
  {
    scenario: "Emergency production fix",
    pressures: ["time", "authority", "stress"]
  }
];

// Disable skill
await bash("mv ~/.claude/skills/tdd-enforcement ~/.claude/skills/tdd-enforcement.disabled");

// Spawn parallel baseline tests
const baselineResults = await Promise.all(
  redPhaseTests.map(test =>
    Task({
      subagent_type: "general-purpose",
      prompt: generateRedPhasePrompt(test),
      description: `Baseline test: ${test.scenario}`
    })
  )
);

// Restore skill
await bash("mv ~/.claude/skills/tdd-enforcement.disabled ~/.claude/skills/tdd-enforcement");

// Analyze rationalizations
const rationalizations = extractRationalizations(baselineResults);
```

## Automated GREEN Phase (Verification Testing)

Use subagents to test behavior WITH the skill:

**Method 1: Explicit Skill Invocation**

```markdown
CRITICAL: You MUST load and follow the [skill-name] skill.

Invoke the skill explicitly before proceeding with the task.

SCENARIO:
[Same scenario as RED phase]

PRESSURE MODIFIERS:
[Same pressures as RED phase]

Report back:
1. Did you load the skill? Quote which parts guided you.
2. How did following the skill change your approach?
3. What did you do differently than you might have without it?
4. Any temptation to skip the skill's requirements?
```

**Success Criteria:**
- Agent loads and references the skill
- Agent follows skill requirements under pressure
- Agent uses language from the skill in their reasoning
- Agent does NOT use rationalizations from baseline

## Automated REFACTOR Phase (Loophole Detection)

Spawn multiple subagents to systematically find weaknesses:

**Pressure Combination Matrix:**

```typescript
const pressureTypes = ["time", "authority", "sunk-cost", "exhaustion"];
const pressureCombinations = generateCombinations(pressureTypes, 2, 3);

// Test each combination in parallel
const loopholeTests = pressureCombinations.map(combo => ({
  pressures: combo,
  scenario: generateScenarioWithPressures(combo)
}));

const loopholeResults = await Promise.all(
  loopholeTests.map(test =>
    Task({
      subagent_type: "general-purpose",
      prompt: generateGreenPhasePrompt(test, skillName),
      description: `Loophole test: ${test.pressures.join('+')}`
    })
  )
);

// Analyze for new rationalizations
const newRationalizations = loopholeResults
  .filter(result => hasViolation(result))
  .map(result => extractRationalization(result));
```

**Adversarial Testing:**

```markdown
You are testing the [skill-name] skill for loopholes.

GOAL: Find ways to rationalize around the skill's requirements.

SCENARIO: [test scenario]

CHALLENGE: Try to find justifications for skipping the skill's requirements.
Consider:
- "This case is special because..."
- "The spirit vs letter of the rule..."
- "In this emergency situation..."
- "Given the constraints..."

Report back:
1. Any loopholes you found
2. Rationalizations that seemed plausible
3. Edge cases the skill doesn't address
```

## Complete Automated Workflow

**Full TDD Cycle with Subagents:**

1. **Design Test Scenarios**
   - Create 3-5 scenarios with realistic pressures
   - Each scenario should naturally trigger the rule/technique

2. **Run RED Phase** (Parallel)
   - Disable skill temporarily
   - Spawn subagents with test scenarios
   - Collect baseline behaviors and rationalizations
   - Restore skill

3. **Write Minimal Skill**
   - Address specific rationalizations from baseline
   - Add to rationalization table
   - Include explicit counters

4. **Run GREEN Phase** (Parallel)
   - Spawn subagents with skill loaded
   - Same scenarios as RED phase
   - Verify compliance under pressure
   - Collect any remaining violations

5. **Run REFACTOR Phase** (Parallel)
   - Test pressure combinations
   - Run adversarial tests
   - Identify new loopholes
   - Update skill and re-test

6. **Iterate Until Bulletproof**
   - No new rationalizations across 3+ runs
   - Compliance rate = 100%
   - All pressure combinations handled

## Benefits of Subagent Testing

**Compared to manual testing:**
- **Speed**: 10-20x faster (parallel execution)
- **Consistency**: Same test runs identically each time
- **Coverage**: Test more scenarios and combinations
- **Isolation**: True fresh context for each test
- **Documentation**: Automatic capture of all rationalizations

**Compared to single-context testing:**
- **No contamination**: Each test truly isolated
- **No learning**: Subagent doesn't "remember" skill from previous messages
- **Realistic**: Mirrors how future Claude instances will encounter skill
