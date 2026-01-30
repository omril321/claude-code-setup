# Browser MCP Guidelines

## Overview

Browser MCP connects to **existing browser sessions**, allowing interaction with tabs the user already has open, including logged-in state and cookies.

## When to Use

- User is already viewing a page and wants you to see it
- Page requires authentication/login
- Quick visual inspection needed
- Need to interact with user's current tab

## Available Tools

| Tool | Purpose |
|------|---------|
| `browser_navigate` | Navigate to a URL |
| `browser_go_back` / `browser_go_forward` | Browser history navigation |
| `browser_snapshot` | Get accessibility tree of page (preferred over screenshot) |
| `browser_click` | Click on elements |
| `browser_hover` | Hover over elements |
| `browser_type` | Type into input fields |
| `browser_select_option` | Select dropdown options |
| `browser_press_key` | Press keyboard keys |
| `browser_screenshot` | Capture visual screenshot |
| `browser_get_console_logs` | Get console output |
| `browser_wait` | Wait for specified time |

## Common Workflow

```
1. browser_snapshot     → Get page structure (use refs from snapshot)
2. browser_click/type   → Interact with elements using refs
3. browser_snapshot     → Verify result
```

## Key Points

- **Always use snapshot first** to get element references (`ref` parameter)
- Snapshot provides accessibility tree - more reliable than visual matching
- Element refs like `ref="button[Submit]"` come from the snapshot
- Use `element` parameter for human-readable description (for permissions)

## Limitations

- No network request inspection
- No performance tracing
- No JavaScript evaluation in page context
- No CPU/network emulation
- Console logs are basic (no filtering by type)

## Example Usage

```
# See what's on the page
→ browser_snapshot

# Click a button (using ref from snapshot)
→ browser_click(element="Submit button", ref="button[Submit]")

# Fill a form
→ browser_type(element="Email input", ref="textbox[Email]", text="user@example.com", submit=false)
```
