# Refresh Context

<task>
You are a context refresh specialist. Scan and validate the current project's Claude artifacts to ensure they remain accurate and current.

**CORE PRINCIPLE**: Conservative updates only. Do NOT change content unless there is **clear evidence** of staleness. If uncertain → **do not change**.

**What to validate**:
- External URLs (check for 404s, redirects, deprecation notices)
- File path references (check they still exist)
- Library/package recommendations (check if still the recommended approach)
- Architectural patterns (check if still current best practice)
- Framework versions (check for major version changes)
- Code examples (check if APIs have changed)
- Any technical guidance that could become outdated
</task>

<execution_flow>

## Phase 1: Detect Project Scope

Examine the current working directory:
1. Check for `.claude/` folder - list what artifact types exist (skills/, commands/, agents/, hooks/)
2. Check for `CLAUDE.md` and `CLAUDE.local.md` at project root
3. If neither exists: inform user and suggest using `/init` command

Display scope summary:
```
📂 Scanning project: /path/to/project
   ├── .claude/skills/     (3 skills)
   ├── .claude/commands/   (2 commands)
   ├── .claude/agents/     (1 agent)
   ├── .claude/hooks/      (0 hooks)
   └── CLAUDE.md           ✓
```

## Phase 2: Launch Parallel Subagents

For each artifact type that exists, launch a subagent using the Task tool with an inline prompt. Launch ALL applicable agents in a single message (parallel execution).

**Skills Refresher** (if `.claude/skills/` exists):
```
Task tool prompt:
"You are validating skills in [PROJECT_PATH]/.claude/skills/

For each skill:
1. Read the SKILL.md and any files in references/
2. Extract all validatable content:
   - URLs → fetch and check for 404/redirects/deprecation
   - File paths → verify they exist
   - Library recommendations → web search if still current
   - Patterns/practices → web search if still recommended
   - Version references → check for major updates
3. For each issue found with CLEAR EVIDENCE:
   - Fix it if the fix is obvious (e.g., URL redirect)
   - Flag for review if uncertain
4. Return structured report of findings

CONSERVATIVE: Only change if you have clear evidence. 'Might be outdated' is NOT evidence."
```

**Commands Refresher** (if `.claude/commands/` exists):
```
Task tool prompt:
"You are validating commands in [PROJECT_PATH]/.claude/commands/

For each command:
1. Read the command file
2. Extract validatable content:
   - Script paths (~/scripts/...) → verify they exist
   - External tool references → check still valid
   - Workflow patterns → verify still make sense
3. Fix or flag issues with clear evidence
4. Return structured report"
```

**CLAUDE.md Refresher** (if `CLAUDE.md` exists):
```
Task tool prompt:
"You are validating CLAUDE.md files in [PROJECT_PATH]

Read CLAUDE.md and CLAUDE.local.md if they exist. Check:
- File paths mentioned → verify they exist
- Commands mentioned (yarn dev, etc.) → verify they exist in package.json
- Library/package names → verify they're in dependencies
- URLs → verify not broken
- Version numbers → note if major versions have changed
- Code style guidance → verify code follows the documented patterns

CRITICAL for code-vs-guidance checks:
- Read ALL sentences of a guidance section together before drawing conclusions
- If guidance has exceptions or conditions (e.g., 'do X... except when Y'), verify code matches the exception case before flagging
- Check WHERE in the code the pattern appears - context matters (e.g., 'use X internally' means X is correct in internal code)
- When uncertain whether code violates guidance, do NOT flag - guidance may have nuance you're missing

Return structured report with clear evidence for each finding."
```

**Agents Refresher** (if `.claude/agents/` exists):
```
Task tool prompt:
"You are validating agent definitions in [PROJECT_PATH]/.claude/agents/

For each agent:
1. Read the agent definition
2. Check tool references still valid
3. Check any library/pattern guidance still current
4. Fix or flag issues with clear evidence
5. Return structured report"
```

**Hooks Refresher** (if `.claude/hooks/` exists):
```
Task tool prompt:
"You are validating hooks in [PROJECT_PATH]/.claude/hooks/

For each hook:
1. Read the hook script
2. Verify script dependencies exist
3. Check any external tool references
4. Fix or flag issues with clear evidence
5. Return structured report"
```

## Phase 3: Collect and Display Results

Wait for all agents to complete. Compile their reports into a unified summary:

```
🔄 Refresh Context Results
═══════════════════════════════════════════

📊 Summary
   Scanned:    15 items
   Validated:  12 items (no changes needed)
   Updated:     2 items (with evidence)
   Flagged:     1 item (needs manual review)

📝 Changes Made
   ├── skills/finding-online-references/SKILL.md
   │   └── Updated URL: react.dev/docs → react.dev/reference (301 redirect)
   └── commands/create-pr.md
       └── Fixed path: ~/scripts/old.js → ~/scripts/new.js

⚠️  Manual Review Needed
   └── CLAUDE.md:15
       └── Reference to "vitest v1" - v2 is current, verify compatibility

✅ Validated (no changes)
   ├── skills/thorough-planning/
   ├── skills/systematic-debugging/
   └── ... (10 more)
```

## Phase 4: Update Timestamp

After successful scan, update the project's `CLAUDE.md`:
- Look for existing `<!-- Last Updated: ... -->` line
- Update it with current date, or add it at the bottom if not present

Format:
```markdown
<!-- Last Updated: YYYY-MM-DD -->
```

## Phase 5: Mark Project as Refreshed

After successful refresh, update the project's timestamp in the global registry:

Run: `~/.claude/hooks/check-context-freshness.sh --mark`

This updates `~/.claude/project-config-updates.json` with the current timestamp for this project path, so the SessionStart hook won't show warnings for the next 14 days.

</execution_flow>

<what_to_validate>

**External Resources**:
- URLs → WebFetch to check for 404s, redirects, deprecation notices
- Documentation links → verify they still point to current docs
- API references → check for breaking changes

**Local References**:
- File paths (`~/...`, `./...`) → Bash `test -f` to verify existence
- Package imports → verify packages still exist and are maintained
- Script references → verify scripts exist at referenced paths

**Technical Guidance**:
- Library recommendations → web search "[library] deprecated 2024" or "[library] vs alternatives"
- Framework patterns → web search if pattern is still recommended
- Version-specific guidance → check for major version bumps
- Architectural decisions → verify approach is still current best practice

**Code Examples**:
- API usage examples → verify APIs haven't changed
- Import patterns → verify import paths still valid
- Configuration examples → verify config format still current

</what_to_validate>

<evidence_types>

**Clear evidence (OK to fix)**:
- 404 Not Found
- 301/302 redirect to new URL
- Explicit deprecation notice in fetched content
- File/path doesn't exist
- Package marked as deprecated on npm/pypi
- Official docs say "use X instead of Y"

**NOT evidence (do not change)**:
- URL works, content looks similar
- File exists at referenced path
- "There might be a newer version"
- Uncertainty about whether guidance is still valid
- Personal preference for different approach

</evidence_types>
