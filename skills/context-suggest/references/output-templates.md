# Output Templates

Example outputs for different project contexts. Use these as reference for formatting.

## Contents
- Debugging with Browser Tools
- Planning Complex Feature
- No Specific Framework Detected

## Example: Debugging with Browser Tools

**Context detected:**
- Browser MCP tools available (`mcp__browsermcp__*`)
- DevTools MCP available (`mcp__chrome-devtools__*`)
- Task: "Debug why the button isn't working"

**Output:**

```markdown
## Tools to Use in This Plan

### Required Skills
- **browser-inspection**: Browser MCPs available. Decision guide:
  - Logged-in session needed → Use Browser MCP
  - Debugging/profiling needed → Use DevTools MCP
  - Authentication trumps debugging features

- **systematic-debugging**: For unclear issues
  - Document assumptions
  - Form hypotheses
  - Test systematically

### Available MCPs
- **browsermcp**: Navigate, click, type, screenshot
- **chrome-devtools**: Console logs, network requests, performance

### Implementation Steps
1. Identify if logged-in session needed
   → Apply **browser-inspection** to choose tool
2. Inspect the failing behavior
3. If root cause unclear, apply **systematic-debugging**
```

## Example: Planning Complex Feature

**Context detected:**
- TypeScript project
- React frontend
- Task: "Implement user authentication"

**Output:**

```markdown
## Tools to Use in This Plan

### Required Skills
- **thorough-planning**: Complex feature. Define success criteria before implementation.

### Required Agents
- **code-architect**: For feature architecture design (official plugin)
- **typescript-expert**: For type system design and review

### Required Commands
- **/commit**: Smart commits during implementation
- **/create-pr**: Create PR with proper template
- **/code-quality-gate**: Verify no TODOs before PR

### Implementation Steps
1. Define success criteria
   → Apply **thorough-planning** before coding
2. Design type structure
   → Use **typescript-expert** agent for type review
3. Implement feature incrementally
4. Prepare PR
   → Run **/code-quality-gate**, then **/create-pr**
```

## Example: No Specific Framework Detected

**Context detected:**
- Generic TypeScript/JavaScript project
- Task: "Add new API endpoint"

**Output:**

```markdown
## Tools to Use in This Plan

### Required Skills
- **thorough-planning**: Define success criteria for the endpoint

### Required Agents
- **typescript-expert**: If TypeScript guidance needed

### Required Commands
- **/commit**: For committing changes
- **/create-pr**: For PR creation

### Implementation Steps
1. Define what "done" looks like
   → Apply **thorough-planning**
2. Implement endpoint
3. Add tests
4. Create PR
   → Use **/commit** and **/create-pr**
```
