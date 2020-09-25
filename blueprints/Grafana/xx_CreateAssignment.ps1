Set-Location $PSScriptRoot

$BlueprintName = 'GrafanaManual'
$SubscriptionId = (Get-AzSubscription).Id
$blueprint = Get-AzBlueprint -Name $BlueprintName -SubscriptionId $SubscriptionId -LatestPublished

$owner = "s123"
$purpose = "dev"
$application = "widgeter"
$environment = "001"
$location = "West Europe"

$baseName = $owner, $purpose, $application, $environment -join "-"
$baseName_underscore = $owner, $purpose, $application, $environment -join "_"
$baseName_nochar = $owner, $purpose, $application, $environment -join ""

$appServiceName = $baseName, "as" -join "-"
$appServicePlanName = $baseName, "asp" -join "-"
$appServiceRuntimeStack = "DOCKER|grafana/grafana:7.1.3"
$mySqlServerName = $baseName, "msql" -join "-"
$mySqlServerFQDN = $mySqlServerName, ".mysql.database.azure.com" -join ""
$grafanaDatabaseName = $baseName_underscore, "db" -join "_"
$grafanaDatabaseUser = $mySqlAdminLogin , $mySqlServerName -join "@"
$storageAccountName = $baseName_nochar, "str" -join ""

$firewallRuleNamePrefix = $appServicePlanName, "AZURE_IP-" -join "-"

#$ipAddresses = "[reference('app-service').outputs.possibleOutboundIpAddresses.value]"
$json = Get-Content ".\blueprint-assignment.json" -Raw | ConvertFrom-Json
$json.location = $location
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.purpose.value = $purpose
$json.properties.parameters.applicationName.value = $application
$json.properties.parameters.environment.value = $environment
$json.properties.resourceGroups.bpRg.name = $baseName
$json.properties.resourceGroups.bpRg.location = $location

$json | ConvertTo-Json -Depth 5 | Set-Content "temp.json"

New-AzBlueprintAssignment -Name "Grafana-01" `
-Blueprint $blueprint `
-AssignmentFile ".\temp.json" `
-SubscriptionId $SubscriptionId -Verbose

