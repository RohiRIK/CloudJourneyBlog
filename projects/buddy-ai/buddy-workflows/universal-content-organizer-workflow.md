# Workflow: Universal Content Organizer

**Purpose:** To systematically sort, categorize, and organize any type of content file based on its content, user-defined criteria, and specified content type, moving it to appropriate directories and optionally updating metadata.

**Activation Triggers:**
- "Organize content."
- "Sort files."
- "Categorize my documents."
- "Process new content."
- "Universal organizer."

## SYSTEM INSTRUCTIONS FOR UNIVERSAL CONTENT ORGANIZATION
When a user requests to organize content, I MUST:
1.  Follow all phases of this workflow systematically.
2.  Validate all user inputs and file paths.
3.  Accurately extract or infer metadata for categorization.
4.  Require explicit user confirmation before moving or modifying files.
5.  Ensure content is moved to the correct target location based on content type and category.

---

## PHASE 1: IDENTIFY & PREPARE CONTENT

### Step 1.1: Define Source Content & Type
**Tools to Use:** User Input, `list_directory`, `glob`
**Actions:**
- Ask the user for the full path to the content file(s) or directory to be organized.
- Ask the user to specify the *type* of content (e.g., "blog post", "workflow document", "AI output log", "research note", "image", "general document").
- If a directory is provided, list all relevant content files within it based on common extensions.
**Evidence to Gather:**
- The specified source path(s).
- The declared content type.
- A list of content files to process.
**Validation:**
- Source path(s) exist and contain readable content files.
- Content type is recognized or clearly defined by the user.
**Output:**
- A list of absolute paths to content files ready for processing, along with their declared content type.

---

## PHASE 2: ANALYZE & CATEGORIZE

### Step 2.1: Extract Metadata & Infer Category
**Tools to Use:** `read_file`, `fabric-ai` (e.g., `extract_insights`, `analyze_prose`, `summarize`)
**Actions:**
- For each content file:
    - Read its content.
    - Use `fabric-ai` patterns (selected based on content type) to extract key information (e.g., main topic, keywords, summary, purpose).
    - Based on extracted info, content type, and internal knowledge, propose a primary category and relevant tags.
    - If `fabric-ai` is unavailable or insufficient, prompt the user for manual categorization.
**Evidence to Gather:**
- Extracted metadata (topic, keywords, summary, purpose).
- Proposed category and tags.
**Validation:**
- Metadata extraction is accurate.
- Proposed category is logical and aligns with content type.
**Output:**
- For each file: `file_path`, `declared_content_type`, `proposed_category`, `proposed_tags`, `extracted_summary`.

### Step 2.2: User Review & Confirm Categories
**Tools to Use:** User Input, `echo`
**Actions:**
- Present the proposed category and tags for each file to the user.
- Ask the user to confirm or modify the categorization.
**Evidence to Gather:**
- User's confirmation or revised categories/tags.
**Validation:**
- User-approved categorization for all files.
**Output:**
- Finalized `category` and `tags` for each content file.

---

## PHASE 3: SORT & MOVE CONTENT

### Step 3.1: Define Dynamic Target Paths
**Tools to Use:** Internal Logic
**Actions:**
- Based on the `declared_content_type` and finalized `category` for each file, construct the `base_target_directory`.
    - **Examples:**
        - "blog post" -> `content/blogs/<category>/`
        - "workflow document" -> `projects/buddy-ai/buddy-workflows/`
        - "AI output log" -> `projects/buddy-ai/buddy-output/<category>/`
        - "research note" -> `content/research/<category>/` (if applicable)
        - "general document" -> `docs/general/<category>/` (if applicable)
- Construct the `final_target_file_path` (e.g., `<base_target_directory>/<original_filename>`).
**Evidence to Gather:**
- The constructed target paths for each file.
**Validation:**
- Target paths are correctly formed and align with content type and category.
**Output:**
- `base_target_directory` and `final_target_file_path` for each file.

### Step 3.2: Create Target Directories (if needed)
**Tools to Use:** `run_shell_command` (`mkdir -p`)
**Actions:**
- For each unique `base_target_directory`, check if it exists. If not, create it.
**Evidence to Gather:**
- The existence status of each target directory.
**Validation:**
- All necessary target directories exist.
**Output:**
- Ready target directories for content placement.

### Step 3.3: Move Content Files
**Tools to Use:** `run_shell_command` (`git mv` or `mv`)
**Actions:**
- For each content file, execute `git mv <source_file_path> <final_target_file_path>` (if tracked by Git) or `mv <source_file_path> <final_target_file_path>` (if untracked).
**Evidence to Gather:**
- The output of the move command for each file.
**Validation:**
- All files are successfully moved to their new locations.
**Output:**
- Content files in their categorized directories.

---

## PHASE 4: UPDATE METADATA & INDEX (OPTIONAL)

### Step 4.1: Add/Update Front Matter (if applicable)
**Tools to Use:** `read_file`, `replace`, `write_file`
**Actions:**
- For Markdown files, check for existing front matter.
- If missing or incomplete, add/update YAML front matter with `category`, `tags`, `title` (from filename or extracted summary), `date`, and `content_type`.
**Evidence to Gather:**
- Content of files before and after front matter modification.
**Validation:**
- Files contain correct and complete front matter.
**Output:**
- Content files with updated metadata.

### Step 4.2: Update Category Index (e.g., README.md, navigation.json)
**Tools to Use:** `read_file`, `replace`, `write_file`
**Actions:**
- Identify relevant index files (e.g., `content/blogs/README.md`, `projects/buddy-ai/buddy-workflows/README.md`, `navigation.json`).
- Add a link or entry for the newly sorted content to the appropriate index file.
**Evidence to Gather:**
- Content of index files before and after modification.
**Validation:**
- Index files are updated correctly.
**Output:**
- Updated content indexes.

---

## PHASE 5: GIT OPERATIONS

### Step 5.1: Stage Changes
**Tools to Use:** `run_shell_command` (`git add`)
**Actions:**
- Execute `git add <final_target_file_path>` for each moved/modified file.
- Execute `git add <index_file_path>` for any updated index files.
**Evidence to Gather:**
- The output of `git status` showing staged changes.
**Validation:**
- All relevant changes are staged.
**Output:**
- Staged changes ready for commit.

### Step 5.2: Propose Commit Message
**Tools to Use:** Internal Logic
**Actions:**
- Generate a concise commit message summarizing the content organization (e.g., "feat(organize): Categorized <filename> as <content_type> in <category>").
**Evidence to Gather:**
- The proposed commit message.
**Validation:**
- The commit message accurately reflects the changes.
**Output:**
- A proposed commit message.

### Step 5.3: Execute Commit
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

### Step 5.4: Push Changes (Optional)
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