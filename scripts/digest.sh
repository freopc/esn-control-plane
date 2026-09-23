#!/usr/bin/env bash
# Digest PDG. UN SEUL appel modèle par jour, one-shot, coût mesuré.
set -euo pipefail
export PATH="$PATH:/home/maxime/bin:/home/maxime/.local/bin"
DAY=$(date +%F)
: "${ESN_USAGE_DIR:=$HOME/.hermes/esn-usage}"
mkdir -p "$ESN_USAGE_DIR"

"$(dirname "$0")/finops.sh" >/dev/null 2>&1 || true
STATS=$(hermes kanban --board esn-direction stats 2>/dev/null | head -20)
CEO=$(hermes kanban --board esn-direction list 2>/dev/null | head -30 || true)

OUT=$(hermes -z "Produis le digest PDG du ${DAY}. Format imposé, 15 lignes maximum, aucune autre sortie.
Etat du board:
${STATS}
Taches ouvertes:
${CEO}" \
      --usage-file "$ESN_USAGE_DIR/digest-$(date +%s).json" \
      --reasoning minimal -m gemini-3.6-flash -t kanban)

printf '%s\n' "$OUT" | "$(dirname "$0")/sb_append.sh" "ESN/Direction/Digests/${DAY}.md"
printf '%s\n' "$OUT" | hermes send --platform telegram 2>/dev/null || printf '%s\n' "$OUT"
