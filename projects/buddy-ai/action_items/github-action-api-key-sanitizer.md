# GitHub Action: API Key Sanitizer for Uploaded Files

## Description
Develop a GitHub Action that automatically detects and sanitizes API keys or other sensitive credentials within files uploaded to the repository. The action replaces identified sensitive strings with a placeholder (e.g., `[REDACTED_API_KEY]`) to prevent *new* accidental exposure in future commits. **Note: This action does not rewrite Git history; it only sanitizes files in the current commit.**

## Key Objectives

### 1. Research & Detection Methods
- **Pattern Identification**: Researched common patterns and regular expressions for identifying various types of API keys, tokens, and sensitive credentials (e.g., AWS access keys, Azure client secrets, generic API tokens). **(Done - Initial patterns implemented)**
- **Existing Solutions**: Investigated existing open-source tools or GitHub Actions designed for secret scanning or sanitization to inform our approach.
- **Scope Definition**: Determined the scope of files to be scanned (all new/modified files).

### 2. GitHub Action Implementation
- **Trigger**: Configured the action to trigger on `push` and `pull_request` events. **(Done)**
- **Scanning Logic**: Implemented the logic to scan file contents for identified patterns using regex. **(Done)**
- **Sanitization**: Developed a mechanism to replace detected sensitive strings with a predefined placeholder (`[REDACTED_API_KEY]`). **(Done - In-place file modification)**
- **Reporting**: Provides basic output on sanitization status. **(Done - Basic reporting)**
- **Error Handling**: Implemented robust error handling for cases where patterns are not found or replacement fails.

### 3. Integration & Best Practices
- **`.gitignore` Integration**: Ensured this action complements existing `.gitignore` rules and doesn't interfere with intentionally ignored files.
- **False Positives/Negatives**: Considered strategies to minimize false positives and false negatives.
- **Security Considerations**: Emphasized that this is a *sanitization* step, and proper secret management (e.g., environment variables, secret management services) should be the primary method for handling sensitive data.

## Status
- **Overall Status**: Doing
- **Assigned To**: Buddy / Rohi (Collaborative)
- **Priority**: Critical

## Next Steps & Considerations

- **Automated Commit & Push**: Implement the logic within the GitHub Action to automatically commit and push the sanitized files back to the repository. This is crucial for the action to be effective in preventing exposure. **(Pending Implementation)**
- **Git History Rewriting**: This action *does not* remove API keys from past Git history. For a complete removal of sensitive data from the entire repository history, a separate, more involved process using tools like `git filter-repo` would be required. This is a complex task and should be considered a separate, high-priority action item if needed.
- **Refinement of Regex Patterns**: Continuously refine and expand the set of regex patterns to improve detection accuracy and cover more types of sensitive data.
- **Advanced Reporting**: Enhance reporting to provide more detailed information on sanitized files and detected patterns.

## Notes
This action is vital for enhancing the security posture of the repository by preventing accidental exposure of sensitive information. It requires careful design and testing to ensure effectiveness and reliability.
