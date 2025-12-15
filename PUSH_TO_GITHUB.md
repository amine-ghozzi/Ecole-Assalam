# 🚀 Pousser les corrections sur GitHub

## Fichiers modifiés

✅ **`.github/workflows/azure-deploy.yml`** - Workflow corrigé (sans cache npm, chemins corrects)
✅ **`.gitignore`** - Nouveau fichier pour ignorer les credentials

## ⚠️ IMPORTANT : Supprimer le fichier publish.xml

Le fichier `ecole-assalam-app/deployment/azure/publish.xml` contient vos **credentials Azure** et **NE DOIT PAS** être poussé sur GitHub !

Supprimez-le d'abord :

```bash
cd "C:\Users\ghozz\Desktop\entreprise\Projects\Ecole Assalam"

# Supprimer le fichier
rm -f ecole-assalam-app/deployment/azure/publish.xml

# Ou sous Windows PowerShell :
# Remove-Item "ecole-assalam-app\deployment\azure\publish.xml" -Force
```

## 📝 Commandes Git à exécuter

Ouvrez **Git Bash** ou **PowerShell** dans le dossier du projet :

```bash
# Aller dans le répertoire du repo
cd "C:\Users\ghozz\Desktop\entreprise\Projects\Ecole Assalam"

# Vérifier l'état
git status

# Ajouter tous les fichiers modifiés
git add .

# Créer un commit
git commit -m "Fix: Correct GitHub Actions workflow paths and remove npm cache"

# Pousser sur GitHub
git push origin main
```

## 🎯 Après le push

1. **Allez sur GitHub Actions** :
   ```
   https://github.com/amine-ghozzi/Ecole-Assalam/actions
   ```

2. Le workflow devrait se déclencher automatiquement

3. **Attendez 3-5 minutes** que le build se termine

4. Si le build échoue encore, vérifiez que le secret GitHub est bien configuré :
   - Allez sur : https://github.com/amine-ghozzi/Ecole-Assalam/settings/secrets/actions
   - Vérifiez que `AZURE_WEBAPP_PUBLISH_PROFILE_BACKEND` existe
   - Si non, créez-le avec le contenu du fichier `publish.xml` que vous avez récupéré

## ✅ Une fois le déploiement réussi

Connectez-vous en SSH pour exécuter les migrations :

```bash
# Dans Azure Cloud Shell
az webapp ssh --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

Puis dans le SSH :

```bash
cd /home/site/wwwroot
npx prisma generate
npx prisma migrate deploy
exit
```

Redémarrez l'app :

```bash
az webapp restart --resource-group ecole-assalam-rg --name ecole-assalam-backend
```

Testez :

```bash
curl https://ecole-assalam-backend.azurewebsites.net
```

---

**Bon déploiement ! 🎉**
