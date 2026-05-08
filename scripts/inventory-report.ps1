[CmdletBinding()]
param(
    [string]$Environment = "dev",
    [string]$ResourcePrefix = "np",
    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

. "$PSScriptRoot/helpers/Write-Section.ps1"
. "$PSScriptRoot/helpers/Test-AzureLogin.ps1"
. "$PSScriptRoot/helpers/Get-CurrentSubscription.ps1"

Write-Section -Title "AZURE CONTEXT VALIDATION"

if (-not (Test-AzureLogin)) {
    exit 1
}

$subscription = Get-CurrentSubscription

Write-Host ("SUBSCRIPTION NAME : {0}" -f $subscription.Name) -ForegroundColor Green
Write-Host ("SUBSCRIPTION ID   : {0}" -f $subscription.Id) -ForegroundColor Green
Write-Host ("TENANT ID         : {0}" -f $subscription.TenantId) -ForegroundColor Green
Write-Host ("SIGNED-IN USER    : {0}" -f $subscription.User) -ForegroundColor Green

$resourceGroups = @(
    "rg-$ResourcePrefix-hub-network-$Environment",
    "rg-$ResourcePrefix-management-network-$Environment",
    "rg-$ResourcePrefix-workload-network-$Environment",
    "rg-$ResourcePrefix-monitoring-$Environment"
)

Write-Section -Title "COLLECTING RESOURCE INVENTORY"

$inventory = foreach ($resourceGroup in $resourceGroups) {
    $resourcesJson = az resource list --resource-group $resourceGroup --output json 2>$null

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($resourcesJson)) {
        continue
    }

    $resources = $resourcesJson | ConvertFrom-Json

    foreach ($resource in $resources) {
        [PSCustomObject]@{
            SubscriptionName = $subscription.Name
            SubscriptionId   = $subscription.Id
            Environment      = $Environment
            ResourceGroup    = $resource.resourceGroup
            Name             = $resource.name
            Type             = $resource.type
            Location         = $resource.location
            Id               = $resource.id
        }
    }
}

if (-not $inventory) {
    Write-Host "NO RESOURCES WERE FOUND FOR THE REQUESTED ENVIRONMENT." -ForegroundColor Yellow
    exit 0
}

Write-Section -Title "RESOURCE INVENTORY"

$inventory |
    Sort-Object ResourceGroup, Type, Name |
    Format-Table ResourceGroup, Name, Type, Location -AutoSize

if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
    $directory = Split-Path -Parent $OutputPath

    if (-not [string]::IsNullOrWhiteSpace($directory) -and -not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }

    $inventory |
        Sort-Object ResourceGroup, Type, Name |
        ConvertTo-Json -Depth 5 |
        Set-Content -Path $OutputPath -Encoding UTF8

    Write-Host ""
    Write-Host ("INVENTORY REPORT WRITTEN TO: {0}" -f $OutputPath) -ForegroundColor Green
}