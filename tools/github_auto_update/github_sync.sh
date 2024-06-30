#!/bin/bash
# Script to automatically update the sync_script_file.sh script from GitHub

# URL of the raw file from GitHub
GITHUB_URL="https://raw.githubusercontent.com/your-username/your-repo/main/sync_script_file.sh"
# Path to the local file
LOCAL_FILE_PATH="./sync_script_file.sh"


echo ">[sh] GitHub Sync Script Started | --------------------------"
echo ">[sh] GitHub URL: $GITHUB_URL"
echo ">[sh] Local file path: $(realpath $LOCAL_FILE_PATH)"

# Fetch the content from GitHub
CONTENT=$(curl -s $GITHUB_URL)

# Check if the curl command was successful
if [ $? -ne 0 ]; then
    echo ">[sh] Failed to fetch content from GitHub."
    exit 1
fi

# Check if content was fetched successfully
if [ -z "$CONTENT" ]; then
    echo ">[sh] No content fetched from GitHub."
    exit 1
fi

# Write the content to the local file (replace if exists, create if not)
echo "$CONTENT" > $LOCAL_FILE_PATH

# Check if the file write was successful
if [ $? -eq 0 ]; then
    echo ">[sh] File Synced from GitHub successfully."
else
    echo ">[sh] Failed to Sync the file."
    exit 1
fi

# Check if the file has execute permission
if [ ! -x "$LOCAL_FILE_PATH" ]; then
    echo ">[sh] File does not have execute permission. Adding execute permission..."
    chmod +x "$LOCAL_FILE_PATH"
    
    # Verify if chmod was successful
    if [ $? -eq 0 ]; then
        echo ">[sh] Execute permission added successfully to $LOCAL_FILE_PATH"
    else
        echo ">[sh] Failed to add execute permission to $LOCAL_FILE_PATH"
        exit 1
    fi
else
    echo ">[sh] File already has execute permission."
fi

echo ">[sh] GitHub Sync Script Completed | ------------------------"