# Workflow: Manage Git Ignore Patterns

**Purpose:** To systematically manage `.gitignore` patterns, ensuring specific files and directories are correctly excluded from Git tracking, and to guide the user through remediation if issues are found.

**Activation Triggers:**
- "Manage gitignore."
- "Add files to gitignore."
- "Remove tracked files from gitignore."
- "Test gitignore patterns."

## SYSTEM INSTRUCTIONS FOR MANAGING GIT IGNORE PATTERNS
When a user requests to manage gitignore patterns, I MUST:
1.  Follow all phases of this workflow systematically.
2.  Proactively identify files/directories that should be ignored.
3.  Guide the user through updating `.gitignore` and untracking files.
4.  Verify the patterns are working correctly.
5.  Ensure changes are committed.

---

## PHASE 1: IDENTIFY & ANALYZE IGNORE TARGETS

### Step 1.1: Identify Files and Directories to Ignore
**Tools to Use:** User Input, `find`, `glob`
**Actions:**
- Ask the user for specific files or directories they want to ignore.
- Propose common ignore targets (e.g., `node_modules`, `dist`, `.env`, `logs/`, `projects/TELOS`, `.gemini`, `.goosehints`).
- Use `find` to locate instances of these files/directories in the repository.
**Evidence to Gather:**
- A list of files/directories the user wants to ignore.
- Paths of existing instances of these targets.
**Validation:**
- The list of targets is clear and comprehensive.
**Output:**
- A consolidated list of absolute paths to files/directories that should be ignored.

### Step 1.2: Check Current Git Status of Targets
**Tools to Use:** `run_shell_command` (`git status --porcelain`, `git ls-files`)
**Actions:**
- For each identified target, check if it is currently tracked by Git.
- Identify any files that are *already* tracked but *should* be ignored.
**Evidence to Gather:**
- Output from `git status --porcelain` and `git ls-files` filtered by target paths.
**Validation:**
- Accurate identification of tracked vs. untracked targets.
**Output:**
- A list of targets that are currently tracked by Git and need to be untracked.

---

## PHASE 2: UPDATE .GITIGNORE

### Step 2.1: Propose .gitignore Patterns
**Tools to Use:** Internal Logic, User Input
**Actions:**
- Based on the identified targets, propose appropriate `.gitignore` patterns (e.g., `**/filename`, `dirname/`, `*.extension`).
- Explain the different pattern types and their scope.
- Ask the user to confirm or modify the proposed patterns.
**Evidence to Gather:**
- The proposed `.gitignore` patterns.
**Validation:**
- The patterns are syntactically correct and cover the intended targets.
**Output:**
- Finalized `.gitignore` patterns.

### Step 2.2: Apply .gitignore Changes
**Tools to Use:** `write_file`, `read_file`
**Actions:**
- Read the current `.gitignore` file.
- Append the new patterns to the `.gitignore` file.
**Evidence to Gather:**
- The updated content of the `.gitignore` file.
**Validation:**
- The `.gitignore` file is updated successfully.
**Output:**
- The `.gitignore` file with new patterns applied.

---

## PHASE 3: REMEDIATE TRACKED FILES

### Step 3.1: Identify Already-Tracked Files for Removal
**Tools to Use:** Internal Logic
**Actions:**
- Reconfirm the list of files identified in Phase 1 that are currently tracked by Git but should be ignored.
**Evidence to Gather:**
- The confirmed list of files to be untracked.
**Validation:**
- The list is accurate and approved by the user.
**Output:**
- A definitive list of files to untrack.

### Step 3.2: Remove Tracked Files from Git
**Tools to Use:** `run_shell_command` (`git rm --cached`)
**Actions:**
- For each file in the list, execute `git rm --cached <file_path>`.
- For directories, execute `git rm -r --cached <directory_path>/`.
**Evidence to Gather:**
- The output of the `git rm --cached` commands.
**Validation:**
- The files/directories are no longer tracked by Git.
**Output:**
- Untracked files/directories, remaining in the local working copy.

---

## PHASE 4: VERIFY & TEST PATTERNS

### Step 4.1: Test Applied Patterns
**Tools to Use:** `run_shell_command` (`git check-ignore -v`)
**Actions:**
- For each new pattern and untracked file, use `git check-ignore -v <path>` to verify that Git now correctly ignores them.
**Evidence to Gather:**
- The output of `git check-ignore -v` for all relevant paths.
**Validation:**
- All patterns are working as expected.
**Output:**
- Confirmation that patterns are effective.

### Step 4.2: Verify Final Git Status
**Tools to Use:** `run_shell_command` (`git status`)
**Actions:**
- Execute `git status` to show the user that the previously tracked files are no longer listed as changes, and new ignored files are not appearing.
**Evidence to Gather:**
- The output of `git status`.
**Validation:**
- The repository status is clean regarding ignored files.
**Output:**
- A clean Git status, confirming successful ignore management.

---

## PHASE 5: COMMIT CHANGES

### Step 5.1: Stage Changes
**Tools to Use:** `run_shell_command`
**Actions:**
- Execute `git add .gitignore` to stage the updated `.gitignore` file.
- Stage any other relevant changes (e.g., `git add .` for untracked files that are now correctly ignored).
**Evidence to Gather:**
- The output of `git status` showing the staged changes.
**Validation:**
- The changes are correctly staged.
**Output:**
- Staged changes ready for commit.

### Step 5.2: Propose Commit Message
**Tools to Use:** Internal Logic
**Actions:**
- Generate a concise commit message summarizing the `.gitignore` updates and any untracked file removals.
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