# Weather-related functions and variables

# API Key and City (Consider parameterizing these or using a config file)
$apiKey = "<YOUR OPENWEATHERMAPS API KEY>"
$city = "<YOUR CITY>",

<#
.SYNOPSIS
    Retrieves and displays weather information for a specified city, state, and country.

.DESCRIPTION
    The Get-Weather function uses the OpenWeatherMap API to fetch current weather conditions,
    "feels like" temperature, humidity, wind speed, wind direction, pressure, sunrise and sunset times,
    and a 5-day forecast for the specified location.

.PARAMETER city
    Specifies the city for weather retrieval. Default is "Dubuque."

.PARAMETER state
    Specifies the state for weather retrieval. Optional parameter.

.PARAMETER country
    Specifies the country for weather retrieval. Default is "US."

.PARAMETER apiKey
    Specifies the API key for OpenWeatherMap. Default key is provided.

.EXAMPLE
    Get-Weather -city "New York" -state "NY" -country "US"
#>
function Get-Weather {
    param (
        [string] $city = "<YOUR CITY>",
        [string] $state = "<YOUR STATE>",
        [string] $country = "<YOUR COUNTRY>",
        [string] $apiKey = "<YOUR OPENWEATHERMAPS API KEY>"
    )
    # Build the location query
    $locationQuery = $city
    if ($state -ne "") { $locationQuery += ",$state" }
    $locationQuery += ",$country"

    # Fetch and display current weather
    $currentWeatherUrl = "http://api.openweathermap.org/data/2.5/weather?q=$locationQuery&appid=$apiKey&units=imperial"
    $currentWeatherResponse = Invoke-RestMethod -Uri $currentWeatherUrl
    $temp = $currentWeatherResponse.main.temp
    $feelsLikeTemp = $currentWeatherResponse.main.feels_like # Extracting the "feels like" temperature
    $description = $currentWeatherResponse.weather[0].description
    $humidity = $currentWeatherResponse.main.humidity
    $windSpeed = $currentWeatherResponse.wind.speed
    $windDirection = $currentWeatherResponse.wind.deg
    $pressure = $currentWeatherResponse.main.pressure
    $sunrise = (Get-Date "1970-01-01 00:00:00").AddSeconds($currentWeatherResponse.sys.sunrise)
    $sunset = (Get-Date "1970-01-01 00:00:00").AddSeconds($currentWeatherResponse.sys.sunset)

    $icon = Get-WeatherIcon $currentWeatherResponse.weather[0].main
    $color = Get-WeatherColor $currentWeatherResponse.weather[0].main
    Write-Host ("The current weather in {0},{1} is {2}°F (feels like {3}°F) with {4} {5}." -f $city, $state, $temp, $feelsLikeTemp, $description, $icon) -ForegroundColor $color
    Write-Host ("  Humidity: {0}% | Wind Speed: {1} mph | Wind Direction: {2}° | Pressure: {3} hPa" -f $humidity, $windSpeed, $windDirection, $pressure) -ForegroundColor $color
    Write-Host ("  Sunrise: {0} | Sunset: {1}" -f $sunrise, $sunset) -ForegroundColor $color

    # Fetch 5-day forecast
    $forecastUrl = "http://api.openweathermap.org/data/2.5/forecast?q=$locationQuery&appid=$apiKey&units=imperial"
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

<#
.SYNOPSIS
    Returns a weather icon based on the weather condition.

.DESCRIPTION
    The Get-WeatherIcon function returns a corresponding icon for the specified weather condition.

.PARAMETER weatherMain
    Specifies the main weather condition to retrieve the icon for.

.EXAMPLE
    Get-WeatherIcon "Rain"
    Returns: 🌧️
#>
function Get-WeatherIcon ($weatherMain) {
    switch ($weatherMain) {
        "Clouds" { "☁️" }
        "Rain" { "🌧️" }
        "Snow" { "❄️" }
        "Thunderstorm" { "⛈️" }
        "Clear" { "☀️" }
        default { "" }
    }
}

<#
.SYNOPSIS
    Returns a color based on the weather condition.

.DESCRIPTION
    The Get-WeatherColor function returns a corresponding color for the specified weather condition.

.PARAMETER weatherMain
    Specifies the main weather condition to retrieve the color for.

.EXAMPLE
    Get-WeatherColor "Rain"
    Returns: Blue
#>
function Get-WeatherColor ($weatherMain) {
    switch ($weatherMain) {
        "Clouds" { "Gray" }
        "Rain" { "Blue" }
        "Snow" { "White" }
        "Thunderstorm" { "DarkRed" }
        "Clear" { "Yellow" }
        default { "Green" }
    }
}
