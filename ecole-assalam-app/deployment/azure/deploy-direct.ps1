# Script de déploiement direct Azure (SANS GIT)
# Déploie via ZIP upload

$RESOURCE_GROUP = "ecole-assalam-rg"
$LOCATION = "canadacentral"
$APP_SERVICE_PLAN = "ecole-assalam-plan"
$BACKEND_APP = "ecole-assalam-backend"
$DB_SERVER = "ecole-assalam-db"
$DB_NAME = "ecole_assalam"
$DB_ADMIN_USER = "assalamadmin"
$DB_ADMIN_PASSWORD = "VotreMotDePasseSecurise123!"  # CHANGEZ !

Write-Host "🚀 Déploiement direct sur Azure (sans Git)" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# 1. Créer le groupe de ressources
Write-Host "📦 Création du groupe de ressources..." -ForegroundColor Cyan
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Créer l'App Service Plan
Write-Host "📋 Création de l'App Service Plan..." -ForegroundColor Cyan
az appservice plan create `
  --name $APP_SERVICE_PLAN `
  --resource-group $RESOURCE_GROUP `
  --location $LOCATION `
  --is-linux `
  --sku B1

# 3. Créer l'App Service Backend
Write-Host "🔧 Création de l'App Service Backend..." -ForegroundColor Cyan
az webapp create `
  --resource-group $RESOURCE_GROUP `
  --plan $APP_SERVICE_PLAN `
  --name $BACKEND_APP `
  --runtime "NODE:20-lts"

# 4. Créer PostgreSQL
Write-Host "🗄️  Création du serveur PostgreSQL..." -ForegroundColor Cyan
az postgres flexible-server create `
  --resource-group $RESOURCE_GROUP `
  --name $DB_SERVER `
  --location $LOCATION `
  --admin-user $DB_ADMIN_USER `
  --admin-password $DB_ADMIN_PASSWORD `
  --sku-name Standard_B1ms `
  --tier Burstable `
  --version 14 `
  --storage-size 32 `
  --public-access 0.0.0.0-255.255.255.255

# 5. Créer la base de données
Write-Host "🗃️  Création de la base de données..." -ForegroundColor Cyan
az postgres flexible-server db create `
  --resource-group $RESOURCE_GROUP `
  --server-name $DB_SERVER `
  --database-name $DB_NAME

# 6. Configurer les variables d'environnement
Write-Host "⚙️  Configuration des variables d'environnement..." -ForegroundColor Cyan
$DATABASE_URL = "postgresql://$DB_ADMIN_USER`:$DB_ADMIN_PASSWORD@$DB_SERVER.postgres.database.azure.com:5432/$DB_NAME`?sslmode=require"

az webapp config appsettings set `
  --resource-group $RESOURCE_GROUP `
  --name $BACKEND_APP `
  --settings `
    DATABASE_URL="$DATABASE_URL" `
    PORT=8080 `
    NODE_ENV=production `
    SCM_DO_BUILD_DURING_DEPLOYMENT=true

# 7. Activer HTTPS
Write-Host "🔒 Configuration HTTPS..." -ForegroundColor Cyan
az webapp update `
  --resource-group $RESOURCE_GROUP `
  --name $BACKEND_APP `
  --https-only true

Write-Host ""
Write-Host "✅ Ressources créées avec succès !" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Informations :" -ForegroundColor Yellow
Write-Host "  Backend URL : https://$BACKEND_APP.azurewebsites.net" -ForegroundColor White
Write-Host "  Database    : $DB_SERVER.postgres.database.azure.com" -ForegroundColor White
Write-Host ""
Write-Host "📦 Prochaine étape : Déployer le code backend" -ForegroundColor Yellow
Write-Host "   cd ..\..\backend" -ForegroundColor White
Write-Host "   Exécutez : .\deploy-backend.ps1" -ForegroundColor White
Write-Host ""
