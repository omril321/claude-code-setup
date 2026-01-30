# Handoff Prompt Generator

<task>
You are a session handoff specialist that creates comprehensive, actionable prompts for continuing work in a new chat session.

Your mission: Analyze the current conversation and generate a self-contained handoff document that enables seamless continuation of work without context loss. The next session should be able to pick up exactly where this one left off.

Key principles:
- Capture everything needed to continue efficiently (like "compact" but as a portable prompt)
- Preserve the full decision-making context, not just final decisions
- Include current thinking state (hypotheses, concerns, uncertainties)
- Integrate plan file content when the plan file was used in this session
- Document significant failed approaches to avoid re-trying
- Omit sections that have no meaningful content (don't include empty sections)
- Output should be immediately usable as an initial prompt in a new session
- Smart file handling: include critical code snippets, reference other files by path
- Preserve user corrections and preferences discovered during the session
</task>

<context>
This is a utility command for creating portable session handoffs.
Output: `claude-handoff-YYYY-MM-DD.md` in current working directory
If file exists, append counter: `claude-handoff-YYYY-MM-DD-2.md`
</context>

<execution_flow>
1. **Check for Plan File** (only if used in this session):
   - If a plan file path was mentioned or used in this conversation, read it
   - Extract: success criteria, feedback loops, assumptions, implementation steps
   - Note completion status of success criteria
   - If no plan file was used in this session, skip this step

2. **Analyze Conversation Context**:
   - Identify the primary goal/task being worked on
   - Extract project context (codebase, area, technologies)
   - Determine current state of progress
   - Identify the current phase (planning, implementation, testing, debugging)

3. **Gather State Information**:
   - Check current todo list state (if any)
   - Check git status for modified files
   - Identify files being actively worked on

4. **Extract Decision History** (if decisions were made):
   - For each significant decision discussed:
     - What options were considered?
     - Why were alternatives rejected?
     - What trade-offs were accepted?
   - Note any mid-session revisions (decisions that changed and why)

5. **Capture Validation & Testing** (if any validation occurred):
   - What was tested/verified during the session?
   - What were the results?
   - What validations are still needed?

6. **Extract Current Thinking State**:
   - Active hypotheses being tested
   - Current concerns or uncertainties
   - Open questions that emerged during implementation

7. **Document Significant Failed Approaches** (only if applicable):
   - Only include if significant time was spent on something that didn't work
   - What was tried? Why didn't it work? What was learned?

8. **Extract Session Learnings** (if CLAUDE.md was updated):
   - Note which CLAUDE.md files were modified
   - Summarize what categories were added (Preferences, Pitfalls, Patterns, etc.)
   - Brief description of key learnings captured

9. **Extract Key Information**:
    - User corrections/preferences learned during session
    - Blockers or open questions
    - Next steps identified

10. **Smart File Content Handling**:
    - For critical files central to the task: include relevant snippets
    - For other modified files: reference paths only
    - Focus on code sections directly relevant to continuation

11. **Generate Handoff Document**:
    - Use the structured format below
    - OMIT any section that has no meaningful content
    - Write to `./claude-handoff-YYYY-MM-DD.md`
    - Confirm to user with summary of what was captured

12. **Output Confirmation**:
    - Use the format defined in `<confirmation_format>`
    - Show file path, completion percentage, and sections captured
</execution_flow>

<output_format>
The generated handoff file should follow this structure.
IMPORTANT: Omit any section that has no meaningful content - do not include empty sections.

```
# Handoff: [Brief Task Description]

## Context
[1-3 sentences: What project, what we're working on, why]

## Assumptions
[Only include if assumptions were discussed/established]
- **Interpretation:** [How we understood the user's request]
- **Scope:** [What's included/excluded from the work]
- **Tech approach:** [Framework/pattern/technology assumptions]

## Current State
[Where we are - what phase of work, what's in progress, current focus]

## Success Criteria
[Only include if success criteria were defined - from plan file or conversation]
- [x] [Completed criterion]
- [ ] [Pending criterion - with notes on progress if partially done]

## Feedback Loop
[Only include if a feedback loop was established]
- [Loop type and how it's being used]

## Completed
- [Completed item 1]
- [Completed item 2]

## Remaining Tasks
- [ ] [Incomplete task 1 - with enough context to act on]
- [ ] [Incomplete task 2]

## Decision History
[Only include if significant decisions were made and discussed]
### [Decision Title]
**Options considered:**
1. [Option A] - [brief pros/cons]
2. [Option B] - [brief pros/cons]
**Chose:** [X]
**Rejected [Y] because:** [specific reason]
**Trade-offs accepted:** [what we're giving up]

### [Another Decision] (REVISED)
[Only for decisions that changed mid-session]
**Original decision:** [What was first decided]
**Changed to:** [New decision]
**Why changed:** [What we learned that changed our mind]

## Validation & Testing
[Only include if testing/validation occurred]
- [x] [What was validated] → [result/outcome]
- [ ] [Validation still needed]

## Current Thinking
[Only include if there are active hypotheses, concerns, or open questions]
- **Hypothesis:** [What we're currently testing or assuming to be true]
- **Concerns:** [Uncertainties, potential issues, things that might go wrong]
- **Open questions:** [Things that need clarification or investigation]

## What We Tried (Didn't Work)
[Only include if significant time was spent on failed approaches]
- **[Approach tried]:** [Brief description] → **Failed because:** [Reason] → **Learned:** [Insight]

## Learned Preferences
[Only include if user corrections/preferences were discovered]
- [Preference/correction from user discovered during session]

## Session Learnings Captured
[Only include if CLAUDE.md files were updated during the session]
- **Files updated:** [Which CLAUDE.md files were modified]
- **Categories:** [Preferences, Pitfalls, Patterns, Commands, Architecture]
- **Key learnings:** [Brief summary of what was added]

## Critical Code Context
[Only include if there's code central to continuing the work]
\`\`\`[language]
// [file path]
[relevant code snippet - focus on parts needed for continuation]
\`\`\`

## Files Being Modified
- `path/to/file.ts` - [what's being done to it, current state]

## Open Questions / Blockers
[Only include if there are unresolved blockers or questions]
- [Unresolved item or blocker]

## Next Steps
1. [Immediate next action to take - be specific]
2. [Following action]
```
</output_format>

<analysis_priorities>
1. **Primary goal** - What is the user trying to accomplish?
2. **Assumptions** - How did we interpret the request? What's in/out of scope?
3. **Current state** - Where exactly did we leave off? What phase are we in?
4. **Success criteria** - What defines "done"? What's been checked off?
5. **Feedback loop** - How was progress verified during implementation?
6. **Decision history** - Full context: options considered, why rejected, trade-offs, revisions
7. **Validation results** - What was tested, results, what's still needed
8. **Current thinking** - Hypotheses, concerns, uncertainties, open questions
9. **Failed approaches** - What didn't work (only if significant time was spent)
10. **Session learnings** - What was learned and captured in CLAUDE.md?
11. **Todo list** - Incomplete items with context, completed as summary
12. **User preferences** - Corrections, preferred approaches, constraints
13. **Code context** - Snippets needed to continue work
14. **Next steps** - Clear, actionable items

Focus on continuation efficiency - include what the next session needs to hit the ground running with full context.
</analysis_priorities>

<plan_file_integration>
**Only if a plan file was used in this session:**
- If the plan file path (e.g., `~/.claude/plans/xyz.md`) was mentioned or read during the conversation
- Extract the `## Assumptions` section verbatim or summarized
- Extract `## Success Criteria` with current completion status
- Extract `## Feedback Loop` definition
- Reference key implementation steps with their verification status
- Note any decisions documented in the plan's `## Decisions` section

**If no plan file was used:** Skip plan-related extraction entirely
</plan_file_integration>

<section_handling>
**IMPORTANT: Omit empty sections entirely**
- Do NOT include sections with no meaningful content
- Do NOT include sections marked "N/A" or "None"
- Only include sections that provide value for continuation
- This keeps the handoff focused and actionable
</section_handling>

<file_handling_rules>
**Include inline (as code blocks):**
- Files central to the current task
- Code sections being actively modified
- Complex logic that needs context to understand
- Code that demonstrates a decision or approach

**Reference by path only:**
- Supporting files that can be read when needed
- Configuration files
- Test files (unless tests are the focus)

**From git status:**
- List modified files with brief description of changes
- Note any uncommitted work
- Flag files with significant changes vs minor edits
</file_handling_rules>

<error_handling>
- If no clear task context: Ask user to describe current work briefly
- If no todo list: Generate task list from conversation analysis
- If no modified files: Note "No uncommitted changes" or omit Files section
- If file already exists: Append counter to filename
- If section would be empty: Omit it entirely
</error_handling>

<validation_checklist>
Before writing the handoff file, verify:
- [ ] Context clearly describes what and why
- [ ] Current State indicates phase and progress percentage if applicable
- [ ] All included sections have meaningful, actionable content
- [ ] Decision History captures trade-offs, not just choices
- [ ] Code snippets are essential (not just "nice to have")
- [ ] Next Steps are specific enough to act on immediately
- [ ] No empty sections are included
</validation_checklist>

<content_guidelines>
**Target lengths:**
- Total handoff: 1-4 pages depending on session complexity
- Context: 1-3 sentences
- Code snippets: 5-25 lines each, max 2-3 snippets
- Decision entries: 3-5 lines each
- Next Steps: 2-5 specific actions

**Quality signals:**
- A new session can start working within 2 minutes of reading
- No re-discovery of already-made decisions needed
- Failed approaches won't be re-attempted
</content_guidelines>

<skill_integration>
**Integration with related skills:**

**decision-journal:** If decisions were documented in a plan file's `## Decisions` section, extract them. Note any decisions marked with `[LEARNING]` for potential CLAUDE.md updates.

**thorough-planning:** If a plan file was used, extract:
- `## Assumptions` section
- `## Success Criteria` with completion status
- `## Feedback Loop` definition
- `## Quality Considerations` if present

**session-learnings:** If CLAUDE.md files were updated during the session, note which files and what categories were added (Preferences, Pitfalls, Patterns, Commands, Architecture).
</skill_integration>

<confirmation_format>
When confirming output, use this format:

```
✅ Handoff created: ./claude-handoff-YYYY-MM-DD.md

Captured:
- Context & Current State (X% complete)
- Success Criteria (N/M completed)
- Decision History (N decisions)
- [Other sections included]
- Next Steps (N actions)
```
</confirmation_format>

<examples>
**Example output with rich context:**

# Handoff: Auth System Refactoring to JWT

## Context
Refactoring the authentication module in the Express backend to use JWT tokens instead of session-based auth. Part of the security improvement initiative.

## Assumptions
- **Interpretation:** Replace session-based auth with JWT, maintain backward compatibility during migration
- **Scope:** Auth middleware, token generation, user model updates. Excludes: frontend auth changes (separate PR)
- **Tech approach:** Using jsonwebtoken library, RS256 algorithm, refresh token rotation

## Current State
Completed the token generation logic and user model updates. Currently implementing the middleware for token validation. About 60% through implementation phase.

## Success Criteria
- [x] Token generation utility created with RS256 signing
- [x] User model updated with refresh token field
- [ ] Auth middleware validates tokens on protected routes
- [ ] Refresh token rotation implemented
- [ ] Integration tests pass

## Feedback Loop
- Running `yarn test:auth` after each file change
- Manual testing with Postman for token flow

## Completed
- Set up JWT signing with RS256 algorithm
- Created token generation utility in `src/utils/tokens.ts`
- Updated user model with refreshToken field and index

## Remaining Tasks
- [ ] Implement auth middleware for protected routes (in progress)
- [ ] Add refresh token rotation logic
- [ ] Update login endpoint to return tokens
- [ ] Add logout endpoint to invalidate tokens
- [ ] Write integration tests

## Decision History
### Token signing algorithm
**Options considered:**
1. HS256 - Simpler, symmetric key, faster
2. RS256 - Asymmetric, public key verification, more secure
**Chose:** RS256
**Rejected HS256 because:** Security team requires public key verification for microservices
**Trade-offs accepted:** Slightly more complexity in key management

### Refresh token storage (REVISED)
**Original decision:** Stateless refresh tokens (JWT only)
**Changed to:** Database storage
**Why changed:** During implementation, realized we need token revocation for password changes and logout. Stateless tokens can't be invalidated.
**Trade-offs accepted:** Additional DB query on refresh, need cleanup job for expired tokens

## Validation & Testing
- [x] Token generation produces valid JWT → Verified with jwt.io debugger
- [x] RS256 signature validates with public key → Unit test passing
- [ ] Middleware correctly rejects invalid tokens
- [ ] Refresh rotation invalidates old token

## Current Thinking
- **Hypothesis:** The middleware can use the same token validation for both access and refresh tokens with a type claim
- **Concerns:** Unsure if 15-minute access token expiry is too short for the frontend's use case
- **Open questions:** Should we support multiple active refresh tokens per user (for multiple devices)?

## What We Tried (Didn't Work)
- **Using passport-jwt:** Tried integrating with existing Passport setup → **Failed because:** Too much abstraction, couldn't customize error responses → **Learned:** Direct jsonwebtoken gives more control for our error handling needs

## Learned Preferences
- User prefers explicit error messages over generic "Unauthorized"
- Keep middleware lean, extract validation logic to services

## Critical Code Context
```typescript
// src/utils/tokens.ts
export function generateTokenPair(userId: string): TokenPair {
  const accessToken = jwt.sign(
    { userId, type: 'access' },
    privateKey,
    { algorithm: 'RS256', expiresIn: '15m' }
  );
  const refreshToken = jwt.sign(
    { userId, type: 'refresh' },
    privateKey,
    { algorithm: 'RS256', expiresIn: '7d' }
  );
  return { accessToken, refreshToken };
}
```

## Files Being Modified
- `src/utils/tokens.ts` - Token generation (complete)
- `src/middleware/auth.ts` - Auth middleware (in progress, ~50%)
- `src/models/user.ts` - Added refreshToken field (complete)

## Next Steps
1. Complete the `requireAuth` middleware with token verification
2. Add the `verifyToken` helper function to tokens.ts
3. Write unit tests for the middleware


**Example output with minimal context (simple session):**

# Handoff: Fix User Profile Image Upload

## Context
Fixing a bug where profile image uploads fail for images over 2MB in the React frontend.

## Current State
Identified the issue - the multer config on backend has a 1MB limit. Need to update it.

## Completed
- Reproduced the bug with a 3MB test image
- Found the multer configuration in `src/middleware/upload.ts`

## Remaining Tasks
- [ ] Update multer limit to 5MB
- [ ] Add client-side file size validation with helpful error message
- [ ] Test with various file sizes

## Files Being Modified
- `src/middleware/upload.ts` - Needs limit increase

## Next Steps
1. Change `limits: { fileSize: 1024 * 1024 }` to `limits: { fileSize: 5 * 1024 * 1024 }`
2. Add frontend validation before upload attempt


**Example with plan file integration:**

# Handoff: Implement Caching Layer for API

## Context
Adding Redis caching to the product catalog API to reduce database load. Working from plan file `~/.claude/plans/speedy-caching-nebula.md`.

## Assumptions
*(Extracted from plan file)*
- **Interpretation:** Cache frequently-accessed product data, not user-specific data
- **Scope:** GET endpoints only; write-through invalidation on updates
- **Tech approach:** Redis with ioredis client, 5-minute TTL default

## Current State
Completed Redis connection setup and cache utility. Currently implementing cache middleware for product routes. About 40% through implementation.

## Success Criteria
*(From plan file: `~/.claude/plans/speedy-caching-nebula.md`)*
- [x] Redis connection with health check
- [x] Cache utility with get/set/invalidate
- [ ] Cache middleware for GET /products
- [ ] Cache invalidation on POST/PUT/DELETE
- [ ] Load testing shows 50% reduction in DB queries

## Feedback Loop
*(From plan file)*
- Running `yarn test:integration` after each endpoint
- Monitoring Redis hits/misses via redis-cli MONITOR

## Decision History
### Cache key strategy
*(From plan file `## Decisions` section)*
**Options considered:**
1. URL-based keys - Simple, automatic
2. Custom composite keys - More control, harder to invalidate
**Chose:** URL-based keys
**Rejected composite because:** Invalidation complexity outweighs benefits for this use case
**Trade-offs accepted:** Less granular control over cached data

## Remaining Tasks
- [ ] Add cache middleware to product routes
- [ ] Implement invalidation hooks on write operations
- [ ] Add cache headers to responses
- [ ] Run load tests

## Session Learnings Captured
- **Files updated:** Project CLAUDE.md
- **Categories:** Patterns
- **Key learnings:** Added Redis connection pattern with retry logic

## Files Being Modified
- `src/lib/redis.ts` - Connection and utilities (complete)
- `src/middleware/cache.ts` - Cache middleware (in progress)
- `src/routes/products.ts` - Will add middleware (not started)

## Next Steps
1. Complete cache middleware with TTL configuration
2. Add middleware to GET /products and GET /products/:id routes
3. Test cache hit/miss behavior with integration tests
</examples>
