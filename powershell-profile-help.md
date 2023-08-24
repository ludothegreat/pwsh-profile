# PowerShell Profile Help

This document provides an overview of the custom functions and aliases in your PowerShell profile.

## Functions

### `Get-IPAddress`

Gets the IP address based on the provided parameters.

- Parameters:
  - `InterfaceType`: The type of network interface (default is "All").
  - `IPv6`: A boolean to get IPv6 address (default is `$false`).
  - `AllAddresses`: A boolean to get all addresses (default is `$false`).

### `flushdns`

Clears the DNS client cache.

### `restart-net`

Restarts the network adapter.

### `edit`

Opens a file in Visual Studio Code.

- Parameters:
  - `file`: The file to open.

### `home`

Navigates to the user's home directory.

### `docs`

Navigates to the user's Documents folder.

### `weather`

Displays the current weather and 5-day forecast for a specified city.

### `up`

Updates the source list and upgrades all packages that require upgrading using Winget.

### `Update-Profile`

Updates the profile and imports modules.

- Alias: `reload`

## Aliases

- `atd`: Alias for `Add-ToDo`
- `rtd`: Alias for `Remove-ToDo`
- `gtd`: Alias for `Get-ToDos`
- `ctd`: Alias for `Clear-ToDos`
- `std`: Alias for `Save-ToDos`
- `itd`: Alias for `Import-ToDos`
- `amtd`: Alias for `Add-MultipleToDos`

## Other Details

This profile also includes additional configurations and customizations specific to your environment.

For any further assistance or specific details, refer to the PowerShell profile script or consult the relevant documentation.
