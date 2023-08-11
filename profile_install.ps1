<#
.SYNOPSIS
    This script installs and configures a PowerShell profile with Oh My Posh, custom fonts, and themes.

.DESCRIPTION
    The script performs the following actions:
    - Installs winget if not present.
    - Installs the latest PowerShell version if below 7.
    - Installs Oh My Posh.
    - Downloads and installs Hack Nerd Font.
    - Updates PowerShell settings to use the custom font.
    - Clones a GitHub repository containing custom profiles and themes.
    - Copies the custom profile and theme to the appropriate locations.

.NOTES
    The script must be run with administrator privileges to perform certain actions, such as installing fonts.

.LINK
    GitHub repository: https://github.com/ludothegreat/pwsh-profile.git
#>

# Check if winget is installed and install if not
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not installed. Installing now..."
    # Install winget outside of the store
    Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
    Write-Host "winget installation complete."
} else {
    Write-Host "winget is already installed."
}

# Check if the latest PowerShell version is installed and install if not
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "Installing latest PowerShell version..."
    # Use winget to install the latest PowerShell version
    winget install --id=Microsoft.PowerShell -e
}
Write-Host "Latest PowerShell version installed."

# Install Oh My Posh using winget
Write-Host "Installing Oh My Posh..."
winget install JanDeDobbeleer.OhMyPosh -s winget

# Check if running as an administrator and relaunch if not
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting PowerShell as Administrator..."
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $($MyInvocation.MyCommand.Definition)" -Verb RunAs
    exit
}

# Get the source of the installed Oh My Posh
Write-Host "Getting Oh My Posh source..."
$ohMyPoshSource = (Get-Command oh-my-posh).Source
Write-Host "Oh My Posh installed at: $ohMyPoshSource"

# Download and extract Hack Nerd Font
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip"
$tempFile = "$env:TEMP\\Hack.zip"
Write-Host "Downloading Hack Nerd Font..."
Invoke-WebRequest -Uri $url -OutFile $tempFile
$tempFolder = "$env:TEMP\\Hack"
Write-Host "Extracting Hack Nerd Font..."
Expand-Archive -Path $tempFile -DestinationPath $tempFolder

# Install fonts from the extracted folder
Get-ChildItem "$tempFolder\\*.ttf" | ForEach-Object {
    Write-Host "Installing font $_..."
    Copy-Item $_.FullName -Destination "C:\\Windows\\Fonts"
}

# Update PowerShell Font in the JSON settings file
Write-Host "Updating PowerShell font..."
$settingsFile = "$env:LOCALAPPDATA\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json"
(Get-Content $settingsFile) -replace '"fontFace": ".*"', '"fontFace": "Hack Nerd Font"' | Set-Content $settingsFile

# Get the path where the script is running (assumed to be the root of the cloned repository)
$clonePath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Copy Custom Powershell Profile
$sourceProfilePath = Join-Path -Path $clonePath -ChildPath "Microsoft.PowerShell_profile.ps1"
$oneDrivePath = [Environment]::GetEnvironmentVariable('OneDrive', 'User')
$destinationProfilePath = Join-Path -Path $oneDrivePath -ChildPath "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$destinationFolder = Split-Path -Path $destinationProfilePath
if (-Not (Test-Path -Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory -Force
}
Write-Host "Copying custom profile to $destinationProfilePath..."
Copy-Item -Path $sourceProfilePath -Destination $destinationProfilePath -Force
Write-Host "Custom profile copied successfully."

# Copy Custom Oh My Posh Theme
$customThemeSourcePath = Join-Path -Path $clonePath -ChildPath "customkali.omp.json"
$destinationThemePath = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\customkali.omp.json"
$destinationThemeFolder = Split-Path -Path $destinationThemePath
if (-Not (Test-Path -Path $destinationThemeFolder)) {
    New-Item -Path $destinationThemeFolder -ItemType Directory -Force
}
Write-Host "Copying custom theme to $destinationThemePath..."
Copy-Item -Path $customThemeSourcePath -Destination $destinationThemePath -Force
Write-Host "Custom theme copied successfully."

