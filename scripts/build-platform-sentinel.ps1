[CmdletBinding()]
param(
    [string]$ProjectPath = "../src/Platform.Sentinel/Platform.Sentinel.csproj",
    [string]$Configuration = "Release",
    [string]$Runtime = "win-x64",
    [string]$OutputRoot = ".generated/platform-sentinel",
    [switch]$SelfContained = $true,
    [switch]$RunTests = $false
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

Write-Host "VALIDATING PLATFORM SENTINEL PROJECT PATH..." -ForegroundColor Yellow
Test-RequiredPath -Path $ProjectPath -ExpectedType LEAF -Description "PLATFORM SENTINEL PROJECT FILE"

$resolvedProjectPath = (Resolve-Path $ProjectPath).Path
$projectDirectory = Split-Path -Path $resolvedProjectPath -Parent
$projectName = [System.IO.Path]::GetFileNameWithoutExtension($resolvedProjectPath)

$resolvedOutputRoot = Join-Path $projectDirectory $OutputRoot
$publishDirectory = Join-Path $resolvedOutputRoot "publish"
$packageDirectory = Join-Path $resolvedOutputRoot "package"
$zipFilePath = Join-Path $packageDirectory "$projectName.zip"

Write-Host "PREPARING OUTPUT DIRECTORIES..." -ForegroundColor Yellow

if (Test-Path -Path $resolvedOutputRoot -PathType Container) {
    Remove-Item -Path $resolvedOutputRoot -Recurse -Force
}

New-Item -Path $publishDirectory -ItemType Directory -Force | Out-Null
New-Item -Path $packageDirectory -ItemType Directory -Force | Out-Null

Push-Location $projectDirectory
try {
    Write-Host "RESTORING PLATFORM SENTINEL PROJECT..." -ForegroundColor Yellow
    dotnet restore $resolvedProjectPath | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "DOTNET RESTORE FAILED."
    }

    Write-Host "BUILDING PLATFORM SENTINEL PROJECT..." -ForegroundColor Yellow
    dotnet build $resolvedProjectPath -c $Configuration --no-restore | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "DOTNET BUILD FAILED."
    }

    if ($RunTests) {
        Write-Host "RUNNING PLATFORM SENTINEL TESTS..." -ForegroundColor Yellow
        dotnet test $resolvedProjectPath -c $Configuration --no-build | Out-Host
        if ($LASTEXITCODE -ne 0) {
            throw "DOTNET TESTS FAILED."
        }
    }

    Write-Host "PUBLISHING PLATFORM SENTINEL PROJECT..." -ForegroundColor Yellow

    $publishArguments = @(
        "publish"
        $resolvedProjectPath
        "-c"
        $Configuration
        "-r"
        $Runtime
        "-o"
        $publishDirectory
        "-p:PublishSingleFile=true"
        "-p:IncludeNativeLibrariesForSelfExtract=true"
        "-p:EnableCompressionInSingleFile=true"
    )

    if ($SelfContained) {
        $publishArguments += "--self-contained"
        $publishArguments += "true"
    }
    else {
        $publishArguments += "--self-contained"
        $publishArguments += "false"
    }

    & dotnet @publishArguments | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "DOTNET PUBLISH FAILED."
    }
}
finally {
    Pop-Location
}

Write-Host "CREATING PLATFORM SENTINEL PACKAGE ZIP..." -ForegroundColor Yellow
Compress-Archive -Path (Join-Path $publishDirectory "*") -DestinationPath $zipFilePath -Force

if (-not (Test-Path -Path $zipFilePath -PathType Leaf)) {
    throw "PLATFORM SENTINEL PACKAGE ZIP WAS NOT CREATED."
}

$artifactVersion = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host ("PLATFORM SENTINEL PUBLISH DIRECTORY : {0}" -f $publishDirectory) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL PACKAGE ZIP       : {0}" -f $zipFilePath) -ForegroundColor Green
Write-Host ("PLATFORM SENTINEL ARTIFACT VERSION  : {0}" -f $artifactVersion) -ForegroundColor Green

return [pscustomobject]@{
    ProjectName       = $projectName
    PublishDirectory  = $publishDirectory
    PackageZipPath    = $zipFilePath
    ArtifactVersion   = $artifactVersion
    Configuration     = $Configuration
    Runtime           = $Runtime
    SelfContained     = [bool]$SelfContained
}