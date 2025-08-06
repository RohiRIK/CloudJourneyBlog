# Workflow: Explain Buddy Output Cleanup

**Purpose:** To explain the process of cleaning and organizing the `projects/buddy-ai/buddy-output/` directory, including identifying and archiving irrelevant files.

**Activation Triggers:**
- "Explain buddy output cleanup."
- "How do I clean buddy-output?"
- "Guide me through organizing buddy-output."

## SYSTEM INSTRUCTIONS FOR EXPLAINING BUDDY OUTPUT CLEANUP
When a user requests an explanation of the buddy output cleanup, I MUST:
1.  Follow all phases of this workflow systematically.
2.  Clearly describe each step of the cleanup process.
3.  Provide the commands used for each step.
4.  Emphasize the benefits of maintaining a clean `buddy-output` directory.

---

## PHASE 1: UNDERSTANDING THE NEED FOR CLEANUP

### Step 1.1: Explain Purpose of `buddy-output`
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Explain that `projects/buddy-ai/buddy-output/` is where Buddy AI stores various generated outputs, analyses, and temporary files.
- Emphasize that it can accumulate clutter over time.
**Evidence to Gather:**
- User's understanding of the directory's purpose.
**Validation:**
- User acknowledges the explanation.
**Output:**
- Clear understanding of `buddy-output`'s role.

### Step 1.2: Explain Benefits of Cleanup
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Describe the benefits: better organization, easier navigation, reduced clutter, potential disk space savings.
**Evidence to Gather:**
- User's understanding of the benefits.
**Validation:**
- User acknowledges the benefits.
**Output:**
- Motivation for performing cleanup.

---

## PHASE 2: IDENTIFYING CLUTTER

### Step 2.1: How to Scan for Files
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Explain that the first step is to list all files in the `buddy-output` directory, including their sizes.
- Provide the `find` and `du -h` command used: `find projects/buddy-ai/buddy-output/ -type f -print0 | xargs -0 du -h`
**Evidence to Gather:**
- User's understanding of the scanning command.
**Validation:**
- User acknowledges the command.
**Output:**
- Knowledge of how to list files and sizes.

### Step 2.2: How to Analyze Files (Manual/Fabric AI)
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Explain that each file needs to be reviewed to determine its relevance.
- Describe manual review (checking content, filename, timestamp).
- Explain how Fabric AI can assist (as we just did):
    - Read file content: `default_api.read_file(absolute_path='<path>')`
    - Analyze with Fabric AI: `fabric-ai --pattern "analyze_prose" --model "gemini-2.0-flash-exp" "<file_content>"`
- Emphasize looking for:
    *   Older versions (e.g., `V2`, `temp`).
    *   Timestamped files that are no longer current.
    *   Specific analysis reports that have served their purpose.
    *   Files that are clearly temporary or intermediate outputs.
**Evidence to Gather:**
- User's understanding of analysis methods.
**Validation:**
- User acknowledges the methods.
**Output:**
- Knowledge of how to analyze files for archival suitability.

---

## PHASE 3: ARCHIVING THE CLUTTER

### Step 3.1: Create Archive Directory
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Explain the importance of archiving instead of immediate deletion for safety.
- Provide the command to create the `archive/` subdirectory: `mkdir -p projects/buddy-ai/buddy-output/archive/`
**Evidence to Gather:**
- User's understanding of the archive directory.
**Validation:**
- User acknowledges the command.
**Output:**
- Knowledge of how to create the archive directory.

### Step 3.2: How to Move Files to Archive
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Explain that files are moved using the `mv` command.
- Provide an example command: `mv <file_path> projects/buddy-ai/buddy-output/archive/`
- Emphasize moving files one by one or using a loop for multiple files after confirmation.
**Evidence to Gather:**
- User's understanding of the move command.
**Validation:**
- User acknowledges the command.
**Output:**
- Knowledge of how to move files to the archive.

---

## PHASE 4: VERIFICATION & MAINTENANCE

### Step 4.1: Verify Cleanup
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Explain how to verify the cleanup by re-listing the `buddy-output` directory.
- Provide the command: `find projects/buddy-ai/buddy-output/ -type f -print0 | xargs -0 du -h`
**Evidence to Gather:**
- User's understanding of verification.
**Validation:**
- User acknowledges the command.
**Output:**
- Knowledge of how to verify cleanup.

### Step 4.2: Ongoing Maintenance
**Tools to Use:** Internal Knowledge, `echo`
**Actions:**
- Recommend periodic review and cleanup of the `buddy-output` directory.
- Suggest integrating this cleanup into a regular routine.
**Evidence to Gather:**
- User's understanding of ongoing maintenance.
**Validation:**
- User acknowledges the recommendation.
**Output:**
- Strategy for continuous organization.
