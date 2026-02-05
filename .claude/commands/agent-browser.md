# /agent-browser — Browser Automation for AI Agents

Automate browser interactions for testing, screenshots, and validation using agent-browser CLI.

**Reliability:** 95% first-try success rate (vs 80% for Playwright MCP)

---

## Core Workflow

1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2...)
3. `agent-browser click @e5` - Interact by reference (NOT selector)

---

## Why Refs > Selectors

| Approach | Success Rate | Why |
|----------|--------------|-----|
| Refs (@e1, @e2) | 95% | Deterministic pointers to elements |
| Selectors (CSS/XPath) | 80% | Requires searching/matching |

**Key insight:** Selectors are non-deterministic. Refs are deterministic.

---

## Key Commands

### Navigation
```bash
agent-browser open <url>     # Load page
agent-browser back           # Go back
agent-browser forward        # Go forward
agent-browser reload         # Refresh page
agent-browser close          # Close browser
```

### Snapshot (THE KEY COMMAND)
```bash
agent-browser snapshot       # Full accessibility tree with refs
agent-browser snapshot -i    # Interactive elements only (RECOMMENDED)
agent-browser snapshot -c    # Compact format
agent-browser snapshot -d 3  # Limit depth
```

**Output includes refs like @e1, @e2, @e3 - use these for interactions!**

### Interactions (ALWAYS use refs, not selectors!)
```bash
agent-browser click @e1            # Click by reference
agent-browser fill @e2 "text"      # Fill input (clears first)
agent-browser type @e3 "text"      # Type without clearing
agent-browser scroll up            # Scroll viewport
agent-browser scroll down
agent-browser hover @e4            # Hover over element
agent-browser select @e5 "value"   # Select dropdown option
```

### Information Retrieval
```bash
agent-browser get text @e1    # Get element text
agent-browser get html @e1    # Get innerHTML
agent-browser get value @e1   # Get input value
agent-browser get url         # Current page URL
agent-browser get title       # Page title
```

### Screenshots & Media
```bash
agent-browser screenshot path.png         # Capture viewport
agent-browser screenshot path.png --full  # Full page
agent-browser pdf path.pdf                # Save as PDF
```

### Error Checking
```bash
agent-browser errors          # JavaScript console errors
agent-browser console         # All console messages
```

### State Checks
```bash
agent-browser is visible @e1  # Check visibility
agent-browser is enabled @e1  # Check if interactive
agent-browser is checked @e1  # Check checkbox state
```

### Wait Operations
```bash
agent-browser wait @e1               # Wait for element
agent-browser wait 3000              # Wait milliseconds
agent-browser wait --text "Welcome"  # Wait for text
agent-browser wait --url "**/dash"   # Wait for URL pattern
agent-browser wait --load networkidle # Wait for load state
```

### Semantic Locators (Alternative to Refs)
```bash
agent-browser find role button click --name "Submit"
agent-browser find text "Sign In" click
agent-browser find label "Email" fill "test@example.com"
```

---

## Typical Validation Workflow

```bash
# 1. Open the app
agent-browser open http://localhost:8080

# 2. Take snapshot to get element refs
agent-browser snapshot -i

# 3. Navigate as user would
agent-browser click @e3  # Click nav link
agent-browser wait --url "**/dashboard"

# 4. Fill a form
agent-browser fill @e5 "test@example.com"
agent-browser fill @e6 "password123"
agent-browser click @e7  # Submit button
agent-browser wait --text "Welcome"

# 5. Check for errors
agent-browser errors

# 6. Take screenshot for artifact
agent-browser screenshot /tmp/validation.png --full

# 7. Close browser
agent-browser close
```

---

## Sessions & Profiles

### Multiple Sessions
```bash
agent-browser --session agent1 open site-a.com
agent-browser --session agent2 open site-b.com
agent-browser session list
```

### Persistent Profiles (preserve login state)
```bash
agent-browser --profile ~/.myapp-profile open myapp.com
# Login once, then reuse profile
```

---

## Browser Configuration

```bash
agent-browser set viewport 1920 1080   # Screen size
agent-browser set device "iPhone 14"   # Device emulation
agent-browser set offline on           # Offline mode
agent-browser set media dark           # Color scheme
```

---

## Installation

```bash
npm install -g agent-browser
agent-browser install  # Download Chromium
```

Linux requires:
```bash
agent-browser install --with-deps
```

---

**Version:** 1.0
