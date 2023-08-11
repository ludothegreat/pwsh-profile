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

# Additional configuration and steps can be added here


