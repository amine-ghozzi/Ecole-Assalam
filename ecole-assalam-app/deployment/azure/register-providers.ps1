# Script pour enregistrer les Resource Providers Azure nécessaires
# À exécuter AVANT deploy-powershell.ps1

Write-Host "🔧 Enregistrement des Resource Providers Azure" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# Liste des providers nécessaires
$providers = @(
    "Microsoft.DBforPostgreSQL",
    "Microsoft.Web",
    "Microsoft.Storage"
)

# Enregistrer chaque provider
foreach ($provider in $providers) {
    Write-Host "📋 Enregistrement de $provider..." -ForegroundColor Cyan
    az provider register --namespace $provider
}

Write-Host ""
Write-Host "⏳ Vérification de l'état d'enregistrement..." -ForegroundColor Yellow
Write-Host ""

# Attendre que tous les providers soient enregistrés
$allRegistered = $false
$maxAttempts = 30
$attempt = 0

while (-not $allRegistered -and $attempt -lt $maxAttempts) {
    $attempt++
    $allRegistered = $true

    foreach ($provider in $providers) {
        $state = az provider show --namespace $provider --query "registrationState" -o tsv

        if ($state -ne "Registered") {
            $allRegistered = $false
            Write-Host "  ⏳ $provider : $state" -ForegroundColor Yellow
        } else {
            Write-Host "  ✅ $provider : $state" -ForegroundColor Green
        }
    }

    if (-not $allRegistered) {
        Write-Host ""
        Write-Host "  Attente de 10 secondes... (Tentative $attempt/$maxAttempts)" -ForegroundColor Gray
        Start-Sleep -Seconds 10
        Write-Host ""
    }
}

Write-Host ""
if ($allRegistered) {
    Write-Host "✅ Tous les Resource Providers sont enregistrés !" -ForegroundColor Green
    Write-Host ""
    Write-Host "📦 Vous pouvez maintenant exécuter :" -ForegroundColor Cyan
    Write-Host "   .\deploy-powershell.ps1" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "⚠️  Certains providers ne sont pas encore enregistrés." -ForegroundColor Yellow
    Write-Host "   Attendez quelques minutes et vérifiez avec :" -ForegroundColor Yellow
    Write-Host "   az provider list --query \"[?registrationState=='Registering']\"" -ForegroundColor White
    Write-Host ""
}
