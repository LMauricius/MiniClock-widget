#!/usr/bin/env bash
# Install (or upgrade) the Mini Analog Clock plasmoid for the current user.
# Usage: ./install.sh [--restart]   (--restart reloads plasmashell so an upgrade takes effect)
set -euo pipefail

cd "$(dirname "$0")"
ID=$(python3 -c 'import json; print(json.load(open("widget/metadata.json"))["KPlugin"]["Id"])')

if kpackagetool6 -t Plasma/Applet -s "$ID" >/dev/null 2>&1; then
    kpackagetool6 -t Plasma/Applet -u widget
    echo "Upgraded $ID."
else
    kpackagetool6 -t Plasma/Applet -i widget
    echo "Installed $ID. Add it via 'Add Widgets…' and search for 'Mini Analog Clock'."
fi

if [[ "${1:-}" == "--restart" ]]; then
    systemctl --user restart plasma-plasmashell.service
else
    echo "If an existing instance doesn't pick up the changes, run: $0 --restart"
fi
