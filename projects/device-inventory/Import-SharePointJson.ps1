# --- Configuration ---
$SiteUrl = "https://m365x57796783.sharepoint.com/sites/device_inentory/_layouts/15/appinv.aspx"             # Replace with your SharePoint site URL
$ListName = "device_inventory"                                              # Replace with your SharePoint list name
$JsonFilePath = "C:\Users\RohiRikman\OneDrive - OnCloud\infrastructure_toolkit\automation_workflows\device_inventory\data\device_inventry_exmple.json"

# --- Service Principal Authentication Details ---
# IMPORTANT: Replace these with your actual Client ID, Tenant ID, and Client Secret
$ClientId = "5c87eb80-c3e2-45a0-bc1e-520785b3df38"     # e.g., "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$TenantId = "d7e5afc3-f28a-4611-bf69-bb91ff76fefa"       # e.g., "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
$ClientSecret = "Lfa8Q~ZYF5cgm2KuNTBnFNCTpjdTRgmo6r1yzarq"   # The VALUE of the secret you copied (e.g., "abC~123...XYZ")



# --- Connect to SharePoint Online using Service Principal ---
Write-Host "Connecting to SharePoint Online using Service Principal..."
try {
    Connect-PnPOnline -Url $SiteUrl -ClientId $ClientId -ClientSecretCredential $ClientSecret -WarningAction Ignore
    Write-Host "Successfully connected to $SiteUrl using Service Principal."
}
catch {
    Write-Error "Failed to connect to SharePoint using Service Principal: $($_.Exception.Message)"
    exit
}

# --- Read and Parse JSON File ---
Write-Host "Reading JSON file from $JsonFilePath..."
if (-not (Test-Path $JsonFilePath)) {
    Write-Error "JSON file not found at $JsonFilePath. Please check the path."
    #Disconnect-PnPOnline
    exit
}

try {
    $jsonData = Get-Content -Path $JsonFilePath | ConvertFrom-Json
    Write-Host "Successfully read and parsed JSON data."
}
catch {
    Write-Error "Failed to read or parse JSON file: $($_.Exception.Message)"
    #Disconnect-PnPOnline
    exit
}

# --- Import Data into SharePoint List ---
Write-Host "Importing data into SharePoint List '$ListName'..."
$counter = 0
foreach ($item in $jsonData) {
    $counter++
    Write-Host "Processing item $counter : $($item.DeviceName)"# Using DeviceName for display, cleans newlines

    try {
        # Create a hashtable for list item properties
        $itemProperties = @{}
        foreach ($prop in $item.PSObject.Properties) {
            $columnName = $prop.Name
            $columnValue = $prop.Value
            $itemProperties[$columnName] = $columnValue
        }

        # Add the item to the SharePoint list
        Add-PnPListItem -List $ListName -Values $itemProperties #| Out-Null
        Write-Host "  - Item added successfully."
    }
    catch {
        Write-Error "  - Failed to add item: $($_.Exception.Message)"
        Write-Error "  - Item details: $($item | ConvertTo-Json -Compress)"
    }
}

Write-Host "Data import complete. Total items processed: $counter"

# --- Disconnect from SharePoint ---
#Disconnect-PnPOnline
Write-Host "Disconnected from SharePoint Online."