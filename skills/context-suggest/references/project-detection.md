# Project Detection Patterns

Helpful patterns for detecting project characteristics. Use these as guidance when gathering context.

## Contents
- Package.json Signals
- Monorepo Detection
- Test Framework Detection
- Frontend Framework Detection
- File Pattern Indicators
- MCP Availability
- Current Task Type

## Package.json Signals

| Field | What to look for |
|-------|------------------|
| `dependencies` | Runtime libraries the project uses |
| `devDependencies` | Test frameworks, build tools |
| `scripts` | Available npm scripts (test, build, etc.) |
| `workspaces` | Monorepo indicator |

## Monorepo Detection

```
IF any of these exist:
  - packages/*/package.json
  - apps/*/package.json
  - lerna.json
  - nx.json
  - pnpm-workspace.yaml
  - package.json has "workspaces" field
THEN → Monorepo project
```

**For monorepos:** Check the nearest package.json to the current working directory, not just the root.

## Test Framework Detection

```
IF vitest.config.* exists OR "vitest" in devDependencies → Vitest
IF jest.config.* exists OR "jest" in devDependencies → Jest
IF playwright.config.* exists → Playwright (E2E)
IF cypress.config.* exists → Cypress (E2E)
```

## Frontend Framework Detection

```
IF "react" in deps → React
IF "vue" in deps → Vue
IF "@angular/core" in deps → Angular
IF "svelte" in deps → Svelte
IF "next" in deps → Next.js (React)
```

## File Pattern Indicators

| Pattern | Indicates |
|---------|-----------|
| `*.test.ts`, `*.spec.ts` | Unit tests present |
| `*.stories.tsx` | Storybook stories |
| `*.e2e.ts` | E2E tests |
| `Dockerfile` | Containerized |
| `.github/workflows/` | CI/CD with GitHub Actions |

## MCP Availability

Check `ListMcpResourcesTool` output for:
- `mcp__browsermcp__*` → Browser automation available
- `mcp__chrome-devtools__*` → DevTools debugging available
- `mcp__ide__*` → IDE integration available

## Current Task Type

Infer from user's request:
- "test", "mock", "spec" → Testing task
- "debug", "error", "not working" → Debugging task
- "plan", "implement", "build" → Planning/implementation
- "PR", "pull request", "merge" → PR preparation
- "refactor", "clean up" → Refactoring
