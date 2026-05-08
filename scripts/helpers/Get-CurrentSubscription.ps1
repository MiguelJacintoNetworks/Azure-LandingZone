function Get-CurrentSubscription {
    [CmdletBinding()]
    param()

    try {
        $accountJson = az account show --output json 2>$null

        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($accountJson)) {
            throw "FAILED TO RESOLVE THE CURRENT AZURE SUBSCRIPTION CONTEXT."
        }

        $account = $accountJson | ConvertFrom-Json

        return [PSCustomObject]@{
            Name      = $account.name
            Id        = $account.id
            TenantId  = $account.tenantId
            IsDefault = $account.isDefault
            User      = $account.user.name
        }
    }
    catch {
        throw "FAILED TO READ THE CURRENT AZURE SUBSCRIPTION CONTEXT. $_"
    }
}