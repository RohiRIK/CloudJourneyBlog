

## authenticate parameters
$tenantId = "d7e5afc3-f28a-4611-bf69-bb91ff76fefa"
$clientId = "5c87eb80-c3e2-45a0-bc1e-520785b3df38"
$clientSecret = "Lfa8Q~ZYF5cgm2KuNTBnFNCTpjdTRgmo6r1yzarq"

## sharepoint parameters
# $sharePointSiteUrl = ""
# $sharePointLibraryUrl = ""

## properties to collect from the  device object
$mainObjectProperties = @(
    "Id",
    "AzureAdDeviceId",
    "DeviceName",
    "UserPrincipalName",
    "Model",
    "Manufacturer",
    "SerialNumber",
    "IsEncrypted" # For "Disk Encryption Status"
)

# functions

## Function to create logs
function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Warning", "Error")]
        [string]$Level = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    switch ($Level) {
        "Info" {
            Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor Green
        }
        "Warning" {
            Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor Yellow
        }
        "Error" {
            Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor Red
        }
    }
}

## function to get access token
function Get-AccessToken {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TenantId,

        [Parameter(Mandatory = $true)]
        [string]$ClientId,

        [Parameter(Mandatory = $true)]
        [string]$ClientSecret
    )
    $body = @{
        grant_type    = "client_credentials"
        client_id     = $ClientId
        client_secret = $ClientSecret
        resource      = "https://graph.microsoft.com"
    }
    $response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/token" -Method Post -Body $body
    return $response.access_token
}   

function Get-EndpointAnalyticsScore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$DeviceId
    )
    
    $apiUrl = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsDeviceScores"
    
    # If DeviceId is provided, filter by that specific device
    if ($DeviceId) {
        $requestUri = "$apiUrl?`$filter=id eq '$DeviceId'"
    } else {
        $requestUri = $apiUrl
    }

    Write-Log "Querying Graph API for device scores. URI: $requestUri" -Level "Info"

    try {
        # If querying a specific device, no pagination needed
        if ($DeviceId) {
            $response = Invoke-MgGraphRequest -Uri $requestUri -Method Get
            
            if ($response.value) {
                Write-Log "Successfully retrieved device score for specific device ID: $DeviceId" -Level "Info"
                return $response.value
            } else {
                Write-Log "No device score found for device ID: $DeviceId" -Level "Warning"
                return $null
            }
        }
        else {
            # Get all device scores with pagination (only when getting all devices)
            $allDeviceScores = @()
            $nextLink = $requestUri
            
            do {
                $response = Invoke-MgGraphRequest -Uri $nextLink -Method Get
                
                if ($response.value) {
                    $allDeviceScores += $response.value
                    Write-Log "Retrieved $($response.value.Count) device scores in this batch. Total so far: $($allDeviceScores.Count)" -Level "Info"
                }
                
                $nextLink = $response.'@odata.nextLink'
            } while ($nextLink)
            
            if ($allDeviceScores.Count -gt 0) {
                Write-Log "Successfully retrieved $($allDeviceScores.Count) device score records in total" -Level "Info"
                return $allDeviceScores
            } else {
                Write-Log "No device scores found" -Level "Warning"
                return $null
            }
        }
    }
    catch {
        Write-Log "Error querying device scores: $($_.Exception.Message)" -Level "Error"
        return $null
    }
}


function Get-RecentCrashEvents {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,
        [Parameter(Mandatory = $false)]
        [int]$DaysBack = 30
    )

    try {
        $daysAgo = (Get-Date).AddDays(-$DaysBack).ToString("yyyy-MM-ddTHH:mm:ssZ")
        $detailsUri = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsAppHealthDevicePerformanceDetails?`$filter=deviceId eq '$DeviceId' and eventType eq 'App crash' and eventDateTime ge $daysAgo"

        Write-Log "Querying crash events for device: $DeviceId" -Level "Info"
        $detailsResponse = Invoke-MgGraphRequest -Uri $detailsUri -Method Get 

        if ($detailsResponse.value -and $detailsResponse.value.Count -gt 0) {
            Write-Log "Found $($detailsResponse.value.Count) crash events in the last $DaysBack days for device: $DeviceId" -Level "Info"
            
            # Format the crash details and return them
            $crashes = $detailsResponse.value | Select-Object -Property @{Name = "AppDisplayName"; Expression = { $_.appDisplayName } },
                                                                        @{Name = "AppVersion"; Expression = { $_.appVersion } },
                                                                        @{Name = "EventDateTime"; Expression = { $_.eventDateTime } }
            
            return $crashes
        } 
        else {
            Write-Log "No crash events found within the last $DaysBack days for device: $DeviceId" -Level "Info"
            return $null
        }
    }
    catch {
        Write-Log "Error getting crash events for device '$DeviceId': $($_.Exception.Message)" -Level "Error"
        return $null
    }
}



### Main
Write-Log "Connecting to Microsoft Graph..." -Level "Info"
# Added UserExperienceAnalytics.Read.All for the new endpoints

# Convert the client secret to a SecureString
$secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force

# Create a PSCredential object
$ClientSecretCredential = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)

# Connect to Microsoft Graph
Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $ClientSecretCredential
Write-Log "Successfully connected to Microsoft Graph." -Level "Info"

## query all devices
Write-Log "Querying all managed devices to get their main properties from your table..." -Level "Info"

    # This single, efficient call gets all the direct properties for all devices.
$allDevicesWithMainProps = Get-MgDeviceManagementManagedDevice  -All -Property $mainObjectProperties #-top 300 # -Filter "operatingSystem eq 'Windows'"
Write-Log "Found $($allDevicesWithMainProps.Count) devices. Now fetching additional data for each." -Level "Info"

$results = @()

# Get all device scores first (more efficient than individual calls)
Write-Log "Fetching all endpoint analytics scores..." -Level "Info"
$allDeviceAnalytics = Get-EndpointAnalyticsScore

$deviceAnalyticsHash = @{}

#Create a hashtable for quick lookup by device ID
if ($allDeviceAnalytics) {
        foreach ($Analytics in $allDeviceAnalytics) {

        $deviceAnalyticsHash[$Analytics.id] = $Analytics
    }
    Write-Log "Device score hash created with $($deviceAnalyticsHash.Count) entries." -Level "Info"
}

foreach ($device in $allDevicesWithMainProps) {
    $deviceId = $device.Id
    $AzureAdDeviceId = $device.AzureAdDeviceId
    Write-Log "Processing device: $($device.DeviceName) with ID: $deviceId" -Level "Info"

    # Try to get the device score - first by regular ID 
    $deviceAnalytics = $deviceAnalyticsHash[$deviceId]
    # if ($deviceAnalytics -eq $null) {
    #     # If not found, try using AzureAdDeviceId
    #     write-Log "Device $($device.DeviceName) not found, trying request it again: $($deviceId)" -Level "Info"
    #     #$result = Get-EndpointAnalyticsScore -DeviceId $deviceId
    # }

    # Create a custom object to hold the device data
    $result = [PSCustomObject]@{
        Id                         = $deviceId
        AzureAdDeviceId            = $AzureAdDeviceId
        DeviceName                 = $device.DeviceName
        UserPrincipalName          = $device.UserPrincipalName
        Model                      = $device.Model
        Manufacturer               = $device.Manufacturer
        SerialNumber               = $device.SerialNumber
        IsEncrypted                = $device.IsEncrypted
        
        # Endpoint Analytics Scores (handle null device scores)
        EndpointAnalyticsScore     = if ($deviceAnalytics) { $deviceAnalytics.endpointAnalyticsScore } else { -1 }
        StartupPerformanceScore    = if ($deviceAnalytics) { $deviceAnalytics.startupPerformanceScore } else { -1 }
        AppReliabilityScore        = if ($deviceAnalytics) { $deviceAnalytics.appReliabilityScore } else { -1 }
        WorkFromAnywhereScore      = if ($deviceAnalytics) { $deviceAnalytics.workFromAnywhereScore } else { -1 }
        MeanResourceSpikeTimeScore = if ($deviceAnalytics) { $deviceAnalytics.meanResourceSpikeTimeScore } else { -1 }
        BatteryHealthScore         = if ($deviceAnalytics) { $deviceAnalytics.batteryHealthScore } else { -1 }
        HealthStatus               = if ($deviceAnalytics) { $deviceAnalytics.healthStatus } else { "Unknown" }

        # Crash Events Data - only call if we have a device score and it's low
        RecentCrashEvents          = if ($deviceAnalytics -and $deviceAnalytics.appReliabilityScore -lt 80) { Get-RecentCrashEvents -DeviceId $deviceId -DaysBack 30 } else { $null }
        dataCollectionTime       = get-date -Format "yyyy-MM-ddTHH:mm:ssZ" # Add a timestamp for data collection
    }

    # Add the result to the results array
    $results += $result
}

# Display summary
Write-Log "Processing completed. Total devices processed: $($results.Count)" -Level "Info"

# Display the results in a formatted table
Write-Log "Device Analytics Summary:" -Level "Info"
$results | ConvertTo-Json
# Export to CSV
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvPath = "device_analytics_scores_$timestamp.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation
Write-Log "Results exported to: $csvPath" -Level "Info"

# # Disconnect from Microsoft Graph
# Disconnect-MgGraph
# Write-Log "Disconnected from Microsoft Graph." -Level "Info"