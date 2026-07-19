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

Full set adopted from Kun's dotfiles.

- Never use the em dash "—". Use a plain dash "-" instead.
- When writing commit messages, never auto-add your agent name as co-author.
- Never manually modify `CHANGELOG.md` or any file marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line, while preserving normal Markdown structure.
- When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long-term maintainability.
- When fixing a bug, always start by reproducing it in an E2E setting as close as possible to how a real user hits it, so the fix addresses the real cause.
- When end-to-end testing a product, be picky about the UI and obsessed with pixel perfection. If something clearly looks off, even if unrelated to the current task, get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness. If you see one, even if it is not caused by your current work, still get it fixed.
- Before using dynamic workflows, ultra code, or any harness feature that spawns a large swarm of subagents, explain the tradeoffs and ask for explicit approval first.

**Opinions:** When a task would benefit from my viewpoints, read `~/OPINIONS.md`.

**Voice:** When talking or posting using my identity, read `~/VOICE.md` for how I write.
