#!/bin/bash

# Array of applications to close
apps=("iTerm2" "Microsoft Outlook" "Microsoft Teams" "AnyDesk" "Microsoft Edge" "WhatsApp")

# Path to the icon for the Zenity dialog
# Note: Update this path to match your system or use --icon-name=dialog-information for default icon
icon_path="/assets/Sunset.png"

# Current time for logging
Time_of_Day="$(date +'%H:%M:%S')"

# Array to store successfully closed apps
successfully_closed=()

# Function to check if Zenity is installed
check_zenity_installed() {
    command -v zenity >/dev/null 2>&1 || { 
        echo "${Time_of_Day} | [ERROR] Zenity is not installed. Please install Zenity to run this script."
        echo "Install Zenity using: brew install zenity"
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

# Function to prompt the user for confirmation using Zenity
main_automation() {
    # Check if icon file exists, if not use default icon
    if [ ! -f "$icon_path" ]; then
        icon_option="--icon-name=dialog-information"
    else
        icon_option="--icon=${icon_path}"
    fi
    
    GTK_THEME=Adwaita:dark zenity --question \
        --text="As the day comes to an end, I will close all work-related applications within the next few seconds." \
        --timeout=300 \
        $icon_option \
        --width=500 \
        --title='End of the Day Alert!'
    local exit_status=$?
    
    # Handle timeout (exit code 5) as if user clicked Continue
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
            echo "${Time_of_Day} | [INFO] $app is not running"
        fi
    done
    display_result_alert
}

# Function to display the result in an alert
display_result_alert() {
    if [ "${#successfully_closed[@]}" -eq 0 ]; then
        echo "${Time_of_Day} | [INFO] No applications were closed."
        exit 0
    else
        local success_message="Successfully closed the following apps:\n$(printf "👉🏻 %s\n" "${successfully_closed[@]}")"
        echo "${Time_of_Day} | [INFO] Successfully closed: ${successfully_closed[*]}"
        
        # Display AppleScript dialog with results
        osascript -e 'tell app "System Events" to display dialog "'"${success_message}"'" buttons {"OK"} default button "OK" giving up after 300 with title "Apps Closed"' >/dev/null 2>&1
    fi
}

# Function to check if it's a weekday (optional - uncomment to enable)
check_weekday() {
    day_of_week=$(date +%u)
    if [ "$day_of_week" -gt 5 ]; then
        echo "${Time_of_Day} | [INFO] Today is a weekend. Skipping app closure."
        exit 0
    fi
}

# Main function
main() {
    echo "######## $(date +'%d-%m-%Y') App Closure Automation Log ########"
    
    # Uncomment the next line to only run on weekdays
    # check_weekday
    
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

