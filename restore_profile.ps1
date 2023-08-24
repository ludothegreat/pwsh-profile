# Determine the PowerShell profile path based on whether OneDrive is installed
if (Test-Path $env:OneDrive) {
    $profilePath = "$env:OneDrive\Documents\PowerShell"
} else {
    $profilePath = "$env:USERPROFILE\Documents\PowerShell"
}

# Define the source directory for all files
$sourceDir = "C:\Scripts\pwsh-profile"

# Define the destination details for all files
$filesToCopy = @{
    "$sourceDir\Microsoft.PowerShell_profile.ps1" = "$profilePath\Microsoft.PowerShell_profile.ps1"
    "$sourceDir\HyperFocus.psm1" = "C:\Scripts\HyperFocus\HyperFocus.psm1"
    "$sourceDir\RDPManager.psm1" = "C:\Scripts\rdpmanager\RDPManager.psm1"
    "$sourceDir\PSWeather.psm1" = "C:\Scripts\PSWeather\PSWeather.psm1"
    "$sourceDir\interactivemenu.psm1" = "$profilePath\interactivemenu.psm1"
    "$sourceDir\powershell-profile-help.md" = "$profilePath\powershell-profile-help.md"
    "$sourceDir\Get-IPEnrichment.ps1" = "C:\Scripts\IPEnrichment\Get-IPEnrichment.ps1"
    "$sourceDir\Get-CountryCodesAndContinents.ps1" = "C:\Scripts\IPEnrichment\Get-CountryCodesAndContinents.ps1"
    "$sourceDir\Get-GeoIP.ps1" = "C:\Scripts\IPEnrichment\Get-GeoIP.ps1"
    "$sourceDir\Get-WhoIs.ps1" = "C:\Scripts\IPEnrichment\Get-WhoIs.ps1"
    "$sourceDir\PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-LICENSE" = "C:\Scripts\IPEnrichment\PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-LICENSE"
    "$sourceDir\PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-README.md" = "c:\Scripts\IPEnrichment\PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-README.md"
    "$sourceDir\customkali.omp.json" = "C:\Users\ludot\AppData\Local\Programs\oh-my-posh\themes\customkali.omp.json"
}

# Loop through the files and copy them to their original locations
foreach ($sourcePath in $filesToCopy.Keys) {
    $destinationPath = $filesToCopy[$sourcePath]

    # Check if the source file exists
    if (Test-Path -Path $sourcePath) {
        # Copy the file
        Copy-Item -Path $sourcePath -Destination $destinationPath

        Write-Host "File copied successfully from $sourcePath to $destinationPath"
    } else {
        Write-Host "Source file not found at $sourcePath"
    }
}
