#!/usr/bin/env bash
# Lance les 7 tests Jules. Prérequis : JULES_API_KEY exporté, jq installé.
set -uo pipefail
H="X-Goog-Api-Key: ${JULES_API_KEY:?}"
A="https://jules.googleapis.com/v1alpha"

echo "=== TEST 1 : format de source (LE test critique) ==="
curl -sS -H "$H" "$A/sources" | jq .
SRC=$(curl -sS -H "$H" "$A/sources" | jq -r '.sources[0].name // empty')
[ -z "$SRC" ] && { echo "Aucune source. Installer l'app GitHub Jules."; exit 1; }
echo ">>> source : $SRC"

echo "=== TEST 2 : creation avec gate ==="
RESP=$(curl -sS -X POST "$A/sessions" -H "$H" -H "Content-Type: application/json" \
  -d "$(jq -n --arg s "$SRC" '{
    prompt:"[pilote][001] Ajoute un fichier HELLO.md avec une ligne de description.",
    title:"[pilote][001]",
    sourceContext:{source:$s, githubRepoContext:{startingBranch:"main"}},
    requirePlanApproval:true}')")
echo "$RESP" | jq .
SID=$(jq -r '.id // .name' <<<"$RESP" | sed 's|sessions/||')

echo "=== TEST 3 : le gate tient-il ? (120s) ==="
sleep 120
curl -sS -H "$H" "$A/sessions/$SID" | jq '{state, url, title}'

echo "=== TEST 4 : structure du plan ==="
curl -sS -H "$H" "$A/sessions/$SID/activities?pageSize=50" \
  | jq '[.activities[] | select(.planGenerated)] | last'

echo "=== TEST 5 : approbation (200 attendu) ==="
curl -sS -o /dev/null -w "%{http_code}\n" -X POST "$A/sessions/$SID:approvePlan" \
  -H "$H" -H 'Content-Type: application/json' -d '{}'

echo "=== TEST 7 : comptage DAF ==="
curl -sS -H "$H" "$A/sessions?pageSize=100" \
  | jq '{total:(.sessions|length), etats:([.sessions[].state]|group_by(.)|map({(.[0]):length})|add)}'

echo ""
echo ">>> TEST 6, dans ~10 min quand la session sera COMPLETED :"
echo "curl -sS -H \"\$H\" \"$A/sessions/$SID/activities?pageSize=100\" | jq '[.activities[].artifacts[]? | select(.changeSet)] | last'"
