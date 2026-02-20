#!/bin/bash
# Wrapper script to run get.scpt and get normal shell output for cron

# Get the directory where this script is located to reliably find get.scpt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

echo "--- Starting mail export at $(date) ---"

# Execute the AppleScript
/usr/bin/osascript "${SCRIPT_DIR}/get.scpt"

echo "--- Finished mail export at $(date) ---"

