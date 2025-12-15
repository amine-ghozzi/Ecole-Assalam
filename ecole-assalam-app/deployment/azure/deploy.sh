#!/bin/bash

# Script de déploiement Azure pour École Assalam
# Prérequis : Azure CLI installé et connecté (az login)

# Variables de configuration
RESOURCE_GROUP="ecole-assalam-rg"
LOCATION="westeurope"  # Changer selon votre région (francecentral, etc.)
APP_SERVICE_PLAN="ecole-assalam-plan"
BACKEND_APP="ecole-assalam-backend"
FRONTEND_APP="ecole-assalam-frontend"
DB_SERVER="ecole-assalam-db"
DB_NAME="ecole_assalam"
DB_ADMIN_USER="assalamadmin"
DB_ADMIN_PASSWORD="assalamadmin!"  # CHANGEZ CE MOT DE PASSE !

echo "🚀 Déploiement de l'application École Assalam sur Azure"
echo "======================================================="

# 1. Créer le groupe de ressources
echo "📦 Création du groupe de ressources..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# 2. Créer le serveur PostgreSQL
echo "🗄️  Création du serveur PostgreSQL..."
az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP \
  --name $DB_SERVER \
  --location $LOCATION \
  --admin-user $DB_ADMIN_USER \
  --admin-password $DB_ADMIN_PASSWORD \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --version 14 \
  --storage-size 32 \
  --public-access 0.0.0.0-255.255.255.255

# 3. Créer la base de données
echo "🗃️  Création de la base de données..."
az postgres flexible-server db create \
  --resource-group $RESOURCE_GROUP \
  --server-name $DB_SERVER \
  --database-name $DB_NAME

# 4. Créer l'App Service Plan (Linux)
echo "📋 Création de l'App Service Plan..."
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --is-linux \
  --sku B1

# 5. Créer l'App Service pour le Backend (Node.js)
echo "🔧 Création de l'App Service Backend..."
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --name $BACKEND_APP \
  --runtime "NODE:20-lts"

# 6. Configurer les variables d'environnement pour le Backend
echo "⚙️  Configuration des variables d'environnement..."
DATABASE_URL="postgresql://$DB_ADMIN_USER:$DB_ADMIN_PASSWORD@$DB_SERVER.postgres.database.azure.com:5432/$DB_NAME?sslmode=require"

az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $BACKEND_APP \
  --settings \
    DATABASE_URL="$DATABASE_URL" \
    PORT=8080 \
    NODE_ENV=production \
    ALLOWED_ORIGINS="https://$FRONTEND_APP.azurewebsites.net,https://$BACKEND_APP.azurewebsites.net"

# 7. Créer l'App Service pour le Frontend (Static Web App ou Container)
echo "🎨 Création de l'App Service Frontend..."
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --name $FRONTEND_APP \
  --runtime "NODE:20-lts"

# 8. Afficher les informations de déploiement
echo ""
echo "✅ Ressources Azure créées avec succès !"
echo "========================================"
echo ""
echo "📝 Informations de connexion :"
echo "  Backend URL : https://$BACKEND_APP.azurewebsites.net"
echo "  Frontend URL: https://$FRONTEND_APP.azurewebsites.net"
echo "  Database    : $DB_SERVER.postgres.database.azure.com"
echo ""
echo "🔐 Credentials PostgreSQL :"
echo "  User     : $DB_ADMIN_USER"
echo "  Password : $DB_ADMIN_PASSWORD"
echo "  Database : $DB_NAME"
echo ""
echo "📦 Prochaines étapes :"
echo "  1. Déployer le code backend : cd backend && az webapp up --name $BACKEND_APP --resource-group $RESOURCE_GROUP"
echo "  2. Exécuter les migrations Prisma"
echo "  3. Build et déployer le frontend Flutter Web"
echo ""
