# TESTING ONLY!!!! Bypass the execution policy for the current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

function Install-LatestPowerShell {
    # Check if PowerShell 7 is already installed
    if (Get-Command -Name 'pwsh' -ErrorAction SilentlyContinue) {
        Write-Host "PowerShell 7 is already installed."
        return
    }

    # Set the API URL for the latest release
    $latestReleaseApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

    # Invoke the REST method to get the latest release information
    $releaseInfo = Invoke-RestMethod -Uri $latestReleaseApiUrl

    # Find the download URL for the Windows 64-bit MSI
    $downloadUrl = ($releaseInfo.assets | Where-Object { $_.browser_download_url -like '*win-x64.msi' }).browser_download_url

    # Define the output file path
    $outFile = "$env:USERPROFILE\Downloads\" + [System.IO.Path]::GetFileName($downloadUrl)

    # Download the MSI file
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outFile

    # Install the downloaded MSI silently
    Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i `"$outFile`" /quiet /norestart" -Wait
}

function Update-OhMyPosh {
    # Check if oh-my-posh is installed
    $ohMyPoshPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\oh-my-posh.exe"
    if (Test-Path $ohMyPoshPath) {
        Write-Host "Oh-My-Posh is already installed. Updating..."
    } else {
        Write-Host "Oh-My-Posh is not installed. Installing..."
    }

    # Install or update Oh-My-Posh using the official installation script
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
}

# Install the latest version of PowerShell
Install-LatestPowerShell

# Install or update Oh-My-Posh
Update-OhMyPosh

Write-Host "Oh-My-Posh installed or updated. Please restart your PowerShell session."