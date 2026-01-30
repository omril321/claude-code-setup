# DevTools MCP Guidelines

## Overview

DevTools MCP provides **powerful debugging tools** but opens new browser sessions without existing login/cookies. Best for debugging, performance analysis, and testing in clean state.

## When to Use

- Debugging console errors (with filtering)
- Inspecting network requests/responses
- Performance profiling
- Testing in a clean session (no cookies/auth)
- Need to evaluate JavaScript in page
- Need to emulate conditions (slow network, geolocation)

## Available Tools by Category

### Page Management
| Tool | Purpose |
|------|---------|
| `list_pages` | List all open pages |
| `select_page` | Switch to a specific page |
| `new_page` | Open a new page with URL |
| `close_page` | Close a page |
| `navigate_page` | Navigate/reload current page |
| `resize_page` | Change page dimensions |

### Inspection
| Tool | Purpose |
|------|---------|
| `take_snapshot` | Get accessibility tree (use `uid` for elements) |
| `take_screenshot` | Capture visual screenshot |
| `list_console_messages` | List console logs (can filter by type) |
| `get_console_message` | Get specific console message details |
| `list_network_requests` | List network requests (can filter by type) |
| `get_network_request` | Get request/response details |

### Interaction
| Tool | Purpose |
|------|---------|
| `click` | Click element by uid |
| `hover` | Hover over element |
| `fill` | Fill input field |
| `fill_form` | Fill multiple form fields at once |
| `press_key` | Press keyboard key/combo |
| `drag` | Drag element to another |
| `handle_dialog` | Accept/dismiss browser dialogs |
| `upload_file` | Upload file through input |
| `wait_for` | Wait for text to appear |

### Performance
| Tool | Purpose |
|------|---------|
| `performance_start_trace` | Start recording performance trace |
| `performance_stop_trace` | Stop recording |
| `performance_analyze_insight` | Analyze specific performance insight |

### Emulation
| Tool | Purpose |
|------|---------|
| `emulate` | Set CPU throttling, network conditions, geolocation |

### Advanced
| Tool | Purpose |
|------|---------|
| `evaluate_script` | Run JavaScript in page context |

## Common Workflows

### Debug Console Errors
```
1. navigate_page(url="...")
2. list_console_messages(types=["error", "warn"])
3. get_console_message(msgid=X)  → Get full error details
```

### Inspect Network Issues
```
1. navigate_page(url="...")
2. list_network_requests(resourceTypes=["fetch", "xhr"])
3. get_network_request(reqid=X)  → See headers, body, response
```

### Performance Analysis
```
1. performance_start_trace(reload=true, autoStop=true)
2. (wait for trace to complete)
3. performance_analyze_insight(insightSetId="...", insightName="LCPBreakdown")
```

## Key Points

- Uses `uid` for elements (from `take_snapshot`), not `ref`
- New sessions = no cookies, no login state
- Can create/manage multiple pages
- Console messages support type filtering: `log`, `error`, `warn`, `info`, etc.
- Network requests support type filtering: `fetch`, `xhr`, `document`, `script`, etc.

## Limitations

- No access to existing user sessions
- Pages open without authentication
- No access to user's existing tabs
- Sessions are ephemeral (no persistence)

## Example Usage

```
# Open page and check for errors
→ new_page(url="https://example.com")
→ list_console_messages(types=["error"])

# Inspect a failing API call
→ list_network_requests(resourceTypes=["fetch"])
→ get_network_request(reqid=5)

# Run custom JavaScript
→ evaluate_script(function="() => document.querySelectorAll('.error').length")
```
