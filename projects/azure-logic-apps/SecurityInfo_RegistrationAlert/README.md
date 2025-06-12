# Security Info Registration Alert Logic App

## Overview
This Logic App monitors and alerts on security information registration activities in Microsoft Entra ID (formerly Azure AD). It sends email notifications for various security-related events, helping administrators track and respond to potential security incidents.

## Key Features
- Monitors security info registration activities in near real-time (15-minute intervals)
- Sends detailed email alerts to security teams
- Notifies end-users about security changes to their accounts
- Tracks both successful and failed security info changes
- Provides comprehensive logging and error handling

## Monitored Activities
The Logic App tracks the following security events:
- User registered all required security info
- User registered security info
- User changed default security info
- User started security info registration
- User completed security info registration
- User deleted security info
- User updated security info

## Components

### 1. Recurring Trigger
- Runs every 15 minutes
- Timezone: Israel Standard Time

### 2. Log Analytics Query
Queries Azure Monitor Logs for security events from the past 60 minutes:
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
```

### 3. Email Notifications

#### A. Admin/Summary Email
Sent to security teams with details of all security info changes including:
- Target user information
- Initiator details
- Timestamp (converted to Israel Standard Time)
- Activity type
- IP address
- Result (success/failure)
- Correlation ID for investigation

#### B. User Notification Email
Sent to end-users when their security info is modified, including:
- Details of the change
- Timestamp
- Action items if the activity wasn't authorized
- Contact information for IT support

## Implementation Requirements

### Prerequisites
1. Azure subscription with appropriate permissions
2. Log Analytics workspace with Azure AD audit logs
3. Microsoft Graph API access
4. Office 365 or Exchange Online for email notifications

### Deployment Steps

1. **Create a new Logic App**
   - Use the provided JSON template
   - Set up the required connections:
     - Azure Monitor Logs
     - Office 365 Outlook (for email notifications)

2. **Configure Log Analytics**
   - Ensure Azure AD audit logs are being sent to your Log Analytics workspace
   - Verify the query has access to the required data

3. **Customize Email Templates**
   - Update the email templates in the Logic App to match your organization's branding
   - Modify the contact information and support details

4. **Set Up Authentication**
   - Configure managed identity for the Logic App
   - Assign appropriate Azure RBAC roles

5. **Test the Solution**
   - Perform test security info changes
   - Verify email notifications are received
   - Check for any errors in the Logic App run history

## Error Handling
The Logic App includes comprehensive error handling:
- Tracks and reports errors during execution
- Provides detailed error messages for troubleshooting
- Continues processing even if individual records fail

## Security Considerations
- Uses managed identities for authentication
- Processes sensitive data securely
- Follows principle of least privilege for API permissions
- Logs all activities for audit purposes

## Maintenance
- Monitor the Logic App's performance and error rates
- Regularly review and update the query as needed
- Update email templates to reflect any organizational changes

## Support
For assistance with this Logic App, please contact your IT security team or open a support ticket.

---
*Last Updated: June 2025*
