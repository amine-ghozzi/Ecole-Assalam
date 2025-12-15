# Démarrage Rapide - Déploiement Azure

Ce guide vous permet de déployer l'application en **10 minutes** sur Azure.

## Étape 1 : Installer Azure CLI

### Sur Windows (PowerShell en tant qu'administrateur)

```powershell
# Télécharger et installer Azure CLI
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
Remove-Item .\AzureCLI.msi
```

Ou téléchargez manuellement : [Azure CLI MSI](https://aka.ms/installazurecliwindows)

**Redémarrez PowerShell après l'installation !**

## Étape 2 : Se connecter à Azure

```powershell
az login
```

Une fenêtre de navigateur s'ouvrira. Connectez-vous avec votre compte Azure.

## Étape 3 : Vérifier votre abonnement

```powershell
# Lister vos abonnements
az account list --output table

# Sélectionner un abonnement (si vous en avez plusieurs)
az account set --subscription "Nom-de-votre-abonnement"
```

## Étape 4 : Modifier le mot de passe de la base de données

Éditez le fichier `deployment/azure/deploy-powershell.ps1` et modifiez la ligne :

```powershell
$DB_ADMIN_PASSWORD = "VotreMotDePasse123!"  # CHANGEZ CE MOT DE PASSE !
```

Choisissez un mot de passe fort avec :
- Au moins 8 caractères
- Lettres majuscules et minuscules
- Chiffres
- Caractères spéciaux

## Étape 5 : Exécuter le script de déploiement

```powershell
cd "C:\Users\ghozz\Desktop\entreprise\Projects\Ecole Assalam\ecole-assalam-app\deployment\azure"
.\deploy-powershell.ps1
```

⏱️ **Durée : environ 10-15 minutes**

Le script va créer :
- ✅ Un groupe de ressources Azure
- ✅ Un serveur PostgreSQL
- ✅ Une base de données
- ✅ Un App Service Plan
- ✅ Deux App Services (Backend + Frontend)

## Étape 6 : Déployer le code Backend

```powershell
cd ..\..\backend

# Initialiser Git (si pas déjà fait)
git init
git add .
git commit -m "Initial commit"

# Déployer sur Azure
az webapp up `
  --name ecole-assalam-backend `
  --resource-group ecole-assalam-rg `
  --runtime "NODE:20-lts"
```

## Étape 7 : Exécuter les migrations de base de données

### Option A : Via Azure Portal

1. Allez sur [portal.azure.com](https://portal.azure.com)
2. Naviguez vers votre App Service `ecole-assalam-backend`
3. Dans le menu de gauche, cliquez sur **SSH** ou **Console**
4. Exécutez :
```bash
cd /home/site/wwwroot
npm run prisma:migrate
```

### Option B : Via Azure CLI

```powershell
# Ouvrir SSH dans le navigateur
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

Puis dans le terminal SSH :
```bash
cd /home/site/wwwroot
npm run prisma:migrate
```

### Option C : Depuis votre machine locale

```powershell
cd backend

# Définir la variable d'environnement
$env:DATABASE_URL="postgresql://assalamadmin:VotreMotDePasse123!@ecole-assalam-db.postgres.database.azure.com:5432/ecole_assalam?sslmode=require"

# Exécuter les migrations
npm run prisma:migrate
```

## Étape 8 : Déployer le Frontend Flutter Web

### 8.1 Installer Flutter (si pas déjà fait)

Téléchargez Flutter : [flutter.dev/docs/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)

### 8.2 Mettre à jour l'URL de l'API

Éditez `frontend/lib/config/api_config.dart` :

```dart
static const String baseUrl = 'https://ecole-assalam-backend.azurewebsites.net/api';
```

### 8.3 Build et déployer

```powershell
cd ..\frontend

# Installer les dépendances
flutter pub get

# Build pour le web
flutter build web --release

# Créer un fichier zip
cd build\web
Compress-Archive -Path * -DestinationPath frontend.zip

# Déployer sur Azure
az webapp deployment source config-zip `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-frontend `
  --src frontend.zip
```

## Étape 9 : Tester l'application

### Backend
Ouvrez dans votre navigateur :
```
https://ecole-assalam-backend.azurewebsites.net
```

Vous devriez voir :
```json
{
  "message": "API École Assalam",
  "version": "1.0.0",
  "endpoints": { ... }
}
```

### Frontend
Ouvrez dans votre navigateur :
```
https://ecole-assalam-frontend.azurewebsites.net
```

Vous devriez voir l'écran d'accueil de l'application.

## ✅ C'est terminé !

Votre application est maintenant en ligne sur Azure !

## Commandes utiles

### Voir les logs en temps réel

```powershell
# Logs du backend
az webapp log tail --resource-group ecole-assalam-rg --name ecole-assalam-backend

# Logs du frontend
az webapp log tail --resource-group ecole-assalam-rg --name ecole-assalam-frontend
```

### Redémarrer les services

```powershell
# Redémarrer le backend
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-backend

# Redémarrer le frontend
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-frontend
```

### Arrêter/Démarrer pour économiser

```powershell
# Arrêter
az webapp stop --resource-group ecole-assalam-rg --name ecole-assalam-backend
az webapp stop --resource-group ecole-assalam-rg --name ecole-assalam-frontend
az postgres flexible-server stop --resource-group ecole-assalam-rg --name ecole-assalam-db

# Démarrer
az webapp start --resource-group ecole-assalam-rg --name ecole-assalam-backend
az webapp start --resource-group ecole-assalam-rg --name ecole-assalam-frontend
az postgres flexible-server start --resource-group ecole-assalam-rg --name ecole-assalam-db
```

### Supprimer toutes les ressources

⚠️ **Attention : Cette commande supprime TOUT !**

```powershell
az group delete --name ecole-assalam-rg --yes --no-wait
```

## Dépannage

### Erreur "Az command not found"
- Redémarrez PowerShell
- Vérifiez l'installation : `az --version`

### Erreur de connexion à la base de données
- Vérifiez le mot de passe dans les paramètres de l'App Service
- Vérifiez que le firewall PostgreSQL autorise les connexions Azure

### L'application ne démarre pas
- Consultez les logs : `az webapp log tail ...`
- Vérifiez que le build s'est bien exécuté

### Erreur CORS
```powershell
az webapp cors add `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-backend `
  --allowed-origins "https://ecole-assalam-frontend.azurewebsites.net"
```

## Coûts estimés

- **App Service Plan B1** : ~13€/mois
- **PostgreSQL Flexible Server B1ms** : ~15€/mois
- **Total** : ~28€/mois

💡 **Astuce** : Utilisez le niveau gratuit F1 pour l'App Service si c'est juste pour tester !

## Prochaines étapes

1. ✅ Configurer un domaine personnalisé
2. ✅ Ajouter SSL/TLS
3. ✅ Configurer le monitoring avec Application Insights
4. ✅ Mettre en place des sauvegardes automatiques
5. ✅ Configurer CI/CD avec GitHub Actions

Consultez le [README.md](README.md) complet pour plus de détails !
