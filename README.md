# Claude Code Setup

A curated public subset of my personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration.

This repository contains skills, commands, and hooks that I've developed for my Claude Code workflow. I'm sharing them in case they're useful to others.

## What's Included

### Skills

Skills are reusable technique references and process documentation for Claude Code.

| Skill | Description |
|-------|-------------|
| **thorough-planning** | Planning methodology with mandatory success criteria and feedback loops |
| **systematic-debugging** | Hypothesis-driven debugging framework |
| **writing-skills** | Test-driven development approach for creating skills |
| **context-suggest** | Discovers relevant skills, agents, commands, and MCP tools |
| **finding-online-references** | Parallel search agents for GitHub and web research |
| **slidev** | Story-driven technical presentations using Slidev |
| **browser-inspection** | Decision framework for Browser MCP vs DevTools MCP |
| **generate-image** | Image generation using Google's Gemini API |

### Commands

Commands are execution templates invoked with `/command-name`.

| Command | Description |
|---------|-------------|
| **/create-skill** | Guide for creating new skills using TDD methodology |
| **/create-hook** | Analyze project and suggest practical hooks |
| **/handoff-prompt** | Create comprehensive session handoff documents |
| **/refresh-context** | Validate and update project Claude artifacts |

### Hooks

Hooks are shell scripts triggered at specific Claude Code lifecycle events.

| Hook | Event | Description |
|------|-------|-------------|
| **show-session-tips.sh** | SessionStart | Display helpful tips when sessions start |
| **check-context-freshness.sh** | SessionStart | Warn if project context is stale |

### Scripts

| Script | Description |
|--------|-------------|
| **gemini-image** | CLI tool for generating images via Google Gemini API |

## Installation

Copy the directories you want into your `~/.claude/` directory:

```bash
# Clone this repo
git clone https://github.com/omril321/claude-code-setup.git

# Copy skills
cp -R claude-code-setup/skills/* ~/.claude/skills/

# Copy commands
cp -R claude-code-setup/commands/* ~/.claude/commands/

# Copy hooks
cp -R claude-code-setup/hooks/* ~/.claude/hooks/

# Copy scripts (optional - for generate-image skill)
mkdir -p ~/scripts
cp claude-code-setup/scripts/gemini-image ~/scripts/
chmod +x ~/scripts/gemini-image
```

### For the gemini-image script

Set your Gemini API key as an environment variable:

```bash
export GEMINI_API_KEY="your-api-key-here"
```

## About This Repository

This is a **public subset** of my real Claude Code setup. I maintain a more extensive private configuration that includes work-specific tools and personal preferences.

I'll keep this repository updated as I can, or by request.

## Contact

Feel free to reach out:

- GitHub: [@omril321](https://github.com/omril321)
- Open an issue in this repository

## License

MIT License - feel free to use, modify, and share.
