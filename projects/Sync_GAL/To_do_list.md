# To-Do List: Sync GAL to Exchange Online Contacts

This document outlines the tasks required to implement the Sync GAL to Exchange Online Contacts project.

## Project Setup & Structure

- [x] Create `backend/` directory for synchronization service.
  - [x] Create `backend/Dockerfile`.
  - [x] Create `backend/src/` directory.
  - [x] Create `backend/requirements.txt`.
- [x] Create `frontend/` directory for web-based management dashboard.
  - [x] Create `frontend/Dockerfile`.
  - [x] Create `frontend/src/` directory.
  - [x] Create `frontend/package.json`.
- [x] Create `docs/` directory for project documentation.
  - [x] Create `docs/architecture.md`.
  - [x] Create `docs/setup.md`.
- [x] Create `docker-compose.yml` for service orchestration.
- [x] Create `README.md` for project overview.
- [x] Create `To_do_list.md` (this file).

## Core Requirements Implementation

### 1. Authentication & Security

- [ ] Implement OAuth 2.0 client credentials flow with certificate for Microsoft Graph API authentication in backend.
- [ ] Ensure `Contacts.ReadWrite` and `User.Read.All` Graph API permissions are configured for the Azure AD application.
- [ ] Securely store sensitive data (certificate private key, tenant ID) using Docker Secrets.

### 2. Back-End Service (Synchronization Engine)

#### Initial Fetch

- [ ] Fetch all relevant users from GAL using `/users` endpoint.
- [ ] Filter for active users with mailboxes.
- [ ] Use `$select` OData query parameter for necessary fields (`id`, `displayName`, `givenName`, `surname`, `userPrincipalName`, `businessPhones`, `mobilePhone`, `jobTitle`, `department`).

#### Contact Synchronization Logic (Per-User)

- [ ] Iterate through each GAL user.
- [ ] Implement logic to check for existing contacts using a custom extended property (e.g., `GALSyncId`).
- [ ] **Handling New Contacts:** Create new contact if GAL user does not exist as a contact, mapping GAL attributes to contact fields.
- [ ] **Handling Existing Contacts (Updates):** Compare relevant fields and update existing contact if discrepancies are found.
- [ ] **Handling Name Variations:** Robustly handle `displayName` changes.
- [ ] **Handling Phone Number Changes:** Compare and update `businessPhones` and `mobilePhone`.
- [ ] **Handling Deleted Users:** Implement mechanism to detect and delete contacts for users removed from GAL.

#### Efficiency and Throttling

- [ ] Implement Microsoft Graph Delta Queries (`/users/delta`) for efficient syncs.
- [ ] Implement proper error handling and retry logic for API calls (especially for HTTP 429).

### 3. Front-End Interface (Management Dashboard)

- [ ] Create simple web interface (React).
- [ ] Implement **Dashboard** view (status, timestamp, summary).
- [ ] Implement **Logs Viewer** page.
- [ ] Implement **Configuration** page (sync schedule).
- [ ] Implement **Manual Trigger** button for full GAL sync.

### 4. Containerization

- [ ] Ensure `docker-compose.yml` orchestrates frontend and backend services.
- [ ] Verify `Dockerfile` for backend service (Python).
- [ ] Verify `Dockerfile` for frontend service (React with Nginx).

## Current Development Focus

- [ ] Update `GAL_SYNC_NAMESPACE_GUID` in `backend/src/main.py`.
- [ ] Build and run the backend (`docker-compose build backend` and `docker-compose run --rm backend`) to test updated contact fetching and identification logic.
