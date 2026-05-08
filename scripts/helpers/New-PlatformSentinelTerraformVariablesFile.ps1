function New-PlatformSentinelTerraformVariablesFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputFilePath,

        [Parameter(Mandatory = $true)]
        [string]$ArtifactStorageAccountName,

        [Parameter(Mandatory = $true)]
        [string]$ArtifactStorageAccountId,

        [Parameter(Mandatory = $true)]
        [string]$ArtifactContainerName,

        [Parameter(Mandatory = $true)]
        [string]$PackageBlobName,

        [Parameter(Mandatory = $true)]
        [string]$InstallScriptBlobName,

        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    $parentDirectory = Split-Path -Path $OutputFilePath -Parent

    if (-not (Test-Path -Path $parentDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $parentDirectory -Force | Out-Null
    }

    $artifactBlobFqdn = "{0}.blob.core.windows.net" -f $ArtifactStorageAccountName

    $content = @{
        platform_sentinel_artifact_storage_account_name = $ArtifactStorageAccountName
        platform_sentinel_artifact_storage_account_id   = $ArtifactStorageAccountId
        platform_sentinel_artifact_container_name       = $ArtifactContainerName
        platform_sentinel_package_blob_name             = $PackageBlobName
        platform_sentinel_install_script_blob_name      = $InstallScriptBlobName
        platform_sentinel_artifact_allowed_fqdns        = @($artifactBlobFqdn)
        platform_sentinel_version                       = $Version
    } | ConvertTo-Json -Depth 5

    $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($OutputFilePath, $content, $utf8NoBomEncoding)
}