## Phase 3: SharePoint Integration & Reporting

1.  **SharePoint Upsert Logic:**
    *   **Action:** Modify the SharePoint import function to perform an "upsert" (update or insert) operation.
    *   **Logic:** Use a unique identifier (e.g., `AzureAdDeviceId` or `Id`) to check if a device already exists in the SharePoint list. If it exists, update its properties; otherwise, create a new list item.
    *   **Action:** Map all collected data points from the Graph API (core device properties, all Endpoint Analytics scores, and conditional `RecentCrashEvents` details) to appropriate columns in your SharePoint list.
2.  **Comprehensive Logging & Reporting:**
    *   **Action:** Enhance the `Write-Log` function to provide detailed, timestamped messages for each step (connection status, device processing, data fetching, SharePoint operations).
    *   **Action:** Generate a summary report at the end of the script execution. This report should include:
        *   Total devices processed.
        *   Number of new devices added to SharePoint.
        *   Number of existing devices updated in SharePoint.
        *   A list of devices with scores below the threshold, including their low score and any fetched crash event details.
        *   Any errors encountered during the process.
    *   **Recommendation:** Consider outputting this report to a log file and/or sending it via email for easy review.
