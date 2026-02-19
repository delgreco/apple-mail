#!/bin/bash
# Wrapper script to run get.scpt and handle logging.

# Get the directory where this script is located to reliably find get.scpt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOG_FILE="${SCRIPT_DIR}/getmail.log"

echo "--- Starting mail export at $(date) ---" >> "$LOG_FILE"

# Execute the AppleScript and redirect all output (stdout and stderr) to the log file.
/usr/bin/osascript "${SCRIPT_DIR}/get.scpt" >> "$LOG_FILE" 2>&1

echo "--- Finished mail export at $(date) ---" >> "$LOG_FILE"

echo "Script executed. Log output is in ${LOG_FILE}"
