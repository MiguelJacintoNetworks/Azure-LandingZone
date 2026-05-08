function Test-AzureLogin {
    [CmdletBinding()]
    param()

    try {
        $null = az account show --output json 2>$null

        if ($LASTEXITCODE -ne 0) {
            throw "AZURE CLI IS NOT AUTHENTICATED."
        }

        return $true
    }
    catch {
        Write-Error "AZURE CLI IS NOT AUTHENTICATED. RUN 'AZ LOGIN' BEFORE EXECUTING THIS SCRIPT."
        return $false
    }
}