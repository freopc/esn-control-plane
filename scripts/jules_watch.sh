#!/usr/bin/env bash
# Surveille une session Jules et route vers le Kanban. ZERO token Hermes.
# Usage: jules_watch.sh <session_id> <project_id>
set -euo pipefail
source ~/esn/.env 2>/dev/null || true

SID="$1"; PROJECT="$2"
H="X-Goog-Api-Key: ${JULES_API_KEY:?}"
API="https://jules.googleapis.com/v1alpha/sessions/${SID}"
S=$(curl -fsS -H "$H" "$API"); STATE=$(jq -r '.state' <<<"$S")

case "$STATE" in
  AWAITING_PLAN_APPROVAL)
    PLAN=$(curl -fsS -H "$H" "${API}/activities?pageSize=100" \
           | jq -r '[.activities[]? | select(.planGenerated)] | last
                    | .planGenerated.plan.steps[]? | "- \(.title)\(if .description then ": " + .description else "" end)"')
    "$(dirname "$0")/bus_send.sh" esn-delivery jules qa-lead P3 "$PROJECT" \
      "Plan a valider session ${SID}" "${PLAN}" ;;
  AWAITING_USER_FEEDBACK)
    MSG=$(curl -fsS -H "$H" "${API}/activities?pageSize=100" \
          | jq -r '[.activities[]? | select(.agentMessaged)] | last | .agentMessaged.agentMessage')
    "$(dirname "$0")/bus_send.sh" esn-delivery jules delivery-lead P2 "$PROJECT" \
      "Question Jules session ${SID}" "${MSG}" ;;
  COMPLETED)
    PR=$(jq -r '.outputs[]?.pullRequest.url // empty' <<<"$S")
    "$(dirname "$0")/bus_send.sh" esn-delivery jules qa-lead P3 "$PROJECT" \
      "Session ${SID} terminee" "PR: ${PR:-aucune, recuperer le patch}" ;;
  FAILED)
    R=$(curl -fsS -H "$H" "${API}/activities?pageSize=100" \
        | jq -r '[.activities[]? | select(.sessionFailed)] | last | .sessionFailed.reason')
    "$(dirname "$0")/bus_send.sh" esn-delivery jules delivery-lead P2 "$PROJECT" \
      "Echec session ${SID}" "${R}" ;;
esac
echo "$STATE"
