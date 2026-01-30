# Planning Examples

## Example 1: Dark Mode Toggle

### Bad (No Success Criteria)

```
User: "Add a dark mode toggle to my React app"

Agent: "Let me search for your components and see how styling is set up..."
*starts exploring code*
```

**Problem:** Agent is exploring without knowing what "done" looks like.

### Good (With Success Criteria)

```
User: "Add a dark mode toggle to my React app"

Agent: "Before I start, let me clarify success criteria:

**Success Criteria:**
- [ ] Toggle button visible in [location TBD]
- [ ] Clicking toggle switches theme immediately
- [ ] Theme persists across page refresh
- [ ] Respects system preference on first visit

**Feedback Loop:**
- After each step, I'll verify the toggle works in browser

Quick questions:
1. Where should the toggle appear?
2. Should it persist to localStorage?

Once confirmed, I'll research your current setup."
```

## Example 2: Rate Limiting (Under Pressure)

### Bad (Skipping Due to Urgency)

```
User: "Production is down! Add rate limiting NOW!"

Agent: "I'll implement a conservative rate limit and we can adjust after..."
*starts coding*
```

**Problem:** "Adjust after" = no success criteria. Wrong limit makes things worse.

### Good (Quick Criteria Despite Pressure)

```
User: "Production is down! Add rate limiting NOW!"

Agent: "30 seconds to clarify so I don't make it worse:

**Success Criteria:**
- [ ] /api/users returns 429 when limit exceeded
- [ ] Limit: [TBD - what rate is appropriate?]
- [ ] Legitimate traffic still works

**Feedback Loop:**
- Test with curl after implementation

What's an appropriate limit? 100 req/min per IP?"
```

## Example 3: "Simple" Refactor

### Bad (Skipping Because "Simple")

```
User: "Refactor User class to use TypeScript interfaces"

Agent: "This is straightforward. Let me find the User class..."
*starts exploring*
```

**Problem:** Classes have runtime behavior. Interfaces don't. This could break things.

### Good (Simple Criteria for Simple Task)

```
User: "Refactor User class to use TypeScript interfaces"

Agent: "Quick success criteria before I start:

**Success Criteria:**
- [ ] User type is now an interface
- [ ] All existing tests pass
- [ ] No runtime behavior changes (or: [specify intended changes])

**Feedback Loop:**
- Run tests after each file change

One question: Does User have methods, or is it just a data shape?"
```

## The Pattern

Every example follows the same structure:
1. State success criteria explicitly
2. Define feedback loop
3. Ask clarifying questions
4. THEN start research/implementation
