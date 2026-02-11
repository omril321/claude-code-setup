#!/bin/bash
set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
INSTALL_GEMINI=""
INSTALL_ALL=""
UNINSTALL=""

# ─── Colors ──────────────────────────────────────────────────────────────────
info()    { printf '\033[1;34m[INFO]\033[0m %s\n' "$1"; }
success() { printf '\033[1;32m[ OK ]\033[0m %s\n' "$1"; }
skip()    { printf '\033[1;33m[SKIP]\033[0m %s\n' "$1"; }
error()   { printf '\033[1;31m[ERR ]\033[0m %s\n' "$1" >&2; }

# ─── Parse args ──────────────────────────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --all)         INSTALL_ALL="yes"; INSTALL_GEMINI="${INSTALL_GEMINI:-yes}" ;;
        --with-gemini) INSTALL_GEMINI="yes" ;;
        --no-gemini)   INSTALL_GEMINI="no" ;;
        --uninstall)   UNINSTALL="yes" ;;
        --help|-h)
            cat <<EOF
Usage: setup.sh [OPTIONS]

Install Claude Code skills, commands, and hooks into ~/.claude/

Options:
  --all           Install everything non-interactively
  --with-gemini   Install the gemini-image script (no prompt)
  --no-gemini     Skip the gemini-image script (no prompt)
  --uninstall     Remove previously installed items
  -h, --help      Show this help message

Interactive mode (default):
  Each section shows a checkbox list. Use:
    up/down    Navigate items
    space      Toggle item on/off
    a          Select all
    n          Deselect all
    enter      Confirm selection
EOF
            exit 0
            ;;
        *)
            error "Unknown option: $arg"
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# ─── Prerequisites ───────────────────────────────────────────────────────────
if [[ ! -d "$CLAUDE_DIR" ]]; then
    error "$CLAUDE_DIR does not exist. Please run Claude Code at least once first."
    exit 1
fi

if ! command -v jq &>/dev/null; then
    error "jq is required but not installed. Install it with: brew install jq"
    exit 1
fi

echo ""

# ─── Checkbox menu ───────────────────────────────────────────────────────────
# Reads from global arrays: _sel_names[@] and _sel_existing[@]
# Sets SELECTED_INDICES to the array of chosen indices (0-based)
#
# Usage: checkbox_menu <section> [uninstall]
#   install (default): new items are selectable, existing items are dimmed
#   uninstall:         existing items are selectable, missing items are dimmed
checkbox_menu() {
    local section="$1"
    local mode="${2:-install}"
    SELECTED_INDICES=()

    local count=${#_sel_names[@]}
    local cursor=0
    local checked=()
    local available=()
    local first_available=-1

    # Labels and colors differ by mode
    local dimmed_label="already installed"
    local empty_msg="All $(echo "$section" | tr '[:upper:]' '[:lower:]') already installed."
    local batch_msg="Installing all (--all)"
    local batch_color="\033[1;32m"  # green
    if [[ "$mode" == "uninstall" ]]; then
        dimmed_label="not installed"
        empty_msg="No $(echo "$section" | tr '[:upper:]' '[:lower:]') to uninstall."
        batch_msg="Removing all (--all)"
        batch_color="\033[1;31m"  # red
    fi

    # Initialize state — available items depend on mode
    for i in $(seq 0 $((count - 1))); do
        local is_existing="${_sel_existing[$i]}"
        local is_available="no"
        if [[ "$mode" == "uninstall" && "$is_existing" == "yes" ]] \
        || [[ "$mode" == "install"   && "$is_existing" == "no"  ]]; then
            is_available="yes"
        fi

        if [[ "$is_available" == "yes" ]]; then
            checked+=("yes")
            available+=("yes")
            if [[ $first_available -eq -1 ]]; then
                first_available=$i
            fi
        else
            checked+=("no")
            available+=("no")
        fi
    done

    echo ""
    echo "─── $section ────────────────────────────────────────"

    # Nothing actionable
    if [[ $first_available -eq -1 ]]; then
        echo ""
        for i in $(seq 0 $((count - 1))); do
            printf "  \033[2m   %s (%s)\033[0m\n" "${_sel_names[$i]}" "$dimmed_label"
        done
        echo ""
        info "$empty_msg"
        return
    fi

    cursor=$first_available

    # Non-interactive mode
    if [[ "$INSTALL_ALL" == "yes" ]]; then
        echo ""
        for i in $(seq 0 $((count - 1))); do
            if [[ "${available[$i]}" == "yes" ]]; then
                printf "  ${batch_color}[x]\033[0m %s\n" "${_sel_names[$i]}"
                SELECTED_INDICES+=("$i")
            else
                printf "  \033[2m   %s (%s)\033[0m\n" "${_sel_names[$i]}" "$dimmed_label"
            fi
        done
        echo ""
        info "$batch_msg"
        return
    fi

    # ── Render function ──
    local rendered_lines=$((count + 1))  # items + hint line

    render_menu() {
        local is_redraw="$1"

        # Move cursor up to overwrite previous render
        if [[ "$is_redraw" == "yes" ]]; then
            printf '\033[%dA' "$rendered_lines"
        fi

        for i in $(seq 0 $((count - 1))); do
            printf '\033[2K'  # clear line
            if [[ "${available[$i]}" == "no" ]]; then
                printf "  \033[2m   %s (%s)\033[0m\n" "${_sel_names[$i]}" "$dimmed_label"
            else
                local marker="  "
                local color_start=""
                local color_end=""
                if [[ $i -eq $cursor ]]; then
                    marker="❯ "
                    color_start="\033[1;36m"
                    color_end="\033[0m"
                fi

                local box="[ ]"
                if [[ "${checked[$i]}" == "yes" ]]; then
                    box="[x]"
                fi

                printf "${color_start}${marker}${box} %s${color_end}\n" "${_sel_names[$i]}"
            fi
        done

        # Hint line
        printf '\033[2K'
        printf "  \033[2m↑↓ move  space toggle  a all  n none  enter confirm\033[0m\n"
    }

    # Initial render
    echo ""
    render_menu "no"

    # Hide cursor
    tput civis 2>/dev/null || true
    # Ensure cursor is restored on exit/interrupt
    trap 'tput cnorm 2>/dev/null || true' RETURN

    # ── Input loop ──
    while true; do
        IFS= read -rsn1 key

        case "$key" in
            $'\x1b')
                # Read rest of escape sequence with timeout
                local seq=""
                IFS= read -rsn2 -t 1 seq 2>/dev/null || true
                case "$seq" in
                    '[A')  # Up arrow — find previous available
                        local new=$cursor
                        local i=$((cursor - 1))
                        while [[ $i -ge 0 ]]; do
                            if [[ "${available[$i]}" == "yes" ]]; then
                                new=$i
                                break
                            fi
                            i=$((i - 1))
                        done
                        cursor=$new
                        ;;
                    '[B')  # Down arrow — find next available
                        local new=$cursor
                        local i=$((cursor + 1))
                        while [[ $i -lt $count ]]; do
                            if [[ "${available[$i]}" == "yes" ]]; then
                                new=$i
                                break
                            fi
                            i=$((i + 1))
                        done
                        cursor=$new
                        ;;
                esac
                render_menu "yes"
                ;;
            ' ')  # Space — toggle current item
                if [[ "${checked[$cursor]}" == "yes" ]]; then
                    checked[$cursor]="no"
                else
                    checked[$cursor]="yes"
                fi
                render_menu "yes"
                ;;
            'a'|'A')  # Select all
                for i in $(seq 0 $((count - 1))); do
                    if [[ "${available[$i]}" == "yes" ]]; then
                        checked[$i]="yes"
                    fi
                done
                render_menu "yes"
                ;;
            'n'|'N')  # Deselect all
                for i in $(seq 0 $((count - 1))); do
                    if [[ "${available[$i]}" == "yes" ]]; then
                        checked[$i]="no"
                    fi
                done
                render_menu "yes"
                ;;
            '')  # Enter — confirm
                break
                ;;
        esac
    done

    # Restore cursor
    tput cnorm 2>/dev/null || true

    # Collect selected indices
    for i in $(seq 0 $((count - 1))); do
        if [[ "${checked[$i]}" == "yes" ]]; then
            SELECTED_INDICES+=("$i")
        fi
    done
}

# ─── Uninstall mode ─────────────────────────────────────────────────────────
if [[ "$UNINSTALL" == "yes" ]]; then
    info "Uninstalling Claude Code setup"
    removed=()

    # ── Skills ──
    _sel_names=()
    _sel_existing=()
    for skill_dir in "$REPO_DIR"/skills/*/; do
        name="$(basename "$skill_dir")"
        _sel_names+=("$name")
        target="$CLAUDE_DIR/skills/$name"
        if [[ -d "$target" || -L "$target" ]]; then
            _sel_existing+=("yes")
        else
            _sel_existing+=("no")
        fi
    done

    checkbox_menu "Skills" "uninstall"

    if [[ ${#SELECTED_INDICES[@]} -gt 0 ]]; then
        echo ""
        for idx in "${SELECTED_INDICES[@]}"; do
            rm -rf "$CLAUDE_DIR/skills/${_sel_names[$idx]}"
            success "Removed skill: ${_sel_names[$idx]}"
            removed+=("skill:${_sel_names[$idx]}")
        done
    fi

    # ── Commands ──
    _sel_names=()
    _sel_existing=()
    for cmd_file in "$REPO_DIR"/commands/*.md; do
        name="$(basename "$cmd_file" .md)"
        _sel_names+=("$name")
        target="$CLAUDE_DIR/commands/$(basename "$cmd_file")"
        if [[ -f "$target" ]]; then
            _sel_existing+=("yes")
        else
            _sel_existing+=("no")
        fi
    done

    checkbox_menu "Commands" "uninstall"

    if [[ ${#SELECTED_INDICES[@]} -gt 0 ]]; then
        echo ""
        for idx in "${SELECTED_INDICES[@]}"; do
            rm -f "$CLAUDE_DIR/commands/${_sel_names[$idx]}.md"
            success "Removed command: ${_sel_names[$idx]}"
            removed+=("command:${_sel_names[$idx]}")
        done
    fi

    # ── Hooks ──
    _sel_names=()
    _sel_existing=()
    for hook_file in "$REPO_DIR"/hooks/*.sh; do
        name="$(basename "$hook_file")"
        _sel_names+=("$name")
        target="$CLAUDE_DIR/hooks/$name"
        if [[ -f "$target" ]]; then
            _sel_existing+=("yes")
        else
            _sel_existing+=("no")
        fi
    done

    checkbox_menu "Hooks" "uninstall"

    if [[ ${#SELECTED_INDICES[@]} -gt 0 ]]; then
        echo ""
        for idx in "${SELECTED_INDICES[@]}"; do
            rm -f "$CLAUDE_DIR/hooks/${_sel_names[$idx]}"
            success "Removed hook: ${_sel_names[$idx]}"
            removed+=("hook:${_sel_names[$idx]}")
        done
    fi

    # ── Settings: SessionStart hooks ──
    echo ""
    echo "─── Settings ─────────────────────────────────────────"
    echo ""
    settings_file="$CLAUDE_DIR/settings.json"

    has_session_start=$(jq -e '.hooks.SessionStart // empty | length > 0' "$settings_file" >/dev/null 2>&1 && echo "yes" || echo "no")

    if [[ "$has_session_start" == "no" ]]; then
        skip "settings.json: No SessionStart hooks to remove"
    else
        remove_hooks="yes"

        if [[ "$INSTALL_ALL" != "yes" ]]; then
            printf '\033[1;34m  >\033[0m Remove SessionStart hooks from settings.json? (\033[1mY\033[0m/n): '
            read -r answer
            case "$answer" in
                [nN]|[nN][oO]) remove_hooks="no" ;;
                *) remove_hooks="yes" ;;
            esac
        fi

        if [[ "$remove_hooks" == "yes" ]]; then
            cp "$settings_file" "$settings_file.backup"
            info "Backed up settings.json to settings.json.backup"

            tmp_file=$(mktemp)
            jq 'del(.hooks.SessionStart)' "$settings_file" > "$tmp_file"
            mv "$tmp_file" "$settings_file"

            success "settings.json: Removed SessionStart hooks"
            removed+=("settings:SessionStart")
        else
            skip "settings.json: SessionStart hooks (kept)"
        fi
    fi

    # ── Scripts: gemini-image ──
    echo ""
    echo "─── Scripts ──────────────────────────────────────────"
    echo ""
    gemini_target="$HOME/scripts/gemini-image"

    if [[ ! -f "$gemini_target" ]]; then
        skip "gemini-image (not installed)"
    else
        remove_gemini="yes"

        if [[ "$INSTALL_ALL" != "yes" ]]; then
            printf '\033[1;34m  >\033[0m Remove gemini-image from ~/scripts/? (y/\033[1mN\033[0m): '
            read -r answer
            case "$answer" in
                [yY]|[yY][eE][sS]) remove_gemini="yes" ;;
                *) remove_gemini="no" ;;
            esac
        fi

        if [[ "$remove_gemini" == "yes" ]]; then
            rm -f "$gemini_target"
            success "Removed gemini-image from $gemini_target"
            removed+=("script:gemini-image")
        else
            skip "gemini-image (kept)"
        fi
    fi

    # ── Summary ──
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [[ ${#removed[@]} -gt 0 ]]; then
        success "Removed ${#removed[@]} item(s): ${removed[*]}"
    else
        info "Nothing to remove."
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 0
fi

info "Installing Claude Code setup from $REPO_DIR"

# ─── Tracking ────────────────────────────────────────────────────────────────
installed=()
skipped=()

# ─── Collect skills ──────────────────────────────────────────────────────────
_sel_names=()
skill_dirs=()
_sel_existing=()

for skill_dir in "$REPO_DIR"/skills/*/; do
    name="$(basename "$skill_dir")"
    _sel_names+=("$name")
    skill_dirs+=("$skill_dir")
    target="$CLAUDE_DIR/skills/$name"
    if [[ -d "$target" || -L "$target" ]]; then
        _sel_existing+=("yes")
    else
        _sel_existing+=("no")
    fi
done

checkbox_menu "Skills"

if [[ ${#SELECTED_INDICES[@]} -gt 0 ]]; then
    mkdir -p "$CLAUDE_DIR/skills"
    echo ""
    for idx in "${SELECTED_INDICES[@]}"; do
        cp -R "${skill_dirs[$idx]}" "$CLAUDE_DIR/skills/${_sel_names[$idx]}"
        success "Skill: ${_sel_names[$idx]}"
        installed+=("skill:${_sel_names[$idx]}")
    done
fi

for i in $(seq 0 $((${#_sel_names[@]} - 1))); do
    if [[ "${_sel_existing[$i]}" == "yes" ]]; then
        skipped+=("skill:${_sel_names[$i]}")
    fi
done

# ─── Collect commands ────────────────────────────────────────────────────────
_sel_names=()
cmd_files=()
_sel_existing=()

for cmd_file in "$REPO_DIR"/commands/*.md; do
    name="$(basename "$cmd_file" .md)"
    _sel_names+=("$name")
    cmd_files+=("$cmd_file")
    target="$CLAUDE_DIR/commands/$(basename "$cmd_file")"
    if [[ -f "$target" ]]; then
        _sel_existing+=("yes")
    else
        _sel_existing+=("no")
    fi
done

checkbox_menu "Commands"

if [[ ${#SELECTED_INDICES[@]} -gt 0 ]]; then
    mkdir -p "$CLAUDE_DIR/commands"
    echo ""
    for idx in "${SELECTED_INDICES[@]}"; do
        cp "${cmd_files[$idx]}" "$CLAUDE_DIR/commands/$(basename "${cmd_files[$idx]}")"
        success "Command: ${_sel_names[$idx]}"
        installed+=("command:${_sel_names[$idx]}")
    done
fi

for i in $(seq 0 $((${#_sel_names[@]} - 1))); do
    if [[ "${_sel_existing[$i]}" == "yes" ]]; then
        skipped+=("command:${_sel_names[$i]}")
    fi
done

# ─── Collect hooks ───────────────────────────────────────────────────────────
_sel_names=()
hook_files=()
_sel_existing=()

for hook_file in "$REPO_DIR"/hooks/*.sh; do
    name="$(basename "$hook_file")"
    _sel_names+=("$name")
    hook_files+=("$hook_file")
    target="$CLAUDE_DIR/hooks/$name"
    if [[ -f "$target" ]]; then
        _sel_existing+=("yes")
    else
        _sel_existing+=("no")
    fi
done

checkbox_menu "Hooks"

if [[ ${#SELECTED_INDICES[@]} -gt 0 ]]; then
    mkdir -p "$CLAUDE_DIR/hooks"
    echo ""
    for idx in "${SELECTED_INDICES[@]}"; do
        cp "${hook_files[$idx]}" "$CLAUDE_DIR/hooks/${_sel_names[$idx]}"
        chmod +x "$CLAUDE_DIR/hooks/${_sel_names[$idx]}"
        success "Hook: ${_sel_names[$idx]}"
        installed+=("hook:${_sel_names[$idx]}")
    done
fi

for i in $(seq 0 $((${#_sel_names[@]} - 1))); do
    if [[ "${_sel_existing[$i]}" == "yes" ]]; then
        skipped+=("hook:${_sel_names[$i]}")
    fi
done

# ─── Configure settings.json ─────────────────────────────────────────────────
echo ""
echo "─── Settings ─────────────────────────────────────────"
echo ""
settings_file="$CLAUDE_DIR/settings.json"

if [[ ! -f "$settings_file" ]]; then
    echo '{}' > "$settings_file"
fi

has_session_start=$(jq -e '.hooks.SessionStart // empty | length > 0' "$settings_file" >/dev/null 2>&1 && echo "yes" || echo "no")

if [[ "$has_session_start" == "yes" ]]; then
    skip "settings.json: SessionStart hooks already configured"
    skipped+=("settings:SessionStart")
else
    register_hooks="yes"

    if [[ "$INSTALL_ALL" != "yes" ]]; then
        printf '\033[1;34m  >\033[0m Register SessionStart hooks in settings.json? (\033[1mY\033[0m/n): '
        read -r answer
        case "$answer" in
            [nN]|[nN][oO]) register_hooks="no" ;;
            *) register_hooks="yes" ;;
        esac
    fi

    if [[ "$register_hooks" == "yes" ]]; then
        cp "$settings_file" "$settings_file.backup"
        info "Backed up settings.json to settings.json.backup"

        tmp_file=$(mktemp)
        jq '.hooks.SessionStart = [
            {
                "matcher": "",
                "hooks": [
                    {"type": "command", "command": "~/.claude/hooks/show-session-tips.sh"},
                    {"type": "command", "command": "~/.claude/hooks/check-context-freshness.sh"}
                ]
            }
        ]' "$settings_file" > "$tmp_file"
        mv "$tmp_file" "$settings_file"

        success "settings.json: Added SessionStart hooks"
        installed+=("settings:SessionStart")
    else
        skip "settings.json: SessionStart hooks (not requested)"
    fi
fi

# ─── Optional: gemini-image script ───────────────────────────────────────────
echo ""
echo "─── Scripts ──────────────────────────────────────────"
echo ""

gemini_target="$HOME/scripts/gemini-image"

if [[ -f "$gemini_target" ]]; then
    skip "gemini-image (already exists at $gemini_target)"
    skipped+=("script:gemini-image")
else
    if [[ -z "$INSTALL_GEMINI" ]]; then
        printf '\033[1;34m  >\033[0m Install gemini-image script to ~/scripts/? (y/\033[1mN\033[0m): '
        read -r answer
        case "$answer" in
            [yY]|[yY][eE][sS]) INSTALL_GEMINI="yes" ;;
            *) INSTALL_GEMINI="no" ;;
        esac
    fi

    if [[ "$INSTALL_GEMINI" == "yes" ]]; then
        mkdir -p "$HOME/scripts"
        cp "$REPO_DIR/scripts/gemini-image" "$gemini_target"
        chmod +x "$gemini_target"
        success "gemini-image installed to $gemini_target"
        installed+=("script:gemini-image")

        if [[ -z "${GEMINI_API_KEY:-}" ]]; then
            echo ""
            info "Note: GEMINI_API_KEY is not set. Set it in your shell profile:"
            echo "  export GEMINI_API_KEY=\"your-api-key-here\""
        fi
        if ! echo "$PATH" | tr ':' '\n' | grep -qx "$HOME/scripts"; then
            echo ""
            info "Note: ~/scripts is not in your PATH. Add it to your shell profile:"
            echo "  export PATH=\"\$HOME/scripts:\$PATH\""
        fi
    else
        skip "gemini-image (not requested)"
    fi
fi

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ ${#installed[@]} -gt 0 ]]; then
    success "Installed ${#installed[@]} item(s): ${installed[*]}"
else
    info "Nothing new to install."
fi
if [[ ${#skipped[@]} -gt 0 ]]; then
    skip "Skipped ${#skipped[@]} item(s) (already present)"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
