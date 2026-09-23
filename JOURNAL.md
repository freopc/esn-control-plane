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


## Phase 6 - Usine Jules
- **Date :** 2026-09-23
- **Machines :** Ubuntu (`192.168.1.206`), HA OS (conteneur Hermes), API Google Jules
- **Acteur :** Max-Orchestrator

### Actions et Réalisations :
1. **Exécution des 7 tests obligatoires (`scripts/JULES-VERIF.sh`) :**
   - **Test 1 (Inconnue G6 - Format de source) :** Résolu ! Format exact retourné par l'API : `sources/github/<owner>/<repo>` (ex: `sources/github/freopc/M365-Automation-Engine`).
   - **Test 2 (Création de session avec gate) :** Session `10324074903753772184` créée avec succès, titre respecté (`[pilote][001]`), option `requirePlanApproval: true` confirmée.
   - **Test 3 (Tenue du gate) :** L'état est resté figé sur `AWAITING_PLAN_APPROVAL` pendant les 120s d'observation sans dérive.
   - **Test 4 (Structure du plan) :** Validation de l'arborescence `.planGenerated.plan.steps[]` (titres des étapes, index).
   - **Test 5 (Approbation) :** Requête `POST :approvePlan` retournée avec le code HTTP `200` attendu. Transition immédiate vers `IN_PROGRESS`.
   - **Test 6 (Récupération du patch sans PR) :** Session passée à `COMPLETED`. Extraction réussie du diff unifié (`.changeSet.gitPatch.unidiffPatch`).
   - **Test 7 (Comptage DAF) :** Filtrage sur `createTime` opérationnel, suivi exact des volumes et états (41 sessions recensées).
2. **Ajustement des scripts du Control Plane :**
   - `jules_task.sh` : Normalisation automatique du préfixe de source (`sources/github/...`).
   - `jules_watch.sh` : Adaptation du template de parsing des étapes du plan (description optionnelle).
   - `bus_send.sh` : Ajout du chemin binaire `/home/maxime/bin` pour l'accès direct au wrapper Hermes.
   - `/home/maxime/bin/hermes` : Sérialisation stricte des arguments via `printf %q` pour l'appel distant Docker sous SSH.
3. **Création du dépôt pilote & Chaîne de production (Phases 6.3 & 6.4) :**
   - Dépôt privé créé : `https://github.com/freopc/esn-pilote` avec `AGENTS.md` conventionnel à la racine.
   - Fichiers de projet initialisés dans `esn-control-plane/projects/pilote/` (`fiche-projet.yaml`, `dod.md`, `backlog.md`).
   - Le ticket de backlog `[pilote][001]` a été exécuté par Jules, le plan a été approuvé par le `qa-lead`, le patch a été appliqué sur la branche `jules/pilote/001-hello-md`, et la PR #1 a été ouverte sur GitHub.
   - Routage automatique du statut d'achèvement sur le bus Kanban `esn-delivery` (`t_ccdd31e4`) passé à `✓ done`.

### Critère de sortie Phase 6 :
- **STATUT : ATTEINT (100%)**
- Une entrée de backlog est devenue un patch Jules validé, avec le gate d'approbation de plan effectivement franchi par le `qa-lead`.

PHASE 7 - Qualité et CI
Statut : SUCCES
Commandes exécutées : 25
Critère de sortie : ATTEINT
Inconnues rencontrées : aucune

Boucle de correction implémentée :
- CI rouge détectée (les status checks empêchent le merge et sont tracés)
- Le qa-lead lit le log et crée une tâche Kanban de correction assignée au delivery-lead.
- Le delivery-lead relance Jules avec sessionFailed.reason en contexte.
- Si 2 échecs consécutifs -> reroutage Antigravity + alerte CTO.
