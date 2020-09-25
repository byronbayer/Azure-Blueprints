Set-Location $PSScriptRoot

$SubscriptionId = '83140706-7c33-427a-a373-27883c159e91'
$BlueprintName = 'GrafanaManual'
$BlueprintFile = '.\blueprint.json'
$BluePrintResourceGroupName = 'BPRG'
$Location = 'UK South'
Select-AzSubscription $SubscriptionId

$hash = @([pscustomobject]@{artifactName = 'mySqlServer'; Template = '..\Artifacts\mysql-server.json'; Parameters = '..\Artifacts\mysql-server-params.json'; }
    # [pscustomobject]@{artifactName = 'mySqlServerFirewall'; Template = '..\Artifacts\mysql-server-firewall-rules.json'; Parameters = '..\Artifacts\mysql-server-firewall-rules-params.json'; DependsOn = ("mySqlServer") }
    # [pscustomobject]@{artifactName = 'appServicePlan'; Template = '..\Artifacts\app-service-plan.json'; Parameters = '..\Artifacts\app-service-plan-params.json'; DependsOn = ("mySqlServer") }
    # [pscustomobject]@{artifactName = 'appService'; Template = '..\Artifacts\app-service-linux.json'; Parameters = '..\Artifacts\app-service-linux-params.json'; DependsOn = ("appServicePlan", "storageAccount") },
    # [pscustomobject]@{artifactName = 'storageAccount'; Template = '..\Artifacts\storage-account.json'; Parameters = '..\Artifacts\storage-account-params.json'; },
    # [pscustomobject]@{artifactName = 'fileShare'; Template = '..\Artifacts\storage-fileshare.json'; Parameters = '..\Artifacts\storage-fileshare-params.json'; DependsOn = ("appServicePlan", "storageAccount") }
)

$listOfArtifactAndParameterPaths = @()
$listOfArtifactAndParameterPaths += ($hash)
..\..\Powershell\Blueprints\UpsertDefinition.ps1 -SubscriptionId $SubscriptionId `
    -Location $Location `
    -BlueprintFile $BlueprintFile `
    -BlueprintName $BlueprintName `
    -BluePrintResourceGroupName $BlueprintResourceGroupName `
    -Publish $true `
    -ListOfArtifactAndParameterPaths $listOfArtifactAndParameterPaths