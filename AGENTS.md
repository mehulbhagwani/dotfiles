# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- `chrome-devtools-axi` is patched to launch Brave rather than Chrome, because Brave is the browser on this machine. The patch lives in a global npm package that `npm update -g` overwrites, so `scripts/chrome-devtools-axi-brave.sh` re-applies it from home-manager activation on every rebuild. A patched `dist/` under `node_modules` is intentional, not cruft. Override the target with `CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH`.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
