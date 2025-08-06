# Workflow: Project Cleanup

**Purpose:** To systematically identify, categorize, and eliminate various forms of clutter within the project repository, ensuring a clean, efficient, and organized workspace.

**Activation Triggers:**
- "Clean up the project."
- "Run cleanup workflow."
- "Remove temporary files."
- "Clear out old logs."

## SYSTEM INSTRUCTIONS FOR PROJECT CLEANUP
When a user requests a project cleanup, I MUST:
1.  Follow all phases of this workflow systematically.
2.  Exclude Git branch management from the scope of cleanup.
3.  Clearly report what will be removed before taking action.
4.  Require explicit user confirmation before deleting any files or directories.
5.  Provide options for archiving instead of permanent deletion where appropriate.

---

## PHASE 1: IDENTIFY & CATEGORIZE CLUTTER

### Step 1.1: Define Cleanup Scope
**Tools to Use:** User Input, Internal Knowledge
**Actions:**
- Ask the user what types of clutter they want to target (e.g., temporary files, build artifacts, old logs, untracked files, empty directories).
- Propose common cleanup targets based on project type and typical development practices.
**Evidence to Gather:**
- User-defined cleanup preferences.
- Predefined list of common clutter types.
**Validation:**
- The cleanup scope is clearly defined and understood by the user.
**Output:**
- A prioritized list of clutter categories to target.

### Step 1.2: Scan for Clutter
**Tools to Use:** `run_shell_command` (`find`, `git status --porcelain`, `ls -a`)
**Actions:**
- Based on the defined scope, scan the project directory for instances of identified clutter.
- For temporary files/build artifacts: use `find` with patterns (e.g., `*.tmp`, `*.bak`, `dist/`, `build/`).
- For old logs: use `find` with age criteria (e.g., `-mtime +30`).
- For untracked files: use `git status --porcelain`.
- For empty directories: use `find -type d -empty`.
**Evidence to Gather:**
- A list of all identified clutter, including their paths and sizes.
**Validation:**
- The scan is comprehensive for the defined scope.
**Output:**
- A detailed report of all detected clutter.

---

## PHASE 2: REVIEW & CONFIRMATION

### Step 2.1: Present Clutter Report
**Tools to Use:** `echo`
**Actions:**
- Present the detailed report of detected clutter to the user.
- Categorize the clutter for easier review.
- Highlight the potential disk space savings.
**Evidence to Gather:**
- The clutter report.
**Validation:**
- The user has reviewed and understood the report.
**Output:**
- User awareness of the project's current clutter status.

### Step 2.2: Get User Confirmation for Action
**Tools to Use:** User Input
**Actions:**
- Ask the user to confirm which specific items or categories they want to clean up.
- Offer options for deletion or archiving (if applicable).
**Evidence to Gather:**
- User's explicit confirmation and chosen action (delete/archive).
**Validation:**
- The user's intent for cleanup is clear.
**Output:**
- A confirmed list of items for cleanup and the desired action.

---

## PHASE 3: EXECUTE CLEANUP

### Step 3.1: Perform Deletion or Archiving
**Tools to Use:** `run_shell_command` (`rm -rf`, `tar`, `zip`)
**Actions:**
- Based on user confirmation, execute the appropriate commands.
- For deletion: `rm -rf <path>`.
- For archiving: `tar -czvf <archive_name>.tar.gz <path>` or `zip -r <archive_name>.zip <path>`.
- Provide progress updates during the process.
**Evidence to Gather:**
- The output of the cleanup commands.
**Validation:**
- The cleanup commands execute successfully.
**Output:**
- Cleaned project directory or created archives.

---

## PHASE 4: VERIFY & REPORT

### Step 4.1: Verify Cleanup Success
**Tools to Use:** `run_shell_command` (`ls`, `du -sh`)
**Actions:**
- Re-scan the cleaned areas to confirm that the clutter has been removed or archived.
- Report the new disk space usage.
**Evidence to Gather:**
- New scan results and disk usage.
**Validation:**
- The cleanup was effective.
**Output:**
- Confirmation of successful cleanup.

### Step 4.2: Final Report
**Tools to Use:** `echo`
**Actions:**
- Provide a final summary of the cleanup operation, including what was removed/archived and the resulting benefits.
**Evidence to Gather:**
- Summary of cleanup actions.
**Validation:**
- The report is clear and accurate.
**Output:**
- A comprehensive report of the project cleanup.

---

## PHASE 5: PREVENT FUTURE MESS (OPTIONAL)

### Step 5.1: Propose Prevention Strategies
**Tools to Use:** User Input, Internal Knowledge
**Actions:**
- Based on the types of clutter found, propose strategies to prevent future accumulation (e.g., updating `.gitignore`, configuring build tools to clean automatically, setting up automated archiving scripts).
- Ask the user if they want to implement any of these strategies.
**Evidence to Gather:**
- User's decision on prevention strategies.
**Validation:**
- Prevention strategies are discussed.
**Output:**
- Recommendations for maintaining a clean project.
