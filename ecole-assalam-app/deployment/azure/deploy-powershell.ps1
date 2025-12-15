# Script de déploiement Azure PowerShell pour École Assalam
# Prérequis : Azure CLI installé et connecté (az login)
az login
# Variables de configuration
$RESOURCE_GROUP = "ecole-assalam-rg"
$LOCATION = "Canadacentral"  # Changer selon votre région
$APP_SERVICE_PLAN = "ecole-assalam-plan"
$BACKEND_APP = "ecole-assalam-backend"
$FRONTEND_APP = "ecole-assalam-frontend"
$DB_SERVER = "ecole-assalam-db"
$DB_NAME = "ecole_assalam"
$DB_ADMIN_USER = "assalamadmin"
$DB_ADMIN_PASSWORD = "assalamadmin!"  # CHANGEZ CE MOT DE PASSE !

Write-Host "🚀 Déploiement de l'application École Assalam sur Azure" -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Green
Write-Host ""

# 1. Créer le groupe de ressources
Write-Host "📦 Création du groupe de ressources..." -ForegroundColor Cyan
az group create `
  --name $RESOURCE_GROUP `
  --location $LOCATION

# 2. Créer le serveur PostgreSQL
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

# 3. Créer la base de données
Write-Host "🗃️  Création de la base de données..." -ForegroundColor Cyan
az postgres flexible-server db create `
  --resource-group $RESOURCE_GROUP `
  --server-name $DB_SERVER `
  --database-name $DB_NAME

# 4. Créer l'App Service Plan (Linux)
Write-Host "📋 Création de l'App Service Plan..." -ForegroundColor Cyan
az appservice plan create `
  --name $APP_SERVICE_PLAN `
  --resource-group $RESOURCE_GROUP `
  --location $LOCATION `
  --is-linux `
  --sku B1

# 5. Créer l'App Service pour le Backend (Node.js)
Write-Host "🔧 Création de l'App Service Backend..." -ForegroundColor Cyan
az webapp create `
  --resource-group $RESOURCE_GROUP `
  --plan $APP_SERVICE_PLAN `
  --name $BACKEND_APP `
  --runtime "NODE:20-lts"

# 6. Configurer les variables d'environnement pour le Backend
Write-Host "⚙️  Configuration des variables d'environnement..." -ForegroundColor Cyan
$DATABASE_URL = "postgresql://$DB_ADMIN_USER`:$DB_ADMIN_PASSWORD@$DB_SERVER.postgres.database.azure.com:5432/$DB_NAME`?sslmode=require"

az webapp config appsettings set `
  --resource-group $RESOURCE_GROUP `
  --name $BACKEND_APP `
  --settings `
    DATABASE_URL="$DATABASE_URL" `
    PORT=8080 `
    NODE_ENV=production `
    ALLOWED_ORIGINS="https://$FRONTEND_APP.azurewebsites.net,https://$BACKEND_APP.azurewebsites.net"

# 7. Créer l'App Service pour le Frontend
Write-Host "🎨 Création de l'App Service Frontend..." -ForegroundColor Cyan
az webapp create `
  --resource-group $RESOURCE_GROUP `
  --plan $APP_SERVICE_PLAN `
  --name $FRONTEND_APP `
  --runtime "NODE:20-lts"

# 8. Configurer HTTPS uniquement
Write-Host "🔒 Configuration HTTPS..." -ForegroundColor Cyan
az webapp update `
  --resource-group $RESOURCE_GROUP `
  --name $BACKEND_APP `
  --https-only true

az webapp update `
  --resource-group $RESOURCE_GROUP `
  --name $FRONTEND_APP `
  --https-only true

# 9. Afficher les informations de déploiement
Write-Host ""
Write-Host "✅ Ressources Azure créées avec succès !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Informations de connexion :" -ForegroundColor Yellow
Write-Host "  Backend URL : https://$BACKEND_APP.azurewebsites.net" -ForegroundColor White
Write-Host "  Frontend URL: https://$FRONTEND_APP.azurewebsites.net" -ForegroundColor White
Write-Host "  Database    : $DB_SERVER.postgres.database.azure.com" -ForegroundColor White
Write-Host ""
Write-Host "🔐 Credentials PostgreSQL :" -ForegroundColor Yellow
Write-Host "  User     : $DB_ADMIN_USER" -ForegroundColor White
Write-Host "  Password : $DB_ADMIN_PASSWORD" -ForegroundColor White
Write-Host "  Database : $DB_NAME" -ForegroundColor White
Write-Host ""
Write-Host "📦 Prochaines étapes :" -ForegroundColor Yellow
Write-Host "  1. Déployer le code backend : voir deployment/azure/README.md" -ForegroundColor White
Write-Host "  2. Exécuter les migrations Prisma" -ForegroundColor White
Write-Host "  3. Build et déployer le frontend Flutter Web" -ForegroundColor White
Write-Host ""
Write-Host "💡 Pour voir les logs du backend :" -ForegroundColor Cyan
Write-Host "   az webapp log tail --resource-group $RESOURCE_GROUP --name $BACKEND_APP" -ForegroundColor White
Write-Host ""
