#!/usr/bin/env bash
set -euo pipefail
# Tâche nocturne pour l archiviste
"$(dirname "$0")/bus_send.sh" esn-direction cron archiviste P3 pilote "Hygiène du wiki" "Merci de vérifier les liens morts et de générer les index." false
EOF
chmod +x ~/esn/esn-control-plane/scripts/wiki_hygiene.sh
