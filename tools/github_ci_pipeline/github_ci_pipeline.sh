#!/bin/bash
# Script to automatically update the sync_script_file.sh script from GitHub


# Check if script is called with two arguments, $1 = github_raw_url, $2 = local_file_path
if [ "$#" -ne 2 ]; then
    echo ">[sh] Invalid number of arguments provided, Usage: $0 <github_raw_url> <local_file_path>"
    exit 1
fi

# URL of the raw file from GitHub
GITHUB_URL=$1
LOCAL_FILE_PATH=$2
LOCAL_FILE_NAME=$(basename "$LOCAL_FILE_PATH")

echo ">[sh] Remote Pipeline Script Started | "
echo ">[sh] GitHub URL: $GITHUB_URL"
echo ">[sh] Local file path: $(realpath $LOCAL_FILE_PATH)"
echo ">[sh] File path: $(dirname $LOCAL_FILE_PATH)"
echo ">[sh] File name: $LOCAL_FILE_NAME"

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

# change the directory to LOCAL_FILE_PATH
cd $(dirname $LOCAL_FILE_PATH)
# Write the content to the LOCAL_FILE_NAME (replace if exists, create if not)
echo "$CONTENT" > $LOCAL_FILE_NAME

# Check if the file write was successful
if [ $? -eq 0 ]; then
    echo ">[sh] File $LOCAL_FILE_NAME Synced from GitHub successfully."
else
    echo ">[sh] Failed to Sync with the file $LOCAL_FILE_NAME"
    exit 1
fi

# Check if the file has execute permission
if [ ! -x "$LOCAL_FILE_NAME" ]; then
    echo ">[sh] File does not have execute permission. Adding execute permission..."
    chmod +x "$LOCAL_FILE_NAME"
    
    # Verify if chmod was successful
    if [ $? -eq 0 ]; then
        echo ">[sh] Execute permission added successfully to $LOCAL_FILE_NAME"
    else
        echo ">[sh] Failed to add execute permission to $LOCAL_FILE_NAME"
        exit 1
    fi
else
    echo ">[sh] File already has execute permission."
fi

echo ">[sh] Remote Pipeline Script Completed | "