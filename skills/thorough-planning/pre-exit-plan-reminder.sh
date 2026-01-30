#!/bin/bash
# Enforce Tools Summary before exiting plan mode

PLANS_DIR="$HOME/.claude/plans"

# Find the most recently modified plan file
# This works because the current session's plan file was just edited
PLAN_FILE=$(ls -t "$PLANS_DIR"/*.md 2>/dev/null | head -1)

if [ -z "$PLAN_FILE" ]; then
  echo "⚠️  No plan file found in $PLANS_DIR" >&2
  exit 0  # Allow - no plan file to check
fi

# Check if TOOLS_SKILLS_SUMMARY exists in the plan
if ! grep -q "TOOLS_SKILLS_SUMMARY" "$PLAN_FILE"; then
  echo "" >&2
  echo "❌ BLOCKED: Plan is missing the Tools & Skills Summary" >&2
  echo "" >&2
  echo "Before exiting plan mode, you MUST:" >&2
  echo "  1. Run /context-suggest to discover available components" >&2
  echo "  2. Add '🛠️ Tools & Skills for This Plan (TOOLS_SKILLS_SUMMARY)' section" >&2
  echo "" >&2
  echo "Plan file: $PLAN_FILE" >&2
  exit 2  # Block the tool
fi

# Summary found - allow exit
echo "✅ Tools Summary found in plan" >&2
exit 0