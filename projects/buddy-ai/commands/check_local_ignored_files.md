# Check Local Ignored Files

This command helps you proactively check for directories that should be ignored by Git but might still be tracked locally.

## Usage

To run this check, execute the following commands in your terminal:

```bash
if [ -d "projects/TELOS" ]; then
  echo "Warning: 'projects/TELOS' directory found and might be tracked. If it should be ignored, run: git rm -r --cached projects/TELOS/"
fi

if [ -d ".gemini" ]; then
  echo "Warning: '.gemini' directory found and might be tracked. If it should be ignored, run: git rm -r --cached .gemini/"
fi

echo "Remember to commit any untracking changes after running these commands."
```

## Explanation

*   `if [ -d "projects/TELOS" ]; then ... fi`: This checks if the `projects/TELOS` directory exists.
*   `echo "Warning: ..."`: If the directory exists, a warning message is displayed, along with the `git rm -r --cached` command to untrack it.
*   The same logic applies to the `.gemini` directory.
*   `git rm -r --cached <path>`: This command removes the specified path from the Git index (untracks it) but keeps the local copy of the files.

This command is a local check. For continuous integration, a GitHub Action (like the one I just created) is recommended.
