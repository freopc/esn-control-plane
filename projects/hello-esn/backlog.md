# Backlog - Projet hello-esn

## Sprint 1 : Socle Technique & Implémentation Core

### US-01 : Initialisation du Repository & Dépendances
- **Priorité :** P0 (Bloquant)
- **Estimation :** 1 SP
- **Description :** Mettre en place la structure de répertoires standard (`app/`, `tests/`, `alembic/`), le fichier `pyproject.toml` avec FastAPI, Uvicorn, SQLAlchemy 2.0, Alembic, Pydantic v2, pytest, httpx, ruff et `.env.example`.
- **Critères d'acceptation :**
  - Arborescence conforme à l'architecture.
  - Environnement virtuel installable sans conflit.

### US-02 : Modélisation DB, Schémas SQLAlchemy & Migrations Alembic
- **Priorité :** P0 (Bloquant)
- **Estimation :** 2 SP
- **Description :** Définir les modèles SQLAlchemy `Message` et `AuditLog`, configurer la gestion des sessions pour SQLite et PostgreSQL, et créer la migration initiale Alembic insérant le message par défaut `"Hello ESN"`.
- **Critères d'acceptation :**
  - Tables `messages` et `audit_logs` créées avec indexes appropriés.
  - Migration initiale fonctionnelle via `alembic upgrade head`.

### US-03 : Endpoints Publics (GET / & GET /health)
- **Priorité :** P1 (Haute)
- **Estimation :** 1 SP
- **Description :** Développer le point d'entrée d'accueil `/` retournant le message actif et le endpoint `/health` vérifiant la connectivité DB.
- **Critères d'acceptation :**
  - `GET /` retourne `{"message": "Hello ESN"}` en code 200.
  - `GET /health` valide la santé du service.

### US-04 : Endpoints de Gestion Message & Traçabilité d'Audit (GET / PUT /api/v1/message)
- **Priorité :** P1 (Haute)
- **Estimation :** 3 SP
- **Description :** Implémenter les routes de lecture détaillée et de mise à jour du message. La route `PUT` doit être sécurisée par Bearer token ou X-API-Key, et générer systématiquement une entrée dans `audit_logs`.
- **Critères d'acceptation :**
  - Accès refusé (401) en l'absence de token valide.
  - Mise à jour effective et log d'audit enregistré avec IP et identifiant.

### US-05 : Durcissement Sécurité & Headers HTTP
- **Priorité :** P1 (Haute)
- **Estimation :** 1 SP
- **Description :** Configurer le middleware injectant les en-têtes HTTP de sécurité (CSP, HSTS, X-Content-Type-Options, X-Frame-Options) et la gestion d'un `X-Request-ID`.
- **Critères d'acceptation :**
  - Tous les en-têtes de sécurité requis sont présents dans chaque réponse HTTP.

### US-06 : Suite de Tests Automatisés & Qualité (pytest, ruff, mypy)
- **Priorité :** P1 (Haute)
- **Estimation :** 2 SP
- **Description :** Écrire les tests unitaires et d'intégration avec `pytest` et `TestClient`, couvrant les cas nominaux et d'erreurs (auth, validation Pydantic).
- **Critères d'acceptation :**
  - Couverture de test >= 80%.
  - Zero warning ruff et typage strict validé par mypy.

### US-07 : Conteneurisation Dockerfile Multi-Stage Non-Root
- **Priorité :** P2 (Moyenne)
- **Estimation :** 1 SP
- **Description :** Écrire le `Dockerfile` multi-stage optimisé, configurant l'utilisateur non-privilégié `appuser:appgroup` (UID/GID 10001) et le `HEALTHCHECK`.
- **Critères d'acceptation :**
  - Build rapide et conteneur opérationnel en mode non-root.
