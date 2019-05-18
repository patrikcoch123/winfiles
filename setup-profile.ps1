#!/usr/bin/env powershell.exe
#Requires -Version 5
#Requires -RunAsAdministrator
Set-StrictMode -Version 2.0

# Check Profile Directory
$profileDirectory = Split-Path $PROFILE -Parent
if(-not (Test-Path($PROFILE)))
{
    if (-not (Test-Path $profileDirectory)) {
        New-Item $profileDirectory -ItemType Directory -Force | Out-Null
    }

    New-Item $PROFILE -ItemType File | Out-Null
    Write-Host "Creating profile."
}

$root = $PSScriptRoot

# Set up main PowerShell Profile
$isInstalled = Get-Content $PROFILE | ForEach-Object { if($_.Contains(". $root\powershell-profile\profile.ps1") -eq $true){$true;}}

if($isInstalled -ne $true){
    Add-Content $PROFILE "#Requires -Version 5"
    Add-Content $PROFILE ""
    Add-Content $PROFILE ". `"$root\powershell-profile\profile.ps1`""
    Add-Content $PROFILE ""
    Add-Content $PROFILE "function prompt {"
    Add-Content $PROFILE "    return Get-CustomPrompt"
    Add-Content $PROFILE "}"

    Write-Host "Your environment has been configured at: $PROFILE"
}
else
{
    Write-Host "Your environment is already configured at: $PROFILE"
}

# Setup NuGet profile used within Visual Studio
# TODO: Originally this was used by Visual Studio, not sure if VS 2017\2019 still uses this or standard
# powershell.  Validate that this is still needed.
$nuGetFile = Join-Path $profileDirectory "NuGet_profile.ps1"
$isNugetInstalled = $false

if (Test-Path $nugetFile){
    $isNugetInstalled = Get-Content $nuGetFile | ForEach-Object { if($_.Contains(". $root\powershell-profile\profile.ps1") -eq $true){$true;}}
}

if($isNugetInstalled -ne $true){
    Add-Content $nuGetFile "#Requires -Version 5"
    Add-Content $nuGetFile ""
    Add-Content $nuGetFile ". `"$root\powershell-profile\profile.ps1`""
    Add-Content $nuGetFile ""
    Add-Content $nuGetFile "function prompt {"
    Add-Content $nuGetFile "    return Get-CustomPrompt"
    Add-Content $nuGetFile "}"

    Write-Host "Your NuGet environment has been configured at: $nuGetFile"
}
else
{
    Write-Host "Your NuGet environment is already configured at: $nuGetFile"
}

# Setup module repository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Update all modules
Update-Module -ErrorAction SilentlyContinue

# Install critical user modules (profile doesn't work without these)
Install-Module -Name Pscx -AllowClobber -Scope CurrentUser
Install-Module -Name posh-git -AllowClobber -Scope CurrentUser
