# Azure Logic App for Security Info Change Monitoring

This repository contains an Azure Logic App definition designed to monitor changes in user security information within an Azure Active Directory (Azure AD) tenant. It queries Azure Audit Logs for specific user management activities related to security info registration, changes, and deletions. Upon detecting such events, it can trigger notifications, including summarized emails to administrators and personalized alerts to affected users.

## Features

- **Automated Monitoring**: Regularly queries Azure Audit Logs for security information changes.
- **Detailed Event Capture**: Captures `TimeGenerated`, `OperationName`, `Result`, `ResultDescription`, `TargetUser`, `InitiatedByUser`, `InitiatorIpAddress`, and `CorrelationId`.
- **Customizable Queries**: The Kusto Query Language (KQL) query can be modified to suit specific monitoring needs.
- **Email Notifications**: Sends summary emails to a designated administrator and personalized alerts to individual users whose security info has changed.
- **Error Handling**: Includes basic error tracking and notification for query failures.

## Prerequisites

Before deploying and using this Logic App, ensure you have the following:

- An Azure subscription.
- Permissions to create and manage Azure Logic Apps, Azure Monitor Log Analytics Workspaces, and Azure AD applications.
- An Azure Monitor Log Analytics Workspace with Audit Logs enabled.
- An Office 365 API connection for sending emails.

## Setup Instructions

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/your-username/your-repository-name.git
    cd your-repository-name
    ```

2.  **Update the Logic App Definition**

    The provided `cleaned_logic_app.json` file is a template. You need to replace the placeholders with your actual Azure resource details.

    -   `YOUR_SUBSCRIPTION_ID`: Replace with your Azure subscription ID.
    -   `YOUR_RESOURCE_GROUP`: Replace with the name of your resource group where the Log Analytics Workspace is located.
    -   `YOUR_LOG_ANALYTICS_WORKSPACE_NAME`: Replace with the name of your Azure Monitor Log Analytics Workspace.
    -   `recipient@oncld.io`: Replace with the email address for personalized alerts.
    -   `summary_recipient@oncld.io`: Replace with the email address for summary alerts.
    -   `admin@oncld.io`: Replace with the email address for error notifications.
    -   `support@oncld.io`: Replace with your IT support email address in the personalized email body.

    You can find these values in your Azure portal.

3.  **Deploy the Logic App**

    You can deploy the Logic App using an Azure Resource Manager (ARM) template, Azure CLI, Azure PowerShell, or directly through the Azure portal.

    **Using Azure Portal:**

    a.  Go to the Azure portal.
    b.  Search for "Logic Apps" and click "Add".
    c.  Fill in the required details (Subscription, Resource Group, Logic App name, Region).
    d.  After creation, navigate to your Logic App.
    e.  Go to "Logic app designer" and click "Code view".
    f.  Replace the existing JSON content with the content from your updated `cleaned_logic_app.json` file.
    g.  Save the Logic App.

    **Using Azure CLI (Example):**

    ```bash
    az group create --name <your-resource-group> --location <your-location>
    az logicapp create --resource-group <your-resource-group> --name <your-logic-app-name> --location <your-location>
    az logicapp deployment create --resource-group <your-resource-group> --name <your-logic-app-name> --definition cleaned_logic_app.json
    ```

4.  **Configure API Connections**

    After deployment, you will need to authorize the API connections for Azure Monitor Logs and Office 365.

    a.  In the Azure portal, navigate to your deployed Logic App.
    b.  Under "Development Tools", click on "API connections".
    c.  You will see connections for `azuremonitorlogs` and `office365`. Click on each one and authorize them using your Azure AD credentials.

## How it Works

The Logic App is triggered every 15 minutes (configurable) and performs the following steps:

1.  **Initialize Variables**: Sets up variables for error tracking (`hasErrors`, `errorMessages`), content processing (`content`), email bodies (`summarizeEmailBody`, `personalEmailBody`), email addresses (`emailAddress`), and processed users (`processedUsers`).
2.  **Run Kusto Query**: Executes a KQL query against your Azure Monitor Log Analytics Workspace to retrieve audit logs related to user security information changes within the last 60 minutes.
3.  **Process Results**: If the query returns results, it iterates through each audit record:
    -   Appends a formatted row to the `summarizeEmailBody` for the summary email.
    -   Checks if the `TargetUser` has already been processed to avoid sending duplicate personalized emails.
    -   If not processed, it constructs a personalized HTML email body (`personalEmailBody`) for the `TargetUser`.
    -   Sends a personalized email to the `TargetUser` (or a placeholder recipient).
    -   Adds the `TargetUser` to the `processedUsers` array.
4.  **Send Summary Email**: If any matching activity is found, a summary email containing a table of all detected activities is sent to `summary_recipient@oncld.io`.
5.  **Error Notification**: If the Kusto query fails, an error flag is set, and an error message is appended. An error notification email is sent to `admin@oncld.io`.

## Kusto Query Details

The Kusto query targets `AuditLogs` and filters for `UserManagement` category operations related to security info. It projects relevant fields such as `TimeGenerated`, `OperationName`, `Result`, `ResultDescription`, `TargetUser`, `InitiatedByUser`, `InitiatorIpAddress`, `CorrelationId`, and `Category`.

```kusto
AuditLogs
| where TimeGenerated > ago(60m)
| where Category == "UserManagement"
| where OperationName in (
    "User registered all required security info",
    "User registered security info",
    "User changed default security info",
    "User started security info registration",
    "User completed security info registration",
    "User deleted security info",
    "User updated security info"
)
| extend TargetUser = tostring(TargetResources[0].userPrincipalName)
| extend TargetUserDisplayName = tostring(TargetResources[0].displayName)
| extend InitiatedByUser = tostring(InitiatedBy.user.userPrincipalName)
| extend InitiatorIpAddress = tostring(InitiatedBy.user.ipAddress)
| extend InitiatorDisplayName = tostring(InitiatedBy.user.displayName)
| project
    TimeGenerated,
    OperationName,
    Result,
    ResultDescription,
    TargetUser,
    TargetUserDisplayName,
    InitiatedByUser,
    InitiatorDisplayName,
    InitiatorIpAddress,
    CorrelationId,
    Category
| sort by TimeGenerated desc
```

## Contributing

Feel free to fork this repository, submit pull requests, or open issues for any improvements or bug fixes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.


