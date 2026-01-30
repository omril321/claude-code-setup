#!/bin/bash
# Context Freshness Checker
# Usage:
#   --check (default): Check if context is stale and show warning
#   --mark: Update timestamp for current project
#   --blacklist: Add current project to blacklist (won't show warnings)

CONFIG_FILE="$HOME/.claude/project-config-updates.json"
PROJECT_PATH="$(pwd)"
STALE_DAYS=14

# Initialize config if doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo '{}' > "$CONFIG_FILE"
fi

# Check if current project is blacklisted
is_blacklisted() {
    jq -e --arg path "$PROJECT_PATH" '.blacklist // [] | index($path) != null' "$CONFIG_FILE" > /dev/null 2>&1
}

case "${1:---check}" in
    --blacklist)
        # Add current project to blacklist
        if is_blacklisted; then
            echo -e "\033[1;33m⚠ Project already blacklisted: $PROJECT_PATH\033[0m"
        else
            jq --arg path "$PROJECT_PATH" \
               '.blacklist = ((.blacklist // []) + [$path])' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && \
               mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
            echo -e "\033[1;32m✓ Project blacklisted from context warnings: $PROJECT_PATH\033[0m"
        fi
        ;;
    --mark)
        # Update timestamp for current project
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        # Use jq to update the JSON
        jq --arg path "$PROJECT_PATH" --arg ts "$TIMESTAMP" \
           '.[$path] = $ts' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && \
           mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        echo -e "\033[1;32m✓ Context marked as refreshed for: $PROJECT_PATH\033[0m"
        ;;
    --check)
        # Skip if project is blacklisted
        if is_blacklisted; then
            exit 0
        fi

        # Read last refresh timestamp for this project
        LAST_REFRESH=$(jq -r --arg path "$PROJECT_PATH" '.[$path] // empty' "$CONFIG_FILE")

        show_hint() {
            echo -e "\033[90m(Run ~/.claude/hooks/check-context-freshness.sh --blacklist to disable for this project)\033[0m"
        }

        if [[ -z "$LAST_REFRESH" ]]; then
            # Never refreshed
            echo -e "\033[1;31m╔════════════════════════════════════════════════════════════╗\033[0m"
            echo -e "\033[1;31m║  ⚠️  PROJECT CONTEXT NEVER REFRESHED                        ║\033[0m"
            echo -e "\033[1;31m║                                                            ║\033[0m"
            echo -e "\033[1;31m║  Run \033[1;33m/refresh-context\033[1;31m to validate and update context     ║\033[0m"
            echo -e "\033[1;31m╚════════════════════════════════════════════════════════════╝\033[0m"
            show_hint
        else
            # Calculate days since last refresh
            LAST_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_REFRESH" +%s 2>/dev/null || \
                         date -d "$LAST_REFRESH" +%s 2>/dev/null)
            NOW_EPOCH=$(date +%s)
            DAYS_AGO=$(( (NOW_EPOCH - LAST_EPOCH) / 86400 ))

            if [[ $DAYS_AGO -ge $STALE_DAYS ]]; then
                echo -e "\033[1;31m╔════════════════════════════════════════════════════════════╗\033[0m"
                printf "\033[1;31m║  ⚠️  PROJECT CONTEXT OUTDATED (%-3d days ago)               ║\033[0m\n" "$DAYS_AGO"
                echo -e "\033[1;31m║                                                            ║\033[0m"
                echo -e "\033[1;31m║  Run \033[1;33m/refresh-context\033[1;31m to validate and update context     ║\033[0m"
                echo -e "\033[1;31m╚════════════════════════════════════════════════════════════╝\033[0m"
                show_hint
            fi
            # If not stale, output nothing (no message needed)
        fi
        ;;
esac
