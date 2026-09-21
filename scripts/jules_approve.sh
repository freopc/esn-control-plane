#!/usr/bin/env bash
# Approuve un plan après validation qa-lead, ou envoie un message de suivi.
# Usage: jules_approve.sh approve <sid> | jules_approve.sh send <sid> "<message>"
set -euo pipefail
H="X-Goog-Api-Key: ${JULES_API_KEY:?}"
case "$1" in
  approve) curl -fsS -X POST "https://jules.googleapis.com/v1alpha/sessions/$2:approvePlan" \
             -H "$H" -H 'Content-Type: application/json' -d '{}' ;;
  send)    curl -fsS -X POST "https://jules.googleapis.com/v1alpha/sessions/$2:sendMessage" \
             -H "$H" -H 'Content-Type: application/json' \
             -d "$(jq -n --arg p "$3" '{prompt:$p}')" ;;
  *) echo "verbe inconnu" >&2; exit 2 ;;
esac
