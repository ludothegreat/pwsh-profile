# pwsh-profile

> :warning: **Early Development**: I am currently developing this profile and need to have a way to install it on multiple computers with ease. This project is in the early stages of development and may undergo significant changes. Please use with caution and consider contributing if you encounter issues or have suggestions.

# PowerShell Profile Backup and Restore

This repository contains scripts and tools to manage, backup, and restore PowerShell profiles and associated files. It includes a set of PowerShell modules and scripts to perform specific tasks related to profile management.

## Contents

### Scripts

- `copy_profile.ps1`: Copies specified profile files to a designated folder, creating backups and handling file naming.
- `restore_profile.ps1`: Restores profile files from the backup folder to their original locations.

### Modules

- [HyperFocus.psm1](https://github.com/ludothegreat/HyperFocus): A PowerShell module for hyper-focus functionality.
- [PSWeather.psm1](https://github.com/ludothegreat/PSWeather): A PowerShell module for weather-related functionalities.
- [RDPManager.psm1](https://github.com/ludothegreat/RDPManager): A PowerShell module for Remote Desktop Protocol (RDP) management.
- `interactivemenu.psm1`: A PowerShell module for interactive menus.

### Other Files

- `Microsoft.PowerShell_profile.ps1` Custom Powershell Profile with multiple different functions.
- `customkali.omp.json`: A custom JSON configuration file.
- `powershell-profile-help.md` Help file, because I forget stuff.
- `Get-CountryCodesAndContinents.ps1` : Powershell tool written by [SecTraversl : PowerShell-GeoIP-WhoIs-IPEnrichment-Tools](https://github.com/SecTraversl/PowerShell-GeoIP-WhoIs-IPEnrichment-Tools)
- `Get-GeoIP.ps1` : Powershell tool written by [SecTraversl : PowerShell-GeoIP-WhoIs-IPEnrichment-Tools](https://github.com/SecTraversl/PowerShell-GeoIP-WhoIs-IPEnrichment-Tools)
- `Get-IPEnrichment.ps1` : Powershell tool written by [SecTraversl : PowerShell-GeoIP-WhoIs-IPEnrichment-Tools](https://github.com/SecTraversl/PowerShell-GeoIP-WhoIs-IPEnrichment-Tools)
- `Get-WhoIs.ps1` : Powershell tool written by [SecTraversl : PowerShell-GeoIP-WhoIs-IPEnrichment-Tools](https://github.com/SecTraversl/PowerShell-GeoIP-WhoIs-IPEnrichment-Tools)
- `PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-LICENSE`: License file for the GeoIP and WhoIs enrichment tools by  : [SecTraversl : PowerShell-GeoIP-WhoIs-IPEnrichment-Tools](https://github.com/SecTraversl/PowerShell-GeoIP-WhoIs-IPEnrichment-Tools)
- `PowerShell-GeoIP-WhoIs-IPEnrichment-Tools-README.md`: README file for the GeoIP and WhoIs enrichment tools by  : [SecTraversl : PowerShell-GeoIP-WhoIs-IPEnrichment-Tools](https://github.com/SecTraversl/PowerShell-GeoIP-WhoIs-IPEnrichment-Tools)

### Backup Profile

Run the `copy_profile.ps1` script to copy and backup the profile files to the specified folder.

```powershell
.\copy_profile.ps1
```

### Restore Profile

Run the `restore_profile.ps1` script to restore the profile files from the backup folder.

```powershell
.\restore_profile.ps1
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Acknowledgments

- Thanks to all contributors and users of this project.
