#!/usr/bin/env bash
# Build a .plasmoid archive (installable via "Install Widget From Local File…").
set -euo pipefail

cd "$(dirname "$0")"
ID=$(python3 -c 'import json; print(json.load(open("widget/metadata.json"))["KPlugin"]["Id"])')

rm -f "$ID.plasmoid"
(cd widget && zip -qr "../$ID.plasmoid" .)
echo "Created $ID.plasmoid"
