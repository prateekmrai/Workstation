# Workstation: shared instructions for Claude Code and Codex

This repo is shared between Claude Code and Codex, on both the desktop and the laptop.
Conversations don't carry over between tools or machines, so `context/` holds the memory.

## Automatic sync (hooks)
Hooks in `.claude/settings.json` and `.codex/hooks.json` run `scripts/context-sync.sh`:
- **Session start:** pulls the latest from git and loads `HANDOFF.md` and recent `LOG.md` into context.
- **End of each turn:** if `HANDOFF.md` wasn't updated this turn, you'll be asked to update it
  (or `touch` it if nothing worth recording happened). Then the hook commits and pushes `context/`.
Don't commit `context/` yourself; the hook does it.

## At the start of every session (if hooks didn't run)
1. Run `git pull` so this machine has the latest context.
2. Read `context/HANDOFF.md`. It's the current state of the work.
3. Skim the last few entries of `context/LOG.md` if you need more history.
4. Tell the user in one or two lines where things stand and what's next.

## While working
- Record decisions, preferences and facts worth remembering in `context/HANDOFF.md` as they come up.
  Don't wait until the end.

## Manual handoff (if hooks aren't running, or the user says "handoff" / "save")
1. Rewrite `context/HANDOFF.md` so someone with no memory of this chat could continue:
   current goal, what's done, what's in progress, next steps, open questions, key decisions.
2. Append a short dated entry to the top of `context/LOG.md` with the tool and machine used
   (e.g. `2026-11-13 · Claude · laptop`).
3. Commit with a message like `handoff: <summary>` and `git push`.

## Rules
- `HANDOFF.md` is the current state: keep it short and overwrite stale parts.
  `LOG.md` is history: append only, newest first.
- Never put passwords, API keys or tokens in these files.
