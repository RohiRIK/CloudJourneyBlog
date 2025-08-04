## Phase 3: SharePoint Integration & Reporting

**Goal of Phase 3:** To ensure seamless integration of collected device data into SharePoint, enabling accurate inventory management and comprehensive reporting on device health and analytics.

1.  **SharePoint Upsert Logic:**
    *   **Action:** Develop or modify the SharePoint integration function to perform an "upsert" (update or insert) operation. This means the function will intelligently either update an existing SharePoint list item or insert a new one.
    *   **Logic:** Implement robust logic to identify existing records. This will involve using a unique identifier (e.g., `AzureAdDeviceId` or `Id`) to query the SharePoint list. If a matching item is found, its properties will be updated; otherwise, a new list item will be created.
    *   **Action:** Precisely map all collected data points from the Graph API (including core device properties, all Endpoint Analytics scores, and conditional `RecentCrashEvents` details) to their corresponding columns in your SharePoint list. Ensure data types and formats are compatible.

2.  **Comprehensive Logging & Reporting:**
    *   **Action:** Significantly enhance the `Write-Log` function to provide granular, timestamped messages. These logs should cover every critical step, such as successful connections, individual device processing status, data fetching progress, and the outcome of each SharePoint operation (e.g., "Item added," "Item updated," "Error adding item").
    *   **Action:** Implement functionality to generate a detailed summary report upon script completion. This report should clearly present:
        *   The total number of devices processed during the run.
        *   A count of new devices successfully added to the SharePoint list.
        *   A count of existing devices successfully updated in the SharePoint list.
        *   A clear list of devices whose Endpoint Analytics scores (or other relevant metrics) fall below the predefined threshold, along with their specific low score and any associated fetched crash event details.
        *   A summary of any errors encountered throughout the entire process, including timestamps and relevant device IDs.
    *   **Recommendation:** Design the report output to be flexible, allowing for output to a dedicated log file, console, and/or automated email delivery for easy review by stakeholders.
