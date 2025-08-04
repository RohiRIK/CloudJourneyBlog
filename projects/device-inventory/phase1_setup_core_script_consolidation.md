### Detailed Plan for Phase 1: Setup & Core Script Consolidation

**Goal of Phase 1:** To establish a secure and modular foundation for the device inventory solution by centralizing credential management and consolidating existing scripts into a single, well-structured PowerShell module.

---

#### 1. Secure Credential Management

**Current State:**
*   `Import-SharePointJson.ps1` and `export_devcie_score.ps1` both contain hardcoded `ClientId`, `TenantId`, and `ClientSecret`. This is a security risk as these values are exposed in the script files.

**Planned Improvement:**
*   **Action:** Remove all hardcoded credentials from both scripts.
*   **How it will work:**
    *   The consolidated script (`Update-DeviceInventory.ps1`) will be designed to accept these sensitive values as **parameters** when it's executed.
    *   For Jenkins, these parameters will be populated by Jenkins' built-in credential management system, which securely stores secrets and injects them as environment variables or direct parameters during job execution. This prevents the secrets from ever being stored in plain text in the repository.
    *   This approach ensures that the script itself remains generic and secure, relying on the execution environment to provide the necessary authentication details.

---

#### 2. Script Consolidation & Modularization

**Current State:**
*   Two separate PowerShell scripts: `Import-SharePointJson.ps1` (handles SharePoint import) and `export_devcie_score.ps1` (handles Graph API data export).
*   Both scripts contain their own authentication logic and main execution flows.

**Planned Improvement:**
*   **Action:** Merge `Import-SharePointJson.ps1` and `export_devcie_score.ps1` into a single, well-structured PowerShell script, tentatively named `Update-DeviceInventory.ps1`.
*   **How it will work:**
    *   **`Update-DeviceInventory.ps1` (Main Script/Module):** This will be the primary entry point for the entire solution. It will orchestrate the execution of various functions.
        *   It will define parameters for all necessary configuration (SharePoint URL, List Name, Client ID, Tenant ID, Client Secret, JSON file path, etc.).
        *   It will call the modular functions in a logical sequence to perform the end-to-end process.
        *   It will include the main execution logic, error handling, and logging for the overall workflow.
    *   **Modular Functions (within `Update-DeviceInventory.ps1` or a separate module file):**
        *   **`Connect-GraphAPI`:** Encapsulate the logic from `export_devcie_score.ps1` for authenticating and connecting to Microsoft Graph using the provided credentials. This function will return the Graph connection object or indicate success/failure.
        *   **`Get-ManagedDevices`:** Encapsulate the logic for querying all managed devices from Graph API, including pagination. It will return a collection of device objects.
        *   **`Get-EndpointAnalyticsScores`:** Encapsulate the logic for retrieving all Endpoint Analytics scores from Graph API, including pagination, and potentially creating a hashtable for quick lookups.
        *   **`Get-DeviceCrashEvents`:** Encapsulate the logic for conditionally retrieving recent crash events for a given device ID.
        *   **`Connect-SharePointOnline`:** Encapsulate the logic from `Import-SharePointJson.ps1` for authenticating and connecting to SharePoint Online.
        *   **`Update-SharePointListItem` (or `Set-SharePointDeviceData`):** This will be a new or heavily modified function. It will take a device data object as input and handle the "upsert" logic (checking if the item exists in SharePoint and either updating it or creating a new one). This function will replace the `Add-PnPListItem` loop in `Import-SharePointJson.ps1`.
        *   **`Write-Log`:** The existing logging function from `export_devcie_score.ps1` will be retained and potentially enhanced for consistent logging across the entire consolidated script.

**Benefits of Consolidation & Modularization:**
*   **Improved Readability:** Breaking down complex tasks into smaller functions makes the code easier to understand and maintain.
*   **Reusability:** Functions can be reused within the script or in other PowerShell projects.
*   **Easier Debugging:** Isolating functionalities helps in pinpointing issues more quickly.
*   **Enhanced Testability:** Individual functions can be tested independently.
*   **Centralized Control:** A single main script (`Update-DeviceInventory.ps1`) will control the entire workflow, simplifying execution and scheduling.