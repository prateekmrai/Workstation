# Handoff

_Last updated: 2026-11-20 · Claude_

## Current goal
Share files and conversation context between Claude Code and Codex across the desktop and laptop.

## Done
- Created `AGENTS.md` (read by Codex) and `CLAUDE.md` (imports it for Claude Code).
- Created `context/HANDOFF.md` (current state) and `context/LOG.md` (history).
- Added automatic sync: `scripts/context-sync.sh`, called by hooks in `.claude/settings.json` and `.codex/hooks.json` (session start: pull + load context; end of turn: update handoff, commit, push).

## Next steps
- Clone this repo on both the desktop and the laptop, then open Claude Code and Codex from that folder.
- Try it: in one tool, say "handoff"; in the other, start a session and check that it picks up.

## Open questions
- Codex hook file format was written from search results, not the official docs (blocked from the cloud session). Verify with `/hooks` in Codex.

- Optional: to control laptop/desktop from a cloud session, install the Claude desktop app on each and share the folder via Settings → Claude Code → Remote Control (one computer per cloud session; feature may not be available to all accounts yet).

## Key decisions & preferences
- Git is the sync method between machines; each tool's own data (`~/.claude`, `~/.codex`) is not synced.
