# Workstation: shared instructions for Claude Code and Codex

This repo is shared between Claude Code and Codex, on both the desktop and the laptop.
Conversations don't carry over between tools or machines, so `context/` holds the memory.

## At the start of every session
1. Run `git pull` so this machine has the latest context.
2. Read `context/HANDOFF.md`. It's the current state of the work.
3. Skim the last few entries of `context/LOG.md` if you need more history.
4. Tell the user in one or two lines where things stand and what's next.

## While working
- Record decisions, preferences and facts worth remembering in `context/HANDOFF.md` as they come up.
  Don't wait until the end.

## When the user says "handoff", "save", "wrap up", or the session is ending
1. Rewrite `context/HANDOFF.md` so someone with no memory of this chat could continue:
   current goal, what's done, what's in progress, next steps, open questions, key decisions.
2. Append a short dated entry to the top of `context/LOG.md` with the tool and machine used
   (e.g. `2026-11-13 · Claude · laptop`).
3. Commit with a message like `handoff: <summary>` and `git push`.

## Rules
- `HANDOFF.md` is the current state: keep it short and overwrite stale parts.
  `LOG.md` is history: append only, newest first.
- Never put passwords, API keys or tokens in these files.
