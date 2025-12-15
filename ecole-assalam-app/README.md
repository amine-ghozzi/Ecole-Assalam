# École Assalam - Application de Gestion

Application mobile et web complète pour la gestion des classes d'une école.

## 📋 Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Démarrage rapide](#-démarrage-rapide)
- [Déploiement](#-déploiement)
- [Documentation](#-documentation)

## ✨ Fonctionnalités

- ✅ **Gestion des niveaux scolaires** (Maternelle, CP, CE1, CE2, etc.)
- ✅ **Gestion des groupes/classes** par niveau et année scolaire
- ✅ **Gestion des élèves** avec informations complètes
- ✅ **Horaires d'entrée et de sortie** par groupe
- ✅ **Examens de passage de niveau** avec statuts et dates
- ✅ **Interface responsive** (Web, Mobile iOS/Android, Tablette)
- ✅ **API RESTful** complète et documentée

## 🏗️ Architecture

- **Frontend**: Flutter (Web, iOS, Android)
- **Backend**: Node.js + Express + TypeScript
- **Base de données**: PostgreSQL
- **ORM**: Prisma
- **State Management**: Provider
- **Navigation**: GoRouter

## 🚀 Démarrage rapide

### Option 1 : Déploiement sur Azure (Recommandé)

**En 10 minutes, déployez l'application sur Azure Linux :**

📘 **[Guide de déploiement Azure](DEPLOYMENT_GUIDE.md)**

```powershell
# 1. Installer Azure CLI
# 2. Se connecter
az login

# 3. Déployer
cd deployment/azure
.\deploy-powershell.ps1
```

Coût : ~28€/mois | Compte gratuit : 200$ de crédit

### Option 2 : Déploiement avec Docker

```bash
cd deployment/docker
docker-compose up -d
```

- Frontend : http://localhost:8080
- Backend : http://localhost:3000

### Option 3 : Développement local

#### Backend
```bash
cd backend
npm install
cp .env.example .env
# Configurer DATABASE_URL dans .env
npm run prisma:generate
npm run prisma:migrate
npm run dev
```

#### Frontend
```bash
cd frontend
flutter pub get
flutter run -d chrome  # Web
flutter run            # Mobile
```

## 🌐 Déploiement

### Déploiement Production

Nous fournissons des guides complets pour :

| Plateforme | Difficulté | Coût/mois | Guide |
|-----------|-----------|-----------|-------|
| **Azure** | ⭐⭐ | 28€ | [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) ⭐ |
| **Docker** | ⭐⭐⭐ | Variable | [deployment/docker/README.md](deployment/docker/README.md) |
| **DigitalOcean** | ⭐⭐ | 12-20€ | [deployment/DEPLOYMENT_SUMMARY.md](deployment/DEPLOYMENT_SUMMARY.md) |
| **Vercel + Supabase** | ⭐ | 0-25€ | [deployment/DEPLOYMENT_SUMMARY.md](deployment/DEPLOYMENT_SUMMARY.md) |

### 🎯 Recommandation

👉 **Déploiement Azure** - Guide complet avec scripts automatisés fournis !

**Voir :** [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

## 📚 Documentation

### Guides principaux

- 📘 **[Guide de déploiement](DEPLOYMENT_GUIDE.md)** - Déployer sur Azure en 10 minutes
- 📗 **[Guide de démarrage](GUIDE_DEMARRAGE.md)** - Développement local
- 📙 **[Architecture](ARCHITECTURE.md)** - Architecture technique détaillée

### Documentation spécifique

- [Backend README](backend/README.md) - API Node.js + Prisma
- [Frontend README](frontend/README.md) - Application Flutter
- [Azure Quickstart](deployment/azure/QUICKSTART.md) - Déploiement Azure rapide
- [Docker Guide](deployment/docker/README.md) - Déploiement avec Docker

## 📁 Structure du projet

```
ecole-assalam-app/
├── backend/                  # API Node.js + Express + Prisma
│   ├── prisma/              # Schéma de base de données
│   ├── src/
│   │   ├── controllers/     # Logique métier
│   │   ├── routes/          # Routes API
│   │   └── server.ts        # Point d'entrée
│   └── package.json
├── frontend/                # Application Flutter
│   ├── lib/
│   │   ├── models/         # Modèles de données
│   │   ├── services/       # Services API
│   │   ├── providers/      # State management
│   │   ├── screens/        # Écrans UI
│   │   └── main.dart
│   └── pubspec.yaml
├── deployment/             # Scripts de déploiement
│   ├── azure/             # Azure (PowerShell + Bash)
│   └── docker/            # Docker Compose
├── .github/workflows/     # CI/CD GitHub Actions
├── DEPLOYMENT_GUIDE.md    # 📘 Guide de déploiement
├── GUIDE_DEMARRAGE.md     # Guide développement local
├── ARCHITECTURE.md        # Documentation architecture
└── README.md             # 📍 Vous êtes ici
```

## 🛠️ Technologies utilisées

### Backend
- Node.js 20
- Express.js
- TypeScript
- Prisma ORM
- PostgreSQL 14

### Frontend
- Flutter 3.16+
- Dart
- Provider (State Management)
- Dio (HTTP Client)
- GoRouter (Navigation)
- Material Design 3

### DevOps
- Azure App Service
- Azure Database for PostgreSQL
- Docker & Docker Compose
- GitHub Actions

## 🎓 Cas d'usage

Cette application est idéale pour :

- ✅ Écoles primaires et maternelles
- ✅ Centres de formation
- ✅ Établissements éducatifs
- ✅ Gestion multi-classes
- ✅ Suivi des élèves et examens

## 📊 API Endpoints

Tous les endpoints suivent le pattern RESTful :

```
GET    /api/niveaux          # Liste tous les niveaux
GET    /api/niveaux/:id      # Récupère un niveau
POST   /api/niveaux          # Crée un niveau
PUT    /api/niveaux/:id      # Met à jour un niveau
DELETE /api/niveaux/:id      # Supprime un niveau

# Même pattern pour :
/api/groupes
/api/eleves
/api/horaires
/api/examens
```

## 🔐 Sécurité

- ✅ HTTPS uniquement en production
- ✅ CORS configuré
- ✅ Variables d'environnement pour les secrets
- ✅ Validation des données (Express Validator)
- ✅ PostgreSQL avec SSL
- ✅ Conteneurs Docker non-root

## 📈 Prochaines fonctionnalités

- [ ] Authentification et autorisation (JWT)
- [ ] Upload de photos d'élèves
- [ ] Génération de rapports PDF
- [ ] Notifications push
- [ ] Calendrier scolaire
- [ ] Gestion des absences
- [ ] Bulletins de notes
- [ ] Communication parents-école

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT.

## 💬 Support

Pour toute question :

- 📖 Consultez la [documentation](DEPLOYMENT_GUIDE.md)
- 🐛 Ouvrez une [issue](https://github.com/votre-username/ecole-assalam/issues)
- 📧 Contactez l'équipe

## 🎯 Démarrer maintenant !

**Prêt à déployer votre application ?**

👉 [Guide de déploiement Azure](DEPLOYMENT_GUIDE.md) - En 10 minutes !

---

Développé avec ❤️ pour École Assalam
