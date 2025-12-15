# Déploiement sur Azure - École Assalam

Ce guide explique comment déployer l'application École Assalam sur Azure Linux.

## Prérequis

1. **Compte Azure** : [Créer un compte gratuit](https://azure.microsoft.com/free/)
2. **Azure CLI** : [Installer Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
3. **Git** : Pour le déploiement du code

## Architecture de déploiement

```
┌─────────────────────────────────────────┐
│         Azure Resource Group            │
│  ┌───────────────────────────────────┐  │
│  │   Azure App Service Plan (Linux)  │  │
│  │   ┌─────────────┐  ┌────────────┐ │  │
│  │   │  Backend    │  │  Frontend  │ │  │
│  │   │  (Node.js)  │  │  (Static)  │ │  │
│  │   └──────┬──────┘  └────────────┘ │  │
│  └──────────┼─────────────────────────┘  │
│             │                            │
│  ┌──────────▼──────────────────────────┐ │
│  │  Azure Database for PostgreSQL     │ │
│  │  (Flexible Server)                 │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Option 1 : Déploiement automatique avec le script

### 1. Installer Azure CLI

**Sur Windows (PowerShell en tant qu'administrateur) :**
```powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
rm .\AzureCLI.msi
```

**Sur Linux/macOS :**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### 2. Se connecter à Azure

```bash
az login
```

Votre navigateur s'ouvrira pour vous authentifier.

### 3. Vérifier votre abonnement

```bash
az account list --output table
az account set --subscription "Nom-de-votre-abonnement"
```

### 4. Modifier les variables dans le script

Éditez `deployment/azure/deploy.sh` et modifiez :
- `DB_ADMIN_PASSWORD` : Choisissez un mot de passe fort
- `LOCATION` : Choisissez votre région Azure (francecentral, westeurope, etc.)
- Les noms des ressources si nécessaire

### 5. Exécuter le script de déploiement

**Sur Linux/macOS ou WSL (Windows Subsystem for Linux) :**
```bash
cd deployment/azure
chmod +x deploy.sh
./deploy.sh
```

**Sur Windows PowerShell, utilisez Git Bash ou WSL**

## Option 2 : Déploiement manuel étape par étape

### Étape 1 : Créer le groupe de ressources

```bash
az group create \
  --name ecole-assalam-rg \
  --location francecentral
```

### Étape 2 : Créer la base de données PostgreSQL

```bash
az postgres flexible-server create \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-db \
  --location francecentral \
  --admin-user assalamadmin \
  --admin-password "VotreMotDePasse123!" \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --version 14 \
  --storage-size 32 \
  --public-access 0.0.0.0-255.255.255.255
```

### Étape 3 : Créer la base de données

```bash
az postgres flexible-server db create \
  --resource-group ecole-assalam-rg \
  --server-name ecole-assalam-db \
  --database-name ecole_assalam
```

### Étape 4 : Créer l'App Service Plan

```bash
az appservice plan create \
  --name ecole-assalam-plan \
  --resource-group ecole-assalam-rg \
  --location francecentral \
  --is-linux \
  --sku B1
```

### Étape 5 : Créer l'App Service Backend

```bash
az webapp create \
  --resource-group ecole-assalam-rg \
  --plan ecole-assalam-plan \
  --name ecole-assalam-backend \
  --runtime "NODE:20-lts"
```

### Étape 6 : Configurer les variables d'environnement

```bash
az webapp config appsettings set \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --settings \
    DATABASE_URL="postgresql://assalamadmin:VotreMotDePasse123!@ecole-assalam-db.postgres.database.azure.com:5432/ecole_assalam?sslmode=require" \
    PORT=8080 \
    NODE_ENV=production
```

### Étape 7 : Déployer le code Backend

```bash
cd ../../backend

# Créer un fichier .deployment
cat > .deployment << EOF
[config]
SCM_DO_BUILD_DURING_DEPLOYMENT=true
EOF

# Déployer avec Git
git init
git add .
git commit -m "Initial backend deployment"
az webapp deployment source config-local-git --name ecole-assalam-backend --resource-group ecole-assalam-rg
 "url": "https://None@ecole-assalam-backend.scm.azurewebsites.net/ecole-assalam-backend.git"
# Obtenir l'URL Git de déploiement
DEPLOY_URL=$(az webapp deployment source show --name ecole-assalam-backend --resource-group ecole-assalam-rg  --query url -o tsv)

# Ajouter le remote et push
git remote add azure "https://None@ecole-assalam-backend.scm.azurewebsites.net/ecole-assalam-backend.git"
git push azure main:master
```

### Étape 8 : Exécuter les migrations Prisma

**Option A : Via SSH dans App Service**

1. Activer SSH :
```bash
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

2. Dans le terminal SSH :
```bash
cd /home/site/wwwroot
npm run prisma:migrate
```

**Option B : Localement avec connexion distante**

```bash
# Dans le dossier backend local
export DATABASE_URL="postgresql://assalamadmin:VotreMotDePasse123!@ecole-assalam-db.postgres.database.azure.com:5432/ecole_assalam?sslmode=require"
npm run prisma:migrate
```

### Étape 9 : Déployer le Frontend Flutter Web

```bash
cd ../frontend

# Build l'application Flutter pour le web
flutter build web

# Créer un App Service pour les fichiers statiques
az webapp create \
  --resource-group ecole-assalam-rg \
  --plan ecole-assalam-plan \
  --name ecole-assalam-frontend \
  --runtime "NODE:20-lts"

# Déployer les fichiers build
cd build/web
zip -r frontend.zip .
az webapp deployment source config-zip \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-frontend \
  --src frontend.zip
```

### Étape 10 : Configurer l'URL de l'API dans le Frontend

Modifiez `frontend/lib/config/api_config.dart` :

```dart
static const String baseUrl = 'https://ecole-assalam-backend.azurewebsites.net/api';
```

Puis reconstruisez et redéployez le frontend.

## Option 3 : Utiliser Azure Static Web Apps (Pour le Frontend)

Cette option est optimale pour le frontend Flutter Web :

```bash
# Installer l'extension Static Web Apps
az extension add --name staticwebapp

# Créer la Static Web App
az staticwebapp create \
  --name ecole-assalam-app \
  --resource-group ecole-assalam-rg \
  --location francecentral \
  --source https://github.com/votre-username/ecole-assalam \
  --branch main \
  --app-location "/frontend" \
  --output-location "/build/web"
```

## Vérification du déploiement

### Tester le Backend

```bash
curl https://ecole-assalam-backend.azurewebsites.net/
```

Vous devriez voir la réponse JSON de l'API.

### Tester le Frontend

Ouvrez dans votre navigateur :
```
https://ecole-assalam-frontend.azurewebsites.net
```

## Monitoring et Logs

### Voir les logs du Backend

```bash
az webapp log tail \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend
```

### Activer Application Insights (recommandé)

```bash
az monitor app-insights component create \
  --app ecole-assalam-insights \
  --location francecentral \
  --resource-group ecole-assalam-rg

# Lier à l'App Service
INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app ecole-assalam-insights \
  --resource-group ecole-assalam-rg \
  --query instrumentationKey -o tsv)

az webapp config appsettings set \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=$INSTRUMENTATION_KEY
```

## Gestion des coûts

### Tarification estimée (région France Central)

- **App Service Plan B1** : ~13€/mois
- **PostgreSQL Flexible Server B1ms** : ~15€/mois
- **Static Web App (gratuit)** : 0€ (avec GitHub)

**Total estimé : ~28€/mois**

### Réduire les coûts

```bash
# Arrêter les services quand vous ne les utilisez pas
az webapp stop --name ecole-assalam-backend --resource-group ecole-assalam-rg
az webapp stop --name ecole-assalam-frontend --resource-group ecole-assalam-rg
az postgres flexible-server stop --name ecole-assalam-db --resource-group ecole-assalam-rg

# Redémarrer
az webapp start --name ecole-assalam-backend --resource-group ecole-assalam-rg
az webapp start --name ecole-assalam-frontend --resource-group ecole-assalam-rg
az postgres flexible-server start --name ecole-assalam-db --resource-group ecole-assalam-rg
```

## Sécurité

### Configurer HTTPS uniquement

```bash
az webapp update \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --https-only true
```

### Configurer un domaine personnalisé (optionnel)

```bash
az webapp config hostname add \
  --webapp-name ecole-assalam-backend \
  --resource-group ecole-assalam-rg \
  --hostname api.votre-domaine.com
```

## Dépannage

### Les migrations Prisma échouent

Vérifiez la connexion à la base de données :
```bash
az postgres flexible-server show \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-db
```

### L'application ne démarre pas

Consultez les logs :
```bash
az webapp log download \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --log-file logs.zip
```

### Problème de CORS

Ajoutez les origines autorisées :
```bash
az webapp cors add \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --allowed-origins "https://ecole-assalam-frontend.azurewebsites.net"
```

## Nettoyage (Supprimer toutes les ressources)

```bash
az group delete --name ecole-assalam-rg --yes --no-wait
```

## Support

- [Documentation Azure App Service](https://docs.microsoft.com/azure/app-service/)
- [Documentation PostgreSQL Flexible Server](https://docs.microsoft.com/azure/postgresql/flexible-server/)
- [Azure Static Web Apps](https://docs.microsoft.com/azure/static-web-apps/)
