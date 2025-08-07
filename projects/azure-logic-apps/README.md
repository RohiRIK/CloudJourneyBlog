# Azure Logic Apps

This directory contains Azure Logic App templates for automating various security and compliance tasks within Microsoft Entra ID (formerly Azure AD). Each solution is designed to enhance security posture, improve operational efficiency, and ensure compliance with organizational policies.

## 📋 Solution Overview

Each subdirectory represents a complete Azure Logic App automation solution, containing its definition, configuration, documentation, and deployment resources.

### Available Solutions

- **[Security Info Registration Alert](./security-info-registration-alert/)**: Monitors and alerts on security information registration changes in Microsoft Entra ID.
- **[Break Glass Automation](./break-glass-automation/)**: Automates the management of emergency access accounts within Conditional Access policies.

## 🚀 Quick Start

Each solution includes:
- **Complete Logic App definition** (`logic_app.json`)
- **Configuration templates** (`config/`)
- **Comprehensive documentation** (`docs/`)
- **Email templates** (`templates/`)
- **Utility scripts** (`util/`)

## 🔧 Common Prerequisites

All Logic Apps in this collection require:

### Azure Environment
- Azure subscription with Logic Apps enabled
- Microsoft Entra ID Premium licensing (for advanced features)
- Appropriate Azure RBAC permissions

### Security Requirements
- Managed identity configuration for Logic Apps
- Microsoft Graph API permissions
- Secure credential management

### Operational Requirements
- Log Analytics workspace (for monitoring solutions)
- Email service integration (Office 365 or Exchange Online)
- Change management processes

## 📖 Implementation Guide

### 1. Choose Your Solution
Select the Logic App that meets your organizational needs:
- **Security Monitoring**: Use Security Info Registration Alert
- **Emergency Access**: Use Break Glass Automation

### 2. Review Prerequisites
Each solution has specific requirements documented in its respective README.

### 3. Deploy and Configure
Follow the step-by-step deployment guides in each solution's documentation.

### 4. Monitor and Maintain
Implement ongoing monitoring and maintenance procedures.

## 🛡️ Security Best Practices

### Authentication
- Use managed identities wherever possible
- Implement least privilege access principles
- Regularly review and rotate credentials

### Monitoring
- Enable comprehensive logging for all Logic Apps
- Set up alerts for execution failures
- Monitor for unusual access patterns

### Change Management
- Test all changes in non-production environments
- Document all modifications
- Implement approval workflows for critical changes

## 📊 Monitoring and Alerting

### Key Metrics to Monitor
- Logic App execution success rates
- API call latency and throttling
- Error rates and failure patterns
- Resource consumption and costs

### Recommended Alerts
- Logic App execution failures
- Authentication errors
- API quota exhaustion
- Unexpected high volume of executions

## 🔍 Troubleshooting

### Common Issues
1. **Authentication Failures**: Check managed identity permissions
2. **API Throttling**: Review call patterns and implement retry logic
3. **Email Delivery Issues**: Verify email service configuration
4. **Log Analytics Queries**: Validate workspace access and query syntax

### Diagnostic Resources
- Logic App run history provides detailed execution information
- Azure Monitor logs contain comprehensive diagnostic data
- Microsoft Graph API documentation for permission requirements

## 📚 Related Documentation

### Microsoft Documentation
- [Azure Logic Apps Documentation](https://docs.microsoft.com/en-us/azure/logic-apps/)
- [Microsoft Graph API Reference](https://docs.microsoft.com/en-us/graph/)
- [Microsoft Entra ID Documentation](https://docs.microsoft.com/en-us/azure/active-directory/)

### Security Resources
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)
- [Conditional Access Documentation](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/)
- [Emergency Access Account Guidelines](https://docs.microsoft.com/en-us/azure/active-directory/roles/security-emergency-access)

## 🤝 Contributing

When contributing new Logic App solutions:

1. **Follow the established structure**: Include all required directories and files
2. **Provide comprehensive documentation**: Ensure clear implementation guides
3. **Include configuration examples**: Use `oncld.io` domain for examples
4. **Test thoroughly**: Validate in multiple environments before submission
5. **Security review**: Ensure all security best practices are followed

### Solution Structure Template
```
solution-name/
├── README.md              # Solution-specific documentation
├── logic_app.json         # Logic App definition
├── config/               # Configuration templates
├── docs/                 # Detailed documentation
├── templates/            # Email and notification templates
└── util/                 # Helper scripts and utilities
```

## 📝 Support and Maintenance

### Regular Maintenance Tasks
- **Monthly**: Review execution logs and performance metrics
- **Quarterly**: Update documentation and test emergency procedures
- **Annually**: Review security configurations and update permissions

### Getting Help
For assistance with these Logic App solutions:
1. Review the solution-specific documentation in each subdirectory
2. Check the troubleshooting sections for common issues
3. Consult Microsoft documentation for Azure Logic Apps and Graph API
4. Contact your IT security team for organization-specific guidance

---

## Related Blog Posts

For detailed implementation guides and real-world scenarios, refer to these blog posts:

- **[Keeping an Eye on Azure AD: Automating Security Info Change Alerts with Logic Apps](../../content/blogs/azure/keeping-an-eye-on-azure-ad-automating-security-info-change-alerts-with-logic-apps.md)**
- **[Fortifying Your Azure AD Defenses: Automating Emergency Account Conditional Access Exclusions](../../content/blogs/azure/fortifying-your-azure-ad-defenses-automating-emergency-account-conditional-access-exclusions.md)**

*Last Updated: August 2025*