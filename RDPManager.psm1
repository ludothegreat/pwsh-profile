# RDPManager.psm1

# File path to store the host information
$HostsFile = "$env:USERPROFILE\RDPHosts.txt"

# Load hosts from file if it exists
if (Test-Path -Path $HostsFile) {
    $script:RDPHosts = @(Get-Content -Path $HostsFile)
} else {
    Write-Host "Hosts file not found. Initializing empty hosts list."
    $script:RDPHosts = @()
}

function Add-Host {
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$HostName
    )
    $script:RDPHosts += $HostName
    $script:RDPHosts | Set-Content -Path $HostsFile
    Write-Host "Host(s) $($HostName -join ', ') added successfully."
}

function Get-Hosts {
    Write-Host "List of hosts:"
    foreach ($index in 0..($script:RDPHosts.Length - 1)) {
        Write-Host ($index.ToString() + ": " + $script:RDPHosts[$index])
    }
}

function Remove-Host {
    param (
        [int]$Index
    )
    $removedHost = $script:RDPHosts[$Index]
    $script:RDPHosts = $script:RDPHosts[0..($Index-1)] + $script:RDPHosts[($Index+1)..($script:RDPHosts.Length-1)]
    $script:RDPHosts | Set-Content -Path $HostsFile
    Write-Host "Host $removedHost removed successfully."
}

function Connect-Host {
    param (
        [int]$Index
    )
    $HostName = $script:RDPHosts[$Index]
    if ($null -ne $HostName) {
        mstsc.exe /v:$HostName
    } else {
        Write-Host "Host at index $Index not found."
    }
}

function Show-RDPHelp {
    Write-Host "RDPManager Module Help"
    Write-Host "----------------------"
    Write-Host "Add-Host <host1> <host2> ...    : Add one or more hosts."
    Write-Host "Get-Hosts                       : List all the hosts with their index numbers."
    Write-Host "Remove-Host <index>             : Remove a host by its index number."
    Write-Host "Connect-Host <index>            : Connect to a host using its index number."
    Write-Host "Show-Help                       : Show this help message."
}

Export-ModuleMember -Function Add-Host, Remove-Host, Get-Hosts, Connect-Host, Show-RDPHelp

