# Token-Saving Techniques

## Move Details to Tool Help

**Bad - Document all flags in SKILL.md:**
```markdown
search-conversations supports --text, --both, --after DATE, --before DATE, --limit N...
```

**Good - Reference --help:**
```markdown
search-conversations supports multiple modes. Run --help for details.
```

## Use Cross-References

**Bad - Repeat workflow details:**
```markdown
[20 lines of repeated instructions already in another skill]
```

**Good - Reference other skill:**
```markdown
Always use subagents. REQUIRED: Use [other-skill-name] for workflow.
```

## Keep References One Level Deep

All reference files should link directly from SKILL.md. Avoid nested references (A → B → C).

**Good structure:**
```
SKILL.md → references/examples.md
SKILL.md → references/api-reference.md
```

**Bad structure:**
```
SKILL.md → references/guide.md → references/details/examples.md
```

## Summary

| Technique | Why |
|-----------|-----|
| Reference --help | Tools update, docs don't |
| Cross-reference skills | DRY principle |
| One level deep | Easier navigation |
