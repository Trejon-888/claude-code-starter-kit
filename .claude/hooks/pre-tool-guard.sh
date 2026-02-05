#!/bin/bash
# .claude/hooks/pre-tool-guard.sh
# PreToolUse hook: Block destructive commands even in bypassPermissions mode
#
# Blocks: rm -rf /, mkfs, shutdown, dd if=, format, fdisk
# Returns exit code 2 to block the tool call

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

if [[ "$TOOL_NAME" == "Bash" ]]; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

  # Block destructive commands
  if echo "$COMMAND" | grep -qE '(rm\s+-rf\s+/[^a-zA-Z]|mkfs|shutdown|reboot|dd\s+if=|format\s+[a-zA-Z]:|fdisk|wipefs)'; then
    echo '{"error": "BLOCKED: Destructive command detected. This command could cause irreversible damage."}' >&2
    exit 2
  fi

  # Block git force push to main/master
  if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force.*\s+(main|master)|git\s+push\s+-f.*\s+(main|master)'; then
    echo '{"error": "BLOCKED: Force push to main/master. Use a feature branch instead."}' >&2
    exit 2
  fi
fi

exit 0
