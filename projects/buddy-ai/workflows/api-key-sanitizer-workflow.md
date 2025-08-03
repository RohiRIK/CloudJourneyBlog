# API Key Sanitizer Workflow

## Description
This workflow automatically detects and sanitizes API keys or other sensitive credentials within files uploaded to the repository. It replaces identified sensitive strings with a placeholder (`[REDACTED_API_KEY]`) to prevent accidental exposure in future commits. This action does not rewrite Git history; it only sanitizes files in the current commit.

## Location
`.github/workflows/api-key-sanitizer.yml`

## Triggers
This workflow is triggered on `push` and `pull_request` events to the `main` branch.

## Functionality
1.  **Checkout Repository**: Fetches the repository content.
2.  **Get Changed Files**: Identifies all files that have been changed in the current push or pull request.
3.  **Scan and Sanitize API Keys**: Iterates through the changed files, scanning their content against a predefined list of regular expression patterns for common API keys (e.g., AWS, Azure, Google, GitHub, Stripe, Slack). If a potential API key is found, it replaces the key with `[REDACTED_API_KEY]` directly in the file.
4.  **Report Sanitization Status**: Provides a summary of the sanitization process.

## Security Mechanisms
This workflow is a crucial part of the project's security posture, acting as a preventative measure against accidental API key exposure. It complements existing `.gitignore` rules and emphasizes the importance of proper secret management practices (e.g., using environment variables, secret management services).
