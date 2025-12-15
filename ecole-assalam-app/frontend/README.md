# Frontend Flutter - École Assalam

Application mobile et web Flutter pour la gestion des classes d'une école.

## Prérequis

- Flutter SDK (3.0.0 ou supérieur)
- Dart SDK
- Un éditeur (VS Code, Android Studio, ou IntelliJ IDEA)

## Installation

1. Installer les dépendances :
```bash
flutter pub get
```

2. Configurer l'URL de l'API :

Ouvrez [lib/config/api_config.dart](lib/config/api_config.dart) et modifiez l'URL selon votre environnement :

- **Web**: `http://localhost:3000/api`
- **Android Emulator**: `http://10.0.2.2:3000/api`
- **iOS Simulator**: `http://localhost:3000/api`
- **Production**: Votre URL de production

## Lancement

### Web
```bash
flutter run -d chrome
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Tous les appareils disponibles
```bash
flutter devices
flutter run
```

## Build

### Web
```bash
flutter build web
```
Les fichiers seront dans `build/web/`

### Android APK
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

## Structure du projet

```
lib/
├── config/
│   ├── api_config.dart       # Configuration de l'API
│   └── app_router.dart       # Configuration des routes
├── models/
│   ├── niveau.dart           # Modèle Niveau
│   ├── groupe.dart           # Modèle Groupe
│   ├── eleve.dart            # Modèle Élève
│   ├── horaire.dart          # Modèle Horaire
│   └── examen_passage.dart   # Modèle Examen de Passage
├── services/
│   ├── api_service.dart      # Service HTTP de base
│   ├── niveau_service.dart   # Service pour les niveaux
│   ├── groupe_service.dart   # Service pour les groupes
│   ├── eleve_service.dart    # Service pour les élèves
│   ├── horaire_service.dart  # Service pour les horaires
│   └── examen_service.dart   # Service pour les examens
├── providers/
│   ├── niveau_provider.dart  # Provider pour les niveaux
│   ├── groupe_provider.dart  # Provider pour les groupes
│   ├── eleve_provider.dart   # Provider pour les élèves
│   ├── horaire_provider.dart # Provider pour les horaires
│   └── examen_provider.dart  # Provider pour les examens
├── screens/
│   ├── home_screen.dart      # Écran d'accueil
│   ├── niveaux/              # Écrans des niveaux
│   ├── groupes/              # Écrans des groupes
│   ├── eleves/               # Écrans des élèves
│   └── examens/              # Écrans des examens
└── main.dart                 # Point d'entrée
```

## Fonctionnalités

- Gestion des niveaux scolaires (Maternelle, CP, CE1, etc.)
- Gestion des groupes/classes
- Gestion des élèves
- Gestion des horaires d'entrée et de sortie
- Gestion des examens de passage de niveau
- Interface responsive (Web, Mobile, Tablette)

## Technologies utilisées

- **Flutter**: Framework UI multi-plateforme
- **Provider**: Gestion d'état
- **Dio**: Client HTTP
- **GoRouter**: Navigation
- **Google Fonts**: Typographie
- **Intl**: Internationalisation et formatage

## Configuration supplémentaire

### Pour activer le support web

Si ce n'est pas déjà fait :
```bash
flutter config --enable-web
```

### Pour Android

Assurez-vous que votre `android/app/src/main/AndroidManifest.xml` contient :
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Dépannage

### Problème de connexion à l'API

1. Vérifiez que le backend est démarré
2. Vérifiez l'URL dans `lib/config/api_config.dart`
3. Pour Android Emulator, utilisez `10.0.2.2` au lieu de `localhost`

### Erreur de build

```bash
flutter clean
flutter pub get
flutter run
```

## Développement

Pour activer le hot reload pendant le développement :
```bash
flutter run
```

Appuyez sur `r` pour recharger ou `R` pour un redémarrage complet.
