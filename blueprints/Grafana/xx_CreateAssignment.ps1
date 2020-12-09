Set-Location $PSScriptRoot

$BlueprintName = 'GrafanaManual'
$SubscriptionId = (Get-AzSubscription).Id
$blueprint = Get-AzBlueprint -Name $BlueprintName -SubscriptionId $SubscriptionId -LatestPublished


$owner = "sat"
$purpose = "dev"
$application = "grafana"
$environment = "001"
$location = "UK South"

$baseName = $owner, $purpose, $application, $environment -join "-"
#$baseName_underscore = $owner, $purpose, $application, $environment -join "_"
#$baseName_nochar = $owner, $purpose, $application, $environment -join ""

#$appServiceName = $baseName, "as" -join "-"
#$appServicePlanName = $baseName, "asp" -join "-"
#$appServiceRuntimeStack = "DOCKER|grafana/grafana:7.1.3"
#$mySqlServerName = $baseName, "msql" -join "-"
#$mySqlServerFQDN = $mySqlServerName, ".mysql.database.azure.com" -join ""
#$grafanaDatabaseName = $baseName_underscore, "db" -join "_"
#$grafanaDatabaseUser = $mySqlAdminLogin , $mySqlServerName -join "@"
#$storageAccountName = $baseName_nochar, "str" -join ""

#$firewallRuleNamePrefix = $appServicePlanName, "AZURE_IP-" -join "-"

#$ipAddresses = "[reference('app-service').outputs.possibleOutboundIpAddresses.value]"
# $json = Get-Content ".\blueprint-assignment.json" -Raw | ConvertFrom-Json
# $json.location = $location
# $json.properties.blueprintId = $blueprint.Id
# $json.properties.parameters.owner.value = $owner
# $json.properties.parameters.purpose.value = $purpose
# $json.properties.parameters.applicationName.value = $application
# $json.properties.parameters.environment.value = $environment
# $json.properties.resourceGroups.bpRg.name = $baseName
# $json.properties.resourceGroups.bpRg.location = $location

# $json | ConvertTo-Json -Depth 5 | Set-Content "temp.json"
$AdminLogin = "AdminUser"
$rg = @{bpRg = @{name = 'sat-dev-grafana-001'; location = $location } }
$params = @{owner=$owner;applicationName=$application;environment=$environment;mySqlAdminLogin=$AdminLogin}
$secureString = @{mySqlAdminPassword=@{keyVaultId='subscriptions/83140706-7c33-427a-a373-27883c159e91/resourceGroups/shared-001/providers/Microsoft.KeyVault/vaults/sat-shared-001-kv';secretName='mySqlAdminPassword';secretVersion='e2b7a674ea154d2187b19740b1dc8fa2'}}

# New-AzBlueprintAssignment -Name "Grafana-01" -Blueprint $blueprint `
# -SubscriptionId $SubscriptionId -Location $location -AssignmentFile ".\temp.json" -Verbose 

New-AzBlueprintAssignment -Name "Grafana-01" `
    -Blueprint $blueprint `
    -SubscriptionId $SubscriptionId `
    -Location $location `
    -ResourceGroupParameter $rg `
    -Parameter $params `
    -SecureStringParameter $secureString `
    -Verbose 
