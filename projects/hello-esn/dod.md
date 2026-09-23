# Definition of Done (DoD) - Projet hello-esn

Le projet **hello-esn** est réputé terminé (*Done*) et prêt pour la mise en production lorsque l'intégralité des critères ci-dessous est validée :

## 1. Code & Conception
- [ ] Le code respecte l'arborescence et les patrons d'architecture décrits dans `02-architecture.md`.
- [ ] Les classes et modèles de données utilisent SQLAlchemy 2.0 (syntaxe déclarative avec typage strict).
- [ ] Les modèles de requête et réponse sont validés par des schémas Pydantic.
- [ ] Aucune variable sensible ou credential n'est codé en dur (chargement exclusif via variables d'environnement / `BaseSettings`).

## 2. API & Fonctionnel
- [ ] `GET /` renvoie un statut HTTP `200` avec le message actif (`{"message": "..."}`).
- [ ] `GET /health` renvoie un statut HTTP `200` (`{"status": "ok", "database": "connected"}`).
- [ ] `GET /api/v1/message` renvoie l'état complet du message actif en base de données.
- [ ] `PUT /api/v1/message` est protégé par authentification Bearer / API Key (retour `401 Unauthorized` si clé absente ou incorrecte).
- [ ] Chaque modification de message via `PUT /api/v1/message` génère un enregistrement synchrone et immuable dans la table `audit_logs`.
- [ ] Les en-têtes HTTP de sécurité (CSP, X-Content-Type-Options, X-Frame-Options, etc.) sont systématiquement injectés.

## 3. Qualité & Tests
- [ ] La suite de tests unitaires et d'intégration `pytest` s'exécute avec succès.
- [ ] La couverture de code par les tests est supérieure ou égale à **80%**.
- [ ] Le linter et formateur (`ruff` ou `black`/`flake8`) ne renvoie aucun avertissement ni erreur bloquante.
- [ ] L'analyse statique des types via `mypy` s'exécute avec zéro erreur.

## 4. Conteneurisation & Déploiement
- [ ] Le `Dockerfile` multi-stage s'assemble sans erreur et produit une image optimisée.
- [ ] Le conteneur s'exécute sous un utilisateur non-privilégié (`USER 10001:10001` / non-root).
- [ ] Le Healthcheck Docker est opérationnel et répond positivement sur `/health`.
- [ ] Les migrations de base de données Alembic s'exécutent de façon transparente au démarrage (`alembic upgrade head`).

## 5. Documentation & Gouvernance
- [ ] Le `README.md` du dépôt contient les consignes claires d'installation, d'exécution locale et de test.
- [ ] La documentation d'architecture technique est publiée dans SilverBullet (`ESN/Projets/hello-esn/02-architecture.md`).
- [ ] Les tickets du backlog sont tous résolus ou formellement reportés dans la feuille de route.
