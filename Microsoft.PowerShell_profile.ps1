# Import Terminal Icons
Import-Module -Name Terminal-Icons

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
    } else {
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

function weather {
    $apiKey = "ffedc6c0e07255a9ddc1a2407d4b550c"
    $city = "dubuque"
    $currentWeatherUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=imperial"
    $forecastUrl = "http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=imperial"

    # Function to get weather icon
    function Get-WeatherIcon ($weatherMain) {
        switch ($weatherMain) {
            "Clouds"   { "☁️" }
            "Rain"     { "🌧️" }
            "Snow"     { "❄️" }
            "Thunderstorm" { "⛈️" }
            "Clear"    { "☀️" }
            default    { "" }
        }
    }

    # Function to get color based on weather condition
    function Get-WeatherColor ($weatherMain) {
        switch ($weatherMain) {
            "Clouds"   { "Gray" }
            "Rain"     { "Blue" }
            "Snow"     { "White" }
            "Thunderstorm" { "DarkRed" }
            "Clear"    { "Yellow" }
            default    { "Green" }
        }
    }

    # Fetch and display current weather
    $currentWeatherResponse = Invoke-RestMethod -Uri $currentWeatherUrl
    $temp = $currentWeatherResponse.main.temp
    $description = $currentWeatherResponse.weather[0].description
    $icon = Get-WeatherIcon $currentWeatherResponse.weather[0].main
    $color = Get-WeatherColor $currentWeatherResponse.weather[0].main
    Write-Host ("The current weather in {0} is {1}°F with {2} {3}." -f $city, $temp, $description, $icon) -ForegroundColor $color

    # Fetch 5-day forecast
    $forecastResponse = Invoke-RestMethod -Uri $forecastUrl

    Write-Host "5-day forecast:"
    $currentDate = ""
    $dailyHigh = [double]::MinValue
    $dailyLow = [double]::MaxValue
    $weatherConditions = @()
    $count = 0

    $forecastResponse.list | ForEach-Object {
        $forecastTime = [DateTime]::ParseExact($_.dt_txt, "yyyy-MM-dd HH:mm:ss", $null)
        $forecastDate = $forecastTime.ToString("MM-dd-yyyy")

        # Check if the date has changed
        if ($forecastDate -ne $currentDate -and $currentDate -ne "") {
            $mostCommonCondition = $weatherConditions | Group-Object | Sort-Object Count -Descending | Select-Object -First 1
            $icon = Get-WeatherIcon $mostCommonCondition.Name
            $color = Get-WeatherColor $mostCommonCondition.Name
            Write-Host ("  {0}: High {1}°F, Low {2}°F {3}" -f $currentDate, $dailyHigh, $dailyLow, $icon) -ForegroundColor $color
            $dailyHigh = [double]::MinValue
            $dailyLow = [double]::MaxValue
            $weatherConditions = @()
            $count++
            if ($count -eq 5) { break } # Limit to 5 days
        }

        # Update daily high and low temperatures
        $temp = $_.main.temp
        if ($temp -gt $dailyHigh) { $dailyHigh = $temp }
        if ($temp -lt $dailyLow) { $dailyLow = $temp }
        $weatherConditions += $_.weather[0].main

        $currentDate = $forecastDate
    }

    # Display the last day
    $mostCommonCondition = $weatherConditions | Group-Object | Sort-Object Count -Descending | Select-Object -First 1
    $icon = Get-WeatherIcon $mostCommonCondition.Name
    $color = Get-WeatherColor $mostCommonCondition.Name
    Write-Host ("  {0}: High {1}°F, Low {2}°F {3}" -f $currentDate, $dailyHigh, $dailyLow, $icon) -ForegroundColor $color
}

# Import ToDo module
Import-Module C:\Scripts\pwsh-profile\ToDo.psm1

# Create aliases for the functions
Set-Alias atd Add-ToDo
Set-Alias rtd Remove-ToDo
Set-Alias gtd Get-ToDos # Corrected alias for Get-ToDos
Set-Alias ctd Clear-ToDos
Set-Alias std Save-ToDos
Set-Alias itd Import-ToDos # Alias for Import-ToDos
Set-Alias amtd Add-MultipleToDos


# Update system packages using winget
function up {
    winget upgrade
}

function Update-Profile {
    . $PROFILE
    Import-Module C:\Scripts\pwsh-profile\ToDo.psm1 -Force
    Write-Host "Profile updated and modules imported." -ForegroundColor Green
}
Set-Alias reload Update-Profile

## Final Line to set prompt
oh-my-posh init pwsh --config 'C:\Users\ludot\AppData\Local\Programs\oh-my-posh\themes\customkali.omp.json'| Invoke-Expression
