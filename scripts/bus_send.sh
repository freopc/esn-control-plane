#!/usr/bin/env bash
export PATH="/home/maxime/bin:/home/maxime/.local/bin:$PATH"
# Message inter agents sur le Kanban. ZERO token.
# Usage: bus_send.sh <board> <from> <to> <P1|P2|P3|P4> <project_id> "<sujet>" "<corps>" [needs_ceo]
set -euo pipefail
BOARD="$1"; FROM="$2"; TO="$3"; SEV="$4"; PROJECT="$5"; SUBJECT="$6"; BODY="${7:-}"; CEO="${8:-false}"

read -r -d '' BODY_FULL <<YAML || true
from: ${FROM}
to: ${TO}
type: alert
severity: ${SEV}
project: ${PROJECT}
needs_ceo: ${CEO}

${BODY}
YAML

TASK=$(hermes kanban --board "${BOARD}" create "[${PROJECT}][${FROM}->${TO}][${SEV}] ${SUBJECT}" \
        --body "${BODY_FULL}" | grep -oE 't_[a-z0-9]+|[0-9]+' | head -1)
hermes kanban --board "${BOARD}" assign "${TASK}" "${TO}" >/dev/null
echo "${TASK}"
