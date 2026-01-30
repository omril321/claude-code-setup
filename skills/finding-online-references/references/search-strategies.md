# Search Strategies Reference

Detailed prompts for each type of search agent. Copy and customize based on the user's query.

---

## Query Expansion Templates

Before spawning agents, expand the user's query with synonyms and related terms.

### Domain-Specific Expansions

| Domain | Original Term | Expand To |
|--------|---------------|-----------|
| **Auth** | auth | authentication, login, session, JWT, OAuth, SSO, credentials |
| **State** | state management | store, state, redux, zustand, jotai, context, signals |
| **API** | API client | http client, fetch wrapper, axios, request, ky, got |
| **Data** | validation | schema, zod, yup, validator, ajv, typebox |
| **Testing** | testing | test, jest, vitest, testing-library, playwright, cypress |
| **Styling** | styling | css, styles, tailwind, styled-components, emotion, sass |
| **Routing** | routing | router, routes, navigation, pages, links |
| **Forms** | form | forms, input, form handling, react-hook-form, formik |
| **Database** | database | db, ORM, prisma, drizzle, sequelize, typeorm, mongoose |
| **Caching** | caching | cache, memoization, redis, swr, react-query, tanstack |
| **Error** | error handling | errors, exceptions, try-catch, error boundary |
| **Build** | bundler | webpack, vite, esbuild, rollup, parcel, turbopack |

### Framework-Specific Search Patterns

When the user's tech stack is known, use these optimized search patterns:

#### React Queries
```
Primary searches:
- react.dev (official docs)
- "[query] react hooks"
- "[query] react 18"

Additional sources:
- codesandbox.io/examples (live examples)
- stackblitz.com (live examples)
- kentcdodds.com (best practices)
- tanstack.com (data fetching)

Synonyms:
- component → functional component, FC
- hooks → useEffect, useState, custom hooks
- context → provider, consumer
```

#### Next.js Queries
```
Primary searches:
- nextjs.org/docs
- "[query] next.js 14" OR "next.js 15"
- "[query] app router" (prefer over pages router)

Additional sources:
- vercel.com/templates
- next-auth.js.org (auth)

Synonyms:
- routing → app router, pages, layouts
- SSR → server components, server actions
- API → route handlers, server actions
```

#### TypeScript Queries
```
Primary searches:
- typescriptlang.org/docs
- "[query] typescript"
- "[query] type-safe"

Additional sources:
- type-challenges (advanced patterns)
- total-typescript.com

Synonyms:
- types → generics, utility types, type inference
- interfaces → types, schemas
```

#### Python Queries
```
Primary searches:
- docs.python.org
- PyPI package search
- "[query] python"

Additional sources:
- readthedocs.io (library docs)
- real-python.com (tutorials)

Synonyms:
- async → asyncio, aiohttp, fastapi
- web → flask, fastapi, django
- types → type hints, pydantic, mypy
```

#### Node.js Queries
```
Primary searches:
- nodejs.org/docs
- "[query] node.js"
- "[query] express" OR "fastify"

Additional sources:
- npm search
- socket.io (real-time)

Synonyms:
- server → http, express, fastify, koa
- database → mongoose, prisma, sequelize
```

### Related Searches Generator

After finding results, generate 2-3 related searches based on patterns:

| Query Pattern | Generate These Related Searches |
|--------------|--------------------------------|
| "[library] tutorial" | "[library] best practices", "[library] vs [alternative]" |
| "[framework] [feature]" | "[framework] [feature] performance", "[framework] [feature] testing" |
| "[X] vs [Y]" | "when to use [X]", "when to use [Y]", "[X] [Y] migration" |
| "how to [action]" | "[action] best practices", "[action] examples", "[action] patterns" |
| "[error message]" | "[library] [error] fix", "[library] troubleshooting" |

---

## GitHub Repos Agent

**When to use:** Implementation examples, libraries, working code

**Prompt template:**

```
Search GitHub for repositories related to: [USER_QUERY]

User context:
- Technology: [FRAMEWORK/LANGUAGE]
- Looking for: [code examples / library / pattern implementation]

Execute these searches using gh CLI:

1. Sort by stars (popularity):
   gh search repos "[keywords]" --language=[lang] --sort stars --limit 10

2. Sort by recent updates (freshness):
   gh search repos "[keywords]" --language=[lang] --sort updated --limit 10

For each candidate repository:
1. Check if the name and description match the query intent
2. Run: gh repo view [owner/repo] --json description,stargazersCount,pushedAt,readme,isFork,parent
3. Scan the README to verify it actually implements what the user needs
4. Reject repos that only mention the topic but don't demonstrate it

**Fork Detection:**
5. If `isFork` is true:
   - Get parent repo stats: gh repo view [parent.owner]/[parent.name] --json stargazersCount,pushedAt
   - Only include the fork if:
     a) Parent is inactive (no commits in 12+ months) AND fork has recent activity, OR
     b) Fork has significantly more stars than parent (2x+)
   - Note in relevance: "Active fork of [parent] - original unmaintained"
6. Deduplicate: If multiple repos share the same parent, keep only the best (most stars + recent activity)

CRITICAL: A repo with 50k stars that doesn't match the query is WORSE than a 500-star repo that does.
CRITICAL: Returning 3 forks of the same codebase is noise. Prefer originals, deduplicate forks.

Return exactly 3 results as JSON:
[
  {
    "url": "https://github.com/owner/repo",
    "name": "repo-name",
    "stars": 5200,
    "updated": "2024-12",
    "relevance": "1-2 sentence explanation of how this matches the query and what the user will find"
  }
]

If fewer than 3 relevant repos exist, return fewer. Do not pad with irrelevant results.
```

## GitHub Code Search Agent

**When to use:** Finding specific code patterns, API usage examples

**Prompt template:**

```
Search GitHub code for: [SPECIFIC_PATTERN]

User context:
- Technology: [FRAMEWORK/LANGUAGE]
- Looking for: [specific function/pattern/API usage]

Execute code search:
gh search code "[pattern]" --language=[lang] --limit 20

For each promising match:
1. Note the file path and repository
2. Check if the code context is a real implementation (not test mocks, not comments)
3. Verify the repo is maintained (check last commit date)

Group results by repository. For each unique repo with matching code:
1. Get repo metadata: gh repo view [owner/repo] --json stargazersCount,pushedAt
2. Note the specific file(s) with relevant code

Return top 3 repositories with code matches:
[
  {
    "url": "https://github.com/owner/repo",
    "name": "repo-name",
    "stars": 1200,
    "updated": "2024-11",
    "relevance": "Contains [pattern] in [file path] - [brief description of implementation]",
    "files": ["src/utils/retry.ts:45", "src/api/client.ts:120"]
  }
]
```

## GitHub Issues Agent

**When to use:** Solutions to problems, workarounds, error messages

**Prompt template:**

```
Search GitHub issues for solutions to: [USER_PROBLEM]

User context:
- Technology: [FRAMEWORK/LANGUAGE]
- Error/issue: [SPECIFIC_ERROR_OR_PROBLEM]

Execute issue search:
gh search issues "[error message or problem description]" --sort comments --limit 15

Filter for issues that:
1. Are closed (likely resolved)
2. Have multiple comments (discussion occurred)
3. Contain solution keywords: "fixed", "solved", "workaround", "solution"

For promising issues:
1. Read the issue body to understand the problem
2. Check if it matches the user's situation
3. Find the resolution (last comments or linked PR)

Return top 3 issues with solutions:
[
  {
    "url": "https://github.com/owner/repo/issues/123",
    "name": "Issue title",
    "stars": null,
    "updated": "2024-10",
    "relevance": "This issue describes [same problem]. Solution: [brief summary of fix]"
  }
]
```

## Web Search Agent

**When to use:** Tutorials, best practices, conceptual explanations, comparisons

**Prompt template:**

```
Search the web for: [USER_QUERY]

User context:
- Technology: [FRAMEWORK/LANGUAGE]
- Type: [tutorial / best practices / comparison / documentation]

Use WebSearch tool with these query variations:
1. "[query] [framework] tutorial 2024"
2. "[query] [framework] best practices"
3. "[query] implementation guide"

For each search result:
1. Check the title and snippet for relevance
2. Prefer: official docs, well-known tech blogs (LogRocket, CSS-Tricks, etc.), Medium with high claps
3. Avoid: outdated articles (pre-2023 unless the topic is stable), SEO-spam sites

For top candidates, use WebFetch to verify:
1. The content actually covers the topic in depth
2. Code examples are present (if user needs code)
3. The framework/language matches the user's context

Return top 3 results:
[
  {
    "url": "https://...",
    "name": "Article or doc title",
    "stars": null,
    "updated": "2024-09",
    "relevance": "Covers [specific aspect] with [TypeScript/React/etc.] examples. Includes [key topics]."
  }
]
```

## Official Docs Agent

**When to use:** API references, framework documentation, configuration options

**Prompt template:**

```
Find official documentation for: [USER_QUERY]

User context:
- Technology: [FRAMEWORK/LIBRARY]
- Looking for: [API reference / configuration / guide]

Strategy:
1. Identify the official documentation URL for the technology
2. Use WebSearch: "site:[docs-domain] [query]"
3. Or use WebFetch directly on known doc URLs

Known documentation patterns:
- React: react.dev
- Next.js: nextjs.org/docs
- TypeScript: typescriptlang.org/docs
- Node.js: nodejs.org/docs
- Prisma: prisma.io/docs
- Express: expressjs.com
- MDN: developer.mozilla.org

For each doc page found:
1. Verify it's current (not deprecated/legacy docs)
2. Check it covers the specific topic
3. Note if there are code examples

Return top 3 documentation links:
[
  {
    "url": "https://react.dev/reference/...",
    "name": "React Docs: [Section]",
    "stars": null,
    "updated": "current",
    "relevance": "Official documentation for [feature]. Includes examples and API reference."
  }
]
```

## Integration Search Agent

**When to use:** Query spans multiple technologies (e.g., "React with FastAPI", "connect Next.js to PostgreSQL")

**Prompt template:**

```
Search for integration examples between: [TECH_A] and [TECH_B]

User context:
- Primary technology: [TECH_A]
- Secondary technology: [TECH_B]
- Query type: [integration / migration / comparison]

Execute searches:
1. gh search repos "[tech_a] [tech_b]" --sort stars --limit 10
2. gh search repos "[tech_a] [tech_b] boilerplate" --sort stars --limit 5
3. gh search repos "[tech_a] [tech_b] starter" --sort updated --limit 5

Use WebSearch for tutorials:
4. "[tech_a] [tech_b] integration tutorial 2024"
5. "[tech_a] [tech_b] full stack example"

For each result, verify:
1. The repo/article actually shows BOTH technologies working together
2. Not just a mono-tech project that mentions the other
3. Has real integration code (API calls, data flow between systems)

CRITICAL: Focus on the CONNECTION between technologies, not either one alone.
A React-only tutorial that mentions "you could use FastAPI" is NOT relevant.
A FastAPI backend with React frontend showing actual API integration IS relevant.

Return top 3 results as JSON:
[
  {
    "url": "https://github.com/...",
    "name": "fullstack-react-fastapi",
    "stars": 1200,
    "updated": "2024-11",
    "relevance": "Full-stack boilerplate showing [specific integration pattern]",
    "integration_type": "boilerplate" | "tutorial" | "example"
  }
]
```

## Migration Search Agent

**When to use:** Query involves migrating from one technology to another (e.g., "Express to Fastify", "Redux to Zustand")

**Prompt template:**

```
Search for migration guides from: [TECH_FROM] to [TECH_TO]

Execute searches:
1. gh search issues "[tech_from] to [tech_to] migration" --sort comments --limit 10
2. WebSearch "[tech_from] to [tech_to] migration guide 2024"
3. WebSearch "migrate from [tech_from] to [tech_to]"

Look for:
- Step-by-step migration guides
- Issues/discussions about migration challenges
- Before/after code comparisons
- Codemods or migration tools

Prioritize:
- Official migration guides (if technology has one)
- Detailed blog posts with real migration experience
- GitHub issues with accepted solutions

Return top 3 focusing on the MIGRATION PROCESS, not just "here's how to use [tech_to]".
```

---

## Combining Agents

When spawning multiple agents, launch them ALL in a single message with multiple Task tool calls:

```
<Task tool call 1: GitHub Repos Agent>
<Task tool call 2: Web Search Agent>
<Task tool call 3: GitHub Issues Agent>
```

This runs them in parallel for efficiency.

After all return, merge results:
1. Combine all JSON arrays
2. Remove duplicate URLs
3. Re-rank by relevance score (see relevance-scoring.md)
4. Take top 3-5 for final output
