# Agent Instructions (shared)

This is the single instruction file read by every agent tool (via `~/.claude/CLAUDE.md`,
`~/.codex/AGENTS.md`, and `~/.config/opencode/AGENTS.md`), so they all share the same rules.

Source of truth: `~/dotfiles/home/AGENTS.md` (nix-darwin managed; `~/.dotfiles` is a
symlink to it). Edits take effect only after running `~/dotfiles/rebuild.sh`. Do not edit
the symlink targets directly - they resolve into the read-only nix store, so changes there
silently do nothing.

<!-- CARL-MANAGED: Do not remove this section -->
## CARL Integration

Follow all rules in <carl-rules> blocks from system-reminders.
These are dynamically injected based on context and MUST be obeyed.
<!-- END CARL-MANAGED -->

## General Guidelines

- Never use the em dash "—". Use a plain dash "-" instead.
- When writing commit messages, never auto-add your agent name as co-author.
- Never manually modify `CHANGELOG.md` or any file marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line, while preserving normal Markdown structure.
- When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long-term maintainability.
- When fixing a behavioral bug, when feasible start by reproducing it in an E2E setting as close as possible to how a real user hits it, so the fix addresses the real cause.
- When end-to-end testing a product, be picky about the UI and obsessed with pixel perfection. If something clearly looks off, even if unrelated to the current task, fix it if the fix is small; otherwise report it and ask.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness. If you see one, even if it is not caused by your current work, fix it if small; otherwise flag it.
- Before using dynamic workflows, ultra code, or any harness feature that spawns a large swarm of subagents, explain the tradeoffs and ask for explicit approval first.
- When building apps, build with reusable components ("bricks"): every UI element, layer, or utility should be a self-contained, composable unit reused across the app rather than duplicated. Prefer one shared component over many one-off copies; factor shared logic into shared modules from the start.

**Opinions:** When a task would benefit from my viewpoints, read `~/OPINIONS.md`.

**Voice:** When talking or posting using my identity, read `~/VOICE.md` for how I write.

**Codebase brain:** To locate code, a reusable component, a doc, or cross-repo PAUL state across my projects, read `~/Documents/coding-brain/AGENTS.md` then `00_INDEX.md` FIRST - it is a distilled cross-repo index, faster than grepping repos. It never contains `*_OS` (personal/financial) data.
