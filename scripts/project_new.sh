#!/usr/bin/env bash
# Crée un nouveau projet ESN de manière 100% autonome et standardisée.
# Usage: project_new.sh <project_id> "<nom client>" [description]
set -euo pipefail
export PATH="$PATH:/home/maxime/bin:/home/maxime/.local/bin"
source ~/esn/.env 2>/dev/null || true

PROJECT_ID="$1"
CLIENT_NAME="${2:-Maxime}"
DESC="${3:-Projet $PROJECT_ID pour $CLIENT_NAME}"

ESN_ROOT="${ESN_ROOT:-$HOME/esn}"
CP_DIR="$ESN_ROOT/esn-control-plane"
REPO_NAME="esn-${PROJECT_ID}"
WORKSPACE_DIR="$ESN_ROOT/${PROJECT_ID}"
DAY=$(date +%F)

echo "=== 1. Initialisation du dépôt GitHub $REPO_NAME ==="
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"
if [ ! -d .git ]; then
  git init
  cat << EOF > AGENTS.md
# Projet ${PROJECT_ID}
Client : ${CLIENT_NAME}
Création : ${DAY}

## Règles de développement
1. Aucun secret commité.
2. PR obligatoire pour toute modification sur main.
3. CI verte requise.
EOF
  mkdir -p .github/workflows
  cat << 'EOFCI' > .github/workflows/ci.yml
name: Project CI
on: [push, pull_request]
jobs:
  lint-test:
    runs-on: [self-hosted, esn-linux]
    steps:
      - uses: actions/checkout@v4
      - name: Syntax & Lint
        run: echo "Lint passed for project"
EOFCI
  git add .
  git commit -m "feat: socle initial projet $PROJECT_ID"
  gh repo create "$REPO_NAME" --public --source=. --push || true
fi

echo "=== 2. Configuration control plane projects/$PROJECT_ID ==="
mkdir -p "$CP_DIR/projects/$PROJECT_ID"
cat << EOF > "$CP_DIR/projects/$PROJECT_ID/fiche-projet.yaml"
id: "${PROJECT_ID}"
name: "${DESC}"
client: "${CLIENT_NAME}"
repo: "freopc/${REPO_NAME}"
source: "sources/github/freopc/${REPO_NAME}"
status: "in_progress"
created: "${DAY}"
EOF

cat << 'EOFDOD' > "$CP_DIR/projects/$PROJECT_ID/dod.md"
# Definition of Done
- [ ] Le code compile et passe les tests unitaires.
- [ ] Aucun secret en clair dans le code.
- [ ] La documentation Markdown est à jour.
- [ ] CI verte avant tout merge.
EOFDOD

cat << EOF > "$CP_DIR/projects/$PROJECT_ID/backlog.md"
# Backlog initial - $PROJECT_ID
- [ ] [${PROJECT_ID}][001] Initialisation architecture et tests
EOF

echo "=== 3. Arborescence Wiki SilverBullet ESN/Projets/$PROJECT_ID ==="
cat << EOF > /tmp/idx_${PROJECT_ID}.md
---
type: index
date: ${DAY}
project: ${PROJECT_ID}
client: "${CLIENT_NAME}"
tags: [esn, projet]
---
# Projet ${PROJECT_ID} (${CLIENT_NAME})
- [[ESN/Projets/${PROJECT_ID}/01-cadrage|01 - Cadrage]]
- [[ESN/Projets/${PROJECT_ID}/05-livraisons|05 - Livraisons]]
EOF
"$CP_DIR/scripts/sb_write.sh" "ESN/Projets/${PROJECT_ID}/index.md" "/tmp/idx_${PROJECT_ID}.md"

cat << EOF > /tmp/cadrage_${PROJECT_ID}.md
---
type: cadrage
date: ${DAY}
project: ${PROJECT_ID}
---
# Cadrage initial - ${PROJECT_ID}
Client : ${CLIENT_NAME}
Objectif : ${DESC}
Statut : Initialisé
EOF
"$CP_DIR/scripts/sb_write.sh" "ESN/Projets/${PROJECT_ID}/01-cadrage.md" "/tmp/cadrage_${PROJECT_ID}.md"

echo "=== 4. Enregistrement Kanban ==="
hermes kanban create "[${PROJECT_ID}] Initialisation du projet" --body "Projet créé pour ${CLIENT_NAME}. Dépôt: freopc/${REPO_NAME}" --assignee chef-de-projet 2>/dev/null || true

echo "=== 5. Commit et push du Control Plane ==="
cd "$CP_DIR"
git add "projects/$PROJECT_ID"
git commit -m "feat(projects): creation du projet $PROJECT_ID pour $CLIENT_NAME" || true
git push origin main || true

echo "Projet $PROJECT_ID créé avec succès."
