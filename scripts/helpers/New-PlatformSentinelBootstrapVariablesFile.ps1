function New-PlatformSentinelBootstrapVariablesFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputFilePath,

        [Parameter(Mandatory = $true)]
        [bool]$EnablePlatformSentinelExtension
    )

    $parentDirectory = Split-Path -Path $OutputFilePath -Parent

    if (-not (Test-Path -Path $parentDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $parentDirectory -Force | Out-Null
    }

    $content = @{
        enable_platform_sentinel_extension = $EnablePlatformSentinelExtension
    } | ConvertTo-Json -Depth 3

    $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($OutputFilePath, $content, $utf8NoBomEncoding)
}