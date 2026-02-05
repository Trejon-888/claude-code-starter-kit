#!/bin/bash
# Pre-compaction memory flush — save context before it's lost
# Part of claude-code-starter-kit by INFINITX (app.infinitxai.com)

cat <<'DIRECTIVE'
CRITICAL: Context compaction imminent. Before proceeding, you MUST:

1. Write current session progress to .agents/HANDOVER.md (update current session entry)
2. Write any new architectural decisions to .agents/PROJECT-MEMORY.md
3. Update .agents/plans/INDEX.md if plan status changed
4. Create execution reports for any completed plans (.agents/execution-reports/{date}-{plan-name}.md)
5. Move completed plans from active/ to completed/
6. Update todo list with current progress

Do NOT skip this. Unwritten context will be permanently lost after compaction.
DIRECTIVE

exit 0
