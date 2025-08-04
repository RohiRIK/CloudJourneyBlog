## Phase 1: Setup & Core Script Consolidation

1.  **Secure Credential Management:**
    *   **Action:** Remove hardcoded Client ID, Tenant ID, and Client Secret from the PowerShell scripts.
    *   **Recommendation:** For Jenkins scheduled tasks, use Jenkins' credential management or environment variables to securely pass these values to the script at runtime. Avoid storing them directly in the script or version control.
2.  **Script Consolidation & Modularization:**
    *   **Action:** Merge `Import-SharePointJson.ps1` and `export_devcie_score.ps1` into a single, well-structured PowerShell script (e.g., `Update-DeviceInventory.ps1`).
    *   **Action:** Encapsulate distinct functionalities (e.g., Graph API authentication, SharePoint authentication, device data retrieval, score retrieval, crash event retrieval, SharePoint item upsert) into separate, reusable PowerShell functions.
