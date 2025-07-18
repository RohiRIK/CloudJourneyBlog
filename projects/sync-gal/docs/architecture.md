# Architecture

## High-Level Architecture

The application consists of three main components:

1.  **Backend Service:** A containerized Python application responsible for the core synchronization logic. It fetches user data from the Microsoft Graph API and creates, updates, or deletes contacts in each user's personal contacts folder.

2.  **Frontend Service:** A containerized React application that provides a web-based dashboard for monitoring and managing the synchronization process.

3.  **Docker:** Docker is used to containerize both the backend and frontend services, and `docker-compose` is used to orchestrate the containers.

## Data Flow

1.  The **Backend Service** runs on a schedule (e.g., as a CRON job).
2.  It authenticates with the **Microsoft Graph API** using OAuth 2.0 with a certificate.
3.  It fetches the list of users from the GAL using a delta query to get only the changes since the last run.
4.  For each user, it synchronizes their GAL information to their personal contacts folder.
5.  The **Frontend Service** communicates with the backend (though the mechanism is not yet defined, it could be via a shared volume for logs or a simple API exposed by the backend) to display the status and logs of the synchronization.
