#!/usr/bin/env bash
# Shared context sync for Claude Code and Codex hooks.
# Usage: context-sync.sh <start|prompt|stop> <claude|codex>
set -u
cd "$(dirname "$0")/.." || exit 0

event="${1:-}"; tool="${2:-agent}"
handoff="context/HANDOFF.md"
marker="$(git rev-parse --git-dir 2>/dev/null)/context-turn-start"
host="$(hostname -s 2>/dev/null || hostname)"

case "$event" in
  start)
    # Pull the latest context from the other machine/tool (quietly, bounded).
    if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
      if ! timeout 20 git pull --rebase --autostash -q >/dev/null 2>&1; then
        git rebase --abort >/dev/null 2>&1
        echo "WARNING: git pull failed; context may be out of date. Tell the user."
      fi
    fi
    echo "=== Shared context (auto-loaded from $handoff) ==="
    cat "$handoff" 2>/dev/null || echo "(no handoff yet)"
    echo
    echo "=== Recent log (context/LOG.md) ==="
    head -n 25 context/LOG.md 2>/dev/null
    echo
    echo "Briefly tell the user where things stand and what's next."
    ;;

  prompt)
    # Mark the start of a turn so the stop hook can tell if the handoff was updated.
    touch "$marker"
    ;;

  stop)
    input="$(cat)"
    active=false
    printf '%s' "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && active=true

    # First stop of a turn where the handoff wasn't touched: ask the agent to update it.
    if [ "$active" = false ] && [ -f "$marker" ] && ! [ "$handoff" -nt "$marker" ]; then
      cat <<JSON
{"decision":"block","reason":"Auto-handoff: update context/HANDOFF.md so the other tool or machine can continue (goal, done, in progress, next steps, open questions, decisions). Keep it short. If a meaningful step finished, add a dated entry at the top of context/LOG.md as '$(date +%F) · $tool · $host'. If nothing worth recording happened this turn, just run: touch context/HANDOFF.md. Do not commit; the hook commits and pushes."}
JSON
      exit 0
    fi

    # Commit and push only the context files, in the background so the turn ends fast.
    git add context >/dev/null 2>&1
    if ! git diff --cached --quiet -- context 2>/dev/null; then
      git commit -q -m "handoff: auto-save ($tool · $host)" -- context >/dev/null 2>&1
      ( timeout 30 git push -q >/dev/null 2>&1 & ) 
    fi
    ;;
esac
exit 0
