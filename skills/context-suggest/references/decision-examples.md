# Decision Matrix Examples

## Good Reasoning (Task: Add login button to React app)

| Skill | Decision | Reasoning |
|-------|----------|-----------|
| code-quality-gate | ✅ USE in Step 4 | UI component changes need review for accessibility and state management |
| testing | ✅ USE in Step 3 | Need to test button click handler and auth redirect |
| slidev | ⏭️ SKIP | This is a code task, not a presentation |
| generate-image | ⏭️ SKIP | No images needed, using existing icon library |
| systematic-debugging | ⏭️ SKIP | Greenfield feature, no bugs to debug yet |
| decision-journal | ⏭️ SKIP | Single auth approach (OAuth), no alternatives to weigh |
| browser-inspection | ✅ USE in Step 5 | Need to verify button renders and click behavior works |
| cf-internal-claude-plugin:commit | ✅ USE in Step 5 | Code changes planned, use plugin commit skill for message generation |

## Good Reasoning (Task: Create presentation about microservices)

| Skill | Decision | Reasoning |
|-------|----------|-----------|
| slidev | ✅ USE in Step 2 | This is a presentation task, Slidev is the tool |
| generate-image | ✅ USE in Step 3 | Need architecture diagrams and flow illustrations |
| code-quality-gate | ⏭️ SKIP | No production code being written |
| testing | ⏭️ SKIP | No code to test, presentation content only |
| systematic-debugging | ⏭️ SKIP | No bugs, creating new slides |
| content-research-writer | ✅ USE in Step 1 | Need to research microservices patterns and cite sources |

## Bad Reasoning (Lazy)

| Skill | Decision | Reasoning | Why It's Bad |
|-------|----------|-----------|--------------|
| code-quality-gate | ⏭️ SKIP | Not needed | ❌ WHY not needed? |
| testing | ⏭️ SKIP | Not applicable | ❌ Generic dismissal |
| slidev | ⏭️ SKIP | N/A | ❌ Abbreviated, no reasoning |
| generate-image | | | ❌ Empty - skill ignored entirely |
| systematic-debugging | ⏭️ SKIP | Not relevant | ❌ Same as "not needed" |
| decision-journal | ⏭️ SKIP | Skip | ❌ Not even reasoning |

## Template Reasoning (Also Bad)

These are lazy patterns where the same reason is copy-pasted:

| Skill | Decision | Reasoning |
|-------|----------|-----------|
| code-quality-gate | ⏭️ SKIP | Not required for this task |
| testing | ⏭️ SKIP | Not required for this task |
| slidev | ⏭️ SKIP | Not required for this task |
| generate-image | ⏭️ SKIP | Not required for this task |

❌ **Problem:** Every skill gets the same generic reason. No genuine evaluation happened.

## What Good Reasoning Looks Like

Good reasoning is **specific to the task AND the skill**:

- References the actual task: "This is a presentation task" / "Adding a UI component"
- References the skill's purpose: "No bugs to debug" / "No architecture diagrams needed"
- Explains the mismatch: "Not a presentation task" / "No code being written"

**Test:** If you could swap the reasoning between two different skills and it still makes sense, the reasoning is too generic.
