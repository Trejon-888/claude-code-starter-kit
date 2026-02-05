#!/bin/bash
# .claude/hooks/save-plan.sh
# PostToolUse hook: Auto-save plan files to .agents/plans/active/
# Extracts a descriptive name from the plan's H1 heading instead of using
# Claude Code's random generated filenames (e.g. tingly-squishing-cosmos.md)
# Also cleans up ~/.claude/plans/ after successful copy to prevent pile-up.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

if [[ "$FILE_PATH" == *"/.claude/plans/"* ]] && [[ "$FILE_PATH" == *.md ]]; then
  ACTIVE_DIR="${CLAUDE_PROJECT_DIR:-.}/.agents/plans/active"

  if [ -d "$ACTIVE_DIR" ] && [ -f "$FILE_PATH" ]; then
    # Extract H1 heading and convert to kebab-case filename
    HEADING=$(head -5 "$FILE_PATH" | grep -m1 '^# ' | sed 's/^# //' | sed 's/[^a-zA-Z0-9 ]//g' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

    if [[ -n "$HEADING" ]]; then
      FILENAME="${HEADING}.md"
    else
      FILENAME=$(basename "$FILE_PATH")
    fi

    DEST="$ACTIVE_DIR/$FILENAME"
    cp "$FILE_PATH" "$DEST"
    echo "Plan auto-saved to $DEST" >&2

    # Clean up the source file from ~/.claude/plans/ to prevent pile-up
    rm -f "$FILE_PATH"
  fi
fi

exit 0
