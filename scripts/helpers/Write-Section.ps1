function Write-Section {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    Write-Host ""
    Write-Host ("=" * 80) -ForegroundColor DarkGray
    Write-Host (" {0}" -f $Title) -ForegroundColor Cyan
    Write-Host ("=" * 80) -ForegroundColor DarkGray
    Write-Host ""
}