#!/bin/bash
# .claude/hooks/post-edit-typecheck.sh
# PostToolUse (async) hook: Background typecheck after file edits
#
# Runs non-blocking typecheck after .ts/.tsx files are edited.
# Only outputs if there are errors, to avoid noise.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only run after Write or Edit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

# Only typecheck TypeScript files
if [[ "$FILE_PATH" != *.ts && "$FILE_PATH" != *.tsx ]]; then
  exit 0
fi

# Check if tsconfig exists
if [[ ! -f "${CLAUDE_PROJECT_DIR:-.}/tsconfig.json" ]]; then
  exit 0
fi

# Check if node_modules exists (dependencies installed)
if [[ ! -d "${CLAUDE_PROJECT_DIR:-.}/node_modules" ]]; then
  exit 0
fi

# Run typecheck in background, only show output if errors
cd "${CLAUDE_PROJECT_DIR:-.}"
RESULT=$(npx tsc --noEmit 2>&1)
if [[ $? -ne 0 ]]; then
  echo "TypeCheck errors detected:" >&2
  echo "$RESULT" | head -20 >&2
fi

exit 0
