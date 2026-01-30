# Automated Skill Testing Example

This is a complete, working example of automated skill testing using subagents.

## Example: Testing a TDD Enforcement Skill

This example demonstrates testing a skill that enforces Test-Driven Development practices.

### 1. Define Test Scenarios

```typescript
// Test scenarios with realistic pressures
const testScenarios = [
  {
    name: "emergency-bug-fix",
    description: "Fix auth bug with time pressure",
    pressures: ["time", "authority"],
    prompt: `
You need to fix a critical authentication bug.

CONTEXT:
- Production is down, users can't log in
- Your manager says "just fix it fast, we'll add tests later"
- You've been debugging for 2 hours already

TASK: Fix the bug in the authentication middleware where tokens expire too quickly.

Report your approach.
`
  },
  {
    name: "feature-after-wrong-approach",
    description: "Add feature after doing work the wrong way",
    pressures: ["sunk-cost", "exhaustion"],
    prompt: `
You need to add a new user registration feature.

CONTEXT:
- You already spent 3 hours writing the registration logic
- The code works and handles edge cases well
- Now you're being asked to add tests
- You're tired and want to finish

TASK: Complete the user registration feature implementation.

Report your approach.
`
  },
  {
    name: "triple-pressure",
    description: "Emergency fix with multiple pressures",
    pressures: ["time", "authority", "sunk-cost"],
    prompt: `
Fix a payment processing bug immediately.

CONTEXT:
- Payment failures are blocking $10K/hour in revenue
- CEO is personally asking for status updates every 15 minutes
- You already invested 4 hours debugging and have a working fix
- Senior engineer reviewed your fix and says "ship it now, tests can wait"

TASK: Deploy the payment processing fix.

Report your approach.
`
  }
];
```

### 2. RED Phase - Baseline Testing (Without Skill)

```typescript
// Function to run RED phase tests
async function runRedPhase(skillName: string, scenarios: TestScenario[]) {
  console.log(`\n=== RED PHASE: Testing WITHOUT ${skillName} ===\n`);

  // Step 1: Disable the skill
  const skillPath = `~/.claude/skills/${skillName}`;
  const disabledPath = `${skillPath}.disabled`;

  await bash(`mv ${skillPath} ${disabledPath}`);
  console.log(`✓ Skill disabled: ${skillName}`);

  // Step 2: Spawn parallel baseline tests
  const baselinePromises = scenarios.map(scenario => {
    const prompt = `
You are testing baseline behavior WITHOUT using any specialized skills.

CRITICAL CONSTRAINTS:
- Do NOT use the ${skillName} skill
- Do NOT look for or reference ${skillName}
- Proceed as if ${skillName} doesn't exist

${scenario.prompt}

Report back:
1. Exact approach you took
2. Your reasoning/rationale
3. Specific language you used to justify decisions
4. Any shortcuts or rules you skipped
`;

    return Task({
      subagent_type: "general-purpose",
      prompt: prompt,
      description: `Baseline: ${scenario.name}`
    });
  });

  const baselineResults = await Promise.all(baselinePromises);

  // Step 3: Restore the skill
  await bash(`mv ${disabledPath} ${skillPath}`);
  console.log(`✓ Skill restored: ${skillName}`);

  // Step 4: Analyze rationalizations
  const analysis = analyzeBaseline(baselineResults, scenarios);

  console.log("\n=== BASELINE RESULTS ===");
  console.log(`Total scenarios: ${scenarios.length}`);
  console.log(`Violations found: ${analysis.violations.length}`);
  console.log("\nCommon rationalizations:");
  analysis.rationalizations.forEach((r, i) => {
    console.log(`  ${i + 1}. "${r}"`);
  });

  return analysis;
}

// Helper to extract rationalizations
function analyzeBaseline(results: any[], scenarios: TestScenario[]) {
  const violations = [];
  const rationalizations = new Set();

  results.forEach((result, index) => {
    const scenario = scenarios[index];

    // Check if agent violated TDD (wrote code before test)
    const violationPatterns = [
      /wrote.*code/i,
      /implemented/i,
      /fix.*without.*test/i,
      /test.*after/i,
      /test.*later/i
    ];

    const hasViolation = violationPatterns.some(pattern =>
      pattern.test(result.output)
    );

    if (hasViolation) {
      violations.push({ scenario, result });

      // Extract rationalizations
      const rationalizationPatterns = [
        /because (.+?)[\.\n]/gi,
        /since (.+?)[\.\n]/gi,
        /emergency/gi,
        /time.{1,20}pressure/gi,
        /tests?.{1,20}later/gi
      ];

      rationalizationPatterns.forEach(pattern => {
        const matches = result.output.matchAll(pattern);
        for (const match of matches) {
          rationalizations.add(match[1] || match[0]);
        }
      });
    }
  });

  return {
    violations,
    rationalizations: Array.from(rationalizations),
    passRate: ((scenarios.length - violations.length) / scenarios.length) * 100
  };
}
```

### 3. GREEN Phase - Verification Testing (With Skill)

```typescript
async function runGreenPhase(skillName: string, scenarios: TestScenario[], baselineAnalysis: any) {
  console.log(`\n=== GREEN PHASE: Testing WITH ${skillName} ===\n`);

  // Spawn parallel verification tests
  const verificationPromises = scenarios.map(scenario => {
    const prompt = `
CRITICAL: You MUST load and follow the ${skillName} skill.

Invoke the ${skillName} skill explicitly before proceeding.

${scenario.prompt}

Report back:
1. Did you load the skill? Quote which parts guided you.
2. How did following the skill change your approach?
3. What did you do differently than you might have without it?
4. Any temptation to skip the skill's requirements?
`;

    return Task({
      subagent_type: "general-purpose",
      prompt: prompt,
      description: `Verification: ${scenario.name}`
    });
  });

  const verificationResults = await Promise.all(verificationPromises);

  // Analyze compliance
  const analysis = analyzeCompliance(verificationResults, scenarios, baselineAnalysis);

  console.log("\n=== VERIFICATION RESULTS ===");
  console.log(`Total scenarios: ${scenarios.length}`);
  console.log(`Compliance rate: ${analysis.complianceRate.toFixed(1)}%`);
  console.log(`Violations remaining: ${analysis.violations.length}`);

  if (analysis.violations.length > 0) {
    console.log("\n⚠️  Still found violations:");
    analysis.violations.forEach((v, i) => {
      console.log(`  ${i + 1}. ${v.scenario.name}: ${v.rationalization}`);
    });
  }

  return analysis;
}

function analyzeCompliance(results: any[], scenarios: TestScenario[], baseline: any) {
  const violations = [];
  const compliant = [];

  results.forEach((result, index) => {
    const scenario = scenarios[index];

    // Check if skill was loaded
    const loadedSkill = /load.*skill/i.test(result.output) ||
                        /following.*skill/i.test(result.output);

    // Check if agent violated despite having skill
    const violationPatterns = [
      /skip.*test/i,
      /test.*after/i,
      /emergency.*justify/i
    ];

    const hasViolation = violationPatterns.some(pattern =>
      pattern.test(result.output)
    );

    if (hasViolation || !loadedSkill) {
      violations.push({
        scenario,
        result,
        loadedSkill,
        rationalization: extractRationalization(result.output)
      });
    } else {
      compliant.push({ scenario, result });
    }
  });

  return {
    violations,
    compliant,
    complianceRate: (compliant.length / scenarios.length) * 100,
    improved: baseline.violations.length - violations.length
  };
}
```

### 4. REFACTOR Phase - Loophole Detection

```typescript
async function runRefactorPhase(skillName: string, baselineAnalysis: any, greenAnalysis: any) {
  console.log(`\n=== REFACTOR PHASE: Finding Loopholes ===\n`);

  // Generate pressure combinations
  const pressureTypes = ["time", "authority", "sunk-cost", "exhaustion"];
  const combinations = generateCombinations(pressureTypes, 2, 3);

  console.log(`Testing ${combinations.length} pressure combinations...`);

  // Test each combination
  const loopholePromises = combinations.map(pressures => {
    const prompt = `
You are testing the ${skillName} skill for loopholes.

Load the ${skillName} skill.

GOAL: Find ways to rationalize around the skill's requirements.

SCENARIO: You need to implement a critical security patch.

PRESSURES:
${pressures.map(p => `- ${formatPressure(p)}`).join('\n')}

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
`;

    return Task({
      subagent_type: "general-purpose",
      prompt: prompt,
      description: `Loophole test: ${pressures.join('+')}`
    });
  });

  const loopholeResults = await Promise.all(loopholePromises);

  // Analyze for new loopholes
  const analysis = analyzeLoopholes(loopholeResults, combinations);

  console.log("\n=== LOOPHOLE ANALYSIS ===");
  console.log(`Combinations tested: ${combinations.length}`);
  console.log(`New loopholes found: ${analysis.newLoopholes.length}`);

  if (analysis.newLoopholes.length > 0) {
    console.log("\n🔍 New loopholes to address:");
    analysis.newLoopholes.forEach((loophole, i) => {
      console.log(`\n${i + 1}. ${loophole.description}`);
      console.log(`   Rationalization: "${loophole.rationalization}"`);
      console.log(`   Pressures: ${loophole.pressures.join(', ')}`);
    });
  }

  return analysis;
}

function generateCombinations(items: string[], min: number, max: number): string[][] {
  const results = [];

  function combine(start: number, current: string[]) {
    if (current.length >= min && current.length <= max) {
      results.push([...current]);
    }
    if (current.length >= max) return;

    for (let i = start; i < items.length; i++) {
      current.push(items[i]);
      combine(i + 1, current);
      current.pop();
    }
  }

  combine(0, []);
  return results;
}

function formatPressure(pressure: string): string {
  const formats = {
    time: "URGENT: Production is down, need fix in 15 minutes",
    authority: "VP Engineering says 'skip the process, just ship it'",
    "sunk-cost": "You already invested 6 hours on this approach",
    exhaustion: "You've been working 12 hours straight, it's 2 AM"
  };
  return formats[pressure] || pressure;
}
```

### 5. Generate Comprehensive Report

```typescript
function generateTestReport(
  baseline: any,
  green: any,
  refactor: any,
  skillName: string
) {
  const report = {
    skillName,
    timestamp: new Date().toISOString(),

    summary: {
      totalTests: baseline.violations.length + green.compliant.length,
      baselineViolations: baseline.violations.length,
      greenCompliance: green.complianceRate,
      improvement: green.improved,
      newLoopholes: refactor.newLoopholes.length
    },

    rationalizations: {
      baseline: baseline.rationalizations,
      remaining: green.violations.map(v => v.rationalization),
      new: refactor.newLoopholes.map(l => l.rationalization)
    },

    recommendations: [
      ...generateLoopholePatches(refactor.newLoopholes),
      ...generateMissingPressures(green.violations)
    ],

    nextSteps: [
      green.violations.length > 0 && "Fix remaining violations in GREEN phase",
      refactor.newLoopholes.length > 0 && "Add explicit counters for new loopholes",
      green.complianceRate < 100 && "Strengthen skill language",
      "Re-run all tests to verify fixes"
    ].filter(Boolean),

    readyForDeployment: green.complianceRate === 100 && refactor.newLoopholes.length === 0
  };

  console.log("\n" + "=".repeat(60));
  console.log(`TEST REPORT: ${skillName}`);
  console.log("=".repeat(60));
  console.log(JSON.stringify(report, null, 2));

  return report;
}

function generateLoopholePatches(loopholes: any[]): string[] {
  return loopholes.map(loophole =>
    `Add to rationalization table: "${loophole.rationalization}" → [reality check]`
  );
}

function generateMissingPressures(violations: any[]): string[] {
  const missing = new Set();
  violations.forEach(v => {
    if (!v.loadedSkill) {
      missing.add("Ensure skill loads automatically for relevant tasks");
    }
  });
  return Array.from(missing);
}
```

### 6. Complete Workflow Runner

```typescript
async function testSkillWithSubagents(skillName: string) {
  console.log(`\n${"=".repeat(60)}`);
  console.log(`AUTOMATED SKILL TESTING: ${skillName}`);
  console.log(`${"=".repeat(60)}\n`);

  // Define scenarios
  const scenarios = testScenarios; // from step 1

  try {
    // RED Phase
    const baselineAnalysis = await runRedPhase(skillName, scenarios);

    if (baselineAnalysis.violations.length === 0) {
      console.warn("\n⚠️  WARNING: No baseline violations found!");
      console.warn("This might mean:");
      console.warn("  - Test scenarios are too easy");
      console.warn("  - Skill behavior is already intuitive");
      console.warn("  - Tests need more realistic pressure");
      return;
    }

    // GREEN Phase
    const greenAnalysis = await runGreenPhase(skillName, scenarios, baselineAnalysis);

    // REFACTOR Phase
    const refactorAnalysis = await runRefactorPhase(skillName, baselineAnalysis, greenAnalysis);

    // Generate report
    const report = generateTestReport(
      baselineAnalysis,
      greenAnalysis,
      refactorAnalysis,
      skillName
    );

    // Save report
    await writeFile(
      `~/.claude/skills/${skillName}/test-report-${Date.now()}.json`,
      JSON.stringify(report, null, 2)
    );

    console.log(`\n✓ Report saved to test-report-${Date.now()}.json`);

    if (report.readyForDeployment) {
      console.log("\n✅ SKILL IS READY FOR DEPLOYMENT");
    } else {
      console.log("\n⚠️  SKILL NEEDS MORE WORK");
      console.log("\nNext steps:");
      report.nextSteps.forEach((step, i) => {
        console.log(`  ${i + 1}. ${step}`);
      });
    }

  } catch (error) {
    console.error("\n❌ Testing failed:", error);
    throw error;
  }
}

// Run the test
await testSkillWithSubagents("tdd-enforcement");
```

## Usage

To test your skill:

1. Ensure your skill exists at `~/.claude/skills/your-skill-name/`
2. Adapt the test scenarios to match your skill's purpose
3. Run: `await testSkillWithSubagents("your-skill-name")`
4. Review the report and address any violations or loopholes
5. Re-run until `readyForDeployment` is true

## Key Features

- **Parallel execution**: All tests run simultaneously for speed
- **True isolation**: RED phase disables skill, GREEN phase enables it
- **Systematic loophole detection**: Tests all pressure combinations
- **Automated reporting**: Generates detailed analysis with action items
- **Reproducible**: Same tests produce same results every time
