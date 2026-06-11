# Hooks

<!-- Aucun hook actif ici. Ce dossier documente quand et comment en ajouter. -->

This folder is intentionally empty of active hooks. It documents **when** and **how** to add one,
so the structure is ready the day you need it — without paying the cost before then.

## What hooks are

Hooks are scripts triggered by an agent's lifecycle events — for example at session start, or
before/after a tool call. They let you automate setup or checks around the agent's work.

## Why there is no hook yet

<!-- Choix délibéré : portabilité + YAGNI + maintenance. -->

- **Portability.** Hooks are tool-specific. Claude Code lifecycle hooks do not run in Cursor,
  Gemini CLI, or Copilot — each has its own system or none. The value of this repo lives in the
  Markdown skills, which run everywhere; hooks would tie part of it to one tool.
- **YAGNI.** A useful hook solves a real, recurring friction. With a small library there usually
  isn't one yet. Writing hooks now would be infrastructure for workflows that don't exist.
- **Maintenance.** A bad `SKILL.md` is just ignored. A bad hook can break a session, fail
  silently, or slow every startup. That's a real cost for a starter repo.

## When to add one

Add a hook once you notice a gesture you repeat every session — for example, "I always remind the
agent to check available skills at startup." That recurring friction is the problem a hook solves.

## How to add one (Claude Code)

1. Create the script here, e.g. `hooks/session-start.sh`.
2. Make it portable and safe:
   - `#!/bin/bash` shebang and `set -e` for fail-fast behavior.
   - Status messages to stderr (`echo "msg" >&2`), machine-readable output to stdout.
   - A cleanup trap for any temp files.
3. Register it in your Claude Code settings (see the Claude Code hooks documentation for the
   current config format and event names).
4. Keep the logic minimal — a hook should do one small, reliable thing.

## Keeping it portable

If you later support multiple agents, treat each tool's hook config as a thin adapter that calls
a shared script here. The shared script holds the logic; the per-tool config only wires it to that
tool's events. That way switching agents means rewriting the wiring, not the logic.
