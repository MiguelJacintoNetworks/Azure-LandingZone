[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$VaultName,

    [string]$SecretName = "platform-sentinel-validation-secret",
    [int]$TimeoutSeconds = 900,
    [int]$PollingIntervalSeconds = 15
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Wait-KeyVaultSecretWriteAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VaultName,

        [Parameter(Mandatory = $true)]
        [int]$TimeoutSeconds,

        [Parameter(Mandatory = $true)]
        [int]$PollingIntervalSeconds
    )

    $deadline = (Get-Date).ToUniversalTime().AddSeconds($TimeoutSeconds)

    Write-Host ("WAITING FOR KEY VAULT SECRET WRITE ACCESS. VAULT NAME: {0}" -f $VaultName) -ForegroundColor Yellow

    $previousNativeCommandPreference = $false
    $hasNativePreferenceVariable = $false

    if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
        $hasNativePreferenceVariable = $true
        $previousNativeCommandPreference = $PSNativeCommandUseErrorActionPreference
        $PSNativeCommandUseErrorActionPreference = $false
    }

    try {
        while ((Get-Date).ToUniversalTime() -lt $deadline) {
            & az keyvault secret set `
                --vault-name $VaultName `
                --name "platform-sentinel-probe" `
                --value "ready" `
                --output none `
                --only-show-errors 2>$null | Out-Null

            if ($LASTEXITCODE -eq 0) {
                & az keyvault secret delete `
                    --vault-name $VaultName `
                    --name "platform-sentinel-probe" `
                    --output none `
                    --only-show-errors 2>$null | Out-Null

                Write-Host ("KEY VAULT SECRET WRITE ACCESS IS READY. VAULT NAME: {0}" -f $VaultName) -ForegroundColor Green
                return
            }

            Write-Host ("KEY VAULT SECRET WRITE ACCESS NOT READY YET. RETRYING IN {0} SECONDS..." -f $PollingIntervalSeconds) -ForegroundColor Yellow
            Start-Sleep -Seconds $PollingIntervalSeconds
        }
    }
    finally {
        if ($hasNativePreferenceVariable) {
            $PSNativeCommandUseErrorActionPreference = $previousNativeCommandPreference
        }
    }

    throw "TIMED OUT WAITING FOR KEY VAULT SECRET WRITE ACCESS ON VAULT '$VaultName'."
}

Write-Host "WAITING FOR KEY VAULT DATA PLANE READINESS..." -ForegroundColor Yellow
Wait-KeyVaultSecretWriteAccess `
    -VaultName $VaultName `
    -TimeoutSeconds $TimeoutSeconds `
    -PollingIntervalSeconds $PollingIntervalSeconds

$secretValue = [System.Guid]::NewGuid().ToString("N") + "-" + [System.Guid]::NewGuid().ToString("N")

Write-Host ("SETTING PLATFORM SENTINEL VALIDATION SECRET: {0}" -f $SecretName) -ForegroundColor Yellow

$previousNativeCommandPreference = $false
$hasNativePreferenceVariable = $false

if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
    $hasNativePreferenceVariable = $true
    $previousNativeCommandPreference = $PSNativeCommandUseErrorActionPreference
    $PSNativeCommandUseErrorActionPreference = $false
}

try {
    & az keyvault secret set `
        --vault-name $VaultName `
        --name $SecretName `
        --value $secretValue `
        --output none `
        --only-show-errors | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "FAILED TO SET PLATFORM SENTINEL VALIDATION SECRET."
    }
}
finally {
    if ($hasNativePreferenceVariable) {
        $PSNativeCommandUseErrorActionPreference = $previousNativeCommandPreference
    }
}

Write-Host ("PLATFORM SENTINEL VALIDATION SECRET CONFIGURED SUCCESSFULLY IN VAULT: {0}" -f $VaultName) -ForegroundColor Green