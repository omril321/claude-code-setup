#!/bin/bash

# Read JSON input
input=$(cat)

# --- COLORS ---
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

# --- OSC 8 HYPERLINK ---
# Format: \033]8;;{URI}\a{text}\033]8;;\a
# Using BEL (\a or \007) as terminator for better iTerm2 compatibility
OSC_START=$'\033]8;;'
OSC_END=$'\a'

# --- Helper: format token count (K or M) ---
fmt_tokens() {
    local n=$1
    if [ "$n" -lt 1000 ]; then
        printf "%s" "$n"
    elif [ "$n" -lt 1000000 ]; then
        local v
        v=$(awk "BEGIN {printf \"%.1f\", $n/1000}" | sed 's/\.0$//')
        printf "%sk" "$v"
    else
        local v
        v=$(awk "BEGIN {printf \"%.1f\", $n/1000000}" | sed 's/\.0$//')
        printf "%sM" "$v"
    fi
}

# --- TOKEN COUNT ---
usage=$(echo "$input" | jq '.context_window.current_usage')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')

if [ "$usage" != "null" ]; then
    input_tokens=$(echo "$usage" | jq '.input_tokens')
    cache_creation=$(echo "$usage" | jq '.cache_creation_input_tokens')
    cache_read=$(echo "$usage" | jq '.cache_read_input_tokens')

    current=$((input_tokens + cache_creation + cache_read))
    current_fmt=$(fmt_tokens $current)
    usage_pct=$((current * 100 / context_size))
else
    current_fmt="0"
    usage_pct=0
fi

# Determine token color based on usage
if [ $usage_pct -lt 50 ]; then
    token_color="$GREEN"
elif [ $usage_pct -lt 75 ]; then
    token_color="$YELLOW"
else
    token_color="$RED"
fi

size_fmt=$(fmt_tokens $context_size)
tokens="${token_color}${usage_pct}% (${current_fmt}/${size_fmt})${RESET}"

# --- DIRECTORY NAME ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$cwd")

# Create clickable link to open Cursor (uses custom URL handler for proper window management)
cursor_url="open-cursor://${cwd}"
linked_dir="${OSC_START}${cursor_url}${OSC_END}${dir_name}${OSC_START}${OSC_END}"

# --- GIT INFO ---
# Read branch from .git/HEAD directly - no lock needed
# Supports both regular repos (.git is a dir) and worktrees (.git is a file)
git_info=""
branch=""
git_dot="$cwd/.git"
if [ -d "$git_dot" ]; then
    head_file="$git_dot/HEAD"
elif [ -f "$git_dot" ]; then
    # Worktree: .git is a file containing "gitdir: /path/to/.git/worktrees/name"
    gitdir=$(sed 's/^gitdir: //' "$git_dot")
    # Resolve relative paths
    [[ "$gitdir" != /* ]] && gitdir="$cwd/$gitdir"
    head_file="$gitdir/HEAD"
fi
if [ -n "${head_file:-}" ] && [ -f "$head_file" ]; then
    head_content=$(cat "$head_file")
    if [[ "$head_content" == ref:* ]]; then
        branch="${head_content#ref: refs/heads/}"
        git_info=" ${YELLOW}(${branch})${RESET}"
    fi
fi

# --- PR INFO ---
pr_info=""
if [ -n "${branch:-}" ] && command -v gh >/dev/null 2>&1; then
    cache_hash=$(echo -n "${cwd%/}" | shasum | cut -c1-12)
    cache_file="/tmp/claude-statusline-pr-${cache_hash}.json"
    lock_dir="/tmp/claude-statusline-pr-${cache_hash}.lock"
    refresh_script="$HOME/.claude/hooks/statusline/pr-cache-refresh.sh"

    trigger_refresh() {
        "$refresh_script" "$cwd" "$branch" "$cache_file" "$lock_dir" &
        disown 2>/dev/null
    }

    if [ -f "$cache_file" ]; then
        read -r has_pr pr_num pr_url merge_emoji unreplied approvals changes_req total_rev cached_branch cached_ts \
            < <(jq -r '[
                (.has_pr // false),
                (.pr_number // 0),
                (.pr_url // ""),
                (.merge_emoji // ""),
                (.unreplied // 0),
                (.approvals // 0),
                (.changes_requested // 0),
                (.total_reviewers // 0),
                (.branch // ""),
                (.timestamp // 0)
            ] | @tsv' "$cache_file" 2>/dev/null) || true

        now=$(date +%s)
        age=$((now - ${cached_ts:-0}))

        if [ "${cached_branch:-}" = "$branch" ]; then
            if [ "$has_pr" = "true" ]; then
                linked_pr="${OSC_START}${pr_url}${OSC_END}#${pr_num}${OSC_START}${OSC_END}"
                pr_info=" | ${linked_pr} ${merge_emoji}"

                if [ "${unreplied:-0}" -gt 0 ] 2>/dev/null; then
                    pr_info="${pr_info} ${YELLOW}💬${unreplied}${RESET}"
                else
                    pr_info="${pr_info} 💬0"
                fi

                if [ "${total_rev:-0}" -gt 0 ] 2>/dev/null; then
                    if [ "${changes_req:-0}" -gt 0 ] 2>/dev/null; then
                        pr_info="${pr_info} ${RED}👀${approvals}✓${changes_req}✗/${total_rev}${RESET}"
                    elif [ "$approvals" -eq "$total_rev" ] 2>/dev/null; then
                        pr_info="${pr_info} ${GREEN}👀${approvals}/${total_rev}${RESET}"
                    else
                        pr_info="${pr_info} ${YELLOW}👀${approvals}/${total_rev}${RESET}"
                    fi
                fi
            fi

            # Refresh if stale (>30s)
            if [ "$age" -gt 30 ]; then
                trigger_refresh
            fi
        else
            # Branch changed - show nothing, trigger refresh
            trigger_refresh
        fi
    else
        # No cache yet - trigger first refresh
        trigger_refresh
    fi
fi

# --- MODEL ---
model_name=$(echo "$input" | jq -r '.model.display_name')

# --- OUTPUT ---
printf "%s | %s%s%s\n%s" "$tokens" "$linked_dir" "$git_info" "$pr_info" "$model_name"
