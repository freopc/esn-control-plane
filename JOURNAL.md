# JOURNAL DE BORD DU CONTROL PLANE ESN

## Phase 2 - Control Plane et Wiki
- **Date :** 2026-09-21
- **Machine :** Ubuntu (`esn-ubuntu` / 192.168.1.206)
- **Utilisateur :** maxime
- **Acteur :** Agent Antigravity DevOps
- **Dépôt GitHub :** https://github.com/freopc/esn-control-plane (privé)

### Actions et Réalisations :
1. **Arborescence créée :**
   - `~/esn/esn-control-plane/` avec `agents/{direction,frontoffice,delivery,support}`, `hermes/`, `policies/`, `projects/`, `scripts/`, `templates/`.
2. **Fichiers PARTIE F générés :**
   - `charte-esn.md` (F.1)
   - `hermes/SOUL-client.md` (F.2)
   - `hermes/SOUL-direction.md` (F.3)
   - `hermes/MEMORY.md` (F.4)
   - `hermes/config-client.yaml` et `hermes/config-direction.yaml`
   - Fiches de poste des 17 agents réparties dans `agents/*/*.md` selon le gabarit F.5.
   - `policies/routing.yaml` (F.6), `policies/budgets.yaml` (F.7), `policies/escalation.yaml` (F.8).
   - 11 scripts dans `scripts/` (F.10) : `sb_write.sh`, `sb_append.sh`, `bus_send.sh`, `dispatch.sh`, `jules_task.sh`, `jules_watch.sh`, `jules_approve.sh`, `finops.sh`, `digest.sh`, `JULES-VERIF.sh`, `VERIF-HERMES.sh`.
   - Permissions `755` appliquées sur tous les scripts.
   - Validation syntaxique sans erreur via `bash -n scripts/*.sh`.
   - Fallback filesystem transparent vers `${WIKI_PATH:-/home/maxime/data/silverbullet}` intégré dans `sb_write.sh` et `sb_append.sh`.
3. **Variables d'environnement :**
   - Création de `/home/maxime/esn/.env` avec permissions `600`.
   - `.env` inclus dans `.gitignore`.
4. **Git et GitHub :**
   - Initialisation du dépôt local avec branche `main`.
   - Premier commit : `b54077f` ("socle ESN").
   - Création et push du dépôt privé `freopc/esn-control-plane`.
5. **Initialisation Wiki SilverBullet :**
   - Création des 12 rubriques sous `ESN/` (`Charte`, `Direction/Decisions`, `Direction/Digests`, `Direction/Comites`, `Agents`, `Projets`, `Conversations/Client`, `Conversations/Direction`, `Securite`, `Infra`, `FinOps`, `Veille`).
   - Copie de `charte-esn.md` en page d'accueil `ESN/index.md`.
   - Test réussi d'ajout horodaté via `sb_append.sh` dans `ESN/Conversations/Direction/2026-09-21.md`.
6. **Sauvegarde :**
   - Tâche cron quotidienne à 03:00 ajoutée pour auto-commit du dossier SilverBullet.

### Critère de sortie Phase 2 :
- **STATUT : ATTEINT**
- Vérification :
  - Pages écrites avec frontmatter présentes et lisibles dans SilverBullet (`/home/maxime/data/silverbullet/ESN/`).
  - Dépôt Git synchronisé sur GitHub (`freopc/esn-control-plane`).
  - Backup cron planifié.

## Phase 4 - Message bus Kanban
- **Date :** 2026-09-21
- **Machines :** HA OS (conteneur Hermes), Ubuntu (control plane)
- **Acteur :** Max-Orchestrator

### Actions et Réalisations :
1. **Initialisation Kanban & Création des Boards (Inconnue G3) :**
   - Inconnue G3 résolue : syntaxe exacte confirmée (hermes kanban boards create <slug>).
   - Boards créés : sn-direction et sn-delivery.
2. **Syntaxe des tâches (Inconnue G2) :**
   - Inconnue G2 résolue : l'option de corps est bien --body (hermes kanban create --body).
   - Correction et validation de scripts/bus_send.sh avec positionnement strict du flag --board <slug>.
3. **Démarrage du Dispatcher & Gateway :**
   - Service gateway configuré et démarré sous supervision s6 (hermes gateway start, PID actif).
   - Dispatcher intégré en boucle active toutes les 60s.
4. **Test de la hiérarchie à coût nul (Phase 4.5) :**
   - Émission de 2 alertes P2 sur sn-direction ([pilote][rssi->cto][P2] et [pilote][cto->comex][P2]).
   - Assignation respective à cto et comex sans consommer le moindre token modèle.
   - Vérification de la persistance après redémarrage de la gateway : tâches 100% conservées.
5. **Test de décomposition automatique (Phase 4.6) :**
   - Création de la tâche de triage Outil de suivi de consommation sur sn-delivery.
   - Exécution de hermes kanban decompose via le LLM auxiliaire gemini-3.6-flash.
   - Fan-out réussi : 3 tâches enfants générées dans un graphe ordonné et assignées aux profils spécialisés (client et direction).
   - Exécution autonome par le dispatcher : la première tâche enfant client a été traitée et passée à l'état done !
   - Documentation de hermes kanban swarm.

### Critère de sortie Phase 4 :
- **STATUT : ATTEINT**
- Les messages ont traversé la hiérarchie à coût nul.
- Les tâches ont survécu au redémarrage de la gateway.
- La décomposition a produit un graphe d'enfants complet et orchestré.

## Phase 5 - Antigravity et les équipes
- **Date :** 2026-09-21
- **Machines :** Ubuntu (`192.168.1.206`), Windows `win-fixe` (`192.168.1.201`), HA OS (conteneur Hermes)
- **Acteur :** Max-Orchestrator

### Actions et Réalisations :
1. **Déploiement des 17 fiches de poste (Phase 5.1) :**
   - 17 fichiers agents déployés dans `~/.gemini/config/agents/` sur Ubuntu (`esn-ubuntu`).
   - 17 fichiers agents déployés dans `C:\Users\maxime\.gemini\config\agents\` sur Windows (`win-fixe`).
   - 17 fichiers agents déployés sur la machine Windows locale.
   - Vérification de la commande `agy agents` : les 17 agents sont reconnus sur tous les environnements.
2. **Vérification stricte des tiers de modèles (Phase 5.2) :**
   - `model: pro` strictement réservé aux 4 rôles stratégiques : `presales-architect`, `cto`, `rssi`, `qa-lead`.
   - `model: flash` assigné aux 13 autres rôles opérationnels.
3. **Test autonome de sous-agent Antigravity (Phase 5.3) :**
   - Test exécuté sur Ubuntu avec `presales-architect` en mode non-interactif (`agy -p` avec `--dangerously-skip-permissions`).
   - Durée : 13.9s, sortie JSON valide, 5 lignes de réponse, livrable `ESN/Projets/pilote/01-cadrage.md` créé dans SilverBullet.
4. **Exposition du dispatch à Hermes (Phase 5.4) :**
   - Scripts wrappers déployés dans `/data/hermes/bin/` et `/usr/local/bin/` sur le conteneur Hermes : `dispatch`, `bus_send`, `sb_read`, `sb_write`, `sb_append`.
   - Arguments transmis de manière étanche via SSH vers Ubuntu grâce à `printf %q`.
   - Création de la skill Hermes `esn-dispatch` dans `/data/hermes/skills/esn-dispatch/SKILL.md`.
   - Configuration d'un hook shell Hermes `on_kanban_dispatch.py` (événement `post_tool_call`, matcher `kanban.*`) avec auto-acceptation et inscription dans `shell-hooks-allowlist.json`.
5. **Garde-fous budgétaires et anti-boucle (Phase 5.5) :**
   - Vérification de l'absence totale de référence à `agy` dans les crontabs (Ubuntu, HA OS, Windows).
   - Inscription et validation des seuils dans `policies/budgets.yaml`.
6. **Validation du Critère de Sortie Phase 5 :**
   - Requête envoyée au profil Hermes `client` : "Bonjour, nous souhaitons lancer le projet pilote pour un outil de suivi de consommation électrique. Peux-tu faire cadrer ce projet par l'architecte avant-vente ?".
   - Le profil `client` a répondu en exactement 5 lignes selon la charte `SOUL-client.md`.
   - Le hook Hermes a déclenché le dispatch vers `presales-architect` sous Antigravity.
   - La note de cadrage complète a été rédigée et intégrée dans SilverBullet sous `ESN/Projets/suivi-consommation-electrique/01-cadrage.md` et `ESN/Projets/pilote/01-cadrage.md`.
   - Consommation mesurée sur Hermes : 176 tokens de sortie (< 3000 tokens imposés).

### Critère de sortie Phase 5 :
- **STATUT : ATTEINT (100%)**
- Demande au profil client a produit la note de cadrage dans le wiki pour moins de 3 000 tokens mesurés.
