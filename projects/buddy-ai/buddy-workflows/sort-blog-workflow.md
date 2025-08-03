# Sort New Blog Post Workflow

## Description
This workflow automates the process of organizing new blog posts by moving them to a topic-specific directory and adding front matter if it's missing. It's designed to be triggered manually or by another automated process.

## Location
`.github/workflows/sort-blog.yml`

## Triggers
This workflow is triggered by a `repository_dispatch` event with the type `new-blog-post`. It expects `client_payload` to contain `topic` and `name` (filename) for the blog post.

## Functionality
1.  **Checkout Repository**: Fetches the repository content with write permissions.
2.  **Sorting Blog Post File**: This step performs several critical actions:
    *   **Validation**: Checks if `topic` and `name` are provided and if they contain valid characters. It also ensures the `name` ends with `.md`.
    *   **Path Definition**: Defines the source and target paths for the blog post.
    *   **Source File Check**: Verifies if the source blog post file exists.
    *   **Directory Creation & Move**: Creates the target topic directory if it doesn't exist and then uses `git mv` to move the blog post file.
    *   **Add Front Matter**: If the file does not already have front matter, it adds a basic YAML front matter block (title, topic, date) to the top of the file, preserving the existing content.
3.  **Commit and Push Changes**: Automatically commits the changes (moved file, added front matter) and pushes them to the `main` branch.

## Security Mechanisms
This workflow includes basic security sanitization for the `topic` and `name` inputs to prevent path traversal or injection attacks. It also uses `set -e` to ensure the script exits immediately on any non-zero status, preventing unexpected behavior. The `git mv` command is used to ensure Git tracks the file's movement correctly.
