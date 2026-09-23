#!/usr/bin/env bash
# Crée une session Jules. Appelé par delivery-lead, jamais par Hermes.
# Usage: jules_task.sh <source_name> <project_id> <issue_id> "<prompt>" [branch] [auto_pr]
set -euo pipefail
export PATH="$PATH:/home/maxime/bin:/home/maxime/.local/bin"
source ~/esn/.env 2>/dev/null || true

SRC="$1"; PROJECT="$2"; ISSUE="$3"; PROMPT="$4"; BRANCH="${5:-main}"; AUTO_PR="${6:-0}"
: "${JULES_API_KEY:?}"

# Normalisation du format de la source (Inconnue G6 résolue)
if [[ "$SRC" != sources/* ]]; then
  if [[ "$SRC" == */* ]]; then
    SRC="sources/github/${SRC}"
  else
    SRC="sources/github/freopc/${SRC}"
  fi
fi

if hermes status 2>&1 | grep -qi "paus"; then
  echo '{"status":"refused","reason":"hermes paused"}' >&2; exit 3
fi
[ -f "$(dirname "$0")/../policies/killswitch" ] && { echo "killswitch actif" >&2; exit 3; }

USED=$(curl -fsS "https://jules.googleapis.com/v1alpha/sessions?pageSize=100" \
        -H "X-Goog-Api-Key: ${JULES_API_KEY}" \
        | jq '[.sessions[]? | select(.createTime > (now-86400|todate))] | length')
if [ "${USED:-0}" -ge "${JULES_DAILY_MAX:-70}" ]; then
  echo "{\"status\":\"refused\",\"reason\":\"plafond quotidien ${USED}\"}" >&2; exit 4
fi

BODY=$(jq -n \
  --arg p "[${PROJECT}][${ISSUE}] ${PROMPT}" \
  --arg t "[${PROJECT}][${ISSUE}]" \
  --arg s "${SRC}" --arg b "${BRANCH}" \
  --argjson pr "$([ "$AUTO_PR" = "1" ] && echo true || echo false)" \
  '{prompt:$p, title:$t,
    sourceContext:{source:$s, githubRepoContext:{startingBranch:$b}},
    requirePlanApproval:true}
   + (if $pr then {automationMode:"AUTO_CREATE_PR"} else {} end)')

curl -fsS -X POST "https://jules.googleapis.com/v1alpha/sessions" \
  -H "X-Goog-Api-Key: ${JULES_API_KEY}" \
  -H "Content-Type: application/json" -d "${BODY}"
