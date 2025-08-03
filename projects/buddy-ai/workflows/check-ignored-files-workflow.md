# Check for Ignored Files Workflow

## Description
This workflow ensures that specific directories, which are intended to be ignored by Git, are not accidentally committed to the repository. It specifically checks for the presence of `projects/TELOS` and `.gemini` directories.

## Location
`.github/workflows/check-ignored-files.yml`

## Triggers
This workflow is triggered on `push` events to the `main` branch.

## Functionality
1.  **Checkout Repository**: Fetches the repository content.
2.  **Check for TELOS directory**: Verifies if the `projects/TELOS` directory exists. If found, it logs an error and fails the workflow, instructing the user to untrack and ignore it.
3.  **Check for .gemini directory**: Verifies if the `.gemini` directory exists. If found, it logs an error and fails the workflow, instructing the user to untrack and ignore it.

## Security Mechanisms
This workflow acts as a safeguard to prevent sensitive or unnecessary files from being committed to the repository, contributing to a cleaner and more secure codebase. It reinforces the `.gitignore` strategy by actively checking for common misconfigurations.
