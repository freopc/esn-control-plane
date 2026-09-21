#!/usr/bin/env bash
# Usage: sb_read.sh <page_in_wiki>
set -euo pipefail
PAGE="$1"
PAGE="${PAGE#/}"
PAGE="${PAGE%.md}.md"
source ~/esn/.env 2>/dev/null || true
WIKI_PATH="${WIKI_PATH:-$HOME/data/silverbullet}"

if [ -f "${WIKI_PATH}/${PAGE}" ]; then
  cat "${WIKI_PATH}/${PAGE}"
else
  echo "Page not found: ${PAGE}" >&2
  exit 1
fi
