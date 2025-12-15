# Script de diagnostic et configuration Azure
# Vérifie l'abonnement et les providers avant le déploiement

Write-Host "🔍 Diagnostic de la configuration Azure" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green
Write-Host ""

# 1. Vérifier la connexion Azure
Write-Host "1️⃣  Vérification de la connexion Azure..." -ForegroundColor Cyan
$account = az account show 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Vous n'êtes pas connecté à Azure!" -ForegroundColor Red
    Write-Host ""
    Write-Host "📝 Connectez-vous avec :" -ForegroundColor Yellow
    Write-Host "   az login" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "✅ Connecté à Azure" -ForegroundColor Green
Write-Host ""

# 2. Afficher les abonnements disponibles
Write-Host "2️⃣  Abonnements Azure disponibles :" -ForegroundColor Cyan
Write-Host ""
az account list --output table
Write-Host ""

# 3. Afficher l'abonnement actuel
Write-Host "3️⃣  Abonnement actuellement sélectionné :" -ForegroundColor Cyan
$currentSubscription = az account show --query "{Name:name, ID:id, State:state}" -o table
Write-Host $currentSubscription
Write-Host ""

# 4. Demander si l'utilisateur veut changer d'abonnement
$change = Read-Host "Voulez-vous changer d'abonnement ? (o/N)"

if ($change -eq "o" -or $change -eq "O") {
    Write-Host ""
    Write-Host "📋 Liste des abonnements :" -ForegroundColor Yellow
    $subscriptions = az account list --query "[].{Name:name, ID:id}" -o json | ConvertFrom-Json

    for ($i = 0; $i -lt $subscriptions.Count; $i++) {
        Write-Host "  [$i] $($subscriptions[$i].Name) - $($subscriptions[$i].ID)" -ForegroundColor White
    }

    Write-Host ""
    $choice = Read-Host "Entrez le numéro de l'abonnement à utiliser"

    if ($choice -ge 0 -and $choice -lt $subscriptions.Count) {
        $selectedSub = $subscriptions[$choice]
        Write-Host ""
        Write-Host "🔄 Changement vers : $($selectedSub.Name)" -ForegroundColor Cyan
        az account set --subscription $selectedSub.ID
        Write-Host "✅ Abonnement changé !" -ForegroundColor Green
    }
}

Write-Host ""

# 5. Vérifier les Resource Providers
Write-Host "4️⃣  Vérification des Resource Providers..." -ForegroundColor Cyan
Write-Host ""

$providers = @(
    "Microsoft.DBforPostgreSQL",
    "Microsoft.Web"
)

$needsRegistration = $false

foreach ($provider in $providers) {
    $state = az provider show --namespace $provider --query "registrationState" -o tsv 2>$null

    if ($state -eq "Registered") {
        Write-Host "  ✅ $provider : Enregistré" -ForegroundColor Green
    } elseif ($state -eq "Registering") {
        Write-Host "  ⏳ $provider : En cours d'enregistrement..." -ForegroundColor Yellow
        $needsRegistration = $true
    } else {
        Write-Host "  ❌ $provider : Non enregistré" -ForegroundColor Red
        $needsRegistration = $true
    }
}

Write-Host ""

# 6. Proposer d'enregistrer les providers si nécessaire
if ($needsRegistration) {
    Write-Host "⚠️  Certains providers ne sont pas enregistrés" -ForegroundColor Yellow
    Write-Host ""
    $register = Read-Host "Voulez-vous les enregistrer maintenant ? (O/n)"

    if ($register -ne "n" -and $register -ne "N") {
        Write-Host ""
        Write-Host "📋 Enregistrement des providers..." -ForegroundColor Cyan

        foreach ($provider in $providers) {
            $state = az provider show --namespace $provider --query "registrationState" -o tsv 2>$null

            if ($state -ne "Registered") {
                Write-Host "  🔄 Enregistrement de $provider..." -ForegroundColor Yellow
                az provider register --namespace $provider
            }
        }

        Write-Host ""
        Write-Host "⏳ Attente de l'enregistrement (cela peut prendre 2-5 minutes)..." -ForegroundColor Yellow
        Write-Host ""

        $maxWait = 300 # 5 minutes
        $elapsed = 0
        $allRegistered = $false

        while (-not $allRegistered -and $elapsed -lt $maxWait) {
            $allRegistered = $true

            foreach ($provider in $providers) {
                $state = az provider show --namespace $provider --query "registrationState" -o tsv

                if ($state -ne "Registered") {
                    $allRegistered = $false
                    Write-Host "  ⏳ $provider : $state" -ForegroundColor Yellow
                }
            }

            if (-not $allRegistered) {
                Start-Sleep -Seconds 10
                $elapsed += 10
            }
        }

        Write-Host ""
        if ($allRegistered) {
            Write-Host "✅ Tous les providers sont enregistrés !" -ForegroundColor Green
        } else {
            Write-Host "⚠️  L'enregistrement prend plus de temps que prévu" -ForegroundColor Yellow
            Write-Host "   Vérifiez dans quelques minutes avec : az provider list" -ForegroundColor White
        }
    }
} else {
    Write-Host "✅ Tous les providers nécessaires sont enregistrés !" -ForegroundColor Green
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "📊 Résumé de la configuration :" -ForegroundColor Cyan
Write-Host ""

$currentSub = az account show --query "{Nom:name, ID:id}" -o json | ConvertFrom-Json
Write-Host "  Abonnement : $($currentSub.Nom)" -ForegroundColor White
Write-Host "  ID         : $($currentSub.ID)" -ForegroundColor White

Write-Host ""
$allReady = $true
foreach ($provider in $providers) {
    $state = az provider show --namespace $provider --query "registrationState" -o tsv
    if ($state -ne "Registered") {
        $allReady = $false
    }
    $icon = if ($state -eq "Registered") { "✅" } else { "❌" }
    Write-Host "  $icon $provider" -ForegroundColor White
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

if ($allReady) {
    Write-Host "🎉 Tout est prêt pour le déploiement !" -ForegroundColor Green
    Write-Host ""
    Write-Host "📦 Prochaine étape :" -ForegroundColor Yellow
    Write-Host "   .\deploy-powershell.ps1" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "⚠️  Configuration incomplète" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Attendez que tous les providers soient enregistrés," -ForegroundColor White
    Write-Host "puis relancez ce script pour vérifier." -ForegroundColor White
    Write-Host ""
}
