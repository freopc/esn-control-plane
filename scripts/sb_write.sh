#!/usr/bin/env bash
# Écrit une page SilverBullet. Aucun token.
# Supporte l'API REST HTTP avec fallback filesystem automatique.
set -euo pipefail
PAGE="$1"; SRC="${2:--}"
WIKI_DIR="${WIKI_PATH:-/home/maxime/data/silverbullet}"

TMP_INPUT=""
if [ "$SRC" = "-" ]; then
  TMP_INPUT=$(mktemp)
  cat - > "$TMP_INPUT"
  SRC="$TMP_INPUT"
  trap 'rm -f "$TMP_INPUT"' EXIT
fi

WRITTEN=false
if [ -n "${SB_URL:-}" ] && [ -n "${SB_AUTH_TOKEN:-}" ]; then
  if curl -fsS --max-time 3 -X PUT "${SB_URL}/.fs/${PAGE}" \
       -H "Authorization: Bearer ${SB_AUTH_TOKEN}" \
       -H "Content-Type: text/markdown" \
       --data-binary "@${SRC}" >/dev/null 2>&1; then
    WRITTEN=true
  fi
fi

if [ "$WRITTEN" = false ]; then
  DEST="${WIKI_DIR}/${PAGE}"
  mkdir -p "$(dirname "$DEST")"
  cp "$SRC" "$DEST"
fi

echo "sb://${PAGE}"
