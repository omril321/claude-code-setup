# Question Bank for Thorough Planning

## Success Criteria Questions

### By Category

| Category | Template | Example |
|----------|----------|---------|
| Observable | "Task complete when [user action] produces [visible result]" | "User clicks toggle and theme changes" |
| Testable | "Verified when [test command] returns [expected output]" | "npm test passes with 0 failures" |
| Measurable | "Success means [metric] changes from [current] to [target]" | "Response time drops from 2s to 200ms" |
| Binary | "[Condition] must be true: yes/no" | "Build succeeds without warnings" |

### Universal Questions

Ask these for ANY task:

1. "How will we know this task is done correctly?"
2. "What can the user do after this works that they couldn't before?"
3. "What's the minimum viable proof this works?"
4. "What would a test for this feature check?"

### By Task Type

**Feature Implementation:**
- "What user action triggers this feature?"
- "What should the user see/experience when it works?"
- "What edge cases should we handle?"

**Bug Fix:**
- "What's the current broken behavior?"
- "What should happen instead?"
- "How can we reproduce the bug to verify the fix?"

**Refactoring:**
- "What should remain unchanged after refactoring?"
- "What tests verify nothing broke?"
- "What's the goal of this refactor?"

**Performance:**
- "What's the current metric?"
- "What's the target metric?"
- "How do we measure it?"

## Feedback Loop Questions

1. "What can you check after each step to ensure progress?"
2. "What would indicate you're going in the wrong direction?"
3. "Is there a test you can run incrementally?"
4. "What's your rollback plan if something breaks?"

### Feedback Loop Templates

| Loop Type | Template | When to Use |
|-----------|----------|-------------|
| TDD | "Write test for [behavior], run, see fail, implement, see pass" | Any code change |
| Build-verify | "After each [file/function], run [build command] to verify" | Multi-file changes |
| Incremental preview | "After [step], check [UI/output] shows [expected]" | Visual changes |
| Checkpoint | "Every [N steps], verify [integration point] still works" | Large refactors |

## 5 Whys Technique

For unclear requirements, dig deeper:

1. **Why** do you need this feature?
2. **Why** is the current solution insufficient?
3. **Why** hasn't this been solved before?
4. **Why** is this the right approach?
5. **Why** now?

Each "why" reveals deeper context and constraints.
