# Secure Commit Workflow

## Description
This workflow guides the user through a secure and efficient Git commit process, ensuring that no sensitive information is accidentally committed and that the project's `CHANGELOG-BUDDY-PROJECT.md` is updated before the commit is finalized.

## Location
`projects/buddy-ai/workflows/secure-commit-workflow.md`

## Procedure
This workflow is executed interactively, with Buddy guiding the user through each step.

1.  **Review Changes**: Buddy will display the current `git status` and `git diff HEAD` to allow the user to review all pending changes.

2.  **Update Changelog**: Buddy will prompt the user to update `projects/buddy-ai/CHANGELOG-BUDDY-PROJECT.md` with a summary of the changes being committed. This step *must* be completed and saved before proceeding.

3.  **Secret Scan (Pre-commit)**: Buddy will perform a local scan for common API key/secret patterns within the staged changes. This scan will leverage the principles outlined in the `API Key Sanitizer Workflow`.
    *   If potential secrets are detected, Buddy will alert the user and provide instructions on how to add them to `.gitignore` and untrack them using `git rm --cached <file>`.
    *   The commit process will be paused until all detected secrets are addressed.

4.  **Propose Commit Message**: Based on the reviewed changes and the updated changelog, Buddy will draft a concise and descriptive commit message, adhering to project conventions.

5.  **Confirm Commit**: Buddy will present the proposed commit message and ask for user confirmation before executing the `git commit` command.

6.  **Push Changes (Optional)**: After a successful commit, Buddy will ask the user if they wish to push the changes to the remote repository.

## Security Mechanisms
-   **Pre-commit Secret Scanning**: Integrates a critical security check before sensitive data can be committed.
-   **Forced Changelog Update**: Ensures that project history is accurately maintained and that changes are documented before they become part of the permanent record.
-   **User Confirmation**: Requires explicit user approval at key stages to prevent unintended actions.
-   **Adherence to `.gitignore`**: Reinforces the use of `.gitignore` for sensitive files.

## How to Utilize This Workflow Effectively
-   **Regular Use**: Make this your standard process for all commits to ensure consistency and security.
-   **Descriptive Changelog Entries**: Provide clear and concise entries in the changelog to make future reviews easier.
-   **Review Prompts Carefully**: Pay close attention to Buddy's prompts, especially regarding secret detection and commit message proposals.
