# Workflow: Navigation System Validation

**Purpose:** To ensure the integrity of the project's navigation system by automatically verifying that all paths in `projects/buddy-ai/navigation/navigation.json` point to real files or directories.

**Activation Triggers:**
- "Validate the navigation system."
- "Check for broken links in the navigation."
- "Run the navigation validation workflow."

## SYSTEM INSTRUCTIONS FOR NAVIGATION VALIDATION
When a user requests to validate the navigation system, I MUST:
1. Follow all phases of this workflow systematically.
2. Use the specified tools for each step.
3. Report the results clearly to the user.
4. Propose auto-correction for any broken paths found.

---

## PHASE 1: PARSE NAVIGATION FILE

### Step 1.1: Read the navigation.json File
**Tools to Use:** `read_file`
**Actions:**
- Read the content of the `projects/buddy-ai/navigation/navigation.json` file.
**Evidence to Gather:**
- The JSON content of the navigation file.
**Validation:**
- The file content is successfully read and is valid JSON.
**Output:**
- A JSON object containing the navigation data.

---

## PHASE 2: VALIDATE NAVIGATION PATHS

### Step 2.1: Extract All Paths
**Tools to Use:** `jq` (or similar JSON parsing tool)
**Actions:**
- Parse the JSON object and extract all values associated with the `"path"` key.
**Evidence to Gather:**
- A list of all navigation paths.
**Validation:**
- The list of paths is successfully extracted.
**Output:**
- A list of strings, where each string is a navigation path.

### Step 2.2: Check Each Path
**Tools to Use:** `run_shell_command` (using `test -e`)
**Actions:**
- For each path in the list, check if the file or directory exists.
**Evidence to Gather:**
- The exit code of the `test -e` command for each path.
**Validation:**
- Each path is successfully checked.
**Output:**
- A list of broken paths and a list of valid paths.

---

## PHASE 3: REPORT RESULTS

### Step 3.1: Generate a Validation Report
**Tools to Use:** `echo`
**Actions:**
- Generate a report that summarizes the validation results.
**Evidence to Gather:**
- The number of valid paths and the number of broken paths.
**Validation:**
- The report is successfully generated.
**Output:**
- A markdown-formatted report that lists the broken paths and provides a summary of the validation results.

---

## PHASE 4: AUTO-CORRECTION (FUTURE)

### Step 4.1: Propose Corrections for Broken Paths
**Tools to Use:** `glob`, `search_file_content`
**Actions:**
- For each broken path, search for similar file or directory names in the project.
- Propose a correction for each broken path.
**Evidence to Gather:**
- A list of potential corrections for each broken path.
**Validation:**
- The proposed corrections are likely to be correct.
**Output:**
- A list of proposed corrections for the broken paths.