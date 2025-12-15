# Script de déploiement du backend via ZIP (SANS GIT)

$RESOURCE_GROUP = "ecole-assalam-rg"
$BACKEND_APP = "ecole-assalam-backend"

Write-Host "📦 Déploiement du backend sur Azure" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# 1. Créer le fichier ZIP
Write-Host "📁 Création du fichier ZIP..." -ForegroundColor Cyan

# Créer un dossier temporaire
$tempDir = Join-Path $env:TEMP "backend-deploy"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copier les fichiers nécessaires
Write-Host "  📄 Copie des fichiers..." -ForegroundColor Gray
Copy-Item -Path "package.json" -Destination $tempDir
Copy-Item -Path "package-lock.json" -Destination $tempDir -ErrorAction SilentlyContinue
Copy-Item -Path "tsconfig.json" -Destination $tempDir
Copy-Item -Path "prisma" -Destination $tempDir -Recurse
Copy-Item -Path "src" -Destination $tempDir -Recurse
Copy-Item -Path ".env.example" -Destination $tempDir -ErrorAction SilentlyContinue

# Créer un fichier .deployment pour Azure
$deploymentConfig = @"
[config]
SCM_DO_BUILD_DURING_DEPLOYMENT=true
"@
$deploymentConfig | Out-File -FilePath (Join-Path $tempDir ".deployment") -Encoding utf8

# Créer le ZIP
$zipPath = Join-Path $env:TEMP "backend-deploy.zip"
if (Test-Path $zipPath) {
    Remove-Item -Force $zipPath
}

Write-Host "  📦 Compression..." -ForegroundColor Gray
Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath -Force

Write-Host "  ✅ ZIP créé : $zipPath" -ForegroundColor Green
Write-Host ""

# 2. Déployer sur Azure
Write-Host "🚀 Déploiement sur Azure..." -ForegroundColor Cyan
az webapp deployment source config-zip `
  --resource-group $RESOURCE_GROUP `
  --name $BACKEND_APP `
  --src $zipPath

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Déploiement réussi !" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Prochaines étapes :" -ForegroundColor Yellow
    Write-Host "  1. Exécuter les migrations Prisma" -ForegroundColor White
    Write-Host "     az webapp ssh --resource-group $RESOURCE_GROUP --name $BACKEND_APP" -ForegroundColor Gray
    Write-Host "     cd /home/site/wwwroot && npm run prisma:migrate" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. Tester l'API :" -ForegroundColor White
    Write-Host "     https://$BACKEND_APP.azurewebsites.net" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Erreur lors du déploiement" -ForegroundColor Red
    Write-Host "   Vérifiez les logs avec :" -ForegroundColor Yellow
    Write-Host "   az webapp log tail --resource-group $RESOURCE_GROUP --name $BACKEND_APP" -ForegroundColor Gray
    Write-Host ""
}

# Nettoyage
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
Remove-Item -Force $zipPath -ErrorAction SilentlyContinue

Write-Host "🧹 Fichiers temporaires nettoyés" -ForegroundColor Gray
Write-Host ""
