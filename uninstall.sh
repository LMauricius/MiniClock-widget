#!/usr/bin/env bash
# Remove the Mini Analog Clock plasmoid for the current user.
set -euo pipefail

cd "$(dirname "$0")"
ID=$(python3 -c 'import json; print(json.load(open("widget/metadata.json"))["KPlugin"]["Id"])')

kpackagetool6 -t Plasma/Applet -r "$ID"
echo "Removed $ID."
