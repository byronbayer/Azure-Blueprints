Set-Location $PSScriptRoot

$BlueprintName = 'WidgetManual'
$SubscriptionId = (Get-AzSubscription).Id
$blueprint = Get-AzBlueprint -Name $BlueprintName -SubscriptionId $SubscriptionId -LatestPublished
$owner = "sat"
$application = "widget"
$environment = "001"
$location = "UK South"

$AdminLogin = "AdminUser"
$rg = @{bpRg = @{name = 'sat-dev-widget-001'; location = $location } }
$params = @{owner = $owner; applicationName = $application; environment = $environment; mySqlAdminLogin = $AdminLogin }
$secureString = @{mySqlAdminPassword = @{keyVaultId = 'subscriptions/83140706-7c33-427a-a373-27883c159e91/resourceGroups/shared-001/providers/Microsoft.KeyVault/vaults/sat-shared-001-kv'; secretName = 'mySqlAdminPassword'; secretVersion = 'e2b7a674ea154d2187b19740b1dc8fa2' } }

New-AzBlueprintAssignment -Name "Blueprint-01" `
    -Blueprint $blueprint `
    -SubscriptionId $SubscriptionId `
    -Location $location `
    -ResourceGroupParameter $rg `
    -Parameter $params `
    -SecureStringParameter $secureString `
    -Verbose 
