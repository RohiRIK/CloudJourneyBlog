## Phase 4: Jenkins Scheduling & Maintenance

**Goal of Phase 4:** To establish a robust and automated execution schedule for the device inventory solution within Jenkins, ensuring secure credential handling, effective monitoring, and timely notifications for operational efficiency.

1.  **Jenkins Job Configuration:**
    *   **Action:** Create a dedicated Jenkins job for the `Update-DeviceInventory.ps1` PowerShell script.
    *   **Configuration:**
        *   **Build Trigger:** Configure a build trigger for scheduled execution (e.g., daily, weekly, or at specific times) using cron syntax.
        *   **Build Environment:** Ensure the Jenkins agent has PowerShell installed and the necessary modules (e.g., PnP.PowerShell, Microsoft.Graph.Beta) are available or installed as part of the job's setup.
        *   **Secure Credential Handling:** Configure Jenkins to securely pass the Client ID, Tenant ID, and Client Secret to the PowerShell script. This should be done using Jenkins' built-in credential management (e.g., "Secret text" or "Secret file" credentials) and injecting them as environment variables or script parameters, rather than hardcoding them in the job configuration.
        *   **Script Execution:** Define the build step to execute the PowerShell script, ensuring the correct path and any required parameters are passed.

2.  **Monitoring & Notifications:**
    *   **Action:** Implement comprehensive monitoring and notification mechanisms within the Jenkins job.
    *   **Notifications:**
        *   Configure email notifications for job status changes (success, failure, unstable builds). Specify recipients for different notification types.
        *   Consider integrating with other communication platforms (e.g., Slack, Microsoft Teams) if applicable, using Jenkins plugins.
    *   **Reporting Integration:**
        *   **Recommendation:** Integrate the script's generated summary report (from Phase 3) directly into the Jenkins build output. This allows for quick review of the processing results within the Jenkins UI.
        *   **Recommendation:** If email notifications are used, attach or embed the summary report in the notification emails for immediate access to key metrics and error details.
    *   **Log Retention:** Configure Jenkins' build history and log retention policies to manage disk space and ensure historical data is available for troubleshooting.
