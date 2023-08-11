# Check if winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget is not installed. Installing now..."

    # Install winget outside of the store
    Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe

    Write-Host "winget installation complete."
} else {
    Write-Host "winget is already installed."
}

# Check if the latest PowerShell version is installed
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "Installing latest PowerShell version..."

    # Use winget to install the latest PowerShell version
    winget install --id=Microsoft.PowerShell -e
}

Write-Host "Latest PowerShell version installed."


winget install JanDeDobbeleer.OhMyPosh -s winget

# Check if running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch as an administrator
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $($MyInvocation.MyCommand.Definition)" -Verb RunAs
    exit
}

(Get-Command oh-my-posh).Source

# PowerShell Script to Install Oh My Posh and Restart PowerShell as Administrator

# Install Oh My Posh using winget
Write-Host "Installing Oh My Posh..."
winget install JanDeDobbeleer.OhMyPosh -s winget

# Check if running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch as an administrator
    Write-Host "Restarting PowerShell as Administrator..."
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $($MyInvocation.MyCommand.Definition)" -Verb RunAs
    exit
}

# Get the source of the installed Oh My Posh
Write-Host "Getting Oh My Posh source..."
$ohMyPoshSource = (Get-Command oh-my-posh).Source
Write-Host "Oh My Posh installed at: $ohMyPoshSource"

# URL of the Hack Nerd Font
$url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip"

# Temporary location to download the ZIP file
$tempFile = "$env:TEMP\Hack.zip"

# Download the ZIP file
Write-Host "Downloading Hack Nerd Font..."
Invoke-WebRequest -Uri $url -OutFile $tempFile

# Extract the ZIP file to a temporary directory
Write-Host "Extracting Hack Nerd Font..."
$tempFolder = "$env:TEMP\Hack"
Expand-Archive -Path $tempFile -DestinationPath $tempFolder

# Install the fonts
Write-Host "Installing Hack Nerd Font..."
Get-ChildItem -Path $tempFolder -Filter "*.ttf" | ForEach-Object {
    $fontPath = $_.FullName
    Write-Host "Installing font: $fontPath"
    $null = Add-Type -TypeDefinition @"
        using System; 
        using System.Runtime.InteropServices;
        public class FontInstaller {
            [DllImport("gdi32.dll", EntryPoint = "AddFontResource")]
            public static extern int AddFontResource(string lpszFilename);
        }
"@
    [FontInstaller]::AddFontResource($fontPath)
}

# Path to Windows Terminal settings.json
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Read the JSON content
$settings = Get-Content -Path $settingsPath | ConvertFrom-Json

# Font to be set
$newFont = "Hack Nerd Font"

# Update the fontFace for the PowerShell profile
$settings.profiles.list | Where-Object { $_.name -eq "PowerShell" } | ForEach-Object {
    Write-Host "Updating font for profile: $($_.name)"
    $_.fontFace = $newFont
}

# Write the updated JSON back to the file
$settings | ConvertTo-Json -Depth 100 | Set-Content -Path $settingsPath

Write-Host "Font updated successfully."

# URL of the GitHub repository
$repoUrl = "https://github.com/ludothegreat/pwsh-profile.git"

# Path where the repository will be cloned
$clonePath = "C:\Scripts\pwsh-profile"

# Check if the clone path exists, create it if not
if (-Not (Test-Path -Path $clonePath)) {
    New-Item -Path $clonePath -ItemType Directory -Force
}

# Navigate to the parent directory
Set-Location "C:\Scripts"

# Clone the repository
Write-Host "Cloning repository from $repoUrl..."
git clone $repoUrl

# Path to the custom Microsoft.PowerShell_profile.ps1 inside the cloned repository
$sourceProfilePath = Join-Path -Path $clonePath -ChildPath "Microsoft.PowerShell_profile.ps1"

# Get the OneDrive path from the environment variable
$oneDrivePath = [Environment]::GetEnvironmentVariable('OneDrive', 'User')

# Construct the destination path for the user's PowerShell profile
$destinationProfilePath = Join-Path -Path $oneDrivePath -ChildPath "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Check if the destination folder exists, create it if not
$destinationFolder = Split-Path -Path $destinationProfilePath
if (-Not (Test-Path -Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory -Force
}

# Copy the custom profile
Write-Host "Copying custom profile to $destinationProfilePath..."
Copy-Item -Path $sourceProfilePath -Destination $destinationProfilePath -Force

Write-Host "Custom profile copied successfully."

# Additional configuration and steps can be added here
