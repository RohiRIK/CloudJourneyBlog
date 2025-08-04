#!/bin/bash

# validate_navigation.sh
# This script validates that all 'path' entries in the navigation.json file exist.

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it to run this script."
    echo "On macOS: brew install jq"
    echo "On Debian/Ubuntu: sudo apt-get install jq"
    exit 1
fi

PROJECT_ROOT=$(pwd)
NAV_FILE="$PROJECT_ROOT/projects/buddy-ai/navigation/navigation.json"

if [ ! -f "$NAV_FILE" ]; then
    echo "Error: Navigation file not found at $NAV_FILE"
    exit 1
fi

# Extract all path values from the JSON file
# This looks for any key named "path" anywhere in the JSON structure
PATHS=$(jq -r '.. | .path? // empty' "$NAV_FILE")

BROKEN_PATHS=()
VALID_COUNT=0
TOTAL_COUNT=0

# Loop through each path and check if it exists
while IFS= read -r path; do
    # Skip empty lines
    if [ -z "$path" ]; then
        continue
    fi

    if [[ "$path" == *"[category]"* ]]; then
        continue
    fi

    ((TOTAL_COUNT++))
    # Construct the full path relative to the project root
    FULL_PATH="$PROJECT_ROOT/$path"

    # Check if the file or directory exists
    if [ ! -e "$FULL_PATH" ]; then
        BROKEN_PATHS+=("$path")
    else
        ((VALID_COUNT++))
    fi
done <<< "$PATHS"

# --- Report Results ---
echo "--- Navigation Validation Report ---"
if [ ${#BROKEN_PATHS[@]} -eq 0 ]; then
    echo "✅ All $VALID_COUNT paths are valid. Great job!"
    exit 0
else
    echo "Found ${#BROKEN_PATHS[@]} broken path(s) out of $TOTAL_COUNT total paths checked:"
    for broken in "${BROKEN_PATHS[@]}"; do
        echo "  ❌ Broken: $broken"
    done
    echo "\nFound $VALID_COUNT valid paths."
    # Exit with a non-zero code to indicate failure for automation
    exit 1
fi
