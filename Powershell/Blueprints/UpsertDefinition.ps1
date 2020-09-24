<#
.DESCRIPTION
   Creates Azure BluePrint Definition
.NOTES
   Intent: Sample to demonstrate Azure BluePrints with Azure DevOps
#>
param( 
   [parameter(Mandatory = $True)] 
   [string] $SubscriptionId, 

   [parameter(Mandatory = $True)]
   [string] $Location,

   [parameter(Mandatory = $True)] 
   [string] $BlueprintFile, 

   [parameter(Mandatory = $True)] 
   [string] $BlueprintName, 

   [parameter(Mandatory = $True)]
   [string] $BlueprintResourceGroupName,
     
   [parameter(Mandatory = $True)] 
   [bool] $Publish, 
   
   [parameter()]
   [string] $ChangeNote,

   [parameter(Mandatory = $True)] 
   [array]
   $ListOfArtifactAndParameterPaths
)

# Import the Az.Blueprint module if it is not installed
if (Get-Module -ListAvailable -Name Az.Accounts) {
   write-host "Az.Accounts module is already installed."
 }
 else {
   write-host "Az.Accounts module is not installed, installing now."
   Find-Module Az.Accounts | Install-Module -Force
 }
 
 if (Get-Module -ListAvailable -Name Az.Blueprint) {
     write-host "Az.Blueprints module is already installed."
 }
 else {
   write-host "Az.Blueprints module is not installed, installing now."
   Find-Module Az.Blueprint | Install-Module -Force
 }

#check for existing blueprint
write-host "checking for existing blueprint"
$blueprint = Get-AzBlueprint -Name $BlueprintName -SubscriptionId $SubscriptionId -ErrorAction SilentlyContinue

if (!$blueprint) {
   #create
   write-host "blueprint not found, creating"
   $blueprint = New-AzBlueprint -Name $BlueprintName -BlueprintFile $BlueprintFile
}
else {
   #update
   write-host "blueprint found, updating"
   Set-AzBlueprint -Name $BlueprintName -BlueprintFile $BlueprintFile -SubscriptionId $SubscriptionId
}

write-host "publising $($listOfArtifactAndParameterPaths.length) artifacts"

$listOfArtifactAndParameterPaths | ForEach-Object {
   $artifactName = $_.artifactName
   $templateFile = $_.Template
   $parametersFile = $_.Parameters

   $existingArtifact = Get-AzBlueprintArtifact -Blueprint $blueprint -Name $artifactName -ErrorAction SilentlyContinue
   if (!$existingArtifact) {
      New-AzBlueprintArtifact -Blueprint $blueprint `
         -Type TemplateArtifact `
         -Name $artifactName `
         -TemplateFile  $templateFile `
         -TemplateParameterFile $parametersFile `
         -ResourceGroupName $BlueprintResourceGroupName
   }
   else {
      Set-AzBlueprintArtifact `
         -Blueprint $blueprint `
         -Type TemplateArtifact `
         -Name $artifactName `
         -TemplateFile $templateFile `
         -TemplateParameterFile $parametersFile `
         -ResourceGroupName $BlueprintResourceGroupName
   }
}

if ($Publish) {
   $bluePrintVersion = $blueprint.versions.length + 1
   Write-Host "Publishing"
   if ($ChangeNote) {
      Publish-AzBlueprint -Blueprint $blueprint -Version $bluePrintVersion -ChangeNote $ChangeNote
   }
   else {
      Publish-AzBlueprint -Blueprint $blueprint -Version $bluePrintVersion
   }
}