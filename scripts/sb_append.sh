#!/usr/bin/env bash
# Ajoute une entrée horodatée à une page SilverBullet. Aucun token.
# Supporte l'API REST HTTP avec fallback filesystem automatique.
set -euo pipefail
PAGE="$1"; TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
WIKI_DIR="${WIKI_PATH:-/home/maxime/data/silverbullet}"

FETCHED=false
if [ -n "${SB_URL:-}" ] && [ -n "${SB_AUTH_TOKEN:-}" ]; then
  if curl -fsS --max-time 3 "${SB_URL}/.fs/${PAGE}" -H "Authorization: Bearer ${SB_AUTH_TOKEN}" > "$TMP" 2>/dev/null; then
    FETCHED=true
  fi
fi

if [ "$FETCHED" = false ]; then
  if [ -f "${WIKI_DIR}/${PAGE}" ]; then
    cp "${WIKI_DIR}/${PAGE}" "$TMP"
  fi
fi

{ printf '\n\n## %s\n\n' "$(date -Is)"; cat -; } >> "$TMP"
"$(dirname "$0")/sb_write.sh" "$PAGE" "$TMP"
