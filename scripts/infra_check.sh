#!/usr/bin/env bash
set -euo pipefail
export PATH="$PATH:/home/maxime/bin:/home/maxime/.local/bin"

ALERT=""
if hermes status 2>/dev/null | grep -qi "error\|down\|fail"; then
  ALERT+="Anomalie détectée sur Hermes status.\n"
fi

if [ -n "$ALERT" ]; then
  "$(dirname "$0")/bus_send.sh" esn-direction infra-check infra-sre P1 pilote "Alerte Infra" "$ALERT" true
fi
EOF
chmod +x ~/esn/esn-control-plane/scripts/infra_check.sh
