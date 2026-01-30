# Relevance Scoring Reference

How to validate and rank results to ensure quality over quantity.

## The Iron Rule

> A high-star result that doesn't match the query is WORSE than no result at all.

Noise wastes the user's time and erodes trust. When in doubt, exclude.

## Relevance Validation Checklist

Before including any result, verify ALL of these:

### 1. Title/Description Match (Quick Check)

- [ ] Does the title/repo name contain query keywords?
- [ ] Does the description mention the specific technology?
- [ ] Is this about the same domain? (e.g., "hooks" could be React, Git, or webhooks)

If no on any: **proceed to content sampling** before rejecting.

### 2. Content Sampling (Deep Check)

For borderline cases, actually read the content:

**For GitHub repos:**
```
gh repo view [owner/repo] --json readme | jq '.readme' | head -100
```

Check:
- [ ] README mentions the specific pattern/feature
- [ ] Code examples are in the correct language
- [ ] Not just a passing mention

**For web pages:**
Use WebFetch and check:
- [ ] Article actually covers the topic (not just SEO bait)
- [ ] Code examples present (if code was requested)
- [ ] Technology stack matches user's context

### 3. Recency Check

| Content Type | Acceptable Age |
|--------------|---------------|
| Framework docs | Current version only |
| Library code | Updated in last 24 months |
| Tutorials | Published 2023 or later |
| Best practices | Published 2022 or later |
| Stable concepts (algorithms, patterns) | Any age if still accurate |

### 4. Credibility Check

**GitHub repos:**
- Stars > 100 preferred (but relevance trumps popularity)
- Has recent commits
- Has proper documentation
- Not archived

**Web content:**
- Official docs > Well-known blogs > Medium/Dev.to > Random sites
- Author credibility (known experts, company blogs)
- Not obvious SEO spam

## Scoring Formula

Assign points to each result:

| Criteria | Points |
|----------|--------|
| Direct query keyword match | +3 |
| Same technology/framework | +3 |
| Content actually demonstrates the pattern | +3 |
| Updated in last 12 months | +2 |
| Updated 12-24 months ago | +1 |
| Stars > 5000 | +2 |
| Stars 1000-5000 | +1 |
| Stars 100-1000 | +0 |
| Official documentation | +2 |
| Well-known source | +1 |

**Penalties:**
| Issue | Points |
|-------|--------|
| Wrong technology | -5 (likely exclude) |
| Outdated (>3 years, non-stable topic) | -3 |
| No code examples (when code requested) | -2 |
| Archived/deprecated | -3 |
| Fork of active parent | -3 (prefer original) |
| Duplicate of already-included repo | -5 (exclude) |

**Threshold:** Include only results with score >= 5

## Ranking for Final Output

After filtering, rank remaining results by:

1. **Relevance score** (primary) - highest first
2. **Stars** (tiebreaker) - higher is better
3. **Recency** (tiebreaker) - more recent is better

---

## Confidence Scoring

Assign a confidence level to each result to help users assess reliability.

### Confidence Levels

| Level | Score Range | Criteria | Example |
|-------|-------------|----------|---------|
| **High** | 10+ points | Exact query match + correct tech + recent + validated content | Official React docs for React hooks query |
| **Medium** | 6-9 points | Partial match OR related tech OR older but solid content | TypeScript article for JS query (compatible) |
| **Low** | 4-5 points | Related topic, included for completeness | General programming pattern for specific framework query |

### Confidence Formula

```
Base relevance score (from scoring formula above)
  + Direct technology match: +2
  + Exact query keyword in title: +2
  + Content manually validated: +1
  + Official source: +2
  - Technology mismatch (but compatible): -2
  - Only tangentially related: -3
  - Unvalidated (title match only): -1
= Final confidence score

High = 10+
Medium = 6-9
Low = 4-5
Below 4 = Do not include
```

### When to Use Each Level

| Confidence | When to Apply |
|------------|---------------|
| **High** | Result directly answers the query with no caveats |
| **Medium** | Result is helpful but user should verify it fits their specific case |
| **Low** | Result provides context/background but may not be directly applicable |

---

## Freshness Indicators

Visual badges to help users quickly assess content recency.

### Badge Definitions

| Badge | Meaning | When to Apply |
|-------|---------|---------------|
| 🟢 | Fresh | Updated within 6 months |
| 🟡 | Recent | Updated 6-18 months ago |
| 🔴 | Older | Updated 18+ months ago |

### Freshness by Content Type

Different content types have different freshness requirements:

| Content Type | 🟢 Fresh | 🟡 Recent | 🔴 Older (Still Valid If...) |
|--------------|----------|-----------|------------------------------|
| Framework docs | Current version | Previous major version | Concepts unchanged |
| Library repos | Last 6 months | 6-18 months | Still maintained, no breaking changes |
| Tutorials | 2024-2025 | 2023 | Patterns still valid |
| Best practices | 2024-2025 | 2022-2023 | Not superseded by new patterns |
| Stable concepts | Any age | Any age | Fundamentals don't change (algorithms, design patterns) |

### Freshness Adjustments

When to KEEP older content with 🔴:
- Stable topics (sorting algorithms, design patterns)
- Still-active libraries with backward compatibility
- Canonical references (official docs for older versions still in use)

When to EXCLUDE older content:
- Fast-moving frameworks with breaking changes
- Deprecated libraries or patterns
- Security-related content (always needs latest)

---

## "Why Filtered" Templates

Always show what was excluded and why. Use these templates:

### Filtered Result Templates

| Reason | Template |
|--------|----------|
| Wrong technology | ~~[result](url)~~ - [X]k stars but this is for [wrong-tech], not [user-tech] |
| Outdated | ~~[result](url)~~ - Good content but from [year], patterns have changed |
| Not specific enough | ~~[result](url)~~ - General [topic] guide, doesn't cover [specific-query] |
| Deprecated | ~~[result](url)~~ - Library/pattern deprecated, use [alternative] instead |
| Duplicate | ~~[result](url)~~ - Fork of [original] with no significant changes |
| Low quality | ~~[result](url)~~ - SEO content, lacks depth or real examples |

### Example Filtered Section

```markdown
**Filtered out:**
- ~~[awesome-react](github.com/...)~~ - 200k stars but just a list, no implementations
- ~~[old-state-guide](blog.com/...)~~ - Solid guide but from 2019, uses class components
- ~~[vue-state-management](github.com/...)~~ - Great library but for Vue, not React
```

### When to Show Fewer Filtered Results

Show up to 3 filtered results. If more were filtered:
```markdown
**Filtered out:** (showing top 3 of 8 excluded)
- ~~[result1](url)~~ - reason
- ~~[result2](url)~~ - reason
- ~~[result3](url)~~ - reason
```

## Example Scoring

Query: "React state management patterns"
User context: React 18, TypeScript

| Result | Relevance | Tech Match | Content | Recency | Stars | Total | Include? |
|--------|-----------|------------|---------|---------|-------|-------|----------|
| zustand (state lib) | +3 | +3 | +3 | +2 | +2 | 13 | Yes (top) |
| jotai (state lib) | +3 | +3 | +3 | +2 | +1 | 12 | Yes |
| Redux docs | +3 | +3 | +3 | +2 | +2 | 13 | Yes |
| Vue Pinia | +3 | -5 | +3 | +2 | +1 | 4 | No (wrong tech) |
| Generic React tutorial | +1 | +3 | +1 | +1 | +0 | 6 | Maybe |
| Awesome-react (list) | +0 | +3 | +0 | +2 | +2 | 7 | No (not specific) |

## Common Rejection Reasons

1. **Wrong technology** - React example for Vue user
2. **Just a list** - "Awesome-X" repos without actual implementation
3. **Outdated** - Pre-2022 for rapidly evolving tech
4. **Tangential** - Mentions the keyword but isn't about it
5. **No depth** - Surface-level content, no real examples
6. **Deprecated** - Archived repo, sunset library

## When to Return Fewer Results

Return fewer than 3-5 results when:
- Query is very specific (might only have 1-2 good matches)
- Most results are noise
- Better to return 2 excellent results than 5 mediocre ones

State this clearly: "I found 2 highly relevant references. Additional results were less relevant so I've excluded them."

---

## Niche Technology Scoring

When query involves emerging/niche technology (Bun, Deno, Tauri, SolidJS, Htmx, Effect-TS, Drizzle, etc.), use adjusted scoring:

| Criteria | Points |
|----------|--------|
| Exact pattern/feature match | +5 (boosted from +3) |
| Same technology | +3 |
| Created/updated in last 6 months | +3 |
| Weekly npm downloads > 1000 | +2 |
| Author is maintainer of queried library | +3 |
| Stars > 50 | +1 (lowered from 100) |
| Stars > 500 | +2 |
| Personal blog with real examples | +1 (normally 0) |

**Niche-specific adjustments:**
- Lower threshold from 5 to 4 for inclusion
- Recency weighted higher than stars
- Accept results from less-known sources if content is solid
- Check npm/PyPI downloads as alternative to GitHub stars

**Why different scoring?**
New technologies don't have high-star repos yet. A 50-star Bun library from 2024 may be more relevant than a 5000-star Node.js library from 2020.
