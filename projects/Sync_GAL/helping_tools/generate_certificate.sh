#!/bin/bash

# This script generates a self-signed certificate for use with the GAL Sync application.

# Create the secrets directory if it doesn't exist
mkdir -p secrets

# Generate a private key and a self-signed certificate
openssl req -x509 -newkey rsa:2048 -keyout secrets/certificate.pem -out secrets/certificate.crt -days 365 -nodes -subj "/CN=GALSyncCert" -addext "keyUsage = digitalSignature" -addext "extendedKeyUsage = serverAuth, clientAuth"

# Calculate the certificate thumbprint
THUMBPRINT=$(openssl x509 -in secrets/certificate.crt -noout -fingerprint -sha1 | sed 's/://g' | cut -d'=' -f2)

# Output instructions
echo "Certificate and private key generated successfully."
echo ""
echo "Please upload the 'secrets/certificate.crt' file to your Azure AD App Registration."
echo ""
echo "Your certificate thumbprint is: $THUMBPRINT"
echo "Please use this value for the CERTIFICATE_THUMBPRINT environment variable in the docker-compose.yml file."
echo ""
echo "The private key is located at 'secrets/certificate.pem'."