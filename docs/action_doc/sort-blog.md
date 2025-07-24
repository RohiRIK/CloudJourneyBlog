# Automated Blog Post Sorting Workflow

This repository includes a GitHub Actions workflow (`.github/workflows/sort-blog.yml`) that helps you organize your Markdown blog posts by moving them into topic folders automatically.

## What Does the Workflow Do?

When triggered, the workflow performs these steps:

1. **Trigger:**  
   Starts when a `repository_dispatch` event with type `new-blog-post` is received.

2. **Repository Checkout:**  
   Checks out the latest code from your repository.

3. **Input Validation:**  
   Ensures the required fields (`topic`, `name`, and `content`) are present in the payload.

4. **Input Sanitization:**  
   Removes unsafe characters from `topic` and `name` to prevent security issues.

5. **File Extension Check:**  
   Confirms the blog post file name ends with `.md` (Markdown format).

6. **Directory and File Path Setup:**  
   Defines the target topic folder and file path as `content/blogs/<topic>/<name>`.

7. **Create Topic Folder if Needed:**  
   Creates the topic folder if it does not already exist.

8. **Move Existing Markdown File:**  
   Checks if the Markdown file exists in the repository root.  
   If it exists, moves it into the topic folder.  
   If it does not exist, the workflow aborts with an error.

9. **Commit and Push:**  
   Commits the moved file and pushes it to the `main` branch.

## How to Use

You can trigger this workflow using GitHub’s API with a `repository_dispatch` event.

### Example: Trigger via HTTP Request (using `curl`)

Replace `<OWNER>`, `<REPO>`, and `<TOKEN>` with your values.

### Example: Trigger via HTTP Request (using `curl`)

Replace `<OWNER>`, `<REPO>`, and `<TOKEN>` with your values.

```bash
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <TOKEN>" \
  https://api.github.com/repos/<OWNER>/<REPO>/dispatches \
  -d '{
    "event_type": "new-blog-post",
    "client_payload": {
      "topic": "ai",
      "name": "my-first-post.md"
    }
  }'
```

- `topic`: The folder under `content/blogs/` (only letters, numbers, hyphens, underscores).
- `name`: The Markdown file name (must end with `.md`).

**Note:**  
The Markdown file (`name`) must already exist in the repository root before

### Requirements

- You need a GitHub personal access token (`repo` scope) to authenticate the request.
- The workflow must exist in your repository.
- The Markdown file (`name`) must already exist in the repository root before triggering the workflow.

## Notes

- The workflow will fail if the file already exists in the target folder or if invalid characters are used.
- All moved posts are committed directly to the `main` branch.
- This automation helps keep your blog content organized by topic with minimal manual