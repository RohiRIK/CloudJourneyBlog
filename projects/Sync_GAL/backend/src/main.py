# main.py - Backend Synchronization Service

import os
import json
import requests
import logging
from msal import ConfidentialClientApplication
from fastapi import FastAPI, BackgroundTasks
from fastapi.responses import FileResponse
import uvicorn

# --- Logging Configuration ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("sync.log"),
        logging.StreamHandler()
    ]
)

# --- FastAPI App ---
app = FastAPI()

# --- Configuration ---
TENANT_ID = os.environ.get("TENANT_ID")
CLIENT_ID = os.environ.get("CLIENT_ID")
CERTIFICATE_PATH = os.environ.get("CERTIFICATE_PATH")
GRAPH_API_ENDPOINT = "https://graph.microsoft.com/v1.0"
GAL_SYNC_PROPERTY_NAME = "GALSyncId"
GAL_SYNC_NAMESPACE_GUID = "817EF0C2-33F5-4861-A295-F1B3F05201D8"

# --- Authentication ---
def get_access_token():
    """Authenticates with Azure AD and returns an access token."""
    logging.info("Acquiring access token...")
    CLIENT_ID = os.environ.get("CLIENT_ID")
    with open("/run/secrets/tenant_id", "r") as f:
        TENANT_ID = f.read().strip()
    with open("/run/secrets/certificate_thumbprint", "r") as f:
        CERTIFICATE_THUMBPRINT = f.read().strip()

    app_msal = ConfidentialClientApplication(
        client_id=CLIENT_ID,
        authority=f"https://login.microsoftonline.com/{TENANT_ID}",
        client_credential={
            "private_key": open("/run/secrets/certificate").read(),
            "thumbprint": CERTIFICATE_THUMBPRINT,
        },
    )
    result = app_msal.acquire_token_for_client(scopes=["https://graph.microsoft.com/.default"])
    if "access_token" in result:
        logging.info("Access token acquired successfully.")
        return result["access_token"]
    else:
        logging.error(f"Error acquiring access token: {result.get('error_description')}")
        raise Exception("Could not acquire access token")

# --- Contact Management Functions ---
def create_contact(target_user_id, gal_user, access_token):
    """Creates a new contact."""
    # ... (implementation remains the same)

def update_contact(target_user_id, contact_id, gal_user, access_token):
    """Updates an existing contact."""
    # ... (implementation remains the same)

def delete_contact(target_user_id, contact_id, access_token):
    """Deletes a contact."""
    # ... (implementation remains the same)



# --- Main Synchronization Logic ---
def sync_gal_to_contacts_logic():
    """The core logic for GAL synchronization."""
    logging.info("Simplified GAL synchronization process started.")
    # In a real scenario, the full synchronization logic would go here.
    logging.info("Simplified GAL synchronization process finished.")

# --- API Endpoints ---
@app.post("/sync")
async def trigger_sync(background_tasks: BackgroundTasks):
    """Triggers the GAL synchronization process in the background."""
    logging.info("Received request to trigger synchronization.")
    background_tasks.add_task(sync_gal_to_contacts_logic)
    return {"message": "Synchronization process started in the background."}

@app.get("/logs")
async def get_logs():
    """Returns the synchronization log file."""
    log_path = "sync.log"
    if os.path.exists(log_path):
        return FileResponse(log_path)
    return {"message": "Log file not found."}

# --- Main Execution ---
if __name__ == "__main__":
    logging.info("Starting backend service...")
    uvicorn.run(app, host="0.0.0.0", port=8000)