#!/usr/bin/env bash
# FinOps réel : agrège les rapports --usage-file de chaque run one-shot.
set -euo pipefail
: "${ESN_USAGE_DIR:=$HOME/.hermes/esn-usage}"
DAY=$(date +%F); MONTH=$(date +%Y-%m)
mkdir -p "$ESN_USAGE_DIR"

AGG=$(python3 - "$ESN_USAGE_DIR" <<'PY'
import json,sys,glob,os
c=0.0; ti=0; to=0; n=0
for f in glob.glob(os.path.join(sys.argv[1],"*.json")):
    try: d=json.load(open(f))
    except Exception: continue
    c += float(d.get("estimated_cost") or d.get("cost") or 0)
    ti+= int(d.get("prompt_tokens") or d.get("input_tokens") or 0)
    to+= int(d.get("completion_tokens") or d.get("output_tokens") or 0)
    n += int(d.get("api_calls") or 1)
print(f"{c:.4f}|{ti}|{to}|{n}")
PY
)
IFS='|' read -r COST TIN TOUT CALLS <<<"$AGG"

JULES=$(curl -fsS "https://jules.googleapis.com/v1alpha/sessions?pageSize=100" \
  -H "X-Goog-Api-Key: ${JULES_API_KEY:?}" 2>/dev/null \
  | jq '[.sessions[]? | select(.createTime > (now-86400|todate))] | length' || echo 0)

printf '| %s | cout_usd=%s | in=%s | out=%s | appels=%s | jules=%s/100 |\n' \
  "$DAY" "$COST" "$TIN" "$TOUT" "$CALLS" "$JULES" \
  | "$(dirname "$0")/sb_append.sh" "ESN/FinOps/${MONTH}.md"

if [ "${JULES:-0}" -ge 70 ]; then
  "$(dirname "$0")/bus_send.sh" esn-direction daf-finops comex P2 esn \
    "Quota Jules a ${JULES}/100" "Seuil 70 franchi." true
fi
exit 0
