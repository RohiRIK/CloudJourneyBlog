# Workflow: Workflow Testing

**Purpose:** To systematically test other workflows, ensuring they are reliable, accurate, and function as intended. This workflow provides both a simulated "dry run" and an optional live execution.

**Activation Triggers:**
- "Test the [workflow name] workflow."
- "Run a dry run of [workflow name]."
- "Let's validate the [workflow name] workflow."

## SYSTEM INSTRUCTIONS FOR WORKFLOW TESTING
When a user requests to test a workflow, I MUST:
1.  Follow all phases of this meta-workflow systematically.
2.  Default to a safe "dry run" simulation unless the user explicitly requests a live execution.
3.  Require explicit user confirmation before performing a live execution.
4.  Provide a clear and detailed report of the test results.

---

## PHASE 1: SETUP & INITIALIZATION

### Step 1.1: Identify Target Workflow
**Tools to Use:** `read_file`, User Input
**Actions:**
- Ask the user to specify the workflow they want to test.
- Read the content of the specified workflow file (e.g., `projects/buddy-ai/buddy-workflows/secure-commit-workflow.md`).
**Evidence to Gather:**
- The path to the workflow file to be tested.
- The content of the workflow file.
**Validation:**
- The specified workflow file exists and is readable.
**Output:**
- The target workflow's instructions loaded into context.

---

## PHASE 2: DRY RUN SIMULATION

### Step 2.1: Simulate Workflow Execution
**Tools to Use:** `echo`
**Actions:**
- Parse the target workflow and iterate through each phase and step.
- For each step, identify the tools and commands that *would* be executed.
- Instead of running the commands, print a description of the action that would be taken.
    - **Example:** "[DRY RUN] Would execute `run_shell_command` with `git status`."
    - **Example:** "[DRY RUN] Would use `write_file` to create a new file at `/path/to/new/file.md`."
**Evidence to Gather:**
- The sequence of simulated actions.
**Validation:**
- The dry run completes without any logical errors or missing information.
**Output:**
- A step-by-step log of the simulated execution.

### Step 2.2: Report Dry Run Findings
**Tools to Use:** `echo`
**Actions:**
- Analyze the simulated execution log for potential issues, such as incorrect commands, invalid paths, or logical gaps.
- Generate a summary report of the dry run.
**Evidence to Gather:**
- The simulation log.
**Validation:**
- The report accurately reflects the findings of the dry run.
**Output:**
- A summary report detailing the simulated execution and any potential issues found.

---

## PHASE 3: LIVE EXECUTION (OPTIONAL & CONFIRMED)

### Step 3.1: User Confirmation for Live Run
**Tools to Use:** User Input
**Actions:**
- Ask the user if they want to proceed with a live execution of the target workflow.
- Clearly state that this will perform real actions and may modify files.
**Evidence to Gather:**
- The user's explicit "yes" or "no" confirmation.
**Validation:**
- The user has approved the live execution.
**Output:**
- Authorization to proceed with the live run.

### Step 3.2: Execute Workflow
**Tools to Use:** All available tools (`run_shell_command`, `write_file`, etc.)
**Actions:**
- Execute each step of the target workflow as written.
**Evidence to Gather:**
- The real output from each command and tool used.
**Validation:**
- The workflow completes successfully.
**Output:**
- The results of the live workflow execution.

---

## PHASE 4: REPORTING & VALIDATION

### Step 4.1: Generate Final Report
**Tools to Use:** `echo`
**Actions:**
- Generate a final report summarizing the results of the test (either the dry run or the live execution).
- If the test was a live run, include the final output and confirm success or failure.
**Evidence to Gather:**
- The execution logs and outputs.
**Validation:**
- The report is accurate and complete.
**Output:**
- A final validation report.
