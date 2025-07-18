# # Prompt for Gemini CLI

## **Objective:**
Generate a comprehensive project plan and architectural design for a containerized application that automates the synchronization of an organization's Global Address List (GAL) to individual users' Exchange Online contacts. This will ensure that all GAL contacts are visible and accessible on their mobile devices.

The automation will be managed via a front-end web interface and a back-end service, both running in containers. The back-end service will interact with the Microsoft Graph API using secure, certificate-based authentication.

## **Core Requirements:**

### **1. Authentication & Security:**
* The back-end service must authenticate to the Microsoft Graph API using **OAuth 2.0 client credentials flow with a certificate**.
* The application registration in Azure AD will require the following **Graph API permissions** (at the application level):
  * `Contacts.ReadWrite`
  * `User.Read.All`
* All sensitive data, including the certificate's private key and tenant ID, must be stored securely using Docker Secrets

### **2. Back-End Service (The Synchronization Engine):**
This service will be the core of the automation. It should be designed as a stateless application, likely running on a schedule (e.g., a CRON job within a container).

**Key Logic and Checks to Implement:**

* **Initial Fetch:**
  * Fetch all relevant users from the GAL using the `/users` endpoint. Filter for active users with mailboxes.
  * For performance, use the `$select` OData query parameter to retrieve only necessary fields (e.g., `id`, `displayName`, `givenName`, `surname`, `userPrincipalName`, `businessPhones`, `mobilePhone`, `jobTitle`, `department`).

* **Contact Synchronization Logic (Per-User):**
  For each user in the organization, the script must perform the following actions against their personal contacts folder (`/users/{id | userPrincipalName}/contacts`):

  * **Existing Contact Identification:**
    * Before creating a new contact, you must check if a contact representing that GAL user already exists.
    * **Best Practice:** When you create a contact for the first time, store the GAL user's immutable `id` (from Azure AD) in a custom property or in the `source` property of the contact object. This `id` will be the unique key for future lookups, updates, and deletions.

  * **Handling New Contacts:**
    * If a GAL user does not exist as a contact, create a new contact in the user's personal contacts folder.
    * Map the GAL attributes to the contact fields correctly.

  * **Handling Existing Contacts (Updates):**
    * If a contact already exists (identified by the stored unique ID), compare all relevant fields (`displayName`, `businessPhones`, etc.) with the current data from the GAL.
    * If there are any discrepancies, update the existing contact object.

  * **Handling Name Variations:**
    * The logic must be robust to handle variations in names. The `displayName` should be the primary source of truth for the contact's name. Check for changes between the GAL `displayName` and the contact's `displayName`.

  * **Handling Phone Number Changes:**
    * Compare the `businessPhones` and `mobilePhone` arrays/fields from the GAL with what's stored in the contact. Update if they differ.

  * **Handling Deleted Users:**
    * The script needs a mechanism to detect users that were in the GAL but have now been removed (or disabled). One approach is to fetch all contacts created by the automation (identifiable by the custom property) and cross-reference them with the current GAL list. Any contact that no longer has a corresponding active user in the GAL should be deleted.

* **Efficiency and Throttling:**
  * Implement **Microsoft Graph Delta Queries** (`/users/delta`) to fetch only the changes (new, updated, or deleted users) since the last sync. This is crucial for performance and to avoid API throttling.
  * Implement proper error handling and retry logic, especially for API calls that might be throttled (HTTP 429 errors).

### **3. Front-End Interface (Management Dashboard):**
Create a simple web interface (e.g., using React, Vue, or Angular) that provides the following functionalities:

* **Dashboard:** A view showing the status of the last sync (e.g., "Completed," "In Progress," "Failed"), timestamp, and a summary (e.g., X contacts created, Y updated).
* **Logs Viewer:** A page to display detailed logs from the back-end service for troubleshooting.
* **Configuration:** A secure page to manage settings like the sync schedule.
* **Manual Trigger:** A button to manually trigger a full GAL sync.

### **4. Containerization:**
* Provide a `docker-compose.yml` file to orchestrate the front-end and back-end services.
* Create a `Dockerfile` for the back-end service (e.g., based on Python, Node.js, or .NET).
* Create a `Dockerfile` for the front-end service (e.g., a multi-stage build for a React/Vue app with a web server like Nginx).

## **Output Format:**
Please generate a detailed assumption file in Markdown format. The file should include:
1. **High-Level Architecture Diagram.**
2. **Azure AD App Registration requirements (Permissions & Certificate setup).**
3. **Detailed pseudo-code or logical flow for the back-end synchronization script.**
4. **API Endpoint specifications (which endpoints to use and why).**
5. **A proposed technology stack (e.g., Python with `requests` for back-end, React for front-end, Docker for containerization).**
6. **A sample `docker-compose.yml` structure.**
