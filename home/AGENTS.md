# Agent Instructions (shared)

This is the single instruction file symlinked to `~/.claude/CLAUDE.md`,
`~/.codex/AGENTS.md`, and `~/.config/opencode/AGENTS.md`, so every agent tool
reads the same rules.
Edit this file at `~/.dotfiles/home/AGENTS.md` to change them everywhere at once.

<!-- CARL-MANAGED: Do not remove this section -->
## CARL Integration

Follow all rules in <carl-rules> blocks from system-reminders.
These are dynamically injected based on context and MUST be obeyed.
<!-- END CARL-MANAGED -->

## General Guidelines

Adopted from Kun's dotfiles, trimmed to fit this machine.
Lines that clashed with Ponytail's lazy/YAGNI mode were left out.

- Never use the em dash "—". Use a plain dash "-" instead.
- When writing commit messages, never auto-add your agent name as co-author.
- Never manually modify `CHANGELOG.md` or any file marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line, while preserving normal Markdown structure.
- When fixing a bug, first reproduce it as closely as possible to how a real user hits it, so the fix addresses the real cause and not a symptom.
- Before using dynamic workflows, ultra code, or any harness feature that spawns a large swarm of subagents, explain the tradeoffs and ask for explicit approval first.
