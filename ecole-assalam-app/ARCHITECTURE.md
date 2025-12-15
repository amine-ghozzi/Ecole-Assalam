# Architecture de l'Application École Assalam

## Vue d'ensemble

Application complète de gestion scolaire avec :
- **Backend** : API RESTful Node.js + Express + TypeScript + Prisma + PostgreSQL
- **Frontend** : Application Flutter multi-plateforme (Web, iOS, Android)

## Architecture Backend

### Technologies
- **Runtime** : Node.js
- **Framework** : Express.js
- **Langage** : TypeScript
- **ORM** : Prisma
- **Base de données** : PostgreSQL

### Structure

```
backend/
├── prisma/
│   └── schema.prisma          # Schéma de la base de données
├── src/
│   ├── controllers/           # Logique métier
│   │   ├── niveau.controller.ts
│   │   ├── groupe.controller.ts
│   │   ├── eleve.controller.ts
│   │   ├── horaire.controller.ts
│   │   └── examen.controller.ts
│   ├── routes/               # Définition des routes API
│   │   ├── niveau.routes.ts
│   │   ├── groupe.routes.ts
│   │   ├── eleve.routes.ts
│   │   ├── horaire.routes.ts
│   │   └── examen.routes.ts
│   └── server.ts            # Point d'entrée
├── .env.example             # Variables d'environnement
├── package.json
└── tsconfig.json
```

### Modèle de données

#### Niveau
- Représente un niveau scolaire (Maternelle, CP, CE1, etc.)
- Champs : id, nom, description, ordre

#### Groupe
- Représente une classe/groupe d'élèves
- Champs : id, nom, niveauId, capaciteMax, anneeScolaire
- Relation : appartient à un Niveau

#### Élève
- Représente un élève
- Champs : id, nom, prenom, dateNaissance, groupeId, photo, contactParent, adresse
- Relation : appartient à un Groupe (optionnel)

#### Horaire
- Représente les horaires d'un groupe
- Champs : id, groupeId, joursSemaine[], heureEntree, heureSortie
- Relation : appartient à un Groupe

#### ExamenPassage
- Représente un examen de passage de niveau
- Champs : id, niveauSourceId, niveauDestinationId, dateExamen, dateLimiteInscription, statut, description
- Relations : niveauSource (Niveau), niveauDestination (Niveau)

### API Endpoints

Tous les endpoints suivent le pattern RESTful :

| Méthode | URL | Description |
|---------|-----|-------------|
| GET | /api/{resource} | Liste toutes les ressources |
| GET | /api/{resource}/:id | Récupère une ressource par ID |
| POST | /api/{resource} | Crée une nouvelle ressource |
| PUT | /api/{resource}/:id | Met à jour une ressource |
| DELETE | /api/{resource}/:id | Supprime une ressource |

Ressources disponibles : `niveaux`, `groupes`, `eleves`, `horaires`, `examens`

## Architecture Frontend

### Technologies
- **Framework** : Flutter
- **Langage** : Dart
- **State Management** : Provider
- **HTTP Client** : Dio
- **Navigation** : GoRouter
- **UI** : Material Design 3

### Structure

```
frontend/lib/
├── config/
│   ├── api_config.dart       # Configuration API
│   └── app_router.dart       # Configuration des routes
├── models/                   # Modèles de données
│   ├── niveau.dart
│   ├── groupe.dart
│   ├── eleve.dart
│   ├── horaire.dart
│   └── examen_passage.dart
├── services/                 # Services API
│   ├── api_service.dart      # Service HTTP de base
│   ├── niveau_service.dart
│   ├── groupe_service.dart
│   ├── eleve_service.dart
│   ├── horaire_service.dart
│   └── examen_service.dart
├── providers/                # State management
│   ├── niveau_provider.dart
│   ├── groupe_provider.dart
│   ├── eleve_provider.dart
│   ├── horaire_provider.dart
│   └── examen_provider.dart
├── screens/                  # Écrans de l'application
│   ├── home_screen.dart
│   ├── niveaux/
│   │   ├── niveaux_list_screen.dart
│   │   └── niveau_form_screen.dart
│   ├── groupes/
│   │   ├── groupes_list_screen.dart
│   │   └── groupe_form_screen.dart
│   ├── eleves/
│   │   ├── eleves_list_screen.dart
│   │   └── eleve_form_screen.dart
│   └── examens/
│       ├── examens_list_screen.dart
│       └── examen_form_screen.dart
└── main.dart                 # Point d'entrée
```

### Flux de données

```
User Action → Screen → Provider → Service → API
                ↓         ↓
              UI Update ← State Update
```

1. **Screen** : Interface utilisateur qui affiche les données et capture les actions
2. **Provider** : Gère l'état et la logique métier
3. **Service** : Communique avec l'API backend
4. **API** : Backend qui traite les requêtes et retourne les données

### Patterns utilisés

#### 1. Repository Pattern
Les services encapsulent la logique d'accès aux données.

#### 2. Provider Pattern
Pour la gestion d'état réactive avec `ChangeNotifier`.

#### 3. MVC (Model-View-Controller)
- **Model** : classes dans `models/`
- **View** : widgets dans `screens/`
- **Controller** : providers dans `providers/`

## Communication Backend ↔ Frontend

### Format des données
Toutes les communications utilisent JSON.

### Exemple de flux

#### Création d'un élève

1. **Frontend** : L'utilisateur remplit le formulaire
2. **Frontend** : Le provider valide les données
3. **Frontend** : Le service envoie une requête POST
4. **Backend** : Le contrôleur reçoit la requête
5. **Backend** : Prisma crée l'enregistrement en BD
6. **Backend** : Le contrôleur retourne l'élève créé
7. **Frontend** : Le service reçoit la réponse
8. **Frontend** : Le provider met à jour l'état
9. **Frontend** : L'écran se rafraîchit automatiquement

## Sécurité

### Backend
- CORS configuré pour autoriser uniquement les origines approuvées
- Validation des données d'entrée avec express-validator
- Gestion d'erreurs centralisée

### Frontend
- Validation des formulaires côté client
- Gestion des erreurs réseau
- Messages d'erreur utilisateur-friendly

## Scalabilité

### Backend
- Architecture modulaire (controllers, routes, services)
- ORM Prisma pour les migrations de base de données
- Possibilité d'ajouter facilement de nouvelles entités

### Frontend
- Architecture en couches (screens, providers, services, models)
- Code réutilisable
- Support multi-plateforme natif (Web, iOS, Android)

## Performances

### Backend
- Utilisation d'index sur les colonnes clés
- Requêtes optimisées avec Prisma
- Relations chargées de manière sélective

### Frontend
- Chargement lazy des listes
- Cache local avec Provider
- Build optimisé pour chaque plateforme

## Déploiement

### Backend
1. Build TypeScript : `npm run build`
2. Déployer sur un serveur Node.js (Heroku, DigitalOcean, AWS, etc.)
3. Configurer PostgreSQL en production
4. Définir les variables d'environnement

### Frontend

#### Web
1. Build : `flutter build web`
2. Déployer `build/web/` sur un hébergement web (Firebase Hosting, Netlify, Vercel, etc.)

#### Mobile
1. Android : `flutter build apk` ou `flutter build appbundle`
2. iOS : `flutter build ios`
3. Publier sur Google Play Store / Apple App Store

## Extensions futures

- Authentification et autorisation (JWT)
- Upload de fichiers (photos d'élèves)
- Génération de rapports PDF
- Notifications push
- Calendrier scolaire
- Gestion des absences
- Bulletin de notes
- Communication parents-école
- Tableau de bord avec statistiques
