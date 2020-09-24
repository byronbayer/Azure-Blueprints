Set-Location $PSScriptRoot

$BlueprintName = 'GrafanaManual'

$blueprint = Get-AzBlueprint -Name $BlueprintName -SubscriptionId (Get-AzSubscription).Id

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
$json.properties.parameters.applicationName.value = $application
$json.properties.parameters.usage.value = $us
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner
$json.properties.parameters.owner.value = $owner


# New-AzBlueprintAssignment -Name "Grafana-Signin-01" -Blueprint $blueprint -AssignmentFile ".\blueprint-assignment.json" -SubscriptionId $SubscriptionId

