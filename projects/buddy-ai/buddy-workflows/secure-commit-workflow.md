# Workflow: Secure Git Commit

**Purpose:** To guide the user through a secure and efficient Git commit process, ensuring no sensitive information is committed, the changelog is updated, and project conventions are followed.

**Activation Triggers:**
- "Commit my changes."
- "Run the secure commit workflow."
- "Let's commit this."

## SYSTEM INSTRUCTIONS FOR SECURE COMMIT
When a user requests to commit changes, I MUST:
1.  Follow all phases of this workflow systematically and without skipping steps.
2.  Require user confirmation at critical decision points (e.g., before committing).
3.  Halt the process if secrets are detected and not remediated.
4.  Ensure the changelog is updated before proposing a commit message.

---

## PHASE 1: PRE-COMMIT ANALYSIS & VALIDATION

### Step 1.1: Review Pending Changes
**Tools to Use:** `run_shell_command`
**Actions:**
- Execute `git status` to show the user a summary of modified and untracked files.
- Execute `git diff HEAD` to show the user the specific changes in tracked files.
**Evidence to Gather:**
- The output from the `git` commands.
**Validation:**
- The user has reviewed and acknowledged the pending changes.
**Output:**
- A clear understanding of the changes to be committed.

### Step 1.2: Secret Scan
**Tools to Use:** `run_shell_command` (using `grep` or a dedicated secret scanning tool), `read_file`
**Actions:**
- Scan all staged files for patterns matching common API keys, tokens, and other secrets. This should leverage the principles from the `api-key-sanitizer-workflow.md`.
- If potential secrets are found, alert the user immediately.
**Evidence to Gather:**
- The output of the secret scanning command.
**Validation:**
- The scan completes without finding any secrets, OR the user has explicitly remediated any found secrets by adding the file to `.gitignore` and running `git rm --cached <file>`.
**Output:**
- A confirmation that no secrets are present in the staged changes.

### Step 1.3: Verify Changelog Update
**Tools to Use:** `run_shell_command` (using `git diff --name-only`)
**Actions:**
- Check if `projects/buddy-ai/CHANGELOG-BUDDY-PROJECT.md` is among the modified files.
- If it has not been modified, prompt the user to update it and wait for them to confirm completion.
**Evidence to Gather:**
- The list of modified files.
**Validation:**
- The changelog file has been modified and saved.
**Output:**
- An updated changelog reflecting the current changes.

---

## PHASE 2: COMMIT STAGING & MESSAGE GENERATION

### Step 2.1: Stage Files
**Tools to Use:** `run_shell_command`
**Actions:**
- Ask the user which files they would like to stage for the commit.
- Execute `git add <files>` based on the user's selection.
**Evidence to Gather:**
- The user's list of files to be staged.
**Validation:**
- `git status` confirms that the correct files have been staged.
**Output:**
- A clean staging area ready for commit.

### Step 2.2: Propose Commit Message
**Tools to Use:** `read_file`, `fabric-ai` (optional)
**Actions:**
- Read the content of the updated `projects/buddy-ai/CHANGELOG-BUDDY-PROJECT.md`.
- Analyze the staged changes (`git diff --staged`).
- Generate a concise, descriptive commit message that follows project conventions.
**Evidence to Gather:**
- The content of the changelog and the staged diff.
**Validation:**
- The proposed commit message accurately reflects the changes.
**Output:**
- A formatted commit message for user review.

---

## PHASE 3: EXECUTION & CONFIRMATION

### Step 3.1: Final Confirmation
**Tools to Use:** User Input
**Actions:**
- Present the final, formatted commit message to the user.
- Ask for explicit confirmation to proceed with the commit.
**Evidence to Gather:**
- The user's "yes" or "no" response.
**Validation:**
- The user has approved the commit message.
**Output:**
- Authorization to execute the commit.

### Step 3.2: Execute Commit
**Tools to Use:** `run_shell_command`
**Actions:**
- Execute `git commit -m "<commit_message>"`.
**Evidence to Gather:**
- The output of the `git commit` command.
**Validation:**
- The commit is successful.
**Output:**
- A new commit in the project's history.

---

## PHASE 4: POST-COMMIT (OPTIONAL)

### Step 4.1: Push to Remote
**Tools to Use:** User Input, `run_shell_command`
**Actions:**
- Ask the user if they want to push the changes to the remote repository.
- If confirmed, execute `git push`.
**Evidence to Gather:**
- The user's confirmation.
**Validation:**
- The push is successful.
**Output:**
- The local changes are synchronized with the remote repository.