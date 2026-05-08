[CmdletBinding()]
param(
    [string]$CoreTerraformWorkingDirectory = "../environments/dev",
    [string]$GovernanceTerraformWorkingDirectory = "../governance/global",
    [string]$Location = "eastus",
    [string]$Environment = "dev",
    [string]$ResourcePrefix = "np",
    [string]$CoreBackendStateKey = "environments/dev/terraform.tfstate",
    [string]$GovernanceBackendStateKey = "governance/global/terraform.tfstate",
    [string]$CoreTerraformVariablesFile = "terraform.tfvars",
    [string]$GovernanceTerraformVariablesFile = "terraform.tfvars",
    [switch]$AutoApprove
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

. "$PSScriptRoot/helpers/Write-Section.ps1"
. "$PSScriptRoot/helpers/Test-AzureLogin.ps1"
. "$PSScriptRoot/helpers/Get-CurrentSubscription.ps1"
. "$PSScriptRoot/helpers/New-TerraformBackend.ps1"
. "$PSScriptRoot/helpers/New-PlatformSentinelTerraformVariablesFile.ps1"
. "$PSScriptRoot/helpers/New-PlatformSentinelBootstrapVariablesFile.ps1"

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

function Invoke-TerraformDeployment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $true)]
        [string]$StageTitle,

        [Parameter(Mandatory = $true)]
        [string]$BackendConfigFile,

        [Parameter(Mandatory = $true)]
        [string]$TerraformVariablesFile,

        [Parameter(Mandatory = $true)]
        [switch]$AutoApprove,

        [string[]]$AdditionalTerraformVariableFiles = @()
    )

    Test-RequiredPath -Path $WorkingDirectory -ExpectedType CONTAINER -Description "TERRAFORM WORKING DIRECTORY"

    Write-Section -Title $StageTitle

    Push-Location $WorkingDirectory
    try {
        Test-RequiredPath -Path $TerraformVariablesFile -ExpectedType LEAF -Description "TERRAFORM VARIABLES FILE"

        foreach ($additionalVariableFile in $AdditionalTerraformVariableFiles) {
            Test-RequiredPath -Path $additionalVariableFile -ExpectedType LEAF -Description "ADDITIONAL TERRAFORM VARIABLES FILE"
        }

        Write-Host "RUNNING TERRAFORM FORMAT CHECK..." -ForegroundColor Yellow
        terraform fmt -recursive
        if ($LASTEXITCODE -ne 0) {
            throw "TERRAFORM FORMAT CHECK FAILED IN '$WorkingDirectory'."
        }

        Write-Host "INITIALIZING TERRAFORM BACKEND AND PROVIDERS..." -ForegroundColor Yellow
        $terraformInitArguments = @(
            "init"
            "-input=false"
            "-reconfigure"
            "-backend-config=$BackendConfigFile"
        )

        & terraform @terraformInitArguments
        if ($LASTEXITCODE -ne 0) {
            throw "TERRAFORM INITIALIZATION FAILED IN '$WorkingDirectory'."
        }

        Write-Host "VALIDATING TERRAFORM CONFIGURATION..." -ForegroundColor Yellow
        terraform validate
        if ($LASTEXITCODE -ne 0) {
            throw "TERRAFORM VALIDATION FAILED IN '$WorkingDirectory'."
        }

        Write-Host "GENERATING TERRAFORM EXECUTION PLAN..." -ForegroundColor Yellow
        $terraformPlanArguments = @(
            "plan"
            "-input=false"
            "-var-file=$TerraformVariablesFile"
        )

        foreach ($additionalVariableFile in $AdditionalTerraformVariableFiles) {
            $terraformPlanArguments += "-var-file=$additionalVariableFile"
        }

        & terraform @terraformPlanArguments
        if ($LASTEXITCODE -ne 0) {
            throw "TERRAFORM PLAN GENERATION FAILED IN '$WorkingDirectory'."
        }

        Write-Host "APPLYING TERRAFORM CONFIGURATION..." -ForegroundColor Yellow
        $terraformApplyArguments = @(
            "apply"
            "-input=false"
            "-var-file=$TerraformVariablesFile"
        )

        foreach ($additionalVariableFile in $AdditionalTerraformVariableFiles) {
            $terraformApplyArguments += "-var-file=$additionalVariableFile"
        }

        if ($AutoApprove) {
            $terraformApplyArguments += "-auto-approve"
        }

        & terraform @terraformApplyArguments
        if ($LASTEXITCODE -ne 0) {
            throw "TERRAFORM APPLY FAILED IN '$WorkingDirectory'."
        }

        Write-Host ""
        Write-Host ("DEPLOYMENT COMPLETED SUCCESSFULLY FOR: {0}" -f $WorkingDirectory) -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

Write-Section -Title "AZURE CONTEXT VALIDATION"

if (-not (Test-AzureLogin)) {
    throw "AZURE AUTHENTICATION VALIDATION FAILED."
}

$subscription = Get-CurrentSubscription

Write-Host ("SUBSCRIPTION NAME       : {0}" -f $subscription.Name) -ForegroundColor Green
Write-Host ("SUBSCRIPTION ID         : {0}" -f $subscription.Id) -ForegroundColor Green
Write-Host ("TENANT ID               : {0}" -f $subscription.TenantId) -ForegroundColor Green
Write-Host ("SIGNED-IN USER          : {0}" -f $subscription.User) -ForegroundColor Green
Write-Host ("DEFAULT CONTEXT         : {0}" -f $subscription.IsDefault) -ForegroundColor Green

Write-Section -Title "TERRAFORM BACKEND AND BOOTSTRAP SECRETS PREPARATION"

$backend = Initialize-TerraformBackend `
    -Location $Location `
    -Environment $Environment `
    -ResourcePrefix $ResourcePrefix `
    -SubscriptionId $subscription.Id `
    -SignedInUser $subscription.User

$generatedDirectory = Join-Path $PSScriptRoot ".generated"
$coreBackendConfigFile = Join-Path $generatedDirectory "backend.core.hcl"
$governanceBackendConfigFile = Join-Path $generatedDirectory "backend.governance.hcl"
$platformSentinelTerraformVariablesFile = Join-Path $generatedDirectory "platform-sentinel.auto.tfvars.json"
$platformSentinelBootstrapDisabledFile = Join-Path $generatedDirectory "platform-sentinel.bootstrap.disabled.auto.tfvars.json"
$platformSentinelBootstrapEnabledFile = Join-Path $generatedDirectory "platform-sentinel.bootstrap.enabled.auto.tfvars.json"

New-TerraformBackendConfigFile `
    -OutputFilePath $coreBackendConfigFile `
    -ResourceGroupName $backend.ResourceGroupName `
    -StorageAccountName $backend.StorageAccountName `
    -ContainerName $backend.ContainerName `
    -StateKey $CoreBackendStateKey

New-TerraformBackendConfigFile `
    -OutputFilePath $governanceBackendConfigFile `
    -ResourceGroupName $backend.ResourceGroupName `
    -StorageAccountName $backend.StorageAccountName `
    -ContainerName $backend.ContainerName `
    -StateKey $GovernanceBackendStateKey

Write-Host ("BACKEND RESOURCE GROUP  : {0}" -f $backend.ResourceGroupName) -ForegroundColor Green
Write-Host ("BACKEND STORAGE ACCOUNT : {0}" -f $backend.StorageAccountName) -ForegroundColor Green
Write-Host ("BACKEND CONTAINER       : {0}" -f $backend.ContainerName) -ForegroundColor Green
Write-Host ("BACKEND STORAGE SCOPE   : {0}" -f $backend.StorageAccountScope) -ForegroundColor Green
Write-Host ("BOOTSTRAP KEY VAULT     : {0}" -f $backend.BootstrapKeyVaultName) -ForegroundColor Green
Write-Host ("VM PASSWORD SECRET NAME : {0}" -f $backend.VmAdminPasswordSecretName) -ForegroundColor Green
Write-Host ("KEY VAULT SCOPE         : {0}" -f $backend.KeyVaultScope) -ForegroundColor Green
Write-Host ("CORE BACKEND CONFIG     : {0}" -f $coreBackendConfigFile) -ForegroundColor Green
Write-Host ("GOV BACKEND CONFIG      : {0}" -f $governanceBackendConfigFile) -ForegroundColor Green

Write-Section -Title "PLATFORM SENTINEL ARTIFACT PREPARATION"

$buildScriptPath = Join-Path $PSScriptRoot "build-platform-sentinel.ps1"
$publishArtifactScriptPath = Join-Path $PSScriptRoot "publish-platform-sentinel-artifact.ps1"

Test-RequiredPath -Path $buildScriptPath -ExpectedType LEAF -Description "PLATFORM SENTINEL BUILD SCRIPT"
Test-RequiredPath -Path $publishArtifactScriptPath -ExpectedType LEAF -Description "PLATFORM SENTINEL ARTIFACT PUBLISH SCRIPT"

$buildResult = & $buildScriptPath
if ($LASTEXITCODE -ne 0 -or $null -eq $buildResult) {
    throw "PLATFORM SENTINEL BUILD WORKFLOW FAILED."
}

$artifactPublishResult = & $publishArtifactScriptPath `
    -PackageZipPath $buildResult.PackageZipPath `
    -ArtifactVersion $buildResult.ArtifactVersion `
    -StorageAccountName $backend.StorageAccountName `
    -StorageAccountId $backend.StorageAccountScope `
    -Environment $Environment

if ($LASTEXITCODE -ne 0 -or $null -eq $artifactPublishResult) {
    throw "PLATFORM SENTINEL ARTIFACT PUBLISH WORKFLOW FAILED."
}

New-PlatformSentinelTerraformVariablesFile `
    -OutputFilePath $platformSentinelTerraformVariablesFile `
    -ArtifactStorageAccountName $artifactPublishResult.StorageAccountName `
    -ArtifactStorageAccountId $artifactPublishResult.StorageAccountId `
    -ArtifactContainerName $artifactPublishResult.ContainerName `
    -PackageBlobName $artifactPublishResult.PackageBlobName `
    -InstallScriptBlobName $artifactPublishResult.InstallScriptBlobName `
    -Version $buildResult.ArtifactVersion

New-PlatformSentinelBootstrapVariablesFile `
    -OutputFilePath $platformSentinelBootstrapDisabledFile `
    -EnablePlatformSentinelExtension:$false

New-PlatformSentinelBootstrapVariablesFile `
    -OutputFilePath $platformSentinelBootstrapEnabledFile `
    -EnablePlatformSentinelExtension:$true

Write-Host ("PLATFORM SENTINEL TFVARS                    : {0}" -f $platformSentinelTerraformVariablesFile) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL BOOTSTRAP DISABLED TFVARS : {0}" -f $platformSentinelBootstrapDisabledFile) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL BOOTSTRAP ENABLED TFVARS  : {0}" -f $platformSentinelBootstrapEnabledFile) -ForegroundColor Green

Invoke-TerraformDeployment `
    -WorkingDirectory $CoreTerraformWorkingDirectory `
    -StageTitle "TERRAFORM CORE DEPLOYMENT WORKFLOW - PASS 1" `
    -BackendConfigFile $coreBackendConfigFile `
    -TerraformVariablesFile $CoreTerraformVariablesFile `
    -AdditionalTerraformVariableFiles @(
        $platformSentinelTerraformVariablesFile,
        $platformSentinelBootstrapDisabledFile
    ) `
    -AutoApprove:$AutoApprove

Write-Section -Title "PLATFORM SENTINEL STORAGE AND KEY VAULT RBAC STABILIZATION"
Write-Host "WAITING FOR PLATFORM SENTINEL RBAC PROPAGATION BEFORE CUSTOM SCRIPT EXTENSION DEPLOYMENT..." -ForegroundColor Yellow
Start-Sleep -Seconds 120

Invoke-TerraformDeployment `
    -WorkingDirectory $CoreTerraformWorkingDirectory `
    -StageTitle "TERRAFORM CORE DEPLOYMENT WORKFLOW - PASS 2" `
    -BackendConfigFile $coreBackendConfigFile `
    -TerraformVariablesFile $CoreTerraformVariablesFile `
    -AdditionalTerraformVariableFiles @(
        $platformSentinelTerraformVariablesFile,
        $platformSentinelBootstrapEnabledFile
    ) `
    -AutoApprove:$AutoApprove

Invoke-TerraformDeployment `
    -WorkingDirectory $GovernanceTerraformWorkingDirectory `
    -StageTitle "TERRAFORM GOVERNANCE DEPLOYMENT WORKFLOW" `
    -BackendConfigFile $governanceBackendConfigFile `
    -TerraformVariablesFile $GovernanceTerraformVariablesFile `
    -AutoApprove:$AutoApprove

Write-Section -Title "DEPLOYMENT SUMMARY"
Write-Host "ALL TERRAFORM DEPLOYMENT WORKFLOWS COMPLETED SUCCESSFULLY." -ForegroundColor Green