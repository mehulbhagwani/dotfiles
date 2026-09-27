#!/usr/bin/env bash
# Clone or fast-update the Kun skills this machine uses, then link them
# into both agent skill directories. Declared here so a dotfiles pull plus
# rebuild is enough; the script is also safe to run on its own.
set -euo pipefail

# Home Manager activation uses a minimal PATH. git and gh are Homebrew
# packages, so they are invisible unless this prefix is added first.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if ! command -v git >/dev/null 2>&1; then
  echo "kun-sync: git is not on PATH. Install the git brew from configuration.nix, then rebuild." >&2
  exit 1
fi

ROOT="${KUN_SKILLS_ROOT:-$HOME/.local/share/kun-skills}"
AGENTS="${KUN_AGENTS_SKILLS:-$HOME/.agents/skills}"
PI="${KUN_PI_SKILLS:-$HOME/.pi/agent/skills}"
mkdir -p "$ROOT" "$AGENTS" "$PI"

# repo<TAB>path-inside-repo<TAB>skill-name
SKILLS=$(cat <<'EOF'
kun	skills/kun	kun
axi	.agents/skills/axi	axi
gh-axi	skills/gh-axi	gh-axi
lavish-axi	skills/lavish	lavish
vision	skills/vision	vision
whathappened	skills/whathappened	whathappened
chrome-devtools-axi	skills/chrome-devtools-axi	chrome-devtools-axi
no-mistakes	skills/no-mistakes	no-mistakes
compact-adviser	packages/codex-plugin/skills/compact-adviser	compact-adviser
gnhf	skills/gnhf	gnhf
quota-axi	skills/quota-axi	quota-axi
tasks-axi	skills/tasks-axi	tasks-axi
EOF
)

sync_repo() {
  local repo="$1"
  local dest="$ROOT/$repo"
  if [ -d "$dest/.git" ]; then
    git -C "$dest" fetch --depth 1 origin HEAD
    git -C "$dest" checkout -f FETCH_HEAD
  else
    rm -rf "$dest"
    git clone --depth 1 "https://github.com/kunchenguid/${repo}.git" "$dest"
  fi
}

link_skill() {
  local repo="$1" src="$2" name="$3"
  local from="$ROOT/$repo/$src"
  if [ ! -d "$from" ]; then
    echo "kun-sync: missing $repo/$src" >&2
    return 1
  fi
  ln -sfn "$from" "$AGENTS/$name"
  ln -sfn "$from" "$PI/$name"
  echo "kun-sync: $name -> $repo/$src"
}

repos=$(printf '%s\n' "$SKILLS" | cut -f1 | sort -u)
for repo in $repos; do
  sync_repo "$repo"
done

printf '%s\n' "$SKILLS" | while IFS=$'\t' read -r repo src name; do
  link_skill "$repo" "$src" "$name"
done
