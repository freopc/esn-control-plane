#!/usr/bin/env bash
# Hermes vers Antigravity. Mode print non interactif, sortie JSON.
# Usage: dispatch.sh <agent> <project_id> "<mission>" [host] [effort]
# JAMAIS appelé par un cron. Voir section C.5.
set -euo pipefail
export PATH="$PATH:/home/maxime/bin:/home/maxime/.local/bin"
AGENT="$1"; PROJECT="$2"; MISSION="$3"; HOST="${4:-ubuntu}"; EFFORT="${5:-low}"

case "$HOST" in
  ubuntu)  TARGET="${ESN_UBUNTU_SSH:?}";  WS="~/esn/${PROJECT}" ;;
  windows) TARGET="${ESN_WINDOWS_SSH:?}"; WS="C:/esn/${PROJECT}" ;;
  *) echo "host inconnu: $HOST" >&2; exit 2 ;;
esac

if ssh -o BatchMode=yes maxime@192.168.1.204 "sudo docker exec app_19006e5f_hermes_assistant test -f /data/hermes/ESTOP" 2>/dev/null; then
  echo '{"status":"refused","reason":"hermes paused"}'; exit 3
fi

ssh -o BatchMode=yes "$TARGET" \
  "export PATH=\"/home/maxime/esn/esn-control-plane/scripts:/home/maxime/bin:/home/maxime/.local/bin:\$PATH\"; mkdir -p ${WS} && cd ${WS} && agy -p \"[${PROJECT}] ${MISSION}\" \
     --agent '${AGENT}' --project '${PROJECT}' --effort '${EFFORT}' \
     --output-format json --print-timeout 20m --dangerously-skip-permissions --sandbox"
