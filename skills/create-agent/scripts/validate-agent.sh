#!/bin/bash
# Agent File Validator
# Validates agent markdown files for correct structure and content

set -uo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 <path/to/agent.md>"
  echo ""
  echo "Validates agent file for:"
  echo "  - YAML frontmatter structure"
  echo "  - Required fields (name, description, model, color)"
  echo "  - Optional fields (permissionMode, maxTurns, memory, disallowedTools)"
  echo "  - Field formats and constraints"
  echo "  - System prompt presence and quality"
  echo "  - Example blocks in description"
  exit 1
fi

AGENT_FILE="$1"

echo "Validating agent file: $AGENT_FILE"
echo ""

# Check 1: File exists
if [ ! -f "$AGENT_FILE" ]; then
  echo "FAIL: File not found: $AGENT_FILE"
  exit 1
fi
echo "PASS: File exists"

# Check 2: Starts with ---
FIRST_LINE=$(head -1 "$AGENT_FILE")
if [ "$FIRST_LINE" != "---" ]; then
  echo "FAIL: File must start with YAML frontmatter (---)"
  exit 1
fi
echo "PASS: Starts with frontmatter"

# Check 3: Has closing ---
if ! tail -n +2 "$AGENT_FILE" | grep -q '^---$'; then
  echo "FAIL: Frontmatter not closed (missing second ---)"
  exit 1
fi
echo "PASS: Frontmatter properly closed"

# Extract frontmatter and system prompt
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$AGENT_FILE")
SYSTEM_PROMPT=$(awk '/^---$/{i++; next} i>=2' "$AGENT_FILE")

error_count=0
warning_count=0

# --- Required Fields ---

echo ""
echo "Required fields:"

# name
NAME=$(echo "$FRONTMATTER" | grep '^name:' | sed 's/name: *//' | sed 's/^"\(.*\)"$/\1/' || true)

if [ -z "$NAME" ]; then
  echo "  FAIL: Missing required field: name"
  ((error_count++))
else
  echo "  PASS: name = $NAME"
  if ! [[ "$NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$ ]] && ! [[ "$NAME" =~ ^[a-zA-Z0-9]{3,}$ ]]; then
    echo "  FAIL: name must start/end with alphanumeric, contain only letters, numbers, hyphens"
    ((error_count++))
  fi
  name_length=${#NAME}
  if [ "$name_length" -lt 3 ]; then
    echo "  FAIL: name too short (minimum 3 characters, got $name_length)"
    ((error_count++))
  elif [ "$name_length" -gt 50 ]; then
    echo "  FAIL: name too long (maximum 50 characters, got $name_length)"
    ((error_count++))
  fi
  if [[ "$NAME" =~ ^(helper|assistant|agent|tool)$ ]]; then
    echo "  WARN: name is too generic: $NAME"
    ((warning_count++))
  fi
fi

# description
DESCRIPTION=$(echo "$FRONTMATTER" | grep '^description:' | sed 's/description: *//' || true)

if [ -z "$DESCRIPTION" ]; then
  echo "  FAIL: Missing required field: description"
  ((error_count++))
else
  desc_length=${#DESCRIPTION}
  echo "  PASS: description ($desc_length chars)"
  if [ "$desc_length" -lt 10 ]; then
    echo "  WARN: description too short (minimum 10 characters recommended)"
    ((warning_count++))
  elif [ "$desc_length" -gt 5000 ]; then
    echo "  WARN: description very long (over 5000 characters)"
    ((warning_count++))
  fi
  if ! echo "$DESCRIPTION" | grep -q '<example>'; then
    echo "  WARN: description should include <example> blocks for triggering"
    ((warning_count++))
  fi
  if ! echo "$DESCRIPTION" | grep -qi 'use this agent when\|use when'; then
    echo "  WARN: description should include trigger conditions ('Use this agent when...' or 'Use when...')"
    ((warning_count++))
  fi
fi

# model
MODEL=$(echo "$FRONTMATTER" | grep '^model:' | sed 's/model: *//' || true)

if [ -z "$MODEL" ]; then
  echo "  FAIL: Missing required field: model"
  ((error_count++))
else
  echo "  PASS: model = $MODEL"
  case "$MODEL" in
    inherit|sonnet|opus|haiku) ;;
    *)
      echo "  WARN: Unknown model: $MODEL (valid: inherit, sonnet, opus, haiku)"
      ((warning_count++))
      ;;
  esac
fi

# color
COLOR=$(echo "$FRONTMATTER" | grep '^color:' | sed 's/color: *//' || true)

if [ -z "$COLOR" ]; then
  echo "  FAIL: Missing required field: color"
  ((error_count++))
else
  echo "  PASS: color = $COLOR"
  case "$COLOR" in
    blue|cyan|green|yellow|magenta|red) ;;
    *)
      echo "  WARN: Unknown color: $COLOR (valid: blue, cyan, green, yellow, magenta, red)"
      ((warning_count++))
      ;;
  esac
fi

# --- Optional Fields ---

echo ""
echo "Optional fields:"

# tools
TOOLS=$(echo "$FRONTMATTER" | grep '^tools:' | sed 's/tools: *//' || true)
if [ -n "$TOOLS" ]; then
  echo "  INFO: tools = $TOOLS"
else
  echo "  INFO: tools not specified (agent has access to all tools)"
fi

# disallowedTools
DISALLOWED=$(echo "$FRONTMATTER" | grep '^disallowedTools:' | sed 's/disallowedTools: *//' || true)
if [ -n "$DISALLOWED" ]; then
  echo "  INFO: disallowedTools = $DISALLOWED"
  # Check for conflict with tools
  if [ -n "$TOOLS" ]; then
    echo "  WARN: Both tools and disallowedTools specified — ensure no overlap"
    ((warning_count++))
  fi
fi

# permissionMode
PERM_MODE=$(echo "$FRONTMATTER" | grep '^permissionMode:' | sed 's/permissionMode: *//' || true)
if [ -n "$PERM_MODE" ]; then
  echo "  INFO: permissionMode = $PERM_MODE"
  case "$PERM_MODE" in
    default|acceptEdits|delegate|dontAsk|bypassPermissions|plan) ;;
    *)
      echo "  FAIL: Invalid permissionMode: $PERM_MODE (valid: default, acceptEdits, delegate, dontAsk, bypassPermissions, plan)"
      ((error_count++))
      ;;
  esac
fi

# maxTurns
MAX_TURNS=$(echo "$FRONTMATTER" | grep '^maxTurns:' | sed 's/maxTurns: *//' || true)
if [ -n "$MAX_TURNS" ]; then
  echo "  INFO: maxTurns = $MAX_TURNS"
  if ! [[ "$MAX_TURNS" =~ ^[1-9][0-9]*$ ]]; then
    echo "  FAIL: maxTurns must be a positive integer (got: $MAX_TURNS)"
    ((error_count++))
  fi
fi

# memory
MEMORY=$(echo "$FRONTMATTER" | grep '^memory:' | sed 's/memory: *//' || true)
if [ -n "$MEMORY" ]; then
  echo "  INFO: memory = $MEMORY"
  case "$MEMORY" in
    user|project|local) ;;
    *)
      echo "  FAIL: Invalid memory: $MEMORY (valid: user, project, local)"
      ((error_count++))
      ;;
  esac
fi

# skills
SKILLS=$(echo "$FRONTMATTER" | grep '^skills:' | sed 's/skills: *//' || true)
if [ -n "$SKILLS" ]; then
  echo "  INFO: skills = $SKILLS"
fi

# mcpServers
MCP=$(echo "$FRONTMATTER" | grep '^mcpServers:' | sed 's/mcpServers: *//' || true)
if [ -n "$MCP" ]; then
  echo "  INFO: mcpServers = $MCP"
fi

# --- System Prompt ---

echo ""
echo "System prompt:"

if [ -z "$SYSTEM_PROMPT" ] || [ "$(echo "$SYSTEM_PROMPT" | tr -d '[:space:]')" = "" ]; then
  echo "  FAIL: System prompt is empty"
  ((error_count++))
else
  prompt_length=${#SYSTEM_PROMPT}
  echo "  PASS: System prompt ($prompt_length chars)"

  if [ "$prompt_length" -lt 20 ]; then
    echo "  FAIL: System prompt too short (minimum 20 characters)"
    ((error_count++))
  elif [ "$prompt_length" -gt 10000 ]; then
    echo "  WARN: System prompt very long (over 10,000 characters)"
    ((warning_count++))
  fi

  if ! echo "$SYSTEM_PROMPT" | grep -q "You are\|You will\|Your"; then
    echo "  WARN: System prompt should use second person (You are..., You will...)"
    ((warning_count++))
  fi

  if ! echo "$SYSTEM_PROMPT" | grep -qi "responsibilities\|process\|steps"; then
    echo "  INFO: Consider adding clear responsibilities or process steps"
  fi

  if ! echo "$SYSTEM_PROMPT" | grep -qi "output"; then
    echo "  INFO: Consider defining output format expectations"
  fi
fi

# --- Summary ---

echo ""
echo "----------------------------------------"

if [ $error_count -eq 0 ] && [ $warning_count -eq 0 ]; then
  echo "RESULT: All checks passed"
  exit 0
elif [ $error_count -eq 0 ]; then
  echo "RESULT: Passed with $warning_count warning(s)"
  exit 0
else
  echo "RESULT: Failed with $error_count error(s) and $warning_count warning(s)"
  exit 1
fi
