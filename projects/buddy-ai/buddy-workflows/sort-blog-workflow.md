# Workflow: Sort New Blog Post

**Purpose:** To automate the process of organizing new blog posts by moving them to a topic-specific directory and ensuring they have the correct front matter.

**Activation Triggers:**
- "Sort a new blog post."
- "Organize this blog post."
- "Add front matter to my blog post."

## SYSTEM INSTRUCTIONS FOR SORTING BLOG POSTS
When a user requests to sort a new blog post, I MUST:
1.  Follow all phases of this workflow systematically.
2.  Validate all user inputs to prevent errors.
3.  Ensure the blog post is moved to the correct topic directory.
4.  Add front matter if it's missing, preserving existing content.
5.  Commit and optionally push the changes.

---

## PHASE 1: INPUT & VALIDATION

### Step 1.1: Get Blog Post Details
**Tools to Use:** User Input
**Actions:**
- Ask the user for the full path to the new blog post file.
- Ask the user for the target topic (e.g., "azure", "n8n", "security").
**Evidence to Gather:**
- The provided file path and topic.
**Validation:**
- The file path is valid and points to an existing Markdown file.
- The topic is a valid string (e.g., no special characters or path traversal attempts).
**Output:**
- Validated `source_file_path` and `topic`.

### Step 1.2: Define Target Paths
**Tools to Use:** Internal Logic
**Actions:**
- Construct the `target_directory` based on the `topic` (e.g., `content/blogs/<topic>/`).
- Construct the `target_file_path` (e.g., `content/blogs/<topic>/<filename>`).
**Evidence to Gather:**
- The constructed target paths.
**Validation:**
- The paths are correctly formed.
**Output:**
- `target_directory` and `target_file_path` variables.

---

## PHASE 2: FILE PROCESSING

### Step 2.1: Create Target Directory (if needed)
**Tools to Use:** `run_shell_command`
**Actions:**
- Check if `target_directory` exists. If not, create it.
**Evidence to Gather:**
- The existence status of the target directory.
**Validation:**
- The target directory exists.
**Output:**
- A ready target directory for the blog post.

### Step 2.2: Move Blog Post File
**Tools to Use:** `run_shell_command`
**Actions:**
- Execute `git mv <source_file_path> <target_file_path>` to move the file and track the change with Git.
**Evidence to Gather:**
- The output of the `git mv` command.
**Validation:**
- The file is successfully moved and Git is tracking the move.
**Output:**
- The blog post file in its new location.

### Step 2.3: Add Front Matter (if missing)
**Tools to Use:** `read_file`, `replace`, `write_file`
**Actions:**
- Read the content of the `target_file_path`.
- Check if the file already contains YAML front matter (e.g., lines starting and ending with `---`).
- If front matter is missing, construct a basic YAML front matter block (e.g., `title`, `topic`, `date`).
- Prepend the front matter to the file content and write it back to the `target_file_path`.
**Evidence to Gather:**
- The content of the file before and after modification.
**Validation:**
- The file now contains valid front matter.
**Output:**
- The blog post file with complete front matter.

---

## PHASE 3: GIT OPERATIONS

### Step 3.1: Stage Changes
**Tools to Use:** `run_shell_command`
**Actions:**
- Execute `git add <target_file_path>` to stage the moved file and any front matter changes.
**Evidence to Gather:**
- The output of `git status` showing the staged changes.
**Validation:**
- The changes are correctly staged.
**Output:**
- Staged changes ready for commit.

### Step 3.2: Propose Commit Message
**Tools to Use:** Internal Logic
**Actions:**
- Generate a concise commit message (e.g., "feat(blog): Sort and add front matter to <filename>").
**Evidence to Gather:**
- The proposed commit message.
**Validation:**
- The commit message accurately reflects the changes.
**Output:**
- A proposed commit message.

### Step 3.3: Execute Commit
**Tools to Use:** User Input, `run_shell_command`
**Actions:**
- Present the proposed commit message to the user and ask for confirmation.
- If confirmed, execute `git commit -m "<commit_message>"`.
**Evidence to Gather:**
- User confirmation and the output of the `git commit` command.
**Validation:**
- The commit is successful.
**Output:**
- A new commit in the project's history.

### Step 3.4: Push Changes (Optional)
**Tools to Use:** User Input, `run_shell_command`
**Actions:**
- Ask the user if they want to push the changes to the remote repository.
- If confirmed, execute `git push`.
**Evidence to Gather:**
- User confirmation and the output of the `git push` command.
**Validation:**
- The push is successful.
**Output:**
- Local changes synchronized with the remote repository.