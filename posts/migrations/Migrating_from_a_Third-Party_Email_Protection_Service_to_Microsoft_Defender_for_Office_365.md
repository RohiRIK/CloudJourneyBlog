**Introduction**

Are you currently using a third-party service to protect your email in Microsoft 365? If so, now might be the perfect time to consider transitioning to **Microsoft Defender for Office 365**.

Recently, I worked with a client who faced challenges managing their email security with a third-party app. With license renewals approaching, we decided to fully migrate to Microsoft Defender for Office 365. This move simplified their operations, reduced costs, and provided advanced, integrated protection. This blog outlines our journey and how you can follow a similar approach.

**The Problem: Complexity and Cost of Third-Party Systems**

Many organizations rely on third-party services for email security. While these services often perform well, they introduce challenges such as:

- **Complexity**: Managing two platforms (Microsoft 365 and a third-party system) adds operational overhead.
- **Cost**: Paying for both Microsoft 365 and an additional service can quickly escalate expenses.
- **Inconsistencies**: Differing protection methods and user experiences can cause inefficiencies and gaps.

This was precisely the situation my client faced with their third-party app. Their IT team was struggling to manage multiple systems, while costs for the service were becoming unsustainable.

As license renewal time approached, we were already in the middle of onboarding Microsoft Defender for Endpoint. Recognizing the efficiency of Microsoft’s tools, we decided to expand this integration by adopting **Defender for Office 365** for email protection.

**The Solution: Microsoft Defender for Office 365**

Microsoft Defender for Office 365 offers a consolidated, cost-effective, and highly secure alternative to third-party systems. By transitioning, organizations can:

- **Simplify Management**: Centralize email security within Microsoft 365.
- **Reduce Costs**: Eliminate third-party service fees by using Defender for Office 365 features included in many Microsoft 365 plans.
- **Enhance Security**: Benefit from Microsoft’s advanced threat protection, backed by a mature, integrated ecosystem.

This solution addressed all the issues my client faced, and we immediately began planning the migration.

**The Migration Process**

Migrating to Defender for Office 365 is a multi-step process that requires careful planning. We followed a **three-phase approach** recommended by Microsoft:

**Phase 1: Prepare**

The preparation phase is all about laying the groundwork for a smooth transition. Here’s what we did:

1. I**nventory Existing Settings**
    
    We documented the third-party app’s existing settings, such as rules, exceptions, and customizations. This was critical because access to these settings would no longer be possible after terminating the service.
    
2. **Analyze Microsoft 365 Configuration**
    
    We reviewed the client’s existing Microsoft 365 settings to identify unnecessary configurations and simplify their email environment.
    
3. **Check External Email Services**
    
    The client had two external services that sent emails on behalf of their domain. We verified these services’ SPF, DKIM, and DMARC configurations to ensure compatibility with Defender for Office 365.
    
4. **Simplify Mail Routing**
    
    Fortunately, the third-party app’s mail routing rules were minimal, so we didn’t need to make significant adjustments.
    
5. **Define User Experience Preferences**
    
    We worked with the client to decide how spam and bulk mail should be handled. For this project, we opted to quarantine spam and send bulk emails to the Junk Email folder.
    

By completing these steps, we ensured the client was fully prepared for the transition.

**Phase 2: Setup**

With the groundwork in place, we moved on to the next step—configuring Defender for Office 365.

1. **Create Pilot Groups**
    
    Before we started using ORCA, we first created pilot groups for testing features like Safe Attachments, Safe Links, and anti-spam policies. These groups were designed to test the impact of the migration on a smaller subset of users before rolling out changes across the entire organization.
    
2. **Maintain the SCL=-1 Rule**
    
    We maintained the **SCL=-1 rule** within the Exchange transport rules. This rule ensured that messages routed through the third-party app bypassed Microsoft’s spam filters, avoiding potential conflicts and ensuring smooth email flow during the transition. This was crucial in preventing any false positives or missed emails while we tested the new Defender settings.
    
3. **Run ORCA for Baseline Analysis**
    
    After setting up the pilot groups and maintaining the SCL=-1 rule, we used the **Office 365 Recommended Configuration Analyzer (ORCA)** PowerShell module to scan Defender policies and identify any gaps. ORCA provided actionable recommendations, ensuring we followed Microsoft’s best practices and helped us optimize Defender for Office 365.
    
4. **Configure Safe Attachments and Safe Links**
- **Safe Attachments**: We enabled dynamic delivery to ensure emails were delivered quickly while attachments were being scanned. We applied stricter settings for high-risk groups, such as executives, to increase protection.
- **Safe Links**: We enabled time-of-click URL verification to ensure all URLs in emails were checked for safety when clicked, extending protection to Teams and Office documents as well.
1. **Fine-Tune Anti-Spam Policies**
    
    We reviewed and migrated block/allow lists from the third-party app and fine-tuned anti-spam settings, including enabling **Bulk Complaint Level (BCL)** filters to handle marketing emails more effectively. This helped reduce the chances of legitimate emails being flagged as spam while still protecting the organization from unwanted messages.
    
2. **Enable User Reporting**
    
    To empower users, we enabled the **Report Message** and **Report Phishing** add-ins in Outlook, allowing them to flag suspicious emails for review.
    

By following these steps, we successfully tailored Defender for Office 365 to meet the client’s needs.

**Phase 3: Onboard**

The final phase involved onboarding all users and completing the migration to Defender for Office 365.

1. **Onboard Security Teams**
    
    We began by training the client’s security team on Defender for Office 365 tools, such as **Threat Explorer** and **Attack Simulator**. This training enabled them to proactively manage and respond to security threats more effectively, ensuring the security team was fully equipped to handle ongoing security operations.
    
2. **Refine Spoof and Impersonation Protections**
    
    Based on user feedback and recommendations from ORCA, we refined the settings for **spoof intelligence** and **impersonation protection**. This fine-tuning allowed us to balance security with user experience, minimizing false positives while maintaining a strong defense against email spoofing and impersonation attacks.
    
3. **Gradual Rollout**
    
    We gradually expanded the pilot group throughout the organization, making adjustments along the way based on user reports. This ensured that we addressed any issues promptly and refined the policies for better effectiveness before full-scale implementation.
    
4. **Finalize the Migration**
    - **Disable the SCL=-1 Mail Flow Rule**: We disabled the SCL=-1 rule, which had previously bypassed spam filtering for messages routed through the third-party app. This ensured that **all email filtering** was now fully handled by Defender for Office 365, maintaining a consistent security approach.
    - **Update MX Records**: The final step in the migration was updating the **MX records** to point directly to Microsoft 365. This completed the transition, ensuring all emails would now be filtered and protected by Microsoft Defender for Office 365.
5. **Create External Service Connectors**
    
    As part of the final migration steps, we also configured **external service connectors** to ensure proper email flow for external services that send emails on behalf of the client’s domain. This setup ensured seamless communication with trusted third-party services while maintaining the robust security protections provided by Defender for Office 365.
    

**Challenges and Lessons Learned**

While the migration was successful, it wasn’t without challenges:

- **Printer Configuration with the Third-Party App**: Printers that were initially configured to work with the third-party app had to be reconfigured to use **Direct Send** to allow emails to be sent within the organization. This required creating a connector in Microsoft 365 to ensure that the devices could send emails directly to Microsoft 365 mailboxes without relying on external SMTP servers. By setting up the connector, we were able to route emails securely from the printers to the organization’s internal mail system.
- **Customization Differences**: Some settings from the third-party app didn’t directly translate to Defender for Office 365, requiring creative solutions.
- **User Training**: Users needed guidance on handling quarantined emails and using the reporting tools.
- **False Positives**: Initial false positives were higher than expected but decreased significantly after fine-tuning the policies.

**Conclusion**

Migrating from a third-party email protection service to Microsoft Defender for Office 365 offers numerous benefits, including simplified management, reduced costs, and enhanced security. By following the three-phase approach outlined above and leveraging tools like ORCA, you can ensure a smooth transition for your organization.

For my client, this migration not only addressed their immediate challenges but also laid the foundation for a more secure and efficient email environment. Whether you’re facing similar issues or simply looking to streamline your operations, Defender for Office 365 is a powerful solution worth considering.

Ready to migrate or have questions about the process? Let’s discuss how Microsoft Defender for Office 365 can work for your organization.
