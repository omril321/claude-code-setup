# TDD Fundamentals for Skills

**This skill applies Test-Driven Development to documentation.** Understanding the TDD cycle is essential.

## The RED-GREEN-REFACTOR Cycle

**RED (Write Failing Test First):**
- Write a test that defines desired behavior
- Run the test - it MUST fail (proves test is valid)
- Document exactly how it fails

**GREEN (Write Minimal Code):**
- Write just enough code to make the test pass
- Don't add extra features or "nice to haves"
- Run the test - it must pass

**REFACTOR (Improve Without Changing Behavior):**
- Clean up code while keeping tests passing
- Eliminate duplication, improve clarity
- Tests must still pass after each change

## Why Test-First Matters

**Test-first prevents:**
- Writing tests that pass by accident (didn't verify failure mode)
- Overbuilding (adding features without proving they're needed)
- Confirmation bias (seeing what you expect instead of what is)

**The Iron Law of TDD:**
```
NO CODE WITHOUT A FAILING TEST FIRST
```

This applies to:
- New features (write test first)
- Bug fixes (write test that reproduces bug first)
- Refactoring (tests must pass before and after)

**No exceptions:** Not for "simple changes", not for "just adding a line", not ever.

## How This Applies to Skills

In skill creation, the mapping is:

| TDD Concept | Skill Creation |
|-------------|----------------|
| Test case | Pressure scenario testing agent behavior |
| Production code | SKILL.md content |
| Test fails (RED) | Agent violates rule without skill |
| Test passes (GREEN) | Agent complies with skill present |
| Refactor | Close loopholes while maintaining compliance |
| Write test first | Run baseline scenario BEFORE writing skill |
| Watch it fail | Document exact rationalizations agent uses |
| Minimal code | Write skill addressing those specific violations |
| Watch it pass | Verify agent now complies |

**Example:** Before writing a skill about "always validate input", run a scenario where an agent receives invalid input. Watch them skip validation. Document their exact rationalization ("input looks clean enough"). Then write skill that addresses that specific rationalization.
