# Buddy Workflows & Commands

This document outlines automated workflows and complex commands that Buddy can execute to maintain and manage the project.

## Navigation System Validation

### Purpose
To ensure the integrity of the project's navigation system by automatically verifying that all paths in `projects/buddy-ai/navigation/navigation.json` point to real files or directories.

### Command
This workflow is executed by running the `validate_navigation.sh` script.

```bash
./tools/scripts/validate_navigation.sh
```

### Procedure
1.  **Parse JSON**: The script reads and parses all `path` values from the `navigation.json` file.
2.  **Validate Paths**: It checks each path to confirm that the file or directory exists.
3.  **Report Results**: It outputs a report detailing any broken paths it finds or confirms that all paths are valid.
4.  **Auto-Correction (Future)**: The next step for this workflow is to implement logic to automatically find and propose corrections for broken paths.
