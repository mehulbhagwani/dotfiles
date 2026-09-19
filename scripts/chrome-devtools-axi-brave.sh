#!/usr/bin/env bash
# Point chrome-devtools-axi at Brave instead of Chrome.
#
# chrome-devtools-axi is a global npm package, so it is outside both Nix and
# Homebrew: `npm update -g` replaces dist/ wholesale and reverts this. Running
# it from home.nix activation means every `./rebuild.sh` puts it back.
#
# The patch teaches the bridge to pass chrome-devtools-mcp's --executablePath,
# defaulting to Brave and overridable with CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH.
# Idempotent: already-patched installs and absent installs are both no-ops.
set -euo pipefail

# Activation runs with a minimal PATH; npm and python3 live in the Homebrew prefix.
export PATH="/opt/homebrew/bin:$PATH"

BRAVE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

prefix="$(npm prefix -g 2>/dev/null)" || { echo "chrome-devtools-axi-brave: npm not found, skipping"; exit 0; }
dist="$prefix/lib/node_modules/chrome-devtools-axi/dist"
[ -d "$dist" ] || { echo "chrome-devtools-axi-brave: package not installed, skipping"; exit 0; }

if grep -q "CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH" "$dist/src/bridge.js" 2>/dev/null; then
  echo "chrome-devtools-axi-brave: already pointed at Brave"
  exit 0
fi

BRAVE="$BRAVE" python3 - "$dist" <<'PY'
import os, pathlib, sys

dist = pathlib.Path(sys.argv[1])
brave = os.environ["BRAVE"]

bridge = dist / "src/bridge.js"
s = bridge.read_text()

decl = "    const channel = process.env.CHROME_DEVTOOLS_AXI_CHANNEL?.trim();\n"
if s.count(decl) != 1:
    sys.exit("chrome-devtools-axi-brave: channel declaration not found, upstream layout changed")
s = s.replace(decl, decl + (
    "    // Brave is this machine's browser: chrome-devtools-mcp launches whatever\n"
    "    // Chromium binary --executablePath names, so Brave is the default target.\n"
    "    // Override with CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH to point somewhere else.\n"
    "    const executablePath = process.env.CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH?.trim()\n"
    f'        || "{brave}";\n'
), 1)

channel_branch = (
    "    if (channel && !browserUrl) {\n"
    "        args.push(`--channel=${channel}`);\n"
    "    }\n"
)
if s.count(channel_branch) != 1:
    sys.exit("chrome-devtools-axi-brave: channel branch not found, upstream layout changed")
s = s.replace(channel_branch, (
    "    // --executablePath names the exact binary, which makes --channel (a Chrome\n"
    "    // distribution selector) meaningless, so the two are mutually exclusive.\n"
    "    if (executablePath && !browserUrl) {\n"
    "        args.push(`--executablePath=${executablePath}`);\n"
    "    }\n"
    "    else if (channel && !browserUrl) {\n"
    "        args.push(`--channel=${channel}`);\n"
    "    }\n"
), 1)
bridge.write_text(s)

cli = dist / "src/cli.js"
t = cli.read_text()
anchor = "  CHROME_DEVTOOLS_AXI_HEADED        Set to 1 to run Chrome in headed (visible) mode\n"
if t.count(anchor) == 1:
    cli.write_text(t.replace(anchor, anchor + (
        "  CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH\n"
        "                                    Path to the Chromium-based browser binary to launch.\n"
        "                                    Defaults to Brave at /Applications/Brave Browser.app.\n"
        "                                    Takes precedence over CHROME_DEVTOOLS_AXI_CHANNEL and is\n"
        "                                    ignored with CHROME_DEVTOOLS_AXI_BROWSER_URL.\n"
    ), 1))

print("chrome-devtools-axi-brave: pointed at Brave")
PY
