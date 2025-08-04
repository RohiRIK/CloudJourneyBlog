## Phase 2: Enhanced Graph API Data Collection & Logic

1.  **Efficient Device & Score Retrieval:**
    *   **Action:** Utilize the existing efficient methods from `export_devcie_score.ps1` to first retrieve all managed devices and then all Endpoint Analytics scores from Microsoft Graph.
    *   **Action:** Create a lookup mechanism (e.g., a hashtable) for quick association of device IDs with their respective analytics scores.
2.  **Conditional Detailed Data Fetching:**
    *   **Action:** Implement logic to iterate through each device.
    *   **Action:** If a device's `AppReliabilityScore` (or another relevant Endpoint Analytics score) falls below a predefined threshold (e.g., 80), trigger the `Get-RecentCrashEvents` function for that specific device.
    *   **Action:** Ensure robust error handling and logging for all Graph API calls, especially for individual device queries.

## To -Do
Your example is already working. Ibeul, this function. We need to research and come to this ot