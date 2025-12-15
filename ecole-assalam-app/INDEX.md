# 📚 Index de la Documentation - École Assalam

Guide complet de navigation dans la documentation du projet.

---

## 🎯 Par où commencer ?

### Vous voulez déployer l'application sur Azure ?
👉 **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Guide complet (10 minutes)
👉 **[deployment/azure/QUICKSTART.md](deployment/azure/QUICKSTART.md)** - Version ultra-rapide

### Vous voulez développer localement ?
👉 **[GUIDE_DEMARRAGE.md](GUIDE_DEMARRAGE.md)** - Développement pas à pas

### Vous voulez comprendre l'architecture ?
👉 **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture technique complète
👉 **[RESUME_PROJET.md](RESUME_PROJET.md)** - Résumé et statistiques

---

## 📖 Documentation principale

### 1. Démarrage et présentation

| Document | Description | Taille | Pour qui ? |
|----------|-------------|--------|------------|
| **[README.md](README.md)** | Vue d'ensemble du projet | ⭐⭐⭐⭐⭐ | Tout le monde |
| **[RESUME_PROJET.md](RESUME_PROJET.md)** | Statistiques et résumé | ⭐⭐⭐ | Découverte rapide |

### 2. Déploiement

| Document | Description | Taille | Pour qui ? |
|----------|-------------|--------|------------|
| **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** | Guide complet de déploiement | ⭐⭐⭐⭐⭐ | Déploiement production |
| **[deployment/DEPLOYMENT_SUMMARY.md](deployment/DEPLOYMENT_SUMMARY.md)** | Comparaison des plateformes | ⭐⭐⭐ | Choix de la plateforme |

### 3. Guides spécifiques

| Document | Description | Taille | Pour qui ? |
|----------|-------------|--------|------------|
| **[GUIDE_DEMARRAGE.md](GUIDE_DEMARRAGE.md)** | Développement local | ⭐⭐⭐⭐ | Développeurs |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | Architecture technique | ⭐⭐⭐⭐ | Développeurs/Architectes |

---

## 🌐 Documentation déploiement

### Azure (Recommandé)

| Document | Description | Temps de lecture |
|----------|-------------|------------------|
| **[deployment/azure/QUICKSTART.md](deployment/azure/QUICKSTART.md)** ⭐ | Démarrage ultra-rapide | 5 min |
| **[deployment/azure/README.md](deployment/azure/README.md)** | Documentation complète Azure | 15 min |
| **[deployment/azure/deploy-powershell.ps1](deployment/azure/deploy-powershell.ps1)** | Script Windows | - |
| **[deployment/azure/deploy.sh](deployment/azure/deploy.sh)** | Script Linux | - |

### Docker

| Document | Description | Temps de lecture |
|----------|-------------|------------------|
| **[deployment/docker/README.md](deployment/docker/README.md)** | Guide Docker complet | 10 min |
| **[deployment/docker/docker-compose.yml](deployment/docker/docker-compose.yml)** | Configuration Docker | - |

---

## 💻 Documentation technique

### Backend (Node.js + TypeScript + Prisma)

| Document | Description | Contenu |
|----------|-------------|---------|
| **[backend/README.md](backend/README.md)** | Documentation API backend | API endpoints, configuration |
| **[backend/prisma/schema.prisma](backend/prisma/schema.prisma)** | Schéma de base de données | Modèles de données |

**Fichiers clés :**
- [backend/src/server.ts](backend/src/server.ts) - Point d'entrée serveur
- [backend/src/controllers/](backend/src/controllers/) - Logique métier (5 contrôleurs)
- [backend/src/routes/](backend/src/routes/) - Routes API (5 fichiers)

### Frontend (Flutter)

| Document | Description | Contenu |
|----------|-------------|---------|
| **[frontend/README.md](frontend/README.md)** | Documentation Flutter | Configuration, build, déploiement |
| **[frontend/pubspec.yaml](frontend/pubspec.yaml)** | Dépendances Flutter | Packages utilisés |

**Fichiers clés :**
- [frontend/lib/main.dart](frontend/lib/main.dart) - Point d'entrée
- [frontend/lib/config/](frontend/lib/config/) - Configuration (API, routes)
- [frontend/lib/models/](frontend/lib/models/) - Modèles de données (5 modèles)
- [frontend/lib/services/](frontend/lib/services/) - Services API (6 services)
- [frontend/lib/providers/](frontend/lib/providers/) - State management (5 providers)
- [frontend/lib/screens/](frontend/lib/screens/) - Interfaces UI (11 écrans)

---

## 🔧 Guides pratiques

### Déploiement

| Tâche | Guide | Section |
|-------|-------|---------|
| Déployer sur Azure en 10 min | [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) | Démarrage rapide |
| Déployer avec Docker | [deployment/docker/README.md](deployment/docker/README.md) | Déploiement rapide |
| Configurer CI/CD | [.github/workflows/azure-deploy.yml](.github/workflows/azure-deploy.yml) | Workflow GitHub |
| Choisir une plateforme | [deployment/DEPLOYMENT_SUMMARY.md](deployment/DEPLOYMENT_SUMMARY.md) | Comparaison |

### Développement

| Tâche | Guide | Section |
|-------|-------|---------|
| Installer en local | [GUIDE_DEMARRAGE.md](GUIDE_DEMARRAGE.md) | Installation |
| Créer une nouvelle entité | [ARCHITECTURE.md](ARCHITECTURE.md) | Développement |
| Comprendre l'architecture | [ARCHITECTURE.md](ARCHITECTURE.md) | Architecture Backend/Frontend |
| Modifier l'UI Flutter | [frontend/README.md](frontend/README.md) | Structure du projet |

### Opérations

| Tâche | Guide | Commande |
|-------|-------|----------|
| Voir les logs Azure | [deployment/azure/QUICKSTART.md](deployment/azure/QUICKSTART.md) | `az webapp log tail` |
| Redémarrer l'application | [deployment/azure/README.md](deployment/azure/README.md) | `az webapp restart` |
| Exécuter migrations | [backend/README.md](backend/README.md) | `npm run prisma:migrate` |
| Build Flutter Web | [frontend/README.md](frontend/README.md) | `flutter build web` |

---

## 📁 Structure des fichiers

### Racine du projet

```
ecole-assalam-app/
├── 📘 README.md                    # Vue d'ensemble ⭐ COMMENCEZ ICI
├── 📗 DEPLOYMENT_GUIDE.md          # Guide déploiement complet
├── 📙 GUIDE_DEMARRAGE.md           # Développement local
├── 📕 ARCHITECTURE.md              # Architecture technique
├── 📖 RESUME_PROJET.md             # Résumé et statistiques
├── 📚 INDEX.md                     # Ce fichier
│
├── backend/                        # Backend Node.js
│   ├── 📘 README.md               # Documentation API
│   ├── prisma/schema.prisma       # Schéma BDD
│   └── src/                       # Code source
│
├── frontend/                       # Frontend Flutter
│   ├── 📘 README.md               # Documentation Flutter
│   ├── pubspec.yaml               # Dépendances
│   └── lib/                       # Code source
│
└── deployment/                     # Déploiement
    ├── 📄 DEPLOYMENT_SUMMARY.md   # Comparaison plateformes
    ├── azure/                     # Scripts Azure
    │   ├── 📗 QUICKSTART.md       # Guide rapide ⭐
    │   ├── 📘 README.md           # Guide complet
    │   ├── deploy-powershell.ps1  # Script Windows
    │   └── deploy.sh              # Script Linux
    └── docker/                    # Configuration Docker
        ├── 📘 README.md           # Guide Docker
        ├── docker-compose.yml
        ├── Dockerfile.backend
        └── Dockerfile.frontend
```

---

## 🎯 Flux de travail recommandés

### Workflow 1 : Déploiement rapide sur Azure

```
1. README.md
   ↓
2. DEPLOYMENT_GUIDE.md (section "Démarrage rapide")
   ↓
3. deployment/azure/QUICKSTART.md
   ↓
4. Exécuter deploy-powershell.ps1
   ↓
5. Application en ligne ! 🎉
```

### Workflow 2 : Développement local

```
1. README.md
   ↓
2. GUIDE_DEMARRAGE.md
   ↓
3. backend/README.md + frontend/README.md
   ↓
4. ARCHITECTURE.md (pour comprendre)
   ↓
5. Développement 💻
```

### Workflow 3 : Compréhension du projet

```
1. README.md
   ↓
2. RESUME_PROJET.md (statistiques)
   ↓
3. ARCHITECTURE.md (technique)
   ↓
4. Explorer le code source
```

---

## 🔍 Recherche rapide

### Je veux...

**... déployer sur Azure**
→ [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) ou [deployment/azure/QUICKSTART.md](deployment/azure/QUICKSTART.md)

**... développer en local**
→ [GUIDE_DEMARRAGE.md](GUIDE_DEMARRAGE.md)

**... comprendre l'architecture**
→ [ARCHITECTURE.md](ARCHITECTURE.md)

**... utiliser Docker**
→ [deployment/docker/README.md](deployment/docker/README.md)

**... modifier le backend**
→ [backend/README.md](backend/README.md)

**... modifier le frontend**
→ [frontend/README.md](frontend/README.md)

**... choisir une plateforme de déploiement**
→ [deployment/DEPLOYMENT_SUMMARY.md](deployment/DEPLOYMENT_SUMMARY.md)

**... voir les statistiques du projet**
→ [RESUME_PROJET.md](RESUME_PROJET.md)

**... configurer CI/CD**
→ [.github/workflows/azure-deploy.yml](.github/workflows/azure-deploy.yml)

---

## 📊 Résumé de la documentation

| Type | Nombre de fichiers | Lignes totales |
|------|-------------------|----------------|
| **Guides principaux** | 6 | ~2000 lignes |
| **Documentation Azure** | 3 | ~800 lignes |
| **Documentation Docker** | 1 | ~350 lignes |
| **Documentation technique** | 2 | ~350 lignes |
| **Scripts** | 3 | ~300 lignes |
| **Workflows CI/CD** | 1 | ~50 lignes |
| **TOTAL** | **16 fichiers** | **~3850 lignes** |

---

## 💡 Conseils

### Pour les débutants

1. Commencez par [README.md](README.md)
2. Lisez [RESUME_PROJET.md](RESUME_PROJET.md) pour avoir une vue d'ensemble
3. Suivez [deployment/azure/QUICKSTART.md](deployment/azure/QUICKSTART.md) pour déployer

### Pour les développeurs

1. Lisez [ARCHITECTURE.md](ARCHITECTURE.md)
2. Consultez [GUIDE_DEMARRAGE.md](GUIDE_DEMARRAGE.md)
3. Explorez le code dans `backend/` et `frontend/`

### Pour les DevOps

1. Consultez [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
2. Regardez les scripts dans `deployment/`
3. Configurez CI/CD avec `.github/workflows/`

---

## 🆘 Aide et support

### Problèmes de déploiement Azure
→ [deployment/azure/README.md](deployment/azure/README.md) - Section "Dépannage"

### Problèmes Docker
→ [deployment/docker/README.md](deployment/docker/README.md) - Section "Dépannage"

### Problèmes de développement
→ [GUIDE_DEMARRAGE.md](GUIDE_DEMARRAGE.md) - Section "Dépannage"

### Questions générales
→ [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Section "Dépannage"

---

## 🎓 Mise à jour de l'index

Dernière mise à jour : Décembre 2025

**Documents principaux :** 6
**Guides de déploiement :** 5
**Documentation technique :** 2
**Scripts :** 3
**Total :** 16 fichiers de documentation

---

**Navigation facile vers tous les documents du projet École Assalam !**

Commencez par 👉 [README.md](README.md) ou [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
