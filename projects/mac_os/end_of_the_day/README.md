# End of the Day - App Closure Automation 🌅

A macOS automation script that helps you wind down at the end of your workday by automatically closing work-related applications with a friendly notification.

## 📖 Overview

This project provides an automated solution to close specific work applications at a scheduled time, helping you maintain work-life balance by creating a clear transition from work to personal time.

## ✨ Features

- **Scheduled Automation**: Runs automatically at 18:30 (6:30 PM) daily via launchd
- **User-Friendly Interface**: Uses Zenity for elegant dialog prompts with custom sunset icon
- **Smart Detection**: Only runs when target applications are actually running
- **Graceful Closure**: Provides 5-minute timeout for user response
- **Comprehensive Logging**: Tracks all actions with timestamps
- **Weekend Awareness**: Optional weekday-only execution (commented out by default)
- **Result Notification**: Shows which apps were successfully closed

## 🎯 Target Applications

By default, the script closes these work-related applications:
- iTerm2
- Microsoft Outlook
- Microsoft Teams
- AnyDesk
- Microsoft Edge
- WhatsApp

## 📁 Project Structure

```
end_of_the_day/
├── end_of_day.sh                     # Main automation script
├── com.endofday.closeapps.plist       # launchd configuration file
├── assets/
│   └── Sunset.png                     # Custom icon for notifications
└── README.md                          # This file
```

## 🚀 Installation

### Prerequisites

1. **Install Zenity** (for GUI dialogs):
   ```bash
   brew install zenity
   ```

2. **Make the script executable**:
   ```bash
   chmod +x end_of_day.sh
   ```

### Manual Setup

1. **Test the script manually**:
   ```bash
   ./end_of_day.sh
   ```

### Automated Setup (launchd)

1. **Update the plist file**:
   - Edit `com.endofday.closeapps.plist`
   - Replace `USERNAME` with your actual username
   - Update paths to match your script location

2. **Install the launchd job**:
   ```bash
   # Copy to LaunchAgents directory
   cp com.endofday.closeapps.plist ~/Library/LaunchAgents/
   
   # Load the job
   launchctl load ~/Library/LaunchAgents/com.endofday.closeapps.plist
   
   # Enable the job
   launchctl enable gui/$(id -u)/com.endofday.closeapps
   ```

3. **Verify installation**:
   ```bash
   launchctl list | grep closeapps
   ```

## ⚙️ Configuration

### Customizing Applications

Edit the `apps` array in `end_of_day.sh`:
```bash
apps=("iTerm2" "Microsoft Outlook" "Microsoft Teams" "AnyDesk" "Microsoft Edge" "WhatsApp")
```

### Changing Schedule

Modify the time in `com.endofday.closeapps.plist`:
```xml
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>18</integer>  <!-- 6 PM -->
    <key>Minute</key>
    <integer>30</integer>  <!-- 30 minutes -->
</dict>
```

### Enable Weekday-Only Mode

Uncomment line 111 in `end_of_day.sh`:
```bash
check_weekday  # Uncomment this line
```

## 🎛️ Usage

### Manual Execution
```bash
./end_of_day.sh
```

### Automated Execution
Once configured with launchd, the script runs automatically at the scheduled time.

### User Interaction
1. **Dialog Prompt**: A Zenity dialog appears asking for confirmation
2. **Options**: 
   - Click "Yes" or wait 5 minutes (timeout) → Apps will be closed
   - Click "No" → Script exits without closing apps
3. **Results**: A system notification shows which apps were closed

## 📊 Logging

The script provides detailed logging with timestamps:
- Application detection status
- User interaction results
- Successful/failed closure attempts
- Error messages and debugging information

## 🔧 Troubleshooting

### Common Issues

1. **Zenity not found**:
   ```bash
   brew install zenity
   ```

2. **Permission denied**:
   ```bash
   chmod +x end_of_day.sh
   ```

3. **launchd job not running**:
   ```bash
   # Check job status
   launchctl list | grep closeapps
   
   # Reload if needed
   launchctl unload ~/Library/LaunchAgents/com.endofday.closeapps.plist
   launchctl load ~/Library/LaunchAgents/com.endofday.closeapps.plist
   ```

4. **Icon not displaying**:
   - Ensure `assets/Sunset.png` exists in the script directory
   - Script will fall back to default system icon if custom icon is missing

### Debugging

Check launchd logs:
```bash
log show --predicate 'subsystem == "com.apple.launchd"' --last 1h | grep closeapps
```

## 🔄 Uninstallation

To remove the automation:
```bash
# Disable and unload the job
launchctl disable gui/$(id -u)/com.endofday.closeapps
launchctl unload ~/Library/LaunchAgents/com.endofday.closeapps.plist

# Remove the plist file
rm ~/Library/LaunchAgents/com.endofday.closeapps.plist
```

## 🤝 Contributing

Feel free to fork this project and submit pull requests for:
- Additional application support
- UI/UX improvements
- Cross-platform compatibility
- Bug fixes and optimizations

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Zenity for providing elegant cross-platform dialogs
- macOS launchd for reliable scheduling
- The open-source community for inspiration and best practices

---

*"A good day's work deserves a good day's rest."* 🌅

