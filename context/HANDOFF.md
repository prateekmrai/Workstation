# Handoff

_Last updated: 2026-11-13 · Claude_

## Current goal
Share files and conversation context between Claude Code and Codex across the desktop and laptop.

## Done
- Created `AGENTS.md` (read by Codex) and `CLAUDE.md` (imports it for Claude Code).
- Created `context/HANDOFF.md` (current state) and `context/LOG.md` (history).

## Next steps
- Clone this repo on both the desktop and the laptop, then open Claude Code and Codex from that folder.
- Try it: in one tool, say "handoff"; in the other, start a session and check that it picks up.

## Open questions
- None yet.

## Key decisions & preferences
- Git is the sync method between machines; each tool's own data (`~/.claude`, `~/.codex`) is not synced.
