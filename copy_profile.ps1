# Determine the PowerShell profile path based on whether OneDrive is installed
if (Test-Path $env:OneDrive) {
    $profilePath = "$env:OneDrive\Documents\PowerShell"
} else {
    $profilePath = "$env:USERPROFILE\Documents\PowerShell"
}

# Define the destination directory for all files
$destinationDir = "C:\Scripts\pwsh-profile"
$backupDir = "$destinationDir\backup"

# Define the source details for all files
$filesToCopy = @(
    "$profilePath\Microsoft.PowerShell_profile.ps1",
    "C:\Scripts\HyperFocus\HyperFocus.psm1",
    "C:\Scripts\rdpmanager\RDPManager.psm1",
    "C:\Scripts\PSWeather\PSWeather.psm1",
    "$profilePath\interactivemenu.psm1",
    "$profilePath\powershell-profile-help.md",
    "C:\Scripts\IPEnrichment\Get-IPEnrichment.ps1",
    "C:\Scripts\IPEnrichment\Get-CountryCodesAndContinents.ps1",
    "C:\Scripts\IPEnrichment\Get-GeoIP.ps1",
    "C:\Scripts\IPEnrichment\Get-WhoIs.ps1",
    "C:\Scripts\IPEnrichment\PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-LICENSE",
    "C:\Scripts\IPEnrichment\PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-README.md",
    "C:\Users\ludot\AppData\Local\Programs\oh-my-posh\themes\customkali.omp.json"
)

# Function to clean specific variables from PSWeather.psm1
function CleanPSWeather {
    $psWeatherPath = "C:\Scripts\pwsh-profile\PSWeather.psm1"
    $content = Get-Content -Path $psWeatherPath
    $content = $content -replace '\$apiKey\s*=.*', '$apiKey = "<YOUR OPENWEATHERMAPS API KEY>"'
    $content = $content -replace '\$city\s*=.*', '$city = "<YOUR CITY>",'
    $content = $content -replace '\$state\s*=.*', '$state = "<YOUR STATE>",'
    $content = $content -replace '\$country\s*=.*', '$country = "<YOUR COUNTRY>",'
    Set-Content -Path $psWeatherPath -Value $content
    Write-Host "Cleaned PSWeather.psm1"
}

# Function to copy, rename, and manage files
function CopyAndManage {
    param (
        [string]$sourcePath
    )

    $destinationFile = [System.IO.Path]::GetFileName($sourcePath)
    $destinationPath = "$destinationDir\$destinationFile"

    # Check if the source file exists
    if (Test-Path -Path $sourcePath) {
        # Check if the destination file exists
        if (Test-Path -Path $destinationPath) {
            # Get today's date in the format YYYYMMDD
            $dateString = (Get-Date).ToString("yyyyMMdd")

            # Define the new name
            $newName = "$backupDir\${dateString}_$destinationFile"

            # Ensure the backup directory exists
            if (-Not (Test-Path -Path $backupDir)) {
                New-Item -Path $backupDir -ItemType Directory
            }

            # Add a counter if the file with the same name already exists
            $counter = 1
            while (Test-Path -Path $newName) {
                $newName = "$backupDir\${dateString}_${counter}_$destinationFile"
                $counter++
            }

            # Move the existing file to the backup directory
            Move-Item -Path $destinationPath -Destination $newName
            Write-Host "Existing file moved to $newName"
        }

        # Copy the file
        Copy-Item -Path $sourcePath -Destination $destinationPath

        Write-Host "File copied successfully to $destinationPath"
    } else {
        Write-Host "Source file not found at $sourcePath"
    }
}

# Loop through the files and call the function
foreach ($file in $filesToCopy) {
    CopyAndManage -sourcePath $file
}

# Call the function to clean PSWeather.psm1
CleanPSWeather