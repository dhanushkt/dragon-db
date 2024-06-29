#!/bin/bash
# MKVRN API
# Bash Script to automatically remove unwanted names from MKV track metadata
# PHP API is implemented to trigger this script remotely on Radarr/Sonarr import and upgrade
# Requirements: mkvinfo, mkvpropedit
# Author: Dragon DB
# Version: 1.1

# Check if script is called with exactly two argument, $1 = path to .mkv file, $2 = media_title
if [ "$#" -ne 2 ]; then
    echo "> Invalid number of arguments provided, Usage: $0 <path_to_mkv_file> <media_title>"
    exit 1
fi

# Get the MKV file path & media title from the arguments
full_file_path="$1"
media_title="$2"

# Creating the log file
mkvlog_current_datetime=$(date +"%d-%m-%Y_%H-%M-%S")
mkvlog_output_file="/home/trinityvoid/scripts/mkvrename_api_logs/${media_title}_${mkvlog_current_datetime}_mkvrn_sh_log.txt"
# Log flag to log mkvinfo & mediainfo only once if there is track metadata changes
mkv_log=true

# Logging the received full file path
echo "> Received full file path: $full_file_path "
echo "#################################################################" >> "$mkvlog_output_file"
echo "> Received full file path: $full_file_path" >> "$mkvlog_output_file"
echo "" >> "$mkvlog_output_file"

# Check if the provided file is a .mkv file & it exists
if [[ "$full_file_path" != *.mkv ]] || [ ! -f "$full_file_path" ]; then
    echo "> Error: The provided file is not a .mkv file or does not exist."
    echo "> Error: The provided file is not a .mkv file or does not exist." >> "$mkvlog_output_file"
    exit 1
fi

# URL to get the list words to remove (.txt file)
WORDS_URL="https://app.infinitysystems.in/api/words_to_remove.txt"
# Local temporary file to store the downloaded content
TMP_FILE="./TEMP_words_to_remove.txt"
# Download the content to the temporary file
curl -s -o "$TMP_FILE" "$WORDS_URL"
# Read the TEMP file into an array
IFS=$'\r\n' GLOBIGNORE='*' command eval 'words_to_remove_arr=($(cat $TMP_FILE))'
# Logging the list of words to remove
echo "> List of words to remove: ${words_to_remove_arr[*]}"
echo "> List of words to remove: ${words_to_remove_arr[*]}" >> "$mkvlog_output_file"
echo "" >> "$mkvlog_output_file"


# MKV Rename Function START
# Function to delete the name metadata if it contains the any words in list array "words_to_remove" from the .mkv file
echo "=================================================================" >> "$mkvlog_output_file"
echo "> START MKV Rename Function | -----------------------------------" >> "$mkvlog_output_file"
echo "" >> "$mkvlog_output_file"
echo "> Full File Path:" >> "$mkvlog_output_file"
echo "$full_file_path" >> "$mkvlog_output_file"

# Loop through tracks and delete the name field if it matches the "word"
mkvinfo "$full_file_path" | grep "Track number" | while read -r line; do
    track_number=$(echo "$line" | awk '{print $5}')
    echo "_________________________________________________________________" >> "$mkvlog_output_file"
    echo "> TRACK NUMBER: $track_number |" >> "$mkvlog_output_file"
    
    # Get the current name of the track
    current_name=$(mkvinfo "$full_file_path" | grep -A 10 "Track number: $track_number" | grep "Name" | sed 's/^[[:space:]]*Name:[[:space:]]*//;s/^[^:]*: //')
    echo "> current name: " >> "$mkvlog_output_file"
    echo "$current_name" >> "$mkvlog_output_file"
    
    for word in "${words_to_remove_arr[@]}"; do
        echo "> selected to remove: $word" >> "$mkvlog_output_file"
        
        # TODO - Regex implimentation for searching the word to remove in one go
        if [[ "$current_name" == *"$word"* ]]; then
            new_name=$(echo "$current_name" | sed "s/$word//g")
            echo "> word: $word found in track: $track_number" >> "$mkvlog_output_file"
            echo "> new name: " >> "$mkvlog_output_file"
            echo "$new_name" >> "$mkvlog_output_file"
            
            # Log mediainfo & mkvinfo based on flag (when there is track metadata changes)
            if [ "$mkv_log" = true ]; then
                echo "" >> "$mkvlog_output_file"
                echo "-----------------------------------------------------------------" >> "$mkvlog_output_file"
                echo "> Media Info START | --------------------------------------------" >> "$mkvlog_output_file"
                mediainfo "$full_file_path" >> "$mkvlog_output_file"
                echo "> Media Info END | ----------------------------------------------" >> "$mkvlog_output_file"
                echo "" >> "$mkvlog_output_file"
                echo "> MKV Info START | ----------------------------------------------" >> "$mkvlog_output_file"
                mkvinfo "$full_file_path" >> "$mkvlog_output_file"
                echo "> MKV Info END | ------------------------------------------------" >> "$mkvlog_output_file"
                echo "-----------------------------------------------------------------" >> "$mkvlog_output_file"
                
                # Send ntfy notification on track metadata changes
                # Extract only file name
                base_mkvfull_file_path=$(basename "$full_file_path")
                curl -H "Tags: rotating_light,MKVRN-API" -d "[MKVRN-API] Found $word in $base_mkvfull_file_path" "ntfy.sh/dragondb_ntfy"
                
                # Set flag to false to prevent logging the mediainfo & mkvinfo
                declare -g mkv_log=false
            fi
            
            echo "> Executing 'delete name' on Track: $track_number" >> "$mkvlog_output_file"
            mkvpropedit "$full_file_path" --edit track:$track_number --delete name
            
            echo "> Word '$word' removed from Track $track_number name metadata."
            echo "> Word '$word' removed from Track $track_number name metadata." >> "$mkvlog_output_file"
            echo "_________________________________________________________________" >> "$mkvlog_output_file"
        else
            echo "> Word '$word' not found in Track $track_number name metadata."
            echo "> Word '$word' not found in Track $track_number name metadata. Skipping." >> "$mkvlog_output_file"
            echo "_________________________________________________________________" >> "$mkvlog_output_file"
        fi
        
    done
done
# MKV Rename Function END

echo "> MKVRename API Script executed successfully"
echo "" >> "$mkvlog_output_file"
echo "> MKVRename API Script executed successfully" >> "$mkvlog_output_file"
echo "=================================================================" >> "$mkvlog_output_file"