# Workflow: Check Ignored Files

**Purpose:** To proactively verify that specific directories and files intended to be ignored by Git are not accidentally committed to the repository, and to guide the user through remediation if issues are found.

**Activation Triggers:**
- "Check for ignored files."
- "Verify .gitignore status."
- "Scan for accidentally committed ignored files."

## SYSTEM INSTRUCTIONS FOR CHECKING IGNORED FILES
When a user requests to check for ignored files, I MUST:
1.  Follow all phases of this workflow systematically.
2.  Clearly report any ignored files found that are not properly untracked.
3.  Provide clear instructions for remediation.
4.  Recommend adding files to `.gitignore` if they are not already.

---

## PHASE 1: IDENTIFY TARGETS & SCAN

### Step 1.1: Define Critical Ignored Paths
**Tools to Use:** Internal Knowledge
**Actions:**
- Identify a predefined list of critical directories and files that *must* be ignored (e.g., `projects/TELOS`, `.gemini`, `.goosehints`).
**Evidence to Gather:**
- A list of absolute paths to critical ignored directories/files.
**Validation:**
- The list is comprehensive and accurate for the project's needs.
**Output:**
- A list of paths to check.

### Step 1.2: Scan for Presence of Ignored Paths
**Tools to Use:** `run_shell_command` (using `find` or `ls -d`)
**Actions:**
- For each path in the critical ignored list, check if it exists in the repository's working directory.
**Evidence to Gather:**
- The existence status of each critical ignored path.
**Validation:**
- All specified paths have been checked.
**Output:**
- A list of existing critical ignored paths.

---

## PHASE 2: VERIFY GIT STATUS

### Step 2.1: Check if Existing Paths are Tracked by Git
**Tools to Use:** `run_shell_command` (using `git ls-files --error-unmatch`)
**Actions:**
- For each existing critical ignored path, determine if Git is currently tracking it.
**Evidence to Gather:**
- The output of `git ls-files --error-unmatch <path>` for each path.
**Validation:**
- The tracking status of each path is determined.
**Output:**
- A list of critical ignored paths that are currently tracked by Git (i.e., problematic files).

---

## PHASE 3: REPORT FINDINGS & REMEDIATION

### Step 3.1: Report Problematic Files
**Tools to Use:** `echo`
**Actions:**
- Present a clear report to the user detailing any critical ignored paths that are currently tracked by Git.
- Explain why these files should not be tracked.
**Evidence to Gather:**
- The list of problematic files.
**Validation:**
- The report is clear and accurate.
**Output:**
- User awareness of the ignored file issues.

### Step 3.2: Provide Remediation Instructions
**Tools to Use:** `echo`
**Actions:**
- For each problematic file, provide the exact commands to untrack it from Git and add it to `.gitignore` (if not already present).
    - `git rm --cached <path>`
    - `echo "<path>" >> .gitignore`
**Evidence to Gather:**
- The user's acknowledgment of the instructions.
**Validation:**
- The user understands how to remediate the issue.
**Output:**
- Actionable steps for the user to fix the ignored file issues.