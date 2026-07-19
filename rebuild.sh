#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# Absolute path: sudo's PATH excludes /run/current-system/sw/bin, so a bare
# `darwin-rebuild` isn't found under sudo. Resolve it before escalating.
exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.dotfiles#mac
