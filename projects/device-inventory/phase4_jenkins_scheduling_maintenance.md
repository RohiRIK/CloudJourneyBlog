## Phase 4: Jenkins Scheduling & Maintenance

1.  **Jenkins Job Configuration:**
    *   **Action:** Create a new Jenkins job configured to run the PowerShell script on a schedule (e.g., daily, weekly).
    *   **Action:** Configure Jenkins to pass the secure credentials (Client ID, Tenant ID, Client Secret) as environment variables to the PowerShell script.
2.  **Monitoring & Notifications:**
    *   **Action:** Set up Jenkins job notifications (e.g., email) for job success, failure, or unstable builds.
    *   **Recommendation:** Integrate the script's summary report into Jenkins' build output or email notifications.
