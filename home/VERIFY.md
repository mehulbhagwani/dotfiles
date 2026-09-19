# Heavy operations

Reached from `AGENTS.md`. Covers the three operations that are slow, expensive, or easy to get wrong by reflex.

## Batched browser E2E

Playwright and similar browser suites run ONCE per checkpoint, not once per change.

Keep a written checklist of changes awaiting browser verification.
Accumulate across tasks, plans, and phases while it is safe to do so.
Verify the whole checklist in one batched run at a natural checkpoint - end of plan or phase, before push.

Targeted single-spec runs are for debugging one specific failure.
Fast unit and integration tests stay per-task; this governs slow browser runs only.

## Subagent swarms

Dynamic workflows, ultracode, and any harness feature that spawns a large swarm: explain the tradeoffs and get explicit approval first.

## Long Markdown edits

When writing or substantially editing a long Markdown file, put each full sentence on its own line.
Preserve normal Markdown structure.
