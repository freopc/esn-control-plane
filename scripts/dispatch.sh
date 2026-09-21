#!/usr/bin/env bash
# Hermes vers Antigravity. Mode print non interactif, sortie JSON.
# Usage: dispatch.sh <agent> <project_id> "<mission>" [host] [effort]
# JAMAIS appelé par un cron. Voir section C.5.
set -euo pipefail
AGENT="$1"; PROJECT="$2"; MISSION="$3"; HOST="${4:-ubuntu}"; EFFORT="${5:-low}"

case "$HOST" in
  ubuntu)  TARGET="${ESN_UBUNTU_SSH:?}";  WS="~/esn/${PROJECT}" ;;
  windows) TARGET="${ESN_WINDOWS_SSH:?}"; WS="C:/esn/${PROJECT}" ;;
  *) echo "host inconnu: $HOST" >&2; exit 2 ;;
esac

if hermes status 2>/dev/null | grep -qi "paus"; then
  echo '{"status":"refused","reason":"hermes paused"}'; exit 3
fi

ssh -o BatchMode=yes "$TARGET" \
  "cd ${WS} && agy -p \"[${PROJECT}] ${MISSION}\" \
     --agent '${AGENT}' --project '${PROJECT}' --effort '${EFFORT}' \
     --output-format json --print-timeout 20m --sandbox"
