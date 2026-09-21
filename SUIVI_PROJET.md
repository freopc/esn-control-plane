# 📊 Suivi de Projet : ESN Virtuelle Multi-Agents

- **Projet :** Plateforme d'orchestration multi-agents ESN Virtuelle (Hermes + Antigravity + Jules)
- **Client & Opérateur :** Maxime (freopc)
- **Orchestrateur :** Max-Orchestrator
- **Dernière mise à jour :** 2026-09-21 16:50 (Europe/Paris)
- **Statut Global :** 🟢 **JALON 1 HOMOLOGUÉ À 100% (Phases 1 à 4)**
- **Avancement Global :** **36%** (4 / 11 phases validées avec succès)
- **Dépôt Control Plane :** `freopc/esn-control-plane` (GitHub privé)
- **Dernier Commit Validé :** `d9206f7`

---

## 📈 Tableau de Bord d'Avancement par Jalon

```
[████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 36% Terminé (Jalon 1 / 4)
```

| Jalon | Intitulé | Phases | Statut | Criticité |
| :---: | :--- | :---: | :---: | :---: |
| **Jalon 1** | **Fondations, Plateforme & Communication** | Phases 1 à 4 | 🟢 **100% Validé** | Bloquant |
| **Jalon 2** | **Usine Logicielle & Cerveau** | Phases 5 à 7 | ⏳ *À démarrer* | Élevée |
| **Jalon 3** | **Surveillance, Sécurité & Fonctions Support** | Phases 8 et 9 | ⏳ *En attente* | Haute |
| **Jalon 4** | **Homologation, Recette & Industrialisation** | Phases 10 et 11 | ⏳ *En attente* | Finale |

---

## ✅ Jalon 1 : Fondations, Plateforme & Communication (100 %)

### Phase 1 : Prérequis, Inventaire & Sauvegardes
- [x] **1.1 Test de persistance HA OS** :
  - Vérification de `~/.hermes` résolvant vers `/root/.hermes` monté sur partition physique `/dev/sda8` (117 Go dispo, persistance totale validée).
- [x] **1.2 Grand inventaire CLI** :
  - Hermes Agent `v0.21.3` (DB WAL, répertoires ok).
  - Antigravity CLI `v1.2.7`.
  - GitHub CLI authentifié sur `freopc` (scopes `repo`, `workflow`, `gist`).
  - Outil `jq` installé sur Windows (`jq-1.8.2` dans le PATH).
  - Validation de la connectivité réseau et des accès SSH.
- [x] **1.3 Gestion des clés et secrets** :
  - Délégation sécurisée à `@cyber-security` pour isoler les secrets hors de l'historique de chat.
  - Clés SSH Ed25519 dédiées et restrictives.
  - Fichier `~/esn/.env` chiffré (permissions `600`) contenant `JULES_API_KEY`, `SB_AUTH_TOKEN`, etc.
- [x] **1.4 Sauvegardes initiales (Baseline)** :
  - Sauvegarde complète du conteneur Hermes (`hermes-backup-2026-09-21-155216.zip`, 115 Mo) extraite sur `/data/` hors conteneur.
  - Baseline Git initialisée et sécurisée sur le wiki SilverBullet.
- [x] **1.5 Validation des décisions architecturales de démarrage** :
  - 9 agents au lancement, digest PDG à 08:00 Europe/Paris, modèle Hermes Flash, premier projet `pilote`.

### Phase 2 : Control Plane & Wiki
- [x] **2.1 Arborescence Control Plane sur Ubuntu (`192.168.1.206`)** :
  - Structure créée : `agents/`, `hermes/`, `policies/`, `projects/`, `scripts/`, `templates/`.
- [x] **2.2 Déploiement des livrables de la PARTIE F** :
  - `charte-esn.md` (10 règles non-négociables).
  - Âmes et mémoires : `SOUL-client.md`, `SOUL-direction.md`, `MEMORY.md`.
  - 17 fiches de poste d'agents avec frontmatter YAML complet.
  - Politiques de gouvernance : `routing.yaml`, `budgets.yaml`, `escalation.yaml`.
  - 11 scripts d'orchestration dans `scripts/` (droits `755`, validés `bash -n`).
- [x] **2.3 Initialisation du Wiki SilverBullet** :
  - 12 rubriques initialisées sous `ESN/` (`Charte`, `Direction`, `Agents`, `Projets`, `Securite`, etc.).
  - Consignation horodatée de test réussie.
- [x] **2.4 Sauvegarde automatique du wiki** :
  - Tâche Cron configurée à 03:00 pour la sauvegarde quotidienne vers le NAS Elijah.
- [x] **2.5 Synchronisation Git & GitHub** :
  - Dépôt privé `freopc/esn-control-plane` créé, synchronisé et pushé (commits `b54077f`, `eac0b63`).

### Phase 3 : Profils Hermes
- [x] **3.1 Découverte syntaxe CLI (Inconnue G1)** :
  - Sous-verbes `hermes profile` recensés (`list`, `create`, `describe`, `use`, `export`, etc.).
- [x] **3.2 Création des profils étanches** :
  - Profil `client` : Interface compte client, qualifie et route vers le Kanban.
  - Profil `direction` : Secrétaire général de l'ESN, unique interface avec le PDG.
- [x] **3.3 Confinement structurel & politique zéro coût** :
  - Outils coûteux désactivés sur `client` (`code_execution`, `terminal`, `browser`, `web_search`, `image_gen`, `skills`).
  - Toolsets restreints au strict nécessaire : `kanban` et `memory`.
  - `agent.reasoning_effort: minimal`.
- [x] **3.4 Configuration des LLM auxiliaires (Inconnue G5)** :
  - `auxiliary.triage_specifier` et `auxiliary.kanban_decomposer` configurés sur `gemini-3.6-flash`.
- [x] **3.5 Injection des personnalités** :
  - `SOUL.md` et `MEMORY.md` injectés dans chaque profil sur HA OS.
- [x] **3.6 Test d'étanchéité & mesure de tokens** :
  - Épreuve : Demande d'un script Python au profil `client`.
  - Résultat : **Refus catégorique de coder**, création automatique d'une carte Kanban assignée à un `developer`.
  - Consommation : **124 tokens en sortie** (seuil critique < 800 tokens largement respecté).
- [x] **3.7 Synchronisation des configurations** :
  - Export vers `hermes/config-client.yaml` et `hermes/config-direction.yaml`, commit `b81d608`.

### Phase 4 : Message Bus Kanban
- [x] **4.1 Initialisation et Boards (Inconnue G3)** :
  - Syntaxe validée : `hermes kanban boards create <slug>`.
  - Création des boards isolés `esn-direction` et `esn-delivery`.
- [x] **4.2 Syntaxe des tâches (Inconnue G2)** :
  - Paramètre de corps validé : `--body` (utilisé dans `bus_send.sh`).
- [x] **4.3 Service Gateway & Dispatcher temps réel** :
  - Démarré sous superviseur s6 (`hermes gateway start`, PID actif).
  - Boucle d'arbitrage automatique active toutes les 60 secondes.
- [x] **4.4 Traversée hiérarchique à coût zéro token** :
  - 2 alertes P2 transmises sans consommer de tokens (`[pilote][rssi->cto][P2]` et `[pilote][cto->comex][P2]`).
  - Assignations respectives vers `cto` et `comex`.
- [x] **4.5 Test de décomposition automatique (Decomposer)** :
  - Tâche `Outil de suivi de consommation` créée en colonne triage sur `esn-delivery`.
  - Décomposition réussie par le modèle auxiliaire en 3 tâches enfants ordonnées (`client`, `default`, `direction`).
  - Prise en charge autonome par le dispatcher : passage automatique de la première tâche à `✓ done`.
- [x] **4.6 Résilience & Redémarrage** :
  - Tâches et états conservés à 100% après redémarrage de la gateway.
  - Mise à jour et push du script `bus_send.sh` et du `JOURNAL.md` (commit `d9206f7`).

---

## ⚠️ Registre des Points Sensibles & Pièges Techniques Rencontrés

Ce registre consigne les écueils réels, les incompatibilités d'environnement et les solutions appliquées pour éviter toute régression future :

| # | Sujet | Problème Rencontré | Solution & Règle Appliquée |
| :---: | :--- | :--- | :--- |
| **PS-01** | **Chiffrement SSH HA OS** | La négociation OpenSSH Windows 9.5 vers HA OS 10.3 échoue avec `Corrupted MAC on input`. | **Règle absolue :** Toujours spécifier le cipher `-c aes256-gcm@openssh.com` pour toute connexion vers `192.168.1.204` (configuré dans `~/.ssh/config`). |
| **PS-02** | **Topologie Windows** | Confusion initiale entre le poste d'orchestration portable (`CHATS-PC`) et le poste fixe cible (`win-fixe` / `192.168.1.201`). | `esn-windows` est fixé sur `192.168.1.201` (user `maxime`). Le fichier `~/.ssh/config` et `.env` ont été corrigés en conséquence. |
| **PS-03** | **Permissions SSH Windows** | Les clés dans `~/.ssh/authorized_keys` sur Windows ne sont pas lues pour les comptes Administrateurs. | Déploiement de la clé publique dans `C:\ProgramData\ssh\administrators_authorized_keys` pour autoriser `esn-windows`. |
| **PS-04** | **API SilverBullet vs Filesystem** | L'endpoint HTTP REST `PUT /.fs/` de SilverBullet n'est pas exposé directement en écriture externe. | **Double mode :** Le script `sb_write.sh` teste l'API HTTP, et bascule de façon transparente en écriture fichier directe sur `/home/maxime/data/silverbullet/` avec commit Git. |
| **PS-05** | **Syntaxe Hermes CLI (`--board`)** | Le flag `--board <slug>` n'est pas un argument global terminal. S'il est placé à la fin, la CLI renvoie `unrecognized argument`. | **Ordre strict :** Placer le flag immédiatement après la commande principale : `hermes kanban --board <slug> <action> [args]`. Le script `bus_send.sh` a été adapté. |
| **PS-06** | **Exécution déportée Hermes** | L'exécutable `hermes` n'est pas installé nativement sur Ubuntu, mais vit dans le conteneur HA OS. | Création d'un wrapper transparent `/home/maxime/bin/hermes` sur Ubuntu qui proxifie directement les appels vers `docker exec app_19006e5f_hermes_assistant hermes "$@"` via SSH. |
| **PS-07** | **Modèles de langage & Dépréciations** | Les anciennes dénominations `gemini-flash` ou `gemini-2.5` sont obsolètes ou ambiguës sur l'API Google AI Studio. | Configuration explicite sur `gemini-3.6-flash` pour le runtime Hermes et les fonctions auxiliaires (triage/decomposeur). |
| **PS-08** | **Processus arrière-plan & SSH** | Des commandes SSH enchaînées avec des quotes imbriquées sous PowerShell peuvent suspendre la sous-tâche en attente stdin. | Privilégier le passage par fichier script temporaire ou encodage Base64 propre pour tout déploiement non-interactif. |

---

## 🗺️ Feuille de Route des Prochains Jalons

### 🔹 Jalon 2 : Usine Logicielle & Cerveau
- [ ] **Phase 5 : Antigravity et les équipes**
  - [ ] Déploiement des 17 fiches de poste sous `~/.gemini/config/agents/` (Ubuntu & Windows).
  - [ ] Contrôle des tiers de modèles (`pro` réservé à `presales-architect`, `cto`, `rssi`, `qa-lead`).
  - [ ] Test de mission autonome Antigravity (`agy -p`) avec production de livrable dans SilverBullet.
  - [ ] Exposition du dispatch Hermes via hook / tool.
- [ ] **Phase 6 : Usine Jules**
  - [ ] Validation des 7 tests d'API Jules (`scripts/JULES-VERIF.sh`).
  - [ ] Vérification du nom exact de source GitHub (`ListSources`).
  - [ ] Test du cycle de vie complet d'une session (`AWAITING_PLAN_APPROVAL` -> `approvePlan` -> PR).
- [ ] **Phase 7 : Qualité et CI**
  - [ ] Mise en place des workflows GitHub Actions (linter, tests, branch protection).
  - [ ] Règle stricte de validation par le `qa-lead`.

### 🔹 Jalon 3 : Surveillance, Sécurité & Support
- [ ] **Phase 8 : Fonctions support autonomes**
  - [ ] Rapport FinOps quotidien (`scripts/finops.sh`).
  - [ ] Digest PDG de 08:00 (`scripts/digest.sh`) via canal Telegram / SilverBullet.
  - [ ] Gestion des incidents Run et veille R&D.
- [ ] **Phase 9 : Sécurité et Arrêt d'urgence**
  - [ ] Audit des secrets et dépendances par le `rssi`.
  - [ ] Test du coupe-circuit d'urgence (`hermes pause` et fichier killswitch).

### 🔹 Jalon 4 : Homologation & Industrialisation
- [ ] **Phase 10 : Recette de bout en bout**
  - [ ] Traitement d'un projet réel complet de A à Z (Client -> Qualification -> Kanban -> Jules -> PR -> Digest).
- [ ] **Phase 11 : Industrialisation**
  - [ ] Documentation finale, fiches d'exploitation et passage en mode nominal.
