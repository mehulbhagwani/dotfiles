#!/usr/bin/env bash
# Install the global npm CLIs this machine's workflow depends on.
#
# These are the -axi agent tools. They are neither Nix packages nor Homebrew
# formulae, so without this a rebuild on a fresh Mac produces a machine with
# none of them. Homebrew's `node` (declared in configuration.nix) is what they
# stand on; that dependency used to be transitive through pi-coding-agent.
#
# Deliberately unpinned: these ship often and are meant to track latest, the
# same way they were installed by hand. Already-installed packages are left
# exactly as they are, so this never downgrades or churns a working machine.
set -euo pipefail

# Activation runs with a minimal PATH; npm lives in the Homebrew prefix.
export PATH="/opt/homebrew/bin:$PATH"

PACKAGES=(
  "@nikolauska/sentry-axi"
  az-axi
  backpass
  chrome-devtools-axi
  comfy-cloud-axi
  council-axi
  doctl-axi
  gh-axi
  gws-axi
  lavish-axi
  linear-sdk-axi
  mobbin-axi
  openpanel-axi
  quota-axi
  tasks-axi
)

command -v npm >/dev/null 2>&1 || { echo "npm-globals: npm not found, skipping"; exit 0; }

installed="$(npm ls -g --depth=0 --parseable 2>/dev/null || true)"

missing=()
for pkg in "${PACKAGES[@]}"; do
  # --parseable prints one install path per line, ending in the package name.
  case "$installed" in
    *"/node_modules/$pkg"$'\n'*|*"/node_modules/$pkg") ;;
    *) missing+=("$pkg") ;;
  esac
done

if [ ${#missing[@]} -eq 0 ]; then
  echo "npm-globals: all ${#PACKAGES[@]} present"
  exit 0
fi

echo "npm-globals: installing ${missing[*]}"
npm install -g "${missing[@]}"
