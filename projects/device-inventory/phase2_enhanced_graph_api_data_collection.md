## Phase 2: Enhanced Graph API Data Collection & Logic

1.  **Efficient Device & Score Retrieval:**
    *   **Action:** Utilize the existing efficient methods from `export_devcie_score.ps1` to first retrieve all managed devices and then all Endpoint Analytics scores from Microsoft Graph.
    *   **Action:** Create a lookup mechanism (e.g., a hashtable) for quick association of device IDs with their respective analytics scores.
2.  **Conditional Detailed Data Fetching:**
    *   **Action:** Implement logic to iterate through each device.
    *   **Action:** If a device's `AppReliabilityScore` (or another relevant Endpoint Analytics score) falls below a predefined threshold (e.g., 80), trigger the `Get-RecentCrashEvents` function for that specific device.
    *   **Action:** Ensure robust error handling and logging for all Graph API calls, especially for individual device queries.

## To-Do: Further Enhancements

The existing function for retrieving device scores is working. Now, we need to research and integrate additional data points from the Graph API for other Endpoint Analytics scores. This involves identifying the correct Graph API endpoints and properties for each. and implement this in the update script

Specifically, we need to enhance data collection for:

*   **EndpointAnalyticsScore:** Research relevant Graph API endpoints to gather more detailed data for this score.
*   **StartupPerformanceScore:** For example, we can add data related to device startup times.
*   **WorkFromAnywhereScore**
*   **MeanResourceSpikeTimeScore**
*   **BatteryHealthScore**
