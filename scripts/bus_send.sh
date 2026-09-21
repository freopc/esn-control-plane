#!/usr/bin/env bash
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

TASK=$(hermes kanban create "[${PROJECT}][${FROM}->${TO}][${SEV}] ${SUBJECT}" \
        --body "${BODY_FULL}" --board "${BOARD}" | grep -oE '[0-9]+' | head -1)
hermes kanban assign "${TASK}" "${TO}" --board "${BOARD}" >/dev/null
echo "${TASK}"
