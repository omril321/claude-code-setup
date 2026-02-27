#!/bin/bash
# PR Cache Refresh - runs in background, fetches PR data from GitHub
# Args: $1=cwd $2=branch $3=cache_file $4=lock_dir

set -euo pipefail

# Use timeout if available, otherwise run without it
if command -v timeout >/dev/null 2>&1; then
    run() { timeout 15 "$@"; }
else
    run() { "$@"; }
fi

# Bot reviewer logins to exclude from review counts
BOT_LOGINS="qodo-sts|dependabot|renovate|github-actions"

cwd="$1"
branch="$2"
cache_file="$3"
lock_dir="$4"

# Redirect all output to prevent leaking into statusline
exec >/dev/null 2>&1

# Clean stale locks (>60s old, handles crashed processes)
if [ -d "$lock_dir" ]; then
    lock_age=$(( $(date +%s) - $(stat -f %m "$lock_dir" 2>/dev/null || echo 0) ))
    if [ "$lock_age" -gt 60 ]; then
        rmdir "$lock_dir" 2>/dev/null || true
    fi
fi

# Acquire lock (atomic mkdir)
if ! mkdir "$lock_dir" 2>/dev/null; then
    exit 0
fi
trap 'rmdir "$lock_dir" 2>/dev/null' EXIT

cd "$cwd"

now=$(date +%s)

write_no_pr() {
    jq -n --arg branch "$branch" --argjson ts "$now" \
        '{branch: $branch, has_pr: false, timestamp: $ts}' \
        > "${cache_file}.tmp"
    mv "${cache_file}.tmp" "$cache_file"
}

# Ensure gh username is cached
gh_user_file="$HOME/.claude/hooks/statusline/.gh-user"
if [ ! -f "$gh_user_file" ]; then
    gh_user=$(run gh api user --jq '.login' 2>/dev/null) || exit 0
    [ -z "$gh_user" ] && exit 0
    echo "$gh_user" > "$gh_user_file"
else
    gh_user=$(cat "$gh_user_file")
fi

# Fetch PR data
pr_json=$(run gh pr view --json number,url,state,mergeStateStatus,isDraft,latestReviews,reviewRequests 2>/dev/null) || {
    write_no_pr
    exit 0
}

# Extract fields
pr_number=$(echo "$pr_json" | jq -r '.number')
pr_url=$(echo "$pr_json" | jq -r '.url')
pr_state=$(echo "$pr_json" | jq -r '.state')
is_draft=$(echo "$pr_json" | jq -r '.isDraft')
merge_state=$(echo "$pr_json" | jq -r '.mergeStateStatus')

# Status emoji
if [ "$pr_state" = "MERGED" ]; then
    merge_emoji="🗑️"
elif [ "$pr_state" = "CLOSED" ]; then
    merge_emoji="🚫"
elif [ "$is_draft" = "true" ]; then
    merge_emoji="📝"
else
    case "$merge_state" in
        CLEAN)   merge_emoji="✅" ;;
        BLOCKED) merge_emoji="❌" ;;
        DIRTY)   merge_emoji="❌" ;;
        BEHIND)  merge_emoji="🔄" ;;
        *)       merge_emoji="🔄" ;;
    esac
fi

# Review counts (filter bots and teams)
read -r approvals changes_requested total_reviewers < <(echo "$pr_json" | jq -r \
    --arg bots "$BOT_LOGINS" '
    ($bots | split("|")) as $bot_list |
    [.latestReviews // [] | .[] |
        select(.author.login as $l |
            ($bot_list | index($l) | not) and
            ($l | test("\\[bot\\]$") | not)
        )
    ] as $human_reviews |
    ([$human_reviews[] | select(.state == "APPROVED")] | length) as $app |
    ([$human_reviews[] | select(.state == "CHANGES_REQUESTED")] | length) as $cr |
    (([$human_reviews[].author.login] | unique | length) +
     ([.reviewRequests // [] | .[] | select(.__typename == "User")] | length)) as $total |
    "\($app) \($cr) \($total)"
')

# Unreplied inline review comment threads
comments_json=$(run gh api "repos/{owner}/{repo}/pulls/${pr_number}/comments?per_page=100" \
    --paginate --jq '.' 2>/dev/null) || comments_json="[]"

unreplied=$(echo "$comments_json" | jq -s --arg me "$gh_user" '
    flatten |
    [.[] | select(.user.type != "Bot")] |
    if length == 0 then 0
    else
        group_by(.in_reply_to_id // .id) |
        map(sort_by(.id) | last) |
        [.[] | select(.user.login != $me)] |
        length
    end
')

# Write cache atomically
jq -n \
    --arg branch "$branch" \
    --argjson has_pr true \
    --argjson pr_number "$pr_number" \
    --arg pr_url "$pr_url" \
    --arg merge_emoji "$merge_emoji" \
    --argjson unreplied "${unreplied:-0}" \
    --argjson approvals "${approvals:-0}" \
    --argjson changes_requested "${changes_requested:-0}" \
    --argjson total_reviewers "${total_reviewers:-0}" \
    --argjson timestamp "$now" \
    '{
        branch: $branch,
        has_pr: $has_pr,
        pr_number: $pr_number,
        pr_url: $pr_url,
        merge_emoji: $merge_emoji,
        unreplied: $unreplied,
        approvals: $approvals,
        changes_requested: $changes_requested,
        total_reviewers: $total_reviewers,
        timestamp: $timestamp
    }' > "${cache_file}.tmp"

mv "${cache_file}.tmp" "$cache_file"
