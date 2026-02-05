#!/bin/bash
# SessionStart hook — load project context at every conversation start
# Part of claude-code-starter-kit by INFINITX (app.infinitxai.com)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "═══ PROJECT CONTEXT LOADED ═══"
echo ""

# Load project name from CLAUDE.md H1 heading
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
  PROJECT_NAME=$(head -5 "$PROJECT_DIR/CLAUDE.md" | grep -m1 '^# ' | sed 's/^# //')
  if [ -n "$PROJECT_NAME" ]; then
    echo "Project: $PROJECT_NAME"
    echo ""
  fi
fi

# Load last session from HANDOVER.md
if [ -f "$PROJECT_DIR/.agents/HANDOVER.md" ]; then
  echo "--- Last Session ---"
  # Show the most recent session entry (last ### heading block)
  awk '/^### Session/{found=1; block=""} found{block=block"\n"$0} END{print block}' "$PROJECT_DIR/.agents/HANDOVER.md" | tail -10
  echo ""
fi

# Show active plans
ACTIVE_DIR="$PROJECT_DIR/.agents/plans/active"
if [ -d "$ACTIVE_DIR" ]; then
  ACTIVE_COUNT=$(ls "$ACTIVE_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
  if [ "$ACTIVE_COUNT" -gt 0 ]; then
    echo "Active plans: $ACTIVE_COUNT"
    ls "$ACTIVE_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md
    echo ""
  fi
fi

echo "═══ END PROJECT CONTEXT ═══"
