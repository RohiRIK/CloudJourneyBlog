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
    *   **Description:** A score (0-100) indicating how quickly a device gets from power-on to a productive state. It's crucial for user satisfaction as it directly impacts their ability to start working. we nned to get the last event based on the id.
    *   **Research Findings:** Detailed data can be found in `userExperienceAnalyticsDeviceStartupHistory` entity.
    *   **Data Points:** Look for:
        *   `startTime`: The timestamp when the startup event began.
        *   `coreBootTimeInMs`: Time from power-on to sign-in screen (in milliseconds).
        *   `totalBootTimeInMs`: Total boot time (in milliseconds).
        *   `coreLoginTimeInMs`: Time from credentials entered to responsive desktop (in milliseconds).
        *   `responsiveDesktopTimeInMs`: Time until the desktop is fully responsive (in milliseconds).
        *   `totalLoginTimeInMs`: Total login time (in milliseconds).
        *   `restartCategory`: Category of the restart (e.g., `restartWithoutUpdate`).
 

*   **AppReliabilityScore:** - Done
    *   **Description:** A score (0-100) reflecting the stability of applications on a device. A lower score often indicates frequent application crashes, impacting user productivity.
    *   **Associated Data Points (from `Get-RecentCrashEvents` function, which uses `userExperienceAnalyticsAppHealthDevicePerformanceDetails`):**
        *   **`AppDisplayName`:** The user-friendly name of the application that crashed.
        *   **`AppVersion`:** The version of the application that experienced the crash.
        *   **`EventDateTime`:** The timestamp when the crash event occurred.

*   **WorkFromAnywhereScore:**
    *   **Description:** A score (0-100) assessing a device's readiness and performance for remote work scenarios. It considers factors like cloud management, identity, and network connectivity.
    *   **Research Findings:** Detailed data is available through the `userExperienceAnalyticsWorkFromAnywhereModelPerformance` entity.
    *   **Data Points:** Look for:
        *   `id`: Unique identifier for the object.
        *   `model`: The name of the device model.
        *   `manufacturer`: The manufacturer's name for the device.
        *   `modelDeviceCount`: The number of devices associated with that specific model.
        *   `workFromAnywhereScore`: A score (0-100) indicating the overall work from anywhere performance of the device model.
        *   `windowsScore`: The Windows score of the device model (0-100).
        *   `healthStatus`: The health state of the device model (`unknown`, `insufficientData`, `needsAttention`, or `meetingGoals`).

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
