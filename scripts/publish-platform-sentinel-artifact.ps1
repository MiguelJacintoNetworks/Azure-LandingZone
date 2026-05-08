[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PackageZipPath,

    [Parameter(Mandatory = $true)]
    [string]$ArtifactVersion,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountId,

    [Parameter(Mandatory = $true)]
    [string]$Environment,

    [string]$ContainerName = "artifacts",
    [string]$InstallScriptPath = "../scripts/install-platform-sentinel.ps1"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Test-RequiredPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [ValidateSet("CONTAINER", "LEAF")]
        [string]$ExpectedType,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $pathType = if ($ExpectedType -eq "CONTAINER") { "Container" } else { "Leaf" }

    if (-not (Test-Path -Path $Path -PathType $pathType)) {
        throw "$Description NOT FOUND: '$Path'."
    }
}

Write-Host "VALIDATING PLATFORM SENTINEL ARTIFACT INPUTS..." -ForegroundColor Yellow
Test-RequiredPath -Path $PackageZipPath -ExpectedType LEAF -Description "PLATFORM SENTINEL PACKAGE ZIP"
Test-RequiredPath -Path $InstallScriptPath -ExpectedType LEAF -Description "PLATFORM SENTINEL INSTALL SCRIPT"

$resolvedPackageZipPath = (Resolve-Path $PackageZipPath).Path
$resolvedInstallScriptPath = (Resolve-Path $InstallScriptPath).Path

$packageFileName = Split-Path -Path $resolvedPackageZipPath -Leaf
$installScriptFileName = Split-Path -Path $resolvedInstallScriptPath -Leaf

$packageBlobName = "platform-sentinel/$Environment/$ArtifactVersion/$packageFileName"
$installScriptBlobName = "platform-sentinel/$Environment/$ArtifactVersion/$installScriptFileName"

Write-Host "ENSURING ARTIFACTS CONTAINER EXISTS..." -ForegroundColor Yellow
az storage container create `
    --name $ContainerName `
    --account-name $StorageAccountName `
    --auth-mode login `
    --output none `
    --only-show-errors | Out-Host

if ($LASTEXITCODE -ne 0) {
    throw "FAILED TO CREATE OR ENSURE ARTIFACTS CONTAINER."
}

Write-Host "UPLOADING PLATFORM SENTINEL PACKAGE ZIP..." -ForegroundColor Yellow
az storage blob upload `
    --account-name $StorageAccountName `
    --container-name $ContainerName `
    --name $packageBlobName `
    --file $resolvedPackageZipPath `
    --auth-mode login `
    --overwrite true `
    --output none `
    --only-show-errors | Out-Host

if ($LASTEXITCODE -ne 0) {
    throw "FAILED TO UPLOAD PLATFORM SENTINEL PACKAGE ZIP."
}

Write-Host "UPLOADING PLATFORM SENTINEL INSTALL SCRIPT..." -ForegroundColor Yellow
az storage blob upload `
    --account-name $StorageAccountName `
    --container-name $ContainerName `
    --name $installScriptBlobName `
    --file $resolvedInstallScriptPath `
    --auth-mode login `
    --overwrite true `
    --output none `
    --only-show-errors | Out-Host

if ($LASTEXITCODE -ne 0) {
    throw "FAILED TO UPLOAD PLATFORM SENTINEL INSTALL SCRIPT."
}

Write-Host ("PLATFORM SENTINEL PACKAGE BLOB NAME      : {0}" -f $packageBlobName) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL SCRIPT BLOB NAME       : {0}" -f $installScriptBlobName) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL ARTIFACT CONTAINER     : {0}" -f $ContainerName) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL ARTIFACT STORAGE NAME  : {0}" -f $StorageAccountName) -ForegroundColor Green

return [pscustomobject]@{
    StorageAccountName     = $StorageAccountName
    StorageAccountId       = $StorageAccountId
    ContainerName          = $ContainerName
    PackageBlobName        = $packageBlobName
    InstallScriptBlobName  = $installScriptBlobName
}