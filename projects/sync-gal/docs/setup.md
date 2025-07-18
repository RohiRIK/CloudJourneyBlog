# Setup Instructions

## Azure AD App Registration

To use this application, you need to register an application in Azure Active Directory.

### 1. Create an Application Registration

1.  Go to the Azure portal and navigate to **Azure Active Directory** > **App registrations**.
2.  Click **New registration**.
3.  Give your application a name (e.g., `GAL-Sync-Service`).
4.  For **Supported account types**, select **Accounts in this organizational directory only**.
5.  Click **Register**.

### 2. Configure API Permissions

1.  Go to your app registration and navigate to **API permissions**.
2.  Click **Add a permission** and select **Microsoft Graph**.
3.  Select **Application permissions**.
4.  Add the following permissions:
    *   `Contacts.ReadWrite`
    *   `User.Read.All`
5.  Click **Grant admin consent for [Your Tenant]**.

### 3. Create a Certificate

1.  You need to create a self-signed certificate to use for authentication. You can use the following PowerShell command to generate one:

    ```powershell
    $cert = New-SelfSignedCertificate -Subject "CN=GALSyncCert" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature
    ```

2.  Export the certificate as a `.cer` file (without the private key) and a `.pfx` file (with the private key, protected by a password).

3.  In your Azure AD app registration, go to **Certificates & secrets** and upload the `.cer` file.

### 4. Configure Docker Secrets

1.  The backend service uses Docker Secrets to securely store the certificate and tenant ID.
2.  You will need to create a `secrets` directory in the root of the project.
3.  Place your certificate's private key in a file named `certificate.pem` inside the `secrets` directory.
4.  Create a file named `tenant_id.txt` in the `secrets` directory and paste your Azure AD tenant ID into it.
