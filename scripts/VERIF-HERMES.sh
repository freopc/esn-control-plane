#!/usr/bin/env bash
# Collecte les inconnues Hermes. À lancer sur HA OS.
echo "=== persistance /data ===";  readlink -f ~/.hermes; df -h /data 2>/dev/null | tail -2
echo "=== profile ===";            hermes profile --help 2>&1 | head -30
echo "=== kanban create ===";      hermes kanban create --help 2>&1 | head -30
echo "=== kanban boards ===";      hermes kanban boards --help 2>&1 | head -25
echo "=== send ===";               hermes send --help 2>&1 | head -25
echo "=== cron create ===";        hermes cron create --help 2>&1 | head -25
echo "=== auxiliary ===";          hermes config 2>&1 | grep -iA3 auxiliary | head -20
echo "=== tools ===";              hermes tools 2>&1 | head -30
echo "=== doctor ===";             hermes doctor 2>&1 | head -30
