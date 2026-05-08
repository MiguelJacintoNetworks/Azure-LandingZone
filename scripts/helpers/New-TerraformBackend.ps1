function Initialize-TerraformBackend {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Location,

        [Parameter(Mandatory = $true)]
        [string]$Environment,

        [Parameter(Mandatory = $true)]
        [string]$ResourcePrefix,

        [Parameter(Mandatory = $true)]
        [string]$SubscriptionId,

        [Parameter(Mandatory = $true)]
        [string]$SignedInUser
    )

    function Wait-StorageBlobDataAccess {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $true)]
            [string]$StorageAccountName,

            [Parameter(Mandatory = $true)]
            [string]$ContainerName,

            [int]$TimeoutSeconds = 900,

            [int]$PollingIntervalSeconds = 15
        )

        $deadline = (Get-Date).ToUniversalTime().AddSeconds($TimeoutSeconds)

        Write-Host ("WAITING FOR STORAGE BLOB DATA ACCESS. STORAGE ACCOUNT: {0}. CONTAINER: {1}." -f $StorageAccountName, $ContainerName) -ForegroundColor Yellow

        while ((Get-Date).ToUniversalTime() -lt $deadline) {
            az storage container show `
                --name $ContainerName `
                --account-name $StorageAccountName `
                --auth-mode login `
                --output none `
                --only-show-errors 2>$null

            if ($LASTEXITCODE -eq 0) {
                Write-Host ("STORAGE BLOB DATA ACCESS IS READY. STORAGE ACCOUNT: {0}. CONTAINER: {1}." -f $StorageAccountName, $ContainerName) -ForegroundColor Green
                return
            }

            Write-Host ("STORAGE BLOB DATA ACCESS NOT READY YET. RETRYING IN {0} SECONDS..." -f $PollingIntervalSeconds) -ForegroundColor Yellow
            Start-Sleep -Seconds $PollingIntervalSeconds
        }

        throw "TIMED OUT WAITING FOR STORAGE BLOB DATA ACCESS ON STORAGE ACCOUNT '$StorageAccountName'."
    }

    Write-Host "SETTING AZURE CLI SUBSCRIPTION CONTEXT..." -ForegroundColor Yellow
    az account set --subscription $SubscriptionId | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO SET AZURE CLI SUBSCRIPTION CONTEXT."
    }

    Write-Host "RESOLVING SIGNED-IN USER OBJECT ID..." -ForegroundColor Yellow
    $signedInUserObjectId = az ad signed-in-user show `
        --query id `
        --output tsv `
        --only-show-errors

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($signedInUserObjectId)) {
        throw "FAILED TO RESOLVE THE SIGNED-IN USER OBJECT ID."
    }

    $backendResourceGroupName = "rg-$ResourcePrefix-tfstate-$Environment"

    $normalizedPrefix = ($ResourcePrefix -replace "[^a-zA-Z0-9-]", "").ToLower()
    $normalizedEnvironment = ($Environment -replace "[^a-zA-Z0-9-]", "").ToLower()
    $subscriptionSuffix = (($SubscriptionId -replace "-", "").Substring(0, 8)).ToLower()

    $backendStorageAccountName = ("st{0}tfstate{1}{2}" -f ($normalizedPrefix -replace "-", ""), ($normalizedEnvironment -replace "-", ""), $subscriptionSuffix).ToLower()
    if ($backendStorageAccountName.Length -gt 24) {
        $backendStorageAccountName = $backendStorageAccountName.Substring(0, 24)
    }

    $backendContainerName = "tfstate"

    $bootstrapKeyVaultName = ("kv-{0}-bootstrap-{1}-{2}" -f $normalizedPrefix, $normalizedEnvironment, $subscriptionSuffix).ToLower()
    if ($bootstrapKeyVaultName.Length -gt 24) {
        $bootstrapKeyVaultName = $bootstrapKeyVaultName.Substring(0, 24).TrimEnd("-")
    }

    $vmAdminPasswordSecretName = "vm-admin-password"

    $storageAccountScope = "/subscriptions/$SubscriptionId/resourceGroups/$backendResourceGroupName/providers/Microsoft.Storage/storageAccounts/$backendStorageAccountName"
    $keyVaultScope = "/subscriptions/$SubscriptionId/resourceGroups/$backendResourceGroupName/providers/Microsoft.KeyVault/vaults/$bootstrapKeyVaultName"

    Write-Host "ENSURING BACKEND RESOURCE GROUP EXISTS..." -ForegroundColor Yellow
    az group create `
        --name $backendResourceGroupName `
        --location $Location `
        --output none `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO CREATE OR ENSURE BACKEND RESOURCE GROUP."
    }

    Write-Host "ENSURING BACKEND STORAGE ACCOUNT EXISTS..." -ForegroundColor Yellow
    az storage account create `
        --name $backendStorageAccountName `
        --resource-group $backendResourceGroupName `
        --location $Location `
        --sku Standard_LRS `
        --kind StorageV2 `
        --min-tls-version TLS1_2 `
        --allow-blob-public-access false `
        --https-only true `
        --output none `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO CREATE OR ENSURE BACKEND STORAGE ACCOUNT."
    }

    Write-Host "ENSURING BACKEND STORAGE CONTAINER EXISTS..." -ForegroundColor Yellow
    az storage container create `
        --name $backendContainerName `
        --account-name $backendStorageAccountName `
        --auth-mode login `
        --output none `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO CREATE OR ENSURE BACKEND STORAGE CONTAINER."
    }

    Write-Host "ENSURING STORAGE BLOB DATA CONTRIBUTOR ROLE ASSIGNMENT..." -ForegroundColor Yellow

    $existingBlobRoleAssignment = az role assignment list `
        --assignee-object-id $signedInUserObjectId `
        --scope $storageAccountScope `
        --query "[?roleDefinitionName=='Storage Blob Data Contributor'] | [0].id" `
        --output tsv `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO CHECK EXISTING STORAGE BLOB DATA CONTRIBUTOR ROLE ASSIGNMENT."
    }

    if ([string]::IsNullOrWhiteSpace($existingBlobRoleAssignment)) {
        az role assignment create `
            --assignee-object-id $signedInUserObjectId `
            --assignee-principal-type User `
            --role "Storage Blob Data Contributor" `
            --scope $storageAccountScope `
            --output none `
            --only-show-errors

        if ($LASTEXITCODE -ne 0) {
            throw "FAILED TO CREATE STORAGE BLOB DATA CONTRIBUTOR ROLE ASSIGNMENT."
        }
    }

    Wait-StorageBlobDataAccess `
        -StorageAccountName $backendStorageAccountName `
        -ContainerName $backendContainerName

    Write-Host "ENSURING BOOTSTRAP KEY VAULT EXISTS..." -ForegroundColor Yellow

    $bootstrapKeyVaultNamePrefix = ("kv-{0}-bootstrap-{1}-" -f $normalizedPrefix, $normalizedEnvironment).ToLower()

    $existingKeyVaultName = az resource list `
        --resource-group $backendResourceGroupName `
        --resource-type "Microsoft.KeyVault/vaults" `
        --query "[?starts_with(name, '$bootstrapKeyVaultNamePrefix')].name | [0]" `
        --output tsv `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO QUERY EXISTING BOOTSTRAP KEY VAULTS."
    }

    if (-not [string]::IsNullOrWhiteSpace($existingKeyVaultName)) {
        $bootstrapKeyVaultName = $existingKeyVaultName
    }
    else {
        az keyvault create `
            --name $bootstrapKeyVaultName `
            --resource-group $backendResourceGroupName `
            --location $Location `
            --enable-rbac-authorization true `
            --output none `
            --only-show-errors

        if ($LASTEXITCODE -ne 0) {
            throw "FAILED TO CREATE BOOTSTRAP KEY VAULT."
        }
    }

    $keyVaultScope = "/subscriptions/$SubscriptionId/resourceGroups/$backendResourceGroupName/providers/Microsoft.KeyVault/vaults/$bootstrapKeyVaultName"

    Write-Host "ENSURING KEY VAULT SECRETS OFFICER ROLE ASSIGNMENT..." -ForegroundColor Yellow

    $existingKvRoleAssignment = az role assignment list `
        --assignee-object-id $signedInUserObjectId `
        --scope $keyVaultScope `
        --query "[?roleDefinitionName=='Key Vault Secrets Officer'] | [0].id" `
        --output tsv `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO CHECK EXISTING KEY VAULT ROLE ASSIGNMENT."
    }

    if ([string]::IsNullOrWhiteSpace($existingKvRoleAssignment)) {
        az role assignment create `
            --assignee-object-id $signedInUserObjectId `
            --assignee-principal-type User `
            --role "Key Vault Secrets Officer" `
            --scope $keyVaultScope `
            --output none `
            --only-show-errors

        if ($LASTEXITCODE -ne 0) {
            throw "FAILED TO CREATE KEY VAULT ROLE ASSIGNMENT."
        }
    }

    Write-Host "WAITING FOR RBAC PROPAGATION..." -ForegroundColor Yellow
    Start-Sleep -Seconds 20

    Write-Host "ENSURING VM ADMIN PASSWORD SECRET EXISTS..." -ForegroundColor Yellow

    $existingSecretId = az keyvault secret list `
        --vault-name $bootstrapKeyVaultName `
        --query "[?name=='$vmAdminPasswordSecretName'] | [0].id" `
        --output tsv `
        --only-show-errors

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO CHECK WHETHER THE VM ADMIN PASSWORD SECRET EXISTS."
    }

    if ([string]::IsNullOrWhiteSpace($existingSecretId)) {
        Write-Host "VM ADMIN PASSWORD SECRET NOT FOUND. PROMPTING USER..." -ForegroundColor Yellow

        $securePassword = Read-Host "ENTER VM ADMIN PASSWORD" -AsSecureString
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)

        try {
            $plainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        }
        finally {
            if ($bstr -ne [IntPtr]::Zero) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
            }
        }

        if ([string]::IsNullOrWhiteSpace($plainTextPassword)) {
            throw "VM ADMIN PASSWORD MUST NOT BE EMPTY."
        }

        az keyvault secret set `
            --vault-name $bootstrapKeyVaultName `
            --name $vmAdminPasswordSecretName `
            --value $plainTextPassword `
            --output none `
            --only-show-errors

        if ($LASTEXITCODE -ne 0) {
            throw "FAILED TO CREATE VM ADMIN PASSWORD SECRET."
        }
    }

    Write-Host "RETRIEVING VM ADMIN PASSWORD SECRET FROM KEY VAULT..." -ForegroundColor Yellow

    $vmAdminPassword = az keyvault secret show `
        --vault-name $bootstrapKeyVaultName `
        --name $vmAdminPasswordSecretName `
        --query "value" `
        --output tsv `
        --only-show-errors

    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($vmAdminPassword)) {
        throw "FAILED TO RETRIEVE VM ADMIN PASSWORD SECRET FROM KEY VAULT."
    }

    $env:TF_VAR_vm_admin_password = $vmAdminPassword

    return @{
        ResourceGroupName         = $backendResourceGroupName
        StorageAccountName        = $backendStorageAccountName
        ContainerName             = $backendContainerName
        StorageAccountScope       = $storageAccountScope
        BootstrapKeyVaultName     = $bootstrapKeyVaultName
        VmAdminPasswordSecretName = $vmAdminPasswordSecretName
        KeyVaultScope             = $keyVaultScope
        SignedInUserObjectId      = $signedInUserObjectId
    }
}

function New-TerraformBackendConfigFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputFilePath,

        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,

        [Parameter(Mandatory = $true)]
        [string]$ContainerName,

        [Parameter(Mandatory = $true)]
        [string]$StateKey
    )

    $parentDirectory = Split-Path -Path $OutputFilePath -Parent

    if (-not (Test-Path -Path $parentDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $parentDirectory -Force | Out-Null
    }

    $content = @"
resource_group_name  = "$ResourceGroupName"
storage_account_name = "$StorageAccountName"
container_name       = "$ContainerName"
key                  = "$StateKey"
use_azuread_auth     = true
"@

    Set-Content -Path $OutputFilePath -Value $content -Encoding utf8
}