[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PackageZip,

    [Parameter(Mandatory = $true)]
    [string]$KeyVaultUri,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountBlobServiceUri,

    [Parameter(Mandatory = $true)]
    [string]$EnvironmentName,

    [Parameter(Mandatory = $true)]
    [string]$WorkloadName,

    [Parameter(Mandatory = $true)]
    [string]$StorageContainerName,

    [Parameter(Mandatory = $true)]
    [string]$Message,

    [Parameter(Mandatory = $true)]
    [string]$ValidationSecretName,

    [string]$EventLogSource = "PlatformSentinel",
    [string]$BlobPrefix = "healthchecks",
    [string]$SchemaVersion = "1.0.0",
    [int]$ExecutionIntervalSeconds = 300,
    [string]$ManagedIdentityClientId = ""
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

function Remove-ServiceIfExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $existingService = Get-Service -Name $Name -ErrorAction SilentlyContinue

    if ($null -ne $existingService) {
        Write-Host ("STOPPING EXISTING WINDOWS SERVICE: {0}" -f $Name) -ForegroundColor Yellow

        if ($existingService.Status -ne "Stopped") {
            Stop-Service -Name $Name -Force -ErrorAction Stop
        }

        Write-Host ("DELETING EXISTING WINDOWS SERVICE: {0}" -f $Name) -ForegroundColor Yellow
        sc.exe delete $Name | Out-Null

        Start-Sleep -Seconds 3
    }
}

function Get-ManagedIdentityAccessToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Resource,

        [string]$ClientId = ""
    )

    $metadataHeaders = @{
        Metadata = "true"
    }

    $tokenUri = if ([string]::IsNullOrWhiteSpace($ClientId)) {
        "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$([System.Uri]::EscapeDataString($Resource))"
    }
    else {
        "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$([System.Uri]::EscapeDataString($Resource))&client_id=$([System.Uri]::EscapeDataString($ClientId))"
    }

    $tokenResponse = Invoke-RestMethod -Method Get -Uri $tokenUri -Headers $metadataHeaders
    return $tokenResponse.access_token
}

function Ensure-ValidationSecretExists {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$KeyVaultUri,

        [Parameter(Mandatory = $true)]
        [string]$SecretName,

        [string]$ManagedIdentityClientId = ""
    )

    Write-Host ("ENSURING PLATFORM SENTINEL VALIDATION SECRET EXISTS: {0}" -f $SecretName) -ForegroundColor Yellow

    $accessToken = Get-ManagedIdentityAccessToken `
        -Resource "https://vault.azure.net" `
        -ClientId $ManagedIdentityClientId

    $headers = @{
        Authorization = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }

    $normalizedVaultUri = if ($KeyVaultUri.EndsWith("/")) { $KeyVaultUri } else { "$KeyVaultUri/" }

    $baseSecretUri = "{0}secrets/{1}" -f $normalizedVaultUri, $SecretName
    $getSecretUri = "{0}?api-version=7.4" -f $baseSecretUri

    try {
        $existingSecret = Invoke-RestMethod -Method Get -Uri $getSecretUri -Headers $headers
        if ($null -ne $existingSecret -and -not [string]::IsNullOrWhiteSpace($existingSecret.value)) {
            Write-Host ("PLATFORM SENTINEL VALIDATION SECRET ALREADY EXISTS: {0}" -f $SecretName) -ForegroundColor Green
            return
        }
    }
    catch {
        $statusCode = $null

        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }

        if ($statusCode -ne 404) {
            throw
        }
    }

    $secretValue = [System.Guid]::NewGuid().ToString("N") + "-" + [System.Guid]::NewGuid().ToString("N")
    $payload = @{
        value = $secretValue
    } | ConvertTo-Json -Depth 5

    $setSecretUri = "{0}?api-version=7.4" -f $baseSecretUri

    Invoke-RestMethod -Method Put -Uri $setSecretUri -Headers $headers -Body $payload | Out-Null

    Write-Host ("PLATFORM SENTINEL VALIDATION SECRET CREATED SUCCESSFULLY: {0}" -f $SecretName) -ForegroundColor Green
}

Write-Host "VALIDATING PLATFORM SENTINEL INSTALLATION INPUTS..." -ForegroundColor Yellow
Test-RequiredPath -Path $PackageZip -ExpectedType LEAF -Description "PLATFORM SENTINEL PACKAGE ZIP"

$resolvedPackageZip = (Resolve-Path $PackageZip).Path

$installRoot = "C:\PlatformSentinel"
$serviceName = "PlatformSentinel"
$displayName = "Platform Sentinel Service"
$appSettingsPath = Join-Path $installRoot "appsettings.json"
$executablePath = Join-Path $installRoot "Platform.Sentinel.exe"

Write-Host "PREPARING PLATFORM SENTINEL INSTALLATION DIRECTORY..." -ForegroundColor Yellow

if (Test-Path -Path $installRoot -PathType Container) {
    Remove-Item -Path $installRoot -Recurse -Force
}

New-Item -Path $installRoot -ItemType Directory -Force | Out-Null

Write-Host "EXPANDING PLATFORM SENTINEL PACKAGE..." -ForegroundColor Yellow
Expand-Archive -Path $resolvedPackageZip -DestinationPath $installRoot -Force

Test-RequiredPath -Path $executablePath -ExpectedType LEAF -Description "PLATFORM SENTINEL EXECUTABLE"

if (-not [System.Diagnostics.EventLog]::SourceExists($EventLogSource)) {
    Write-Host ("CREATING WINDOWS EVENT LOG SOURCE: {0}" -f $EventLogSource) -ForegroundColor Yellow
    New-EventLog -LogName Application -Source $EventLogSource
}
else {
    Write-Host ("WINDOWS EVENT LOG SOURCE ALREADY EXISTS: {0}" -f $EventLogSource) -ForegroundColor Green
}

Ensure-ValidationSecretExists `
    -KeyVaultUri $KeyVaultUri `
    -SecretName $ValidationSecretName `
    -ManagedIdentityClientId $ManagedIdentityClientId

Write-Host "WRITING PLATFORM SENTINEL APPLICATION SETTINGS..." -ForegroundColor Yellow

$managedIdentityValue = if ([string]::IsNullOrWhiteSpace($ManagedIdentityClientId)) {
    $null
}
else {
    $ManagedIdentityClientId
}

$appSettingsObject = @{
    Sentinel = @{
        environmentName              = $EnvironmentName
        workloadName                 = $WorkloadName
        executionIntervalSeconds     = $ExecutionIntervalSeconds
        keyVaultUri                  = $KeyVaultUri
        storageAccountBlobServiceUri = $StorageAccountBlobServiceUri
        storageContainerName         = $StorageContainerName
        message                      = $Message
        validationSecretName         = $ValidationSecretName
        eventLogSource               = $EventLogSource
        blobPrefix                   = $BlobPrefix
        schemaVersion                = $SchemaVersion
        managedIdentityClientId      = $managedIdentityValue
    }
    Logging = @{
        LogLevel = @{
            Default   = "Information"
            Microsoft = "Warning"
        }
    }
}

$appSettingsJson = $appSettingsObject | ConvertTo-Json -Depth 10
Set-Content -Path $appSettingsPath -Value $appSettingsJson -Encoding utf8

Test-RequiredPath -Path $appSettingsPath -ExpectedType LEAF -Description "PLATFORM SENTINEL APP SETTINGS FILE"

Remove-ServiceIfExists -Name $serviceName

Write-Host ("CREATING WINDOWS SERVICE: {0}" -f $serviceName) -ForegroundColor Yellow
sc.exe create $serviceName binPath= "`"$executablePath`"" start= auto DisplayName= "`"$displayName`"" | Out-Null

Write-Host ("SETTING WINDOWS SERVICE DESCRIPTION: {0}" -f $serviceName) -ForegroundColor Yellow
sc.exe description $serviceName "CONTINUOUSLY VALIDATES AZURE LANDING ZONE OPERATIONAL INTEGRITY." | Out-Null

Write-Host ("STARTING WINDOWS SERVICE: {0}" -f $serviceName) -ForegroundColor Yellow
Start-Service -Name $serviceName

Start-Sleep -Seconds 5

$service = Get-Service -Name $serviceName -ErrorAction Stop

if ($service.Status -ne "Running") {
    throw "PLATFORM SENTINEL WINDOWS SERVICE FAILED TO START."
}

Write-Host ("PLATFORM SENTINEL INSTALLATION DIRECTORY : {0}" -f $installRoot) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL EXECUTABLE             : {0}" -f $executablePath) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL APP SETTINGS           : {0}" -f $appSettingsPath) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL WINDOWS SERVICE        : {0}" -f $serviceName) -ForegroundColor Green
Write-Host "PLATFORM SENTINEL INSTALLATION COMPLETED SUCCESSFULLY." -ForegroundColor Green