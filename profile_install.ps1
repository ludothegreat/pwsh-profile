# TESTING ONLY!!!! Bypass the execution policy for the current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

function Install-LatestPowerShell {
    # Check if PowerShell 7 is already installed
    if (Get-Command -Name 'pwsh' -ErrorAction SilentlyContinue) {
        Write-Host "PowerShell 7 is already installed."
        return
    }
    Write-Host "Powershell 7 is not installed. Installing..."

    # Set the API URL for the latest release
    $latestReleaseApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

    # Invoke the REST method to get the latest release information
    $releaseInfo = Invoke-RestMethod -Uri $latestReleaseApiUrl

    # Find the download URL for the Windows 64-bit MSI
    $downloadUrl = ($releaseInfo.assets | Where-Object { $_.browser_download_url -like '*win-x64.msi' }).browser_download_url

    # Define the output file path
    $outFile = "$env:USERPROFILE\Downloads\" + [System.IO.Path]::GetFileName($downloadUrl)

    Write-Host "Downloading $latestReleaseApiUrl..."

    # Download the MSI file
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outFile

    Write-Host "Running $outFile Installer..."

    # Install the downloaded MSI silently
    Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i `"$outFile`" /quiet /norestart" -Wait

    Write-Host "Done! Checking if Oh My Posh is installed..."
}

function Install-WindowsTerminal {
    # Check if Windows Terminal is already installed
    if (Get-AppxPackage -Name 'Microsoft.WindowsTerminal' -ErrorAction SilentlyContinue) {
        Write-Host "Windows Terminal is already installed."
        return
    }
    Write-Host "Windows Terminal is not installed. Installing..."

    # Set the URL for the latest release of Windows Terminal
    $latestReleaseApiUrl = 'https://api.github.com/repos/microsoft/terminal/releases/latest'
    $response = Invoke-RestMethod -Uri $latestReleaseApiUrl

    # Extract the MSIX bundle download URL
    $msixBundleUrl = $response.assets | Where-Object { $_.name -like '*.msixbundle' } | Select-Object -ExpandProperty browser_download_url

    # Download the MSIX bundle
    $downloadPath = Join-Path $env:TEMP "WindowsTerminal.msixbundle"
    Invoke-WebRequest -Uri $msixBundleUrl -OutFile $downloadPath

    # Install the MSIX bundle
    Add-AppxPackage -Path $downloadPath

    Write-Host "Windows Terminal has been installed successfully."
}

function Install-Winget {
    # Check if winget is already installed
    if (Get-Command -Name 'winget' -ErrorAction SilentlyContinue) {
        Write-Host "Winget is already installed."
        return
    }
    
    Write-Host "Winget is not installed. Installing..."

    # Set the API URL for the latest release
    $latestReleaseApiUrl = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

    # Invoke the REST method to get the latest release information
    $releaseInfo = Invoke-RestMethod -Uri $latestReleaseApiUrl

    # Find the download URL for the Windows AppX package
    $downloadUrl = ($releaseInfo.assets | Where-Object { $_.browser_download_url -like '*.appxbundle' }).browser_download_url

    # Define the output file path
    $outFile = "$env:TEMP\\" + [System.IO.Path]::GetFileName($downloadUrl)

    Write-Host "Downloading $downloadUrl..."

    # Download the AppX file
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outFile

    Write-Host "Installing Winget..."

    # Install the downloaded AppX package silently
    Add-AppxPackage -Path $outFile

    Write-Host "Winget has been installed successfully."
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

function Update-OhMyPoshPath {
    # Define the path to oh-my-posh
    $ohMyPoshPath = "$env:LOCALAPPDATA\Programs\oh-my-posh\bin"

    # Add the oh-my-posh path to the current PATH
    $env:Path += ";$ohMyPoshPath"

    Write-Host "Manually updating path for this session..."

    # Test if oh-my-posh is accessible
    try {
        $ohMyPoshSource = (Get-Command oh-my-posh).Source
        if ($ohMyPoshSource -like "*$ohMyPoshPath*") {
            Write-Host "Path update completed successfully!"
        } else {
            Write-Host "Path update failed. Oh-My-Posh is not accessible."
        }
    } catch {
        Write-Host "Error: Oh-My-Posh is not accessible. Please check the installation and path."
    }
}

# Install latest PowerShell
Install-LatestPowerShell

# Install latest Windows Terminal
Install-WindowsTerminal

# Install latest Winget
Install-Winget

# Install or update Oh-My-Posh
Update-OhMyPosh

# Update Oh My Posh path and test
Update-OhMyPoshPath