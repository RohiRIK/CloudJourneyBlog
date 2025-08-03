import json
import os
import sys

def validate_navigation_paths():
    """
    Reads projects/buddy-ai/navigation/navigation.json, checks if each path exists,
    and prints a report of valid and broken paths.
    """
    # The script is run from the project root, so paths are relative to it.
    project_root = os.getcwd()
    nav_file_path = os.path.join(project_root, 'projects/buddy-ai/navigation/navigation.json')

    if not os.path.exists(nav_file_path):
        print(f"Error: navigation.json not found at {nav_file_path}")
        sys.exit(1)

    try:
        with open(nav_file_path, 'r') as f:
            nav_data = json.load(f)
    except json.JSONDecodeError:
        print("Error: Could not decode JSON from navigation.json. Please check for syntax errors.")
        sys.exit(1)
    except IOError as e:
        print(f"Error reading file: {e}")
        sys.exit(1)

    broken_paths = []
    valid_paths_count = 0

    def check_item(item):
        nonlocal valid_paths_count
        if 'path' in item and item['path']:
            # Treat paths as relative to the project root
            path_to_check = os.path.join(project_root, item['path'])
            if not os.path.exists(path_to_check):
                broken_paths.append(item['path'])
            else:
                valid_paths_count += 1

    for category in nav_data:
        if 'items' in category:
            for item in category['items']:
                check_item(item)
        if 'sub_categories' in category:
            for sub_category in category['sub_categories']:
                if 'items' in sub_category:
                    for item in sub_category['items']:
                        check_item(item)

    print("--- Navigation Validation Report ---")
    if not broken_paths:
        print(f"✅ All {valid_paths_count} paths are valid. Great job!")
    else:
        print(f"Found {len(broken_paths)} broken path(s):")
        for path in broken_paths:
            print(f"  ❌ Broken: {path}")
        print(f"\nFound {valid_paths_count} valid paths.")
        # Set a non-zero exit code to indicate failure for scripting purposes
        sys.exit(1)

if __name__ == "__main__":
    validate_navigation_paths()
