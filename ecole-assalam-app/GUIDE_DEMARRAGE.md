# Guide de Démarrage Rapide - École Assalam

Ce guide vous aidera à démarrer rapidement l'application École Assalam.

## Prérequis

### Backend
- Node.js (version 18 ou supérieure)
- PostgreSQL (version 14 ou supérieure)
- npm ou yarn

### Frontend
- Flutter SDK (version 3.0 ou supérieure)
- Dart SDK
- Chrome (pour le développement web)

## Installation

### 1. Configuration de la base de données

Créez une base de données PostgreSQL :

```sql
CREATE DATABASE ecole_assalam;
```

### 2. Configuration du Backend

```bash
cd backend

# Installer les dépendances
npm install

# Configurer les variables d'environnement
cp .env.example .env

# Modifier le fichier .env avec vos paramètres
# DATABASE_URL="postgresql://user:password@localhost:5432/ecole_assalam?schema=public"

# Générer le client Prisma
npm run prisma:generate

# Créer les tables de la base de données
npm run prisma:migrate

# Démarrer le serveur de développement
npm run dev
```

Le backend sera accessible sur [http://localhost:3000](http://localhost:3000)

### 3. Configuration du Frontend Flutter

```bash
cd frontend

# Installer les dépendances
flutter pub get

# Lancer l'application web
flutter run -d chrome

# OU lancer sur mobile
flutter run
```

## Vérification

### Backend

Vérifiez que le backend fonctionne :
- Ouvrez [http://localhost:3000](http://localhost:3000) dans votre navigateur
- Vous devriez voir la réponse JSON de l'API

### Frontend

L'application devrait s'ouvrir automatiquement. Vous verrez :
- Écran d'accueil avec 4 sections : Niveaux, Groupes, Élèves, Examens

## Utilisation

### 1. Créer des niveaux

1. Cliquez sur "Niveaux" depuis l'écran d'accueil
2. Cliquez sur le bouton "+" en bas à droite
3. Remplissez le formulaire :
   - Nom : "CP" (Cours Préparatoire)
   - Ordre : 1
   - Description : "Première année de l'école primaire"
4. Cliquez sur "Créer"

Créez d'autres niveaux (CE1, CE2, CM1, CM2, etc.)

### 2. Créer des groupes/classes

1. Cliquez sur "Groupes" depuis l'écran d'accueil
2. Cliquez sur le bouton "+"
3. Remplissez le formulaire :
   - Nom : "CP-A"
   - Niveau : Sélectionnez "CP"
   - Capacité maximale : 30
   - Année scolaire : "2024-2025"
4. Cliquez sur "Créer"

### 3. Ajouter des élèves

1. Cliquez sur "Élèves" depuis l'écran d'accueil
2. Cliquez sur le bouton "+"
3. Remplissez le formulaire :
   - Prénom : "Ahmed"
   - Nom : "BENJELLOUN"
   - Date de naissance : Sélectionnez la date
   - Groupe : Sélectionnez "CP-A"
   - Contact parent : "0612345678"
   - Adresse : "123 Rue de la Paix, Casablanca"
4. Cliquez sur "Créer"

### 4. Planifier des examens de passage

1. Cliquez sur "Examens" depuis l'écran d'accueil
2. Cliquez sur le bouton "+"
3. Remplissez le formulaire :
   - Niveau source : "CP"
   - Niveau destination : "CE1"
   - Date de l'examen : Sélectionnez la date
   - Date limite d'inscription : Sélectionnez la date
   - Statut : "Planifié"
   - Description : "Examen de passage CP vers CE1"
4. Cliquez sur "Créer"

## Commandes utiles

### Backend

```bash
# Démarrer en mode développement
npm run dev

# Build pour la production
npm run build

# Démarrer en production
npm start

# Ouvrir Prisma Studio (interface graphique pour la BD)
npm run prisma:studio
```

### Frontend Flutter

```bash
# Lancer sur le web
flutter run -d chrome

# Lancer sur Android
flutter run -d android

# Lancer sur iOS
flutter run -d ios

# Build pour le web
flutter build web

# Build APK pour Android
flutter build apk

# Nettoyer le projet
flutter clean && flutter pub get
```

## Structure des URLs de l'API

- **Niveaux**: `http://localhost:3000/api/niveaux`
- **Groupes**: `http://localhost:3000/api/groupes`
- **Élèves**: `http://localhost:3000/api/eleves`
- **Horaires**: `http://localhost:3000/api/horaires`
- **Examens**: `http://localhost:3000/api/examens`

## Dépannage

### Le backend ne démarre pas

1. Vérifiez que PostgreSQL est démarré
2. Vérifiez les informations de connexion dans `.env`
3. Assurez-vous que la base de données existe

### L'application Flutter ne se connecte pas au backend

1. Vérifiez que le backend est démarré ([http://localhost:3000](http://localhost:3000))
2. Vérifiez l'URL dans `frontend/lib/config/api_config.dart`
3. Pour Android Emulator, utilisez `http://10.0.2.2:3000/api` au lieu de `http://localhost:3000/api`

### Erreur Prisma

```bash
cd backend
npx prisma generate
npx prisma migrate dev
```

## Développement

### Ajouter une nouvelle entité

1. Modifiez le schéma Prisma : `backend/prisma/schema.prisma`
2. Créez une migration : `npm run prisma:migrate`
3. Créez le contrôleur dans `backend/src/controllers/`
4. Créez les routes dans `backend/src/routes/`
5. Créez le modèle Flutter dans `frontend/lib/models/`
6. Créez le service Flutter dans `frontend/lib/services/`
7. Créez le provider Flutter dans `frontend/lib/providers/`
8. Créez les écrans Flutter dans `frontend/lib/screens/`

## Support

Pour toute question ou problème :
- Consultez les README dans `backend/` et `frontend/`
- Vérifiez les logs du serveur
- Vérifiez les logs Flutter avec `flutter logs`

## Prochaines étapes

- Ajouter l'authentification des utilisateurs
- Implémenter les permissions et rôles
- Ajouter un système de notifications
- Générer des rapports et statistiques
- Ajouter l'upload de photos pour les élèves
- Implémenter un calendrier scolaire
