#!/usr/bin/env bash
# Apply this repo to the Mac you are on.
# Usage: ./rebuild.sh [rac|mehul-mac]
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles

pick_host() {
  if [ -n "${1:-}" ]; then
    printf '%s\n' "$1"
    return
  fi
  local name user
  user="$(whoami)"
  name="$(scutil --get ComputerName 2>/dev/null || true)"
  case "$user" in
    rac) printf '%s\n' rac; return ;;
    mehul) printf '%s\n' mehul-mac; return ;;
  esac
  case "$name" in
    Mehul-Mac|Mehul*|mehul-mac) printf '%s\n' mehul-mac; return ;;
    Rac*|rac) printf '%s\n' rac; return ;;
  esac
  echo "Could not tell which machine this is (user=$user computer=${name:-unknown})." >&2
  echo "Run: ./rebuild.sh rac    or    ./rebuild.sh mehul-mac" >&2
  exit 1
}

HOST="$(pick_host "${1:-}")"
case "$HOST" in
  rac|mehul-mac) ;;
  *)
    echo "Unknown host '$HOST'. Use rac or mehul-mac." >&2
    exit 1
    ;;
esac

echo "==> applying darwinConfigurations.$HOST"
# Absolute path: sudo's PATH excludes /run/current-system/sw/bin, so a bare
# darwin-rebuild isn't found under sudo.
exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake "$DIR#$HOST"
