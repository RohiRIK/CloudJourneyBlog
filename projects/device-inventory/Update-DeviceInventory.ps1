# Update-DeviceInventory.ps1
# This script consolidates and modularizes the device inventory solution.

# --- Configuration (will be replaced by secure methods in production) ---
# These values are currently hardcoded for local testing purposes.
$SiteUrl = "https://m365x57796783.sharepoint.com/sites/device_inentory/_layouts/15/appinv.aspx"
$ListName = "device_inventory"
$JsonFilePath = "C:\Users\RohiRikman\OneDrive - OnCloud\infrastructure_toolkit\automation_workflows\device_inventory\data\device_inventry_exmple.json"

$ClientId = "5c87eb80-c3e2-45a0-bc1e-520785b3df38"
$TenantId = "d7e5afc3-f28a-4611-bf69-bb91ff76fefa"
$ClientSecret = "Lfa8Q~ZYF5cgm2KuNTBnFNCTpjdTRgmo6r1yzarq"

# --- Functions ---

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

function Get-DeviceStartupHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId
    )

    $apiUrl = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsDeviceStartupHistory"
    $requestUri = "$apiUrl?`$filter=deviceId eq '$DeviceId'&$orderBy=startTime desc&$top=1"

    Write-Log "Querying Graph API for latest startup history for device: $DeviceId" -Level "Info"

    try {
        $response = Invoke-MgGraphRequest -Uri $requestUri -Method Get

        if ($response.value -and $response.value.Count -gt 0) {
            Write-Log "Successfully retrieved startup history for device ID: $DeviceId" -Level "Info"
            return $response.value[0] # Return the latest record
        } else {
            Write-Log "No startup history found for device ID: $DeviceId" -Level "Info"
            return $null
        }
    }
    catch {
        Write-Log "Error getting startup history for device '$DeviceId': $($_.Exception.Message)" -Level "Error"
        return $null
    }
}

function Get-WorkFromAnywhereModelPerformance {
    [CmdletBinding()]
    param()

    $apiUrl = "https://graph.microsoft.com/beta/deviceManagement/userExperienceAnalyticsWorkFromAnywhereModelPerformance"
    Write-Log "Querying Graph API for Work From Anywhere model performance." -Level "Info"

    try {
        $allModelPerformance = @()
        $nextLink = $apiUrl
        
        do {
            $response = Invoke-MgGraphRequest -Uri $nextLink -Method Get
            
            if ($response.value) {
                $allModelPerformance += $response.value
                Write-Log "Retrieved $($response.value.Count) Work From Anywhere model performance records in this batch. Total so far: $($allModelPerformance.Count)" -Level "Info"
            }
            
            $nextLink = $response.'@odata.nextLink'
        } while ($nextLink)
        
        if ($allModelPerformance.Count -gt 0) {
            Write-Log "Successfully retrieved $($allModelPerformance.Count) Work From Anywhere model performance records in total." -Level "Info"
            return $allModelPerformance
        } else {
            Write-Log "No Work From Anywhere model performance records found." -Level "Warning"
            return $null
        }
    }
    catch {
        Write-Log "Error querying Work From Anywhere model performance: $($_.Exception.Message)" -Level "Error"
        return $null
    }
}

function Connect-SharePointOnline {
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl,
        [Parameter(Mandatory = $true)]
        [string]$ClientId,
        [Parameter(Mandatory = true)]
        [string]$ClientSecret
    )
    Write-Log "Connecting to SharePoint Online using Service Principal..." -Level "Info"
    try {
        Connect-PnPOnline -Url $SiteUrl -ClientId $ClientId -ClientSecretCredential $ClientSecret -WarningAction Ignore
        Write-Log "Successfully connected to $SiteUrl using Service Principal." -Level "Info"
        return $true
    }
    catch {
        Write-Log "Failed to connect to SharePoint using Service Principal: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Update-SharePointListItem {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ListName,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$ItemData,
        [Parameter(Mandatory = $true)]
        [string]$UniqueIdColumn # e.g., "AzureAdDeviceId" or "Id"
    )

    Write-Log "Attempting to upsert item with $($UniqueIdColumn) = $($ItemData.$UniqueIdColumn) into SharePoint list '$ListName'." -Level "Info"

    try {
        # Check if item exists
        $existingItem = Get-PnPListItem -List $ListName -Query "<View><Query><Where><Eq><FieldRef Name='$UniqueIdColumn'/><Value Type='Text'>$($ItemData.$UniqueIdColumn)</Value></Eq></Where></Query></View>" -ErrorAction SilentlyContinue

        if ($existingItem) {
            # Update existing item
            Write-Log "  - Item with $($UniqueIdColumn) = $($ItemData.$UniqueIdColumn) found. Updating item." -Level "Info"
            Set-PnPListItem -List $ListName -Identity $existingItem.Id -Values $ItemData -ErrorAction Stop | Out-Null
            Write-Log "  - Item updated successfully." -Level "Info"
            return "Updated"
        }
        else {
            # Add new item
            Write-Log "  - Item with $($UniqueIdColumn) = $($ItemData.$UniqueIdColumn) not found. Adding new item." -Level "Info"
            Add-PnPListItem -List $ListName -Values $ItemData -ErrorAction Stop | Out-Null
            Write-Log "  - New item added successfully." -Level "Info"
            return "Added"
        }
    }
    catch {
        Write-Log "  - Failed to upsert item with $($UniqueIdColumn) = $($ItemData.$UniqueIdColumn): $($_.Exception.Message)" -Level "Error"
        Write-Log "  - Item details: $($ItemData | ConvertTo-Json -Compress)" -Level "Error"
        return "Failed"
    }
}

# --- Main Script Logic ---

### Main
Write-Log "Starting Device Inventory Update Script..." -Level "Info"

# --- Connect to Microsoft Graph ---
Write-Log "Connecting to Microsoft Graph..." -Level "Info"
# Convert the client secret to a SecureString
$secureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
# Create a PSCredential object
$ClientSecretCredential = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)
# Connect to Microsoft Graph
Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $ClientSecretCredential
Write-Log "Successfully connected to Microsoft Graph." -Level "Info"

## Query all devices
Write-Log "Querying all managed devices to get their main properties..." -Level "Info"
$allDevicesWithMainProps = Get-MgDeviceManagementManagedDevice  -All -Property $mainObjectProperties
Write-Log "Found $($allDevicesWithMainProps.Count) devices. Now fetching additional data for each." -Level "Info"

# Get all device scores first (more efficient than individual calls)
Write-Log "Fetching all endpoint analytics scores..." -Level "Info"
$allDeviceAnalytics = Get-EndpointAnalyticsScore
$deviceAnalyticsHash = @{}
if ($allDeviceAnalytics) {
    foreach ($Analytics in $allDeviceAnalytics) {
        $deviceAnalyticsHash[$Analytics.id] = $Analytics
    }
    Write-Log "Device score hash created with $($deviceAnalyticsHash.Count) entries." -Level "Info"
}

# Get all Work From Anywhere model performance scores
Write-Log "Fetching all Work From Anywhere model performance scores..." -Level "Info"
$allWorkFromAnywhereModelPerformance = Get-WorkFromAnywhereModelPerformance
$workFromAnywhereModelPerformanceHash = @{}
if ($allWorkFromAnywhereModelPerformance) {
    foreach ($modelPerf in $allWorkFromAnywhereModelPerformance) {
        $workFromAnywhereModelPerformanceHash["$($modelPerf.manufacturer)-$($modelPerf.model)"] = $modelPerf
    }
    Write-Log "Work From Anywhere model performance hash created with $($workFromAnywhereModelPerformanceHash.Count) entries." -Level "Info"
}

# --- Connect to SharePoint Online ---
Write-Log "Connecting to SharePoint Online..." -Level "Info"
$accessToken = Get-AccessToken -TenantId $TenantId -ClientId $ClientId -ClientSecret $ClientSecret
if (-not $accessToken) {
    Write-Log "Failed to obtain access token for SharePoint. Exiting script." -Level "Error"
    exit
}   
$sharePointConnected = Connect-SharePointOnline -SiteUrl $SiteUrl -AccessToken $accessToken
Write-Log "SharePoint connection established." -Level "Info"    
if (-not $sharePointConnected) {
    Write-Log "SharePoint connection failed. Exiting script." -Level "Error"
    exit
}

$processedCount = 0
$addedCount = 0
$updatedCount = 0
$failedCount = 0
$lowScoreDevices = @()

foreach ($device in $allDevicesWithMainProps) {
    $processedCount++
    $deviceId = $device.Id
    $AzureAdDeviceId = $device.AzureAdDeviceId
    Write-Log "Processing device: $($device.DeviceName) (ID: $deviceId)" -Level "Info"

    $deviceAnalytics = $deviceAnalyticsHash[$deviceId]

    # Get Startup History
    $startupHistory = Get-DeviceStartupHistory -DeviceId $deviceId

    # Create a custom object to hold the device data
    $deviceData = [PSCustomObject]@{
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

        # Startup Performance Details
        Startup_CoreBootTimeInMs = if ($startupHistory) { $startupHistory.coreBootTimeInMs } else { -1 }
        Startup_TotalBootTimeInMs = if ($startupHistory) { $startupHistory.totalBootTimeInMs } else { -1 }
        Startup_CoreLoginTimeInMs = if ($startupHistory) { $startupHistory.coreLoginTimeInMs } else { -1 }
        Startup_ResponsiveDesktopTimeInMs = if ($startupHistory) { $startupHistory.responsiveDesktopTimeInMs } else { -1 }
        Startup_TotalLoginTimeInMs = if ($startupHistory) { $startupHistory.totalLoginTimeInMs } else { -1 }
        Startup_RestartCategory = if ($startupHistory) { $startupHistory.restartCategory } else { "Unknown" }

        # Crash Events Data - only call if we have a device score and it's low
        RecentCrashEvents          = if ($deviceAnalytics -and $deviceAnalytics.appReliabilityScore -lt 80) { Get-RecentCrashEvents -DeviceId $deviceId -DaysBack 30 } else { $null }
        dataCollectionTime       = get-date -Format "yyyy-MM-ddTHH:mm:ssZ" # Add a timestamp for data collection
    }

    # Update SharePoint List Item
    $upsertResult = Update-SharePointListItem -ListName $ListName -ItemData $deviceData -UniqueIdColumn "AzureAdDeviceId"
    
    switch ($upsertResult) {
        "Added" { $addedCount++ }
        "Updated" { $updatedCount++ }
        "Failed" { $failedCount++ }
    }

    # Check for low scores and add to report
    if ($deviceData.EndpointAnalyticsScore -lt 80 -or
        $deviceData.StartupPerformanceScore -lt 80 -or
        $deviceData.AppReliabilityScore -lt 80 -or
        $deviceData.WorkFromAnywhereScore -lt 80 -or
        $deviceData.MeanResourceSpikeTimeScore -lt 80 -or
        $deviceData.BatteryHealthScore -lt 80) {
        $lowScoreDevices += $deviceData
    }
}

# --- Generate Summary Report ---
Write-Log "Data import and processing complete." -Level "Info"
Write-Log "--- Summary Report ---" -Level "Info"
Write-Log "Total Devices Processed: $processedCount" -Level "Info"
Write-Log "New Devices Added to SharePoint: $addedCount" -Level "Info"
Write-Log "Existing Devices Updated in SharePoint: $updatedCount" -Level "Info"
Write-Log "Failed SharePoint Operations: $failedCount" -Level "Info"

if ($lowScoreDevices.Count -gt 0) {
    Write-Log "Devices with Scores Below Threshold (80):" -Level "Warning"
    foreach ($lowDevice in $lowScoreDevices) {
        Write-Log "  - Device: $($lowDevice.DeviceName), EndpointAnalyticsScore: $($lowDevice.EndpointAnalyticsScore), AppReliabilityScore: $($lowDevice.AppReliabilityScore)" -Level "Warning"
        if ($lowDevice.RecentCrashEvents) {
            Write-Log "    Recent Crash Events:" -Level "Warning"
            $lowDevice.RecentCrashEvents | ForEach-Object {
                Write-Log "      App: $($_.AppDisplayName), Version: $($_.AppVersion), Time: $($_.EventDateTime)" -Level "Warning"
            }
        }
    }
} else {
    Write-Log "No devices found with scores below threshold." -Level "Info"
}

# --- Disconnect from Microsoft Graph ---
# Disconnect-MgGraph # Uncomment if you want to disconnect explicitly
# Write-Log "Disconnected from Microsoft Graph." -Level "Info"

# --- Disconnect from SharePoint ---
# Disconnect-PnPOnline # Uncomment if you want to disconnect explicitly
# Write-Log "Disconnected from SharePoint Online." -Level "Info"
