# 🚀 Déploiement Azure SANS Git

Guide complet pour déployer l'application sur Azure **sans utiliser Git**, uniquement via upload ZIP.

## ✅ Prérequis

- Azure CLI installé
- Compte Azure actif
- PowerShell (Windows)

## 📋 Étapes de déploiement

### Étape 1 : Se connecter à Azure

```powershell
# Se connecter au bon tenant
az login --tenant 47704e67-4051-4616-9ff2-1562852375dd

# Sélectionner l'abonnement
az account set --subscription "0330540f-3a0d-45a4-9e32-d5316388ce19"

# Vérifier
az account show --output table
```

### Étape 2 : Enregistrer les Resource Providers (UNE FOIS)

```powershell
# Enregistrer les providers
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Web

# Attendre 3-5 minutes ⏱️

# Vérifier l'état
az provider show --namespace Microsoft.DBforPostgreSQL --query "registrationState"
az provider show --namespace Microsoft.Web --query "registrationState"

# Les deux doivent afficher "Registered"
```

### Étape 3 : Créer les ressources Azure

```powershell
cd "C:\Users\ghozz\Desktop\entreprise\Projects\Ecole Assalam\ecole-assalam-app\deployment\azure"

# IMPORTANT : Modifier le mot de passe dans deploy-direct.ps1 AVANT d'exécuter
# Ligne 10 : $DB_ADMIN_PASSWORD = "VotreMotDePasseSecurise123!"

# Exécuter le script
.\deploy-direct.ps1
```

⏱️ **Durée : 10-15 minutes**

Ce script crée :
- ✅ Groupe de ressources
- ✅ App Service Plan (Linux)
- ✅ App Service Backend
- ✅ PostgreSQL Flexible Server
- ✅ Base de données

### Étape 4 : Déployer le code backend

```powershell
cd "C:\Users\ghozz\Desktop\entreprise\Projects\Ecole Assalam\ecole-assalam-app\backend"

# Déployer via ZIP
.\deploy-backend.ps1
```

⏱️ **Durée : 3-5 minutes**

Ce script :
- 📦 Crée un ZIP avec le code backend
- 🚀 Upload sur Azure
- 🔨 Build automatique (npm install, build TypeScript)

### Étape 5 : Exécuter les migrations Prisma

```powershell
# Se connecter en SSH à l'App Service
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

Dans le terminal SSH qui s'ouvre :

```bash
# Aller dans le répertoire
cd /home/site/wwwroot

# Générer le client Prisma
npm run prisma:generate

# Exécuter les migrations
npm run prisma:migrate

# Redémarrer l'app
exit
```

Puis dans PowerShell :

```powershell
# Redémarrer l'application
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

### Étape 6 : Tester l'API

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

✅ **Votre backend est en ligne !**

---

## 🎨 Déployer le Frontend (Optionnel)

### Méthode 1 : Azure Static Web Apps (Recommandé)

```powershell
# Aller dans le frontend
cd "C:\Users\ghozz\Desktop\entreprise\Projects\Ecole Assalam\ecole-assalam-app\frontend"

# Build Flutter Web
flutter build web --release

# Créer le ZIP
Compress-Archive -Path "build\web\*" -DestinationPath "frontend.zip" -Force

# Créer Static Web App
az staticwebapp create `
  --name ecole-assalam-frontend `
  --resource-group ecole-assalam-rg `
  --location canadacentral

# Déployer
az staticwebapp users update `
  --name ecole-assalam-frontend `
  --resource-group ecole-assalam-rg
```

### Méthode 2 : App Service simple

```powershell
# Créer une App Service pour le frontend
az webapp create `
  --resource-group ecole-assalam-rg `
  --plan ecole-assalam-plan `
  --name ecole-assalam-frontend `
  --runtime "NODE:20-lts"

# Modifier l'URL de l'API dans frontend/lib/config/api_config.dart
# baseUrl = 'https://ecole-assalam-backend.azurewebsites.net/api'

# Rebuild
flutter build web --release

# Créer le ZIP
cd build\web
Compress-Archive -Path "*" -DestinationPath "frontend.zip" -Force

# Déployer
az webapp deployment source config-zip `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-frontend `
  --src frontend.zip
```

---

## 🔧 Commandes utiles

### Voir les logs en temps réel

```powershell
az webapp log tail --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

### Redémarrer l'application

```powershell
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

### Modifier les variables d'environnement

```powershell
az webapp config appsettings set `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-backend `
  --settings NOUVELLE_VARIABLE="valeur"
```

### Se connecter en SSH

```powershell
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

### Télécharger les logs

```powershell
az webapp log download `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-backend `
  --log-file logs.zip
```

---

## ⚠️ Dépannage

### Problème : Déploiement échoue

**Solution :**

```powershell
# Vérifier les logs de déploiement
az webapp log deployment show `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-backend
```

### Problème : L'app ne démarre pas

**Solution :**

```powershell
# Voir les logs d'erreur
az webapp log tail --resource-group ecole-assalam-rg --name ecole-assalam-backend

# Vérifier la configuration
az webapp config show `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-backend
```

### Problème : Erreur de connexion à la base de données

**Solution :**

```powershell
# Vérifier que le serveur PostgreSQL est accessible
az postgres flexible-server show `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-db

# Vérifier les paramètres de connexion
az webapp config appsettings list `
  --resource-group ecole-assalam-rg `
  --name ecole-assalam-backend `
  --query "[?name=='DATABASE_URL']"
```

### Problème : Les migrations Prisma échouent

**Solution :**

```bash
# Dans SSH
cd /home/site/wwwroot

# Vérifier la connexion DB
echo $DATABASE_URL

# Forcer la régénération
npx prisma generate --schema=./prisma/schema.prisma

# Réessayer
npx prisma migrate deploy
```

---

## 🧹 Nettoyer les ressources

Pour **supprimer complètement** toutes les ressources Azure :

```powershell
# ⚠️ ATTENTION : Cela supprime TOUT !
az group delete --name ecole-assalam-rg --yes --no-wait
```

---

## 📊 Coûts

- **App Service Plan B1** : ~13€/mois
- **PostgreSQL Flexible B1ms** : ~15€/mois
- **Total** : ~28€/mois

**Astuce :** Arrêtez les services quand vous ne les utilisez pas :

```powershell
# Arrêter
az webapp stop --resource-group ecole-assalam-rg --name ecole-assalam-backend
az postgres flexible-server stop --resource-group ecole-assalam-rg --name ecole-assalam-db

# Redémarrer
az webapp start --resource-group ecole-assalam-rg --name ecole-assalam-backend
az postgres flexible-server start --resource-group ecole-assalam-rg --name ecole-assalam-db
```

---

## ✅ Checklist de déploiement

- [ ] Azure CLI installé
- [ ] Connecté à Azure (`az login`)
- [ ] Abonnement sélectionné
- [ ] Providers enregistrés (PostgreSQL, Web)
- [ ] Mot de passe modifié dans `deploy-direct.ps1`
- [ ] Ressources créées (`deploy-direct.ps1`)
- [ ] Code déployé (`deploy-backend.ps1`)
- [ ] Migrations exécutées (SSH + `prisma:migrate`)
- [ ] API testée (navigateur)
- [ ] Frontend déployé (optionnel)

---

## 🎯 Résumé rapide

```powershell
# 1. Connexion
az login --tenant 47704e67-4051-4616-9ff2-1562852375dd
az account set --subscription "0330540f-3a0d-45a4-9e32-d5316388ce19"

# 2. Enregistrer providers (une fois)
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Web

# 3. Créer ressources
cd deployment/azure
.\deploy-direct.ps1

# 4. Déployer code
cd ../../backend
.\deploy-backend.ps1

# 5. Migrations
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
cd /home/site/wwwroot && npm run prisma:migrate && exit

# 6. Tester
# https://ecole-assalam-backend.azurewebsites.net
```

**C'est tout ! Votre application est en ligne ! 🎉**
