---
name: finding-online-references
description: Searches GitHub and web for relevant code examples and documentation using parallel subagents. Use when user says "look online", "find references", "search online", "find examples", or needs external resources.
---

# Finding Online References

## Overview

Orchestrates parallel subagents to search multiple sources (GitHub, web, docs), validates relevance, and returns a curated table of 3-5 references with metadata. Prioritizes relevance over popularity.

## When to Use

- User explicitly asks to "look online", "search", "find references", "find examples"
- Need external code examples or documentation
- Looking for how others implement something
- Comparing libraries or approaches

## When NOT to Use

- User wants to search the local codebase (use Grep/Glob)
- Answer exists in project files already open
- Simple questions answerable from knowledge
- User asks for inline code (this skill returns links, not snippets)

## The Pattern

### Step 1: Gather Context & Expand Query

Before searching, check if clarification is needed:

**Ask for clarification when:**
- Single-word query with multiple meanings (e.g., "hooks" - React? Git? Webhooks?)
- No clear technology/framework context
- Query could apply to multiple domains

**Gather user code context when relevant:**
- What framework/version are they using?
- What's their current architecture?
- Can they share the relevant code snippet?

Example: "I see you're looking for auth patterns. Are you using Express, Fastify, or another framework? What's your current auth setup?"

**Detect Multi-Technology Queries:**

Indicators:
- "X to Y" patterns → migration query
- "X with Y" patterns → integration query
- "X and Y" / "X vs Y" patterns → comparison query
- Multiple framework names in query

If detected:
- Note primary and secondary technologies
- Spawn separate agent per technology when comparing
- Add dedicated "integration" agent for cross-tech queries
- See Integration Search Agent in `references/search-strategies.md`

**Query Expansion (NEW):**

Before spawning agents, expand the query with synonyms and related terms:

| Original Term | Also Search |
|---------------|-------------|
| auth | authentication, login, session, JWT, OAuth |
| state management | store, state, redux, zustand, context |
| API client | http client, fetch wrapper, axios, request |
| validation | schema, zod, yup, validator |
| testing | test, jest, vitest, testing-library |
| styling | css, styles, tailwind, styled-components |
| routing | router, routes, navigation |
| form | forms, input, form handling |
| database | db, ORM, prisma, drizzle, sequelize |
| caching | cache, memoization, redis |

See `references/search-strategies.md` for full query expansion templates.

### Step 2: Select Search Directions

Based on query type, select 2-4 of these search directions:

| Query Type | Spawn These Agents |
|------------|-------------------|
| Implementation examples | GitHub Repos + Web Search |
| Error/problem solving | GitHub Issues + Web Search |
| API/framework usage | Official Docs + GitHub Code |
| Best practices | Web Search + GitHub Repos |
| Library comparison | GitHub Repos (multiple) + Web |
| **Multi-tech integration** | GitHub Repos (per tech) + Integration Web Search |
| **Migration (X to Y)** | GitHub Issues (migration problems) + Web Search (guides) |

**Niche Technology Detection:**

If query contains emerging/niche technology:
- Library < 1 year old
- Framework with < 1000 GitHub stars
- Emerging tech keywords: Bun, Deno, Tauri, SolidJS, Qwik, Htmx, Effect-TS, Drizzle, etc.

Then adjust search strategy:
- Lower star threshold from 100 to 10
- Weight recency higher than stars
- Include "trending" repos even with low stars
- Check npm weekly downloads as alternative credibility signal
- Personal blogs and newer sources become acceptable

See `references/relevance-scoring.md` for niche scoring criteria.

### Step 3: Spawn Parallel Agents

Launch agents **IN PARALLEL** using a single message with multiple Task tool calls.

See `references/search-strategies.md` for detailed agent prompts.

**Critical:** Each agent must return:
- Top 3 candidates only
- For each: URL, title, stars (if GitHub), last updated, relevance explanation
- Validation that content actually matches query (not just title)

### Step 4: Aggregate, Validate & Score Confidence

After agents return:
1. Merge all results
2. Remove duplicates
3. Validate relevance using criteria from `references/relevance-scoring.md`
4. Filter out noise (high stars but irrelevant)
5. **Track filtered results with reasons** (for transparency section)
6. **Assign confidence score to each result**

**Confidence Scoring (NEW):**

| Confidence | Criteria |
|------------|----------|
| **High** | Exact query match + correct tech + recent + validated content |
| **Medium** | Partial match OR different but compatible tech OR older content |
| **Low** | Related topic but not exact match, included for completeness |

See `references/relevance-scoring.md` for detailed confidence scoring formula.

### Step 5: Rank, Group & Report

**Ranking priority:**
1. Relevance to query (primary)
2. GitHub stars / credibility
3. Recency (prefer updated in last 12 months)

**Output format (NEW - Grouped with Confidence & Freshness):**

```markdown
## Results by Category

### Official Documentation
| # | Source | Confidence | Fresh | Why Relevant |
|---|--------|------------|-------|--------------|
| 1 | [React Docs: useEffect](url) | High | 🟢 | Canonical reference for hook lifecycle |

### Implementation Examples
| # | Source | Stars | Confidence | Fresh | Why Relevant |
|---|--------|-------|------------|-------|--------------|
| 1 | [zustand](url) | 45k | High | 🟢 | Minimal state management, TypeScript-first |
| 2 | [example-repo](url) | 2.3k | Medium | 🟡 | Real-world usage pattern |

### Tutorials & Guides
| # | Source | Confidence | Fresh | Why Relevant |
|---|--------|------------|-------|--------------|
| 1 | [State Management in 2024](url) | High | 🟢 | Comprehensive comparison with code examples |

---

**Filtered out:**
- ~~[redux-toolkit](url)~~ - 50k stars but query was for alternatives to Redux
- ~~[old-patterns-guide](url)~~ - Good content but from 2021, patterns outdated

**Related searches:**
- "zustand vs jotai comparison"
- "react state management best practices 2024"
- "when to use context vs state library"
```

**Freshness Indicators:**
| Badge | Meaning |
|-------|---------|
| 🟢 | Updated within 6 months |
| 🟡 | Updated 6-18 months ago |
| 🔴 | Updated 18+ months ago (still included if content is stable/relevant) |

**Category Definitions:**
| Category | What Goes Here |
|----------|---------------|
| Official Documentation | Framework/library official docs |
| Implementation Examples | GitHub repos with working code |
| Tutorials & Guides | Blog posts, courses, walkthroughs |
| GitHub Issues | Solutions to specific problems |

After results, offer: "Would you like me to fetch code snippets from any of these?"

## Agent Prompt Templates

### GitHub Repos Agent

```
Search GitHub for repositories matching: [QUERY]
Context: User is using [FRAMEWORK/LANGUAGE]

Use these commands:
- gh search repos "[query]" --sort stars --limit 10
- gh search repos "[query]" --sort updated --limit 10

For each promising result, validate relevance by:
1. Reading the repo description
2. Checking the README summary
3. Verifying it actually implements the pattern, not just mentions it

Return your top 3 as JSON:
[
  {
    "url": "https://github.com/...",
    "name": "repo-name",
    "stars": 5200,
    "updated": "2024-12",
    "relevance": "Why this matches the query"
  }
]
```

### Web Search Agent

```
Search the web for: [QUERY]
Context: User is using [FRAMEWORK/LANGUAGE]

Use WebSearch tool with query variations:
- "[query] tutorial 2024"
- "[query] best practices"
- "[framework] [query] implementation"

For each result, validate by fetching the page and confirming:
- It contains actual implementation details (not just theory)
- It's recent (prefer 2023-2025)
- It matches the user's tech stack

Return your top 3 as JSON (same format as above, stars can be null)
```

### GitHub Issues Agent

```
Search GitHub issues for: [QUERY]
This is used when the user is looking for solutions to problems.

Use: gh search issues "[query]" --sort comments --limit 10

Look for issues that:
- Have accepted answers or solutions
- Are marked as closed/resolved
- Have helpful discussion

Return top 3 with the solution summary in the relevance field.
```

## Common Mistakes

| Mistake | Why It's Wrong | Correct Approach |
|---------|----------------|------------------|
| Including high-star repos that aren't relevant | Noise is worse than nothing | Validate content, not just title |
| Running searches sequentially | Slow and inefficient | Use parallel Task tool calls |
| Returning 10+ results | Overwhelming | Curate to top 3-5 |
| Returning code snippets inline | Token-heavy, may be wrong context | Links + explanations, offer to fetch |
| Not asking about user's tech stack | Results may not match their setup | Gather context first if relevant |
| Skipping query expansion | Misses relevant results using different terminology | Always expand with synonyms |
| Flat list without grouping | Harder to scan and find what's needed | Group by category (docs/examples/tutorials) |
| Hiding filtered results | User can't assess search quality | Always show what was filtered and why |
| Missing freshness indicators | User can't quickly assess recency | Use 🟢🟡🔴 badges consistently |
| No related searches | Missed opportunity for discovery | Suggest 2-3 follow-up queries |

## Red Flags - STOP and Reconsider

If you catch yourself thinking any of these, pause:

| Rationalization | Reality |
|-----------------|---------|
| "This repo has 50k stars so it must be relevant" | Stars ≠ relevance. Validate content matches query. |
| "I'll search sequentially since it's just 2 searches" | Always parallel. Efficiency matters. |
| "I'll include 8 results since they're all good" | User can't process 8. Curate to 3-5 best. |
| "The query is clear, no need to ask about context" | If tech stack matters for results, ask. |
| "I'll just dump the code since it's short" | Links + explanation. User decides what to fetch. |
| "This is close enough to what they asked" | Close ≠ relevant. If unsure, exclude. |

## Hard Rules (No Exceptions)

1. **Never return irrelevant high-star results** - 0 relevant results > 5 noisy ones
2. **Always use parallel agents** - Single message, multiple Task tool calls
3. **Max 5 results** - Quality over quantity
4. **Links only, no inline code** - Offer to fetch, don't assume
5. **Ask about ambiguity** - When query has multiple interpretations, clarify first
6. **Always expand queries** - Use synonyms to catch alternate terminology
7. **Always group results** - Categories make scanning easier
8. **Always show filtered results** - Transparency builds trust
9. **Always include freshness indicators** - 🟢🟡🔴 on every result
10. **Always suggest related searches** - 2-3 follow-up queries

## References

- `references/search-strategies.md` - Detailed agent prompts, query expansion templates
- `references/relevance-scoring.md` - Validation criteria, confidence scoring, freshness thresholds
