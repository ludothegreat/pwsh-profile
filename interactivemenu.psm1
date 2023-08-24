function Show-InteractiveMenu {
    $continueMenu = $true
    do {
        Clear-Host
        Write-Host "Main Menu" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "---------"
        Write-Host "1. Network Utilities"
        Write-Host "2. To-Do Management"
        Write-Host "3. System Updates"
        Write-Host "4. Profile Management"
        Write-Host "5. RDP Manager"
        Write-Host "6. PS Weather"
        Write-Host "Q. Exit"
        $choice = Read-Host "Please choose an option (1-7)"

        switch ($choice) {
            '1' { Show-NetworkUtilitiesMenu }
            '2' { Show-ToDoManagementMenu }
            '3' { Show-SystemUpdatesMenu }
            '4' { Show-ProfileManagementMenu }
            '5' { Show-RDPManagerMenu }
            '6' { Show-PSWeatherMenu }
            'Q' { $continueMenu = $false }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($continueMenu)
}

function Show-NetworkUtilitiesMenu {
    do {
        Clear-Host
        Write-Host "Network Utilities" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "-----------------"
        Write-Host "1. Flush DNS"
        Write-Host "2. Restart Network Adapter"
        Write-Host "3. Get IP Address"
        Write-Host "4. Back to Main Menu"
        $choice = Read-Host "Please choose an option (1-4)"

        switch ($choice) {
            '1' { flushdns; Read-Host "DNS Flushed. Press Enter to continue..." }
            '2' { restart-net; Read-Host "Press Enter to continue..." }
            '3' { Get-IPAddress; Read-Host "Press Enter to continue..." }
            '4' { Show-InteractiveMenu }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

function Show-ToDoManagementMenu {
    do {
        Clear-Host
        Write-Host "To-Do Management" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "----------------"
        Write-Host "1. Add To-Do"
        Write-Host "2. Remove To-Do"
        Write-Host "3. Get To-Dos"
        Write-Host "4. Clear To-Dos"
        Write-Host "5. Save To-Dos"
        Write-Host "6. Import To-Dos"
        Write-Host "7. Back to Main Menu"
        $choice = Read-Host "Please choose an option (1-7)"

        switch ($choice) {
            '1' { Add-ToDo; Read-Host "Press Enter to continue..." }
            '2' { Remove-ToDo; Read-Host "Press Enter to continue..." }
            '3' { Get-ToDos; Read-Host "Press Enter to continue..." }
            '4' { Clear-ToDos; Read-Host "Press Enter to continue..." }
            '5' { Save-ToDos; Read-Host "Press Enter to continue..." }
            '6' { Import-ToDos; Read-Host "Press Enter to continue..." }
            '7' { Show-InteractiveMenu; Read-Host "Press Enter to continue..." }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

function Show-SystemUpdatesMenu {
    do {
        Clear-Host
        Write-Host "System Updates" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "--------------"
        Write-Host "1. Update System Packages"
        Write-Host "2. Back to Main Menu"
        $choice = Read-Host "Please choose an option (1-2)"

        switch ($choice) {
            '1' { up; Read-Host "Press Enter to continue..." }
            '2' { Show-InteractiveMenu }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

function Show-ProfileManagementMenu {
    do {
        Clear-Host
        Write-Host "Profile Management" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "------------------"
        Write-Host "1. Update Profile"
        Write-Host "2. Show Profile Help"
        Write-Host "3. Back to Main Menu"
        $choice = Read-Host "Please choose an option (1-3)"

        switch ($choice) {
            '1' { Update-Profile; Read-Host "Press Enter to continue..." }
            '2' { show-profile-help; Read-Host "Press Enter to continue..." }
            '3' { Show-InteractiveMenu }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

function Show-PSWeatherMenu {
    do {
        Clear-Host
        Write-Host "PS Weather" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "----------"
        Write-Host "1. Get Weather Information"
        Write-Host "2. Get Weather Icon"
        Write-Host "3. Get Weather Color"
        Write-Host "4. Back to Main Menu"
        $choice = Read-Host "Please choose an option (1-4)"

        switch ($choice) {
            '1' { Get-Weather; Read-Host "Press Enter to continue..." }
            '2' { Get-WeatherIcon; Read-Host "Press Enter to continue..." }
            '3' { Get-WeatherColor; Read-Host "Press Enter to continue..." }
            '4' { Show-InteractiveMenu }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

function Show-RDPManagerMenu {
    do {
        Clear-Host
        Write-Host "RDP Manager" -ForegroundColor Black -BackgroundColor DarkRed
        Write-Host "-----------"
        Write-Host "1. Add RDP Host"
        Write-Host "2. Get RDP Host Information"
        Write-Host "3. Remove RDP Host"
        Write-Host "4. Connect to RDP Host"
        Write-Host "5. Show RDP Hosts"
        Write-Host "6. Back to Main Menu"
        $choice = Read-Host "Please choose an option (1-6)"

        switch ($choice) {
            '1' { Add-Host; Read-Host "Press Enter to continue..." }
            '2' { Get-Host; Read-Host "Press Enter to continue..." }
            '3' { Remove-Host; Read-Host "Press Enter to continue..." }
            '4' { Connect-Host; Read-Host "Press Enter to continue..." }
            '5' { Show-Hosts; Read-Host "Press Enter to continue..." }
            '6' { Show-InteractiveMenu }
            default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

