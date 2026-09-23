#!/usr/bin/env bash
# Archive un projet ESN de manière propre.
# Usage: project_archive.sh <project_id>
set -euo pipefail
export PATH="$PATH:/home/maxime/bin:/home/maxime/.local/bin"
source ~/esn/.env 2>/dev/null || true

PROJECT_ID="$1"
ESN_ROOT="${ESN_ROOT:-$HOME/esn}"
CP_DIR="$ESN_ROOT/esn-control-plane"
REPO_NAME="esn-${PROJECT_ID}"
DAY=$(date +%F)

echo "=== 1. Archivage GitHub de freopc/$REPO_NAME ==="
gh repo archive "freopc/$REPO_NAME" --yes 2>/dev/null || echo "Repo distant non trouvé ou déjà archivé"

echo "=== 2. Gel des pages Wiki ==="
BANDEAU="> ⚠️ **PROJET ARCHIVÉ LE ${DAY}** - Lecture seule"
if [ -d "/home/maxime/data/silverbullet/ESN/Projets/${PROJECT_ID}" ]; then
  for f in "/home/maxime/data/silverbullet/ESN/Projets/${PROJECT_ID}"/*.md; do
    if [ -f "$f" ]; then
      sed -i "1s|^|${BANDEAU}\n\n|" "$f" 2>/dev/null || true
    fi
  done
fi

echo "=== 3. Suppression du Workspace local ==="
rm -rf "$ESN_ROOT/${PROJECT_ID}"

echo "=== 4. Mise à jour statut control plane ==="
if [ -f "$CP_DIR/projects/$PROJECT_ID/fiche-projet.yaml" ]; then
  sed -i 's/status: "in_progress"/status: "archived"/' "$CP_DIR/projects/$PROJECT_ID/fiche-projet.yaml"
  cd "$CP_DIR"
  git add "projects/$PROJECT_ID"
  git commit -m "chore(projects): archivage du projet $PROJECT_ID" || true
  git push origin main || true
fi

echo "Projet $PROJECT_ID archivé avec succès."
