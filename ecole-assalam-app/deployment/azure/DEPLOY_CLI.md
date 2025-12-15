# 🚀 Déploiement via Azure CLI Console

Guide complet pour déployer l'application École Assalam directement depuis **Azure Cloud Shell** ou votre terminal local.

## 📋 Prérequis

- Compte Azure actif avec abonnement
- Code source disponible sur GitHub : https://github.com/amine-ghozzi/Ecole-Assalam

## 🌐 Option 1 : Azure Cloud Shell (Recommandé)

### Étape 1 : Ouvrir Azure Cloud Shell

1. Allez sur https://portal.azure.com
2. Cliquez sur l'icône **Cloud Shell** (>_) en haut à droite
3. Choisissez **Bash**
4. Attendez que le shell se charge

**Avantage :** Déjà connecté à votre compte Azure, pas besoin d'installation !

### Étape 2 : Enregistrer les Resource Providers

```bash
# Enregistrer les providers nécessaires
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Web

# Vérifier le statut (doit afficher "Registered")
az provider show --namespace Microsoft.DBforPostgreSQL --query "registrationState" -o tsv
az provider show --namespace Microsoft.Web --query "registrationState" -o tsv
```

⏱️ **Attendez 2-3 minutes** si le statut affiche "Registering"

### Étape 3 : Créer les ressources Azure

Copiez-collez ce script complet dans Azure Cloud Shell :

```bash
# ==========================================
# Variables de configuration
# ==========================================
RESOURCE_GROUP="ecole-assalam-rg"
LOCATION="canadacentral"
APP_SERVICE_PLAN="ecole-assalam-plan"
BACKEND_APP="ecole-assalam-backend"
DB_SERVER="ecole-assalam-db"
DB_NAME="ecole_assalam"
DB_ADMIN_USER="assalamadmin"
DB_ADMIN_PASSWORD="AssalamSecure2024!"  # ⚠️ CHANGEZ CE MOT DE PASSE !

echo "🚀 Déploiement de l'application École Assalam sur Azure"
echo "========================================================"
echo ""

# ==========================================
# 1. Créer le groupe de ressources
# ==========================================
echo "📦 Création du groupe de ressources..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION \
  --output table

echo "✅ Groupe de ressources créé"
echo ""

# ==========================================
# 2. Créer l'App Service Plan
# ==========================================
echo "📋 Création de l'App Service Plan (Linux B1)..."
az appservice plan create \
  --name $APP_SERVICE_PLAN \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --is-linux \
  --sku B1 \
  --output table

echo "✅ App Service Plan créé"
echo ""

# ==========================================
# 3. Créer l'App Service Backend
# ==========================================
echo "🔧 Création de l'App Service Backend..."
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $APP_SERVICE_PLAN \
  --name $BACKEND_APP \
  --runtime "NODE:20-lts" \
  --output table

echo "✅ App Service Backend créé"
echo ""

# ==========================================
# 4. Créer PostgreSQL Flexible Server
# ==========================================
echo "🗄️  Création du serveur PostgreSQL (cela peut prendre 5-10 minutes)..."
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
  --public-access 0.0.0.0-255.255.255.255 \
  --output table

echo "✅ Serveur PostgreSQL créé"
echo ""

# ==========================================
# 5. Créer la base de données
# ==========================================
echo "🗃️  Création de la base de données..."
az postgres flexible-server db create \
  --resource-group $RESOURCE_GROUP \
  --server-name $DB_SERVER \
  --database-name $DB_NAME \
  --output table

echo "✅ Base de données créée"
echo ""

# ==========================================
# 6. Configurer les variables d'environnement
# ==========================================
echo "⚙️  Configuration des variables d'environnement..."
DATABASE_URL="postgresql://$DB_ADMIN_USER:$DB_ADMIN_PASSWORD@$DB_SERVER.postgres.database.azure.com:5432/$DB_NAME?sslmode=require"

az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $BACKEND_APP \
  --settings \
    DATABASE_URL="$DATABASE_URL" \
    PORT=8080 \
    NODE_ENV=production \
    SCM_DO_BUILD_DURING_DEPLOYMENT=true \
  --output table

echo "✅ Variables d'environnement configurées"
echo ""

# ==========================================
# 7. Activer HTTPS uniquement
# ==========================================
echo "🔒 Configuration HTTPS..."
az webapp update \
  --resource-group $RESOURCE_GROUP \
  --name $BACKEND_APP \
  --https-only true \
  --output table

echo "✅ HTTPS activé"
echo ""

# ==========================================
# Résumé
# ==========================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Toutes les ressources Azure sont créées !"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Informations importantes :"
echo "  • Backend URL   : https://$BACKEND_APP.azurewebsites.net"
echo "  • Database Host : $DB_SERVER.postgres.database.azure.com"
echo "  • Database Name : $DB_NAME"
echo "  • Database User : $DB_ADMIN_USER"
echo ""
echo "📦 Prochaines étapes :"
echo "  1. Configurer le déploiement depuis GitHub (voir ci-dessous)"
echo "  2. Déployer le code"
echo "  3. Exécuter les migrations Prisma"
echo ""
```

### Étape 4 : Configurer le déploiement depuis GitHub

#### Option A : Déploiement manuel depuis GitHub

```bash
# Configurer le déploiement externe (sans authentification GitHub)
az webapp deployment source config \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --repo-url https://github.com/amine-ghozzi/Ecole-Assalam \
  --branch main \
  --manual-integration
```

#### Option B : GitHub Actions (Recommandé)

1. **Récupérer le Publish Profile :**

```bash
az webapp deployment list-publishing-profiles \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --xml > publish-profile.xml

# Afficher le contenu
cat publish-profile.xml
```

2. **Copier le contenu XML affiché**

3. **Aller sur GitHub :**
   - Ouvrez https://github.com/amine-ghozzi/Ecole-Assalam/settings/secrets/actions
   - Cliquez sur **New repository secret**
   - Nom : `AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND`
   - Valeur : Collez le XML
   - Cliquez **Add secret**

4. **Déclencher le déploiement :**
   - Allez dans l'onglet **Actions** de votre repo GitHub
   - Cliquez sur **Deploy to Azure**
   - Cliquez sur **Run workflow** → **Run workflow**

### Étape 5 : Attendre le déploiement

⏱️ **Durée : 3-5 minutes**

Suivez la progression sur GitHub Actions :
https://github.com/amine-ghozzi/Ecole-Assalam/actions

### Étape 6 : Exécuter les migrations Prisma

Une fois le code déployé, connectez-vous en SSH :

```bash
# Se connecter en SSH à l'App Service
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

Dans le terminal SSH :

```bash
# Aller dans le répertoire de l'application
cd /home/site/wwwroot

# Vérifier que les fichiers sont présents
ls -la

# Générer le client Prisma
npx prisma generate

# Exécuter les migrations
npx prisma migrate deploy

# Vérifier la connexion à la base de données
npx prisma db push

# Sortir du SSH
exit
```

### Étape 7 : Redémarrer l'application

```bash
# Redémarrer l'App Service
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-backend

echo "✅ Application redémarrée"
```

### Étape 8 : Tester l'API

```bash
# Tester l'endpoint racine
curl https://ecole-assalam-backend.azurewebsites.net

# Tester l'API niveaux
curl https://ecole-assalam-backend.azurewebsites.net/api/niveaux
```

Ou ouvrez dans votre navigateur :
👉 https://ecole-assalam-backend.azurewebsites.net

Vous devriez voir :
```json
{
  "message": "API École Assalam",
  "version": "1.0.0",
  "endpoints": { ... }
}
```

---

## 💻 Option 2 : Terminal Local (Windows/Mac/Linux)

### Étape 1 : Installer Azure CLI

**Windows :**
```powershell
# PowerShell
winget install -e --id Microsoft.AzureCLI
```

**Mac :**
```bash
brew install azure-cli
```

**Linux :**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Étape 2 : Se connecter à Azure

```bash
# Se connecter avec le bon tenant
az login --tenant 47704e67-4051-4616-9ff2-1562852375dd

# Sélectionner l'abonnement
az account set --subscription "0330540f-3a0d-45a4-9e32-d5316388ce19"

# Vérifier
az account show --output table
```

### Étape 3 : Suivre les mêmes étapes que Option 1

À partir d'ici, suivez les **Étapes 2 à 8** de l'Option 1.

---

## 🔧 Commandes utiles

### Voir les logs en temps réel

```bash
az webapp log tail --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

### Télécharger les logs

```bash
az webapp log download \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --log-file logs.zip
```

### Voir les logs de déploiement

```bash
az webapp log deployment show \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend
```

### Redémarrer l'application

```bash
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

### Voir la configuration

```bash
az webapp config show \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend
```

### Voir les variables d'environnement

```bash
az webapp config appsettings list \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --output table
```

### Modifier une variable d'environnement

```bash
az webapp config appsettings set \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --settings NOUVELLE_VARIABLE="valeur"
```

### Voir l'état du serveur PostgreSQL

```bash
az postgres flexible-server show \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-db \
  --output table
```

### Arrêter/Démarrer les services (économiser les coûts)

```bash
# Arrêter
az webapp stop --resource-group ecole-assalam-rg --name ecole-assalam-backend
az postgres flexible-server stop --resource-group ecole-assalam-rg --name ecole-assalam-db

# Démarrer
az webapp start --resource-group ecole-assalam-rg --name ecole-assalam-backend
az postgres flexible-server start --resource-group ecole-assalam-rg --name ecole-assalam-db
```

---

## ⚠️ Dépannage

### Problème : L'application ne démarre pas

```bash
# Voir les logs d'erreur
az webapp log tail --resource-group ecole-assalam-rg --name ecole-assalam-backend

# Vérifier les processus
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
# Puis dans SSH : ps aux | grep node
```

### Problème : Erreur de connexion à la base de données

```bash
# Vérifier la DATABASE_URL
az webapp config appsettings list \
  --resource-group ecole-assalam-rg \
  --name ecole-assalam-backend \
  --query "[?name=='DATABASE_URL']"

# Tester la connexion depuis SSH
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
# Dans SSH :
echo $DATABASE_URL
npx prisma db push
```

### Problème : Les migrations Prisma échouent

```bash
# Se connecter en SSH
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend

# Dans SSH :
cd /home/site/wwwroot
rm -rf node_modules/.prisma
npm run prisma:generate
npx prisma migrate deploy
```

### Problème : GitHub Actions échoue

1. Vérifiez que le secret `AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND` est bien configuré
2. Vérifiez les logs dans l'onglet Actions de GitHub
3. Re-téléchargez le publish profile et remplacez le secret

---

## 🧹 Nettoyer les ressources

**⚠️ ATTENTION : Cela supprime TOUT !**

```bash
az group delete --name ecole-assalam-rg --yes --no-wait
```

---

## 📊 Coûts mensuels estimés

- **App Service Plan B1** : ~13€/mois
- **PostgreSQL Flexible B1ms** : ~15€/mois
- **Total** : ~28€/mois

**Compte gratuit Azure :** 200$ de crédit pour les nouveaux comptes

---

## ✅ Checklist de déploiement

- [ ] Azure CLI installé (si local) ou Cloud Shell ouvert
- [ ] Connecté à Azure
- [ ] Abonnement correct sélectionné
- [ ] Resource Providers enregistrés (Microsoft.DBforPostgreSQL, Microsoft.Web)
- [ ] Mot de passe modifié dans le script
- [ ] Ressources Azure créées (groupe, app service, database)
- [ ] GitHub Secret configuré (AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND)
- [ ] Code déployé via GitHub Actions
- [ ] Migrations Prisma exécutées (SSH)
- [ ] Application redémarrée
- [ ] API testée (https://ecole-assalam-backend.azurewebsites.net)

---

## 🎯 Résumé rapide

```bash
# 1. Connexion (Option 1 : Cloud Shell déjà connecté | Option 2 : az login)
az account show

# 2. Enregistrer providers
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Web

# 3. Créer ressources (copier-coller le script complet de l'Étape 3)

# 4. Configurer GitHub Actions secret avec le publish profile

# 5. Déclencher le déploiement sur GitHub Actions

# 6. Exécuter migrations via SSH
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
# Dans SSH : npx prisma generate && npx prisma migrate deploy

# 7. Tester
curl https://ecole-assalam-backend.azurewebsites.net
```

---

**Votre application est maintenant en ligne ! 🎉**

👉 **URL Backend** : https://ecole-assalam-backend.azurewebsites.net
