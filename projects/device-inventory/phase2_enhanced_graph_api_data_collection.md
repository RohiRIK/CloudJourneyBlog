## Phase 2: Enhanced Graph API Data Collection & Logic

1.  **Efficient Device & Score Retrieval:**
    *   **Action:** Utilize the existing efficient methods from `export_devcie_score.ps1` to first retrieve all managed devices and then all Endpoint Analytics scores from Microsoft Graph.
    *   **Action:** Create a lookup mechanism (e.g., a hashtable) for quick association of device IDs with their respective analytics scores.
2.  **Conditional Detailed Data Fetching:**
    *   **Action:** Implement logic to iterate through each device.
    *   **Action:** If a device's `AppReliabilityScore` (or another relevant Endpoint Analytics score) falls below a predefined threshold (e.g., 80), trigger the `Get-RecentCrashEvents` function for that specific device.
    *   **Action:** Ensure robust error handling and logging for all Graph API calls, especially for individual device queries.

## To-Do: Further Enhancements

The existing function for retrieving device scores is working. Now, we need to research and integrate additional data points from the Graph API for other Endpoint Analytics scores. This involves identifying the correct Graph API endpoints and properties for each, and implementing this in the update script.

Specifically, we need to enhance data collection for:

*   **EndpointAnalyticsScore:** This is an overall score. Detailed data for its contributing factors will be gathered from the specific endpoints below.
*   **StartupPerformanceScore:**
    *   **Research Findings:** Detailed data can be found in `userExperienceAnalyticsDeviceStartupProcess` and `userExperienceAnalyticsDeviceStartupProcessPerformance` entities.
    *   **Data Points:** Look for `processName`, `productName`, `publisher`, `impactInMs`, `medianImpactInMs`, `totalImpactInMs`, and `deviceCount` related to startup processes.
*   **WorkFromAnywhereScore:**
    *   **Research Findings:** Detailed data is available through the `userExperienceAnalyticsWorkFromAnywhereDevices` entity.
    *   **Data Points:** Includes `id`, `deviceId`, `deviceName`, `serialNumber`, `manufacturer`, `model`, `ownership`, `managedBy`, and boolean flags for hardware checks, Autopilot, and Azure AD registration status.
*   **MeanResourceSpikeTimeScore:**
    *   **Research Findings:** This metric is part of **Resource Performance** within Endpoint Analytics and is primarily found in `userExperienceAnalyticsMetricHistory`.
    *   **Data Points:** Focus on historical trends of CPU and RAM usage spikes (over 50% usage) to understand the underlying factors.
*   **BatteryHealthScore:**
    *   **Research Findings:** Detailed battery health information is available via the `userExperienceAnalyticsBatteryHealthDevicePerformance` entity.
    *   **Data Points:** Includes `maxCapacity`, `cycleCount`, `tags` (e.g., "newbattery", "batterycapacityred"), and `overallBatteryHealthStatus`.
