#!/usr/bin/env bash
# Run the installed plasmoid in its own window, for quick testing.
# Usage: ./test.sh [width height]
set -euo pipefail

cd "$(dirname "$0")"
ID=$(python3 -c 'import json; print(json.load(open("widget/metadata.json"))["KPlugin"]["Id"])')

./install.sh
exec plasmawindowed "$ID" "$@"
