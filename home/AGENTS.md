# Agent Instructions (shared)

Single instruction file for every agent tool: `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, and `~/.config/opencode/AGENTS.md` all resolve here, so edits are live immediately.
Run `~/dotfiles/rebuild.sh` only after changing `home.nix` (new files, packages, env vars).

<!-- CARL-MANAGED: Do not remove this section -->
## CARL Integration

Follow all rules in <carl-rules> blocks from system-reminders.
These are dynamically injected based on context and MUST be obeyed.
<!-- END CARL-MANAGED -->

## Replying

- Be extremely concise. Short bullets, not prose. Lead with the answer; skip filler and restating the question.
- Write dashes as "-". Never the em dash "—".
- Research before asking. If research yields an obvious best answer, act and notify me with a one-line rationale. Ask only for judgment calls that are genuinely mine, and include the findings plus your recommendation.

## Code work

- Weight quality, simplicity, robustness, scalability, and long-term maintainability over development cost.
- Build with bricks: every UI element, layer, and utility is a self-contained composable unit reused across the app. Factor shared logic into shared modules from the start.
- Reproduce behavioral bugs E2E first, as close as feasible to how a real user hits them, so the fix lands on the real cause.
- Broken windows: any flaw you notice off-task - UI, lint, test failure, flakiness - fix it if small, flag it if not. Be pixel-picky on UI.
- Single-quote URLs passed to `gh api` or `curl`; zsh globs `?` and `&` in bare query strings.
- Commit messages are mine alone - no agent co-author trailer. Let generators own `CHANGELOG.md` and anything marked auto-generated.

## Pointers

**Heavy ops:** Before a browser E2E run, a subagent swarm (dynamic workflows, ultracode), or a long Markdown edit, read `~/.dotfiles/home/VERIFY.md`.

**Opinions:** When a task would benefit from my viewpoints, read `~/OPINIONS.md`.

**Voice:** When talking or posting using my identity, read `~/VOICE.md` for how I write.

**Codebase brain:** To locate code, a reusable component, a doc, or cross-repo GSD state across my projects, read `~/Documents/coding-brain/AGENTS.md` then `00_INDEX.md` FIRST - it is a distilled cross-repo index, faster than grepping repos. It never contains `*_OS` (personal/financial) data.

**Simplicity:** Apply the `ponytail` skill's ladder to all code work: need-to-exist -> reuse -> stdlib -> platform -> dependency -> one line. Stop at the first rung that holds.

**Grilling:** On "grill me", or when a plan, decision, or idea needs stress-testing, use the `grill-me` skill. Interview me in numbered frontier rounds with a recommended answer per question; look up facts yourself and bring me only decisions.
