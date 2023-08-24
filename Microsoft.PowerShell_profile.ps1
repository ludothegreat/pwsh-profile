# Welcome function to display disk space and resource utilization
function Show-WelcomeMessage {
    Write-Host @"
_________________________________________________________________________
LudoTheGreat's Custom Powershell Environment!

Quick Overview:
- Monitor Disk Space, CPU & Memory Utilization
- Manage HyperFocus Tasks
- Control Network Adapter, DNS, and System Updates
- Edit Files & Navigate Directories
- Import Custom Modules & Scripts

Type 'Menu' for an interactive menu for all functions or 'profile-help' for detailed documentation.
Happy Commanding!
_________________________________________________________________________
"@ -ForegroundColor DarkRed

    Write-Host "Loading Profile..." -ForegroundColor Black -BackgroundColor DarkYellow

    # Disk Space Check
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $freeSpaceGB = [math]::Round($_.FreeSpace / 1GB, 2)
        $totalSpaceGB = [math]::Round($_.Size / 1GB, 2)
        Write-Host ("Drive {0}: {1} GB free of {2} GB total" -f $_.DeviceID, $freeSpaceGB, $totalSpaceGB) -ForegroundColor Black -BackgroundColor DarkGreen
    }


    # CPU Utilization Check
    $cpuUtilization = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 1 | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | ForEach-Object { [math]::Round($_, 2) }
    Write-Host ("CPU Utilization: {0}%" -f $cpuUtilization) -ForegroundColor Black -BackgroundColor DarkGreen

    # Memory Utilization Check
    $totalMemory = Get-CimInstance -ClassName CIM_OperatingSystem | Select-Object -ExpandProperty TotalVisibleMemorySize
    $freeMemory = Get-CimInstance -ClassName CIM_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
    $usedMemoryPercentage = [math]::Round((($totalMemory - $freeMemory) / $totalMemory) * 100, 2)
    Write-Host ("Memory Utilization: {0}%" -f $usedMemoryPercentage) -ForegroundColor Black -BackgroundColor DarkGreen
}

# Call the welcome function when the profile is loaded
Show-WelcomeMessage

# Import Modules
Import-Module -Name Terminal-Icons
Write-Host "Imported Terminal-Icons..." -ForegroundColor Black -BackgroundColor Cyan
Import-Module "C:\Scripts\HyperFocus\HyperFocus.psm1"
Write-Host "Imported HyperFocus..." -ForegroundColor Black -BackgroundColor Cyan
Import-Module "C:\Scripts\rdpmanager\RDPManager.psm1"
Write-Host "Imported RDPManager..." -ForegroundColor Black -BackgroundColor Cyan
Import-Module "C:\Scripts\PSWeather\PSWeather.psm1"
Write-Host "Imported PSWeather..." -ForegroundColor Black -BackgroundColor Cyan
Import-Module "C:\Scripts\IPEnrichment\Get-IPEnrichment.ps1"
Write-Host "Imported IPEnrichment..."-ForegroundColor Black -BackgroundColor Cyan
Import-Module "C:\Users\ludot\OneDrive\Documents\PowerShell\interactivemenu.psm1"
Write-Host "Type 'Menu' to show all functions..." -ForegroundColor Black -BackgroundColor DarkRed
Write-Host "_____________________________________" 
Write-Host "HyperFocus Task List:"
Get-HyperFocusTasks True
Write-Host "_____________________________________"

function Get-IPAddress {
    param (
        [string]$InterfaceType = "All",
        [bool]$IPv6 = $false,
        [bool]$AllAddresses = $false
    )

    $addressFamily = if ($IPv6) { 'IPv6' } else { 'IPv4' }

    $ipAddresses = Get-NetIPAddress -AddressFamily $addressFamily | Where-Object {
        $InterfaceType -eq "All" -or $_.InterfaceAlias -like $InterfaceType
    }

    if ($AllAddresses) {
        $ipAddresses | ForEach-Object {
            $isLinkLocal = if ($IPv6) { $_.PrefixOrigin -eq "WellKnown" } else { $_.IPAddress.StartsWith("169.254.") }
            Write-Host ("Interface: {0} - IP Address: {1} - Prefix Length: {2} - Link Local: {3}" -f $_.InterfaceAlias, $_.IPAddress, $_.PrefixLength, $isLinkLocal)
        }
    }
    else {
        $firstAddress = $ipAddresses | Select-Object -First 1
        $isLinkLocal = if ($IPv6) { $firstAddress.PrefixOrigin -eq "WellKnown" } else { $firstAddress.IPAddress.StartsWith("169.254.") }
        Write-Host ("Interface: {0} - IP Address: {1} - Prefix Length: {2} - Link Local: {3}" -f $firstAddress.InterfaceAlias, $firstAddress.IPAddress, $firstAddress.PrefixLength, $isLinkLocal)
    }
}

# Clear the DNS client cache
function flushdns {
    Clear-DnsClientCache
}

# Restart the network adapter
function restart-net {
    Get-NetAdapter | Restart-NetAdapter
}

# Open a file in Visual Studio Code
function edit {
    param ($file)
    code $file
}

# Navigate to the user's home directory
function home {
    Set-Location $env:USERPROFILE
}

# Navigate to the user's Documents folder
function docs {
    Set-Location "C:\Users\ludot\OneDrive\Documents"
}

# Path to the help file (adjust as needed)
$helpFilePath = "C:\Users\ludot\OneDrive\Documents\PowerShell\powershell-profile-help.md"

# Function to open the help file
function show-profile-help {
    if (Test-Path -Path $helpFilePath) {
        # Open the help file in Visual Studio Code (or change to your preferred editor)
        code $helpFilePath
    }
    else {
        Write-Host "Help file not found at $helpFilePath. Please make sure the file exists." -ForegroundColor Red
    }
}
Set-Alias profile-help show-profile-help

# Create aliases for the HyperFocus functions
Set-Alias aht Add-HyperFocusTask
Set-Alias ahts Add-HyperFocusTasks
Set-Alias rht Remove-HyperFocusTask
Set-Alias ght Get-HyperFocusTasks
Set-Alias cht Clear-HyperFocusTasks
Set-Alias sht Save-HyperFocusTasks
Set-Alias iht Import-HyperFocusTasks
Set-Alias amht Add-MultipleHyperFocusTasks
Set-Alias shth Show-HyperFocusHelp
Set-Alias uhts Update-HyperFocusStatus

# Creat aliase for Interactive Menu
Set-Alias Menu Show-InteractiveMenu

# Create alias for IPDetailsModule
Set-Alias WhoIs Get-IPDetails

# Update system packages using winget
function up {
    Write-Host "Updating source list..." -ForegroundColor Cyan
    winget source update # Update the source list

    Write-Host "Listing packages that require upgrading..." -ForegroundColor Cyan
    winget upgrade # List all packages that require upgrading

    Write-Host "Upgrading all packages that require upgrading..." -ForegroundColor Cyan
    winget upgrade --all # Upgrade all packages that require upgrading

    Write-Host "Update and upgrade completed." -ForegroundColor Green
}

function Update-Profile {
    . $PROFILE
    Write-Host "Profile updated and modules imported." -ForegroundColor Green
}
Set-Alias reload Update-Profile

## Final Line to set prompt
oh-my-posh init pwsh --config 'C:\Users\ludot\AppData\Local\Programs\oh-my-posh\themes\customkali.omp.json' | Invoke-Expression
