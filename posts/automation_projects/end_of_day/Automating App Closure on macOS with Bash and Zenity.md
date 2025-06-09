# Automating App Closure on macOS with Bash and Zenity

## Introduction

In the fast-paced world of technology, efficiency is key. Automation scripts are the unsung heroes that save us from the monotony of repetitive tasks, letting us focus on what truly matters. Today, I'm excited to share an automation script I developed to automatically close certain applications at the end of the day on macOS. This script combines the power of bash scripting and Zenity, a robust tool for creating graphical dialog boxes in shell scripts.

## Overview of the Solution

This automation solution consists of two main components:

1. **A Bash Script**: Handles the logic for detecting and closing applications with user confirmation
2. **A LaunchAgent Configuration**: Schedules the script to run at a specific time each day

By the end of this tutorial, you'll have a fully automated system that prompts you to close work-related applications at the end of your workday, helping you maintain a healthy work-life balance.

## Prerequisites

Before diving into the script, ensure you have the following:

- **macOS**: This solution is designed specifically for macOS systems
- **Homebrew**: The package manager for macOS (install from [brew.sh](https://brew.sh/))
- **Zenity**: A tool for displaying GTK+ dialog boxes in command-line scripts

To install Zenity using Homebrew, run:

```bash
brew install zenity
```

## The Bash Script: Breaking It Down

Let's examine the script in detail, section by section.

### Part 1: Initial Setup and Prerequisites

The first section prepares the script for execution by defining the applications to close and ensuring the required tools like Zenity are available.

```bash
#!/bin/bash

# Array of applications to close
apps=("iTerm2" "Microsoft Outlook" "Microsoft Teams" "AnyDesk" "Microsoft Edge" "WhatsApp")

# Path to the icon for the Zenity dialog
icon_path="/Sunset.png"

# Current time for logging
Time_of_Day="$(date +'%H:%M:%S')"

# Array to store successfully closed apps
successfully_closed=()

# Function to check if Zenity is installed
check_zenity_installed() {
    command -v zenity >/dev/null 2>&1 || { 
        echo "${Time_of_Day} | [ERROR] Zenity is not installed. Please install Zenity to run this script."
        exit 1
    }
}

# Function to check if any of the apps are running
check_running_apps() {
    for app in "${apps[@]}"; do
        if pgrep -i "$app" > /dev/null; then
            echo "${Time_of_Day} | [INFO] $app is running. Starting closure process."
            return 0
        fi
    done
    return 1
}
```

**Explanation**:

- **App List**: Define the applications you want to close in the apps array. Customize this list to include your frequently used work applications.
- **Environment Setup**: Set paths for the icon and current time for logging purposes. The icon path should be adjusted to match your system.
- **Zenity Check**: Ensure Zenity is installed before proceeding with the script execution.
- **Running Apps Check**: Detect whether any of the listed apps are currently running to avoid unnecessary prompts. The `pgrep -i` command uses case-insensitive matching, which is important because process names might not exactly match the application names in capitalization.

### Part 2: User Interaction and App Closure

Next, the script prompts the user to confirm closing the apps, then proceeds with the closure.

```bash
# Function to prompt the user for confirmation using Zenity
main_automation() {
    GTK_THEME=Adwaita:dark zenity --question \
        --text="As the day comes to an end, I will close all work-related applications within the next few seconds." \
        --timeout=300 \
        --icon="${icon_path}" \
        --width=500 \
        --title='End of the Day Alert!'
    local exit_status=$?
    if [ $exit_status -eq 5 ]; then
        exit_status=0
    fi
    if [ $exit_status -eq 0 ]; then
        echo "${Time_of_Day} | [INFO] User clicked Continue. Proceeding..."
        quit_apps "${apps[@]}"
    else
        echo "${Time_of_Day} | [INFO] User clicked Cancel. Exiting..."
        exit 0
    fi
}

# Function to close applications
quit_apps() {
    local app_list=("$@")
    echo "${Time_of_Day} | [INFO] Starting app closure..."
    for app in "${app_list[@]}"; do
        if pgrep -i "$app" > /dev/null; then
            echo "${Time_of_Day} | [INFO] Closing $app"
            pkill -f "$app"
            successfully_closed+=("$app")
        else
            echo "${Time_of_Day} | [ERROR] $app is not running (Exit Code: $?)"
        fi
    done
    display_result_alert
}
```

**Explanation**:

- **Zenity Prompt**: Displays a dialog box asking for confirmation from the user. The dialog includes:
  - A descriptive message
  - A timeout of 300 seconds (5 minutes)
  - A custom icon
  - A specified width for better readability
  - A clear title indicating the purpose
- **Exit Status Handling**: The script checks the exit status from Zenity to determine the user's choice. The special check for `exit_status -eq 5` handles the case when the dialog times out, treating it as if the user clicked "Continue".
- **Quit Apps Function**: Iterates through the apps list and closes any that are running using the `pkill` command. The `-f` flag ensures that the command matches against the full command line, which is more reliable for identifying applications than just the process name.

### Part 3: Display Results and Script Execution

Finally, the script summarizes the results and controls the flow using a main function.

```bash
# Function to display the result in an alert
display_result_alert() {
    if [ "${#successfully_closed[@]}" -eq 0 ]; then
        exit 0
    else
        local success_message="Successfully closed the following apps:\n$(printf "👉🏻 %s\n" "${successfully_closed[@]}")"
        osascript -e 'tell app "System Events" to display dialog "'"${success_message}"'" buttons {"OK"} default button "OK" giving up after 300 with title "Apps Closed"' >/dev/null 2>&1
    fi
}

# Main function
main() {
    echo "######## $(date +'%d-%m-%Y') App Closure Automation Log ########"
    check_zenity_installed
    if check_running_apps; then
        main_automation
    else
        echo "${Time_of_Day} | [INFO] All apps are already closed. Exiting..."
        exit 0
    fi
}

# Start the script
main
```

**Explanation**:

- **Result Alert**: Uses osascript (AppleScript) to display a dialog summarizing the closed apps, providing clear feedback to the user. Note that on newer macOS versions, you might need to grant permissions for automation to the Terminal or script executor.
- **Main Function**: Handles the script's overall flow by:
  - Creating a log header with the current date
  - Checking if Zenity is installed
  - Verifying if any target apps are running
  - Initiating the main automation process if conditions are met
- **Script Execution**: The script starts by calling the main function.

Save this script as `Quit_apps.sh` in your preferred directory (we'll use `/Users/rohirikman/Documents/Personal-Automation/.Scripts/` in this example).

### Creating a Simple Sunset Icon

If you don't have a sunset icon for the dialog, you can either:

1. Download one from a free icon site like [Flaticon](https://www.flaticon.com/) or [Iconfinder](https://www.iconfinder.com/)
2. Use a default system icon by modifying the Zenity command to use `--icon-name=dialog-information` instead of the custom icon path
3. Create a simple colored square as a placeholder:

```bash
# Create a simple colored icon using AppleScript and Preview
osascript -e 'tell application "Preview" to make new document with properties {name:"Sunset.png", width:100, height:100}' -e 'tell application "Preview" to close window 1 saving in "/Users/rohirikman/Documents/Personal-Automation/.Scripts/Icons/Sunset.png"'
```

## Scheduling with LaunchAgents

Now that we have our script ready, let's set it up to run automatically at the end of each workday.

### Understanding launchd and LaunchAgents

macOS uses a system called launchd to manage background processes and scheduled tasks. There are two main types of launchd configurations:

1. **LaunchDaemons**: Run at system level, without user interface access
2. **LaunchAgents**: Run in the user's session, with access to the user interface

For our script, which requires user interaction through Zenity dialogs, we need to use LaunchAgents.

### Configuring LaunchAgents

Below is a property list (plist) file for scheduling the script and ensuring the necessary environment variables are available.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.rohirikman.closeapps</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/rohirikman/Documents/Personal-Automation/.Scripts/Quit_apps.sh</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/rohirikman/Documents/Personal-Automation/.Scripts/</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin:/Users/rohirikman/Documents/Personal-Automation/.Scripts/</string>
    </dict>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>18</integer>
        <key>Minute</key>
        <integer>30</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/rohirikman/Documents/Personal-Automation/.Scripts/Logs/closingapp.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/rohirikman/Documents/Personal-Automation/.Scripts/Logs/closingapp_error.log</string>
</dict>
</plist>
```

**Key Configuration Elements**:

1. **Label**: Identifies the task as `com.rohirikman.closeapps`. This should follow the reverse-domain naming convention.
2. **ProgramArguments**: Specifies the location of the script to be executed.
3. **WorkingDirectory**: Sets the working directory for the script execution.
4. **EnvironmentVariables**: Ensures all necessary paths are available, including Homebrew binaries which are essential for Zenity to work. This is particularly important because LaunchAgents don't inherit the user's full environment, so paths to Homebrew binaries (like Zenity) must be explicitly included.
5. **StartCalendarInterval**: Schedules the task to run at 6:30 PM (18:30). Adjust this time to match your preferred end-of-workday time.
6. **Log Paths**: Directs output and error logs to specified locations for troubleshooting.

### Setting Up the LaunchAgent

Follow these steps to set up your LaunchAgent:

1. **Create necessary directories**: Ensure your script and log directories exist.

```bash
mkdir -p ~/Documents/Personal-Automation/.Scripts/Logs
mkdir -p ~/Documents/Personal-Automation/.Scripts/Icons
```

2. **Make the script executable**:

```bash
chmod +x ~/Documents/Personal-Automation/.Scripts/Quit_apps.sh
```

3. **Save the plist file**: Save it as `com.rohirikman.closeapps.plist` in `~/Library/LaunchAgents/`.

```bash
# Create the file
touch ~/Library/LaunchAgents/com.rohirikman.closeapps.plist

# Open it in a text editor to paste the XML content
open -a TextEdit ~/Library/LaunchAgents/com.rohirikman.closeapps.plist
```

4. **Load the LaunchAgent**:

```bash
launchctl load ~/Library/LaunchAgents/com.rohirikman.closeapps.plist
```

5. **Verify the LaunchAgent**:

```bash
launchctl list | grep com.rohirikman.closeapps
```

6. **Manually start the LaunchAgent** (for testing):

```bash
launchctl start com.rohirikman.closeapps
```

Note that the `start` command uses the label from the plist file, not the path to the plist file.

### Running Only on Weekdays

To make the script run only on weekdays, you can modify it to check the current day of the week:

```bash
# Add this to the main function before calling main_automation
day_of_week=$(date +%u)
if [ "$day_of_week" -gt 5 ]; then
    echo "${Time_of_Day} | [INFO] Today is a weekend. Skipping app closure."
    exit 0
fi
```

This uses the `date +%u` command, which returns 1-7 for Monday-Sunday. Values greater than 5 represent Saturday and Sunday.

## Logging and Troubleshooting

The LaunchAgent configuration directs both standard output and error messages to log files. These logs are invaluable for troubleshooting issues with your automation.

### Reading and Interpreting Logs

To check the logs for any issues:

```bash
# View standard output log
cat ~/Documents/Personal-Automation/.Scripts/Logs/closingapp.log

# View error log
cat ~/Documents/Personal-Automation/.Scripts/Logs/closingapp_error.log

# Monitor logs in real-time
tail -f ~/Documents/Personal-Automation/.Scripts/Logs/closingapp.log
```

Common log entries you might see:

- `[INFO] All apps are already closed. Exiting...` - Script ran but found no target apps running
- `[INFO] User clicked Cancel. Exiting...` - User dismissed the dialog
- `[ERROR] Zenity is not installed. Please install Zenity to run this script.` - Zenity is missing or not in PATH

### Log Rotation

For long-term use, consider implementing log rotation to prevent log files from growing too large:

```bash
# Add to your script to rotate logs when they exceed 1MB
if [ -f "$log_file" ] && [ $(stat -f%z "$log_file") -gt 1048576 ]; then
    mv "$log_file" "${log_file}.old"
fi
```

## Troubleshooting Common Issues

If you encounter issues with your LaunchAgent, consider these common problems and solutions:

1. **Script permissions**: Ensure your script is executable.

```bash
chmod +x ~/Documents/Personal-Automation/.Scripts/Quit_apps.sh
```

2. **Path issues**: Verify that all paths in the plist file are absolute and correct for your system.

3. **Log directory**: Make sure the log directory exists before loading the LaunchAgent.

4. **Environment variables**: If your script uses commands from Homebrew or other non-standard locations, ensure they're included in the PATH environment variable in the plist file.

5. **GUI elements not working**: Confirm you're using LaunchAgents (not LaunchDaemons) for scripts with GUI components.

6. **LaunchAgent not running**: If the agent doesn't run at the scheduled time, check the log files for errors.

```bash
cat ~/Documents/Personal-Automation/.Scripts/Logs/closingapp_error.log
```

7. **Changes not taking effect**: After modifying the plist file, remember to unload and reload it.

```bash
launchctl unload ~/Library/LaunchAgents/com.rohirikman.closeapps.plist
launchctl load ~/Library/LaunchAgents/com.rohirikman.closeapps.plist
```

8. **AppleScript permissions**: On newer macOS versions, you might need to grant Terminal (or your script executor) permissions in System Preferences > Security & Privacy > Privacy > Automation.

## Customization Options

This automation script can be customized in several ways:

1. **Application List**: Modify the `apps` array to include the applications you use regularly.

2. **Schedule**: Adjust the `Hour` and `Minute` values in the plist file to change when the script runs.

3. **Dialog Appearance**: Customize the Zenity dialog by modifying parameters like `--timeout`, `--width`, or `--text`.

4. **Icon**: Replace the sunset icon with your preferred image to personalize the dialog.

5. **Conditional Execution**: Add logic to only run on weekdays or based on other conditions.

## Conclusion

Automating the closure of work applications at the end of the day is a small but significant step toward better work-life balance. By understanding the differences between launchd and LaunchAgents, you can create powerful automation workflows that integrate seamlessly with macOS.

This approach can be extended to other automation tasks that require user interaction or GUI elements. The combination of bash scripting, Zenity for dialogs, and LaunchAgents for scheduling provides a robust framework for macOS automation.

I hope this guide helps you create your own automation scripts. Feel free to customize the code to suit your specific needs and workflow.

## Next Steps

- Explore other automation possibilities with LaunchAgents
- Customize the script to include your frequently used applications
- Consider adding more sophisticated conditions, such as only closing apps on weekdays
- Share your automation scripts with the community to inspire others

For the complete script and additional resources, check out my [GitHub repository - CloudJourneyBlog](https://github.com/RohiRIK/CloudJourneyBlog/tree/b9866b6d3989a14aed91aac8b6ceb00278c4a25d/posts/automation_projects/end_of_day).


Happy automating!

