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

### Data Point Descriptions for Enhanced Device Inventory

This section provides a detailed explanation of each data point collected for Endpoint Analytics scores, helping you understand their significance in assessing device health and performance.

*   **EndpointAnalyticsScore (Overall):**
    *   **Description:** This is a high-level, aggregated score (0-100) representing the overall user experience on a device. It's a weighted average of several sub-scores like Startup Performance, Application Reliability, and Work from Anywhere. A higher score indicates a better user experience.

*   **StartupPerformanceScore:**
    *   **Description:** A score (0-100) indicating how quickly a device gets from power-on to a productive state. It's crucial for user satisfaction as it directly impacts their ability to start working.
    *   **Associated Data Points (from `userExperienceAnalyticsDeviceStartupProcess` and `userExperienceAnalyticsDeviceStartupProcessPerformance`):**
        *   **`processName`:** The name of the executable or process that runs during device startup.
        *   **`productName`:** The name of the product associated with the startup process.
        *   **`publisher`:** The entity that published the startup process (e.g., Microsoft, Adobe).
        *   **`impactInMs`:** The specific impact (in milliseconds) that a particular startup process has on the device's boot time. Higher values indicate a greater negative impact.
        *   **`medianImpactInMs`:** The median impact of a startup process, providing a more stable measure of its typical effect on boot times across multiple devices.
        *   **`totalImpactInMs`:** The cumulative impact of a startup process on boot time.
        *   **`deviceCount`:** The number of devices on which this specific startup process was observed.

*   **AppReliabilityScore:**
    *   **Description:** A score (0-100) reflecting the stability of applications on a device. A lower score often indicates frequent application crashes, impacting user productivity.
    *   **Associated Data Points (from `Get-RecentCrashEvents` function, which uses `userExperienceAnalyticsAppHealthDevicePerformanceDetails`):**
        *   **`AppDisplayName`:** The user-friendly name of the application that crashed.
        *   **`AppVersion`:** The version of the application that experienced the crash.
        *   **`EventDateTime`:** The timestamp when the crash event occurred.

*   **WorkFromAnywhereScore:**
    *   **Description:** A score (0-100) assessing a device's readiness and performance for remote work scenarios. It considers factors like cloud management, identity, and network connectivity.
    *   **Associated Data Points (from `userExperienceAnalyticsWorkFromAnywhereDevices`):**
        *   **`ownership`:** Indicates whether the device is corporate or personal.
        *   **`managedBy`:** The management agent (e.g., Intune).
        *   **Boolean flags (e.g., `isCloudManaged`, `isHybridAzureAdJoined`, `isCoManaged`):** These flags provide insights into the device's management state and connectivity to cloud services.

*   **MeanResourceSpikeTimeScore:**
    *   **Description:** A score (0-100) related to a device's resource performance, specifically how efficiently CPU and RAM are utilized. A higher score indicates fewer or less impactful resource spikes (CPU/RAM usage over 50%).
    *   **Associated Data Points (from `userExperienceAnalyticsMetricHistory` for historical trends):**
        *   While not a direct individual device property, this score is derived from historical data on CPU and RAM usage. Detailed analysis would involve looking at trends of resource utilization over time to identify patterns of spikes.

*   **BatteryHealthScore:**
    *   **Description:** A score (0-100) indicating the overall health and performance of a device's battery. A lower score suggests potential battery degradation or issues.
    *   **Associated Data Points (from `userExperienceAnalyticsBatteryHealthDevicePerformance`):**
        *   **`maxCapacity`:** The maximum charge capacity of the battery.
        *   **`cycleCount`:** The number of charge cycles the battery has undergone.
        *   **`tags`:** Descriptive tags indicating battery behavior or status (e.g., "newbattery", "batterycapacityred").
        *   **`overallBatteryHealthStatus`:** A categorical status of the battery's health (e.g., `unknown`, `insufficientData`, `needsAttention`, `meetingGoals`).
