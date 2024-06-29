#!/bin/bash
# Script to automatically remove unwanted names from MKV track metadata after Radarr/Sonarr import or upgrade
# PHP API is implamented to trigger this script remotely | MKVRN
# Requirements: mkvinfo, mkvpropedit
# Author: Dragon DB

# Global Log Variables
mkvlog_current_datetime=$(date +"%d-%m-%Y_%H-%M-%S")
mkvlog_output_file="/home/trinityvoid/scripts/mkvrename_api_logs/mkvrename_api_sh_log_${mkvlog_current_datetime}.txt"
# Log flag to log mkvinfo & mediainfo if there are any changes
mkv_log=true

mkv_rename_func() {
    # Full file path of .mkv file (argument)
    local filename=$1
    # Word to be searched in Track name (argument)
    local word_to_remove=$2
    
    echo "=================================================================" >> "$mkvlog_output_file"
    echo "> MKV Rename Function | -----------------------------------------" >> "$mkvlog_output_file"
    echo "" >> "$mkvlog_output_file"
    echo "> File Name | ---------------------------------------------------" >> "$mkvlog_output_file"
    echo "$filename" >> "$mkvlog_output_file"
    echo "> Word to remove | ----------------------------------------------" >> "$mkvlog_output_file"
    echo "$word_to_remove" >> "$mkvlog_output_file"
    
    # Loop through tracks and delete the name field if it contains the "word_to_remove"
    mkvinfo "$filename" | grep "Track number" | while read -r line; do
        track_number=$(echo "$line" | awk '{print $5}')
        
        # echo "#################################################################" >> "$mkvlog_output_file"
        echo "_________________________________________________________________" >> "$mkvlog_output_file"
        echo "> | TRACK NUMBER: $track_number |" >> "$mkvlog_output_file"
        
        current_name=$(mkvinfo "$filename" | grep -A 10 "Track number: $track_number" | grep "Name" | sed 's/^[[:space:]]*Name:[[:space:]]*//;s/^[^:]*: //')
        
        #echo "" >> "$mkvlog_output_file"
        echo "> current_name: " >> "$mkvlog_output_file"
        echo "$current_name" >> "$mkvlog_output_file"
        
        # TODO - Regex implimentation for searching the word to remove in one go
        if [[ "$current_name" == *"$word_to_remove"* ]]; then
            new_name=$(echo "$current_name" | sed "s/$word_to_remove//g")
            
            echo "> word: $word_to_remove found in track: $track_number" >> "$mkvlog_output_file"
            echo "> new_name: " >> "$mkvlog_output_file"
            echo "$new_name"
            
            # Log mediainfo & mkvinfo only once and only if there is a word changes
            if [ "$mkv_log" = true ]; then
                echo "" >> "$mkvlog_output_file"
                echo "-----------------------------------------------------------------" >> "$mkvlog_output_file"
                echo "> Media Info START | --------------------------------------------" >> "$mkvlog_output_file"
                mediainfo "$filename" >> "$mkvlog_output_file"
                echo "> Media Info END | ----------------------------------------------" >> "$mkvlog_output_file"
                echo "" >> "$mkvlog_output_file"
                echo "> MKV Info START | ----------------------------------------------" >> "$mkvlog_output_file"
                mkvinfo "$filename" >> "$mkvlog_output_file"
                echo "> MKV Info END | ------------------------------------------------" >> "$mkvlog_output_file"
                echo "-----------------------------------------------------------------" >> "$mkvlog_output_file"
                
                # ntfy notification on matched names
                # Extract the filename using basename
                base_mkvfilename=$(basename "$filename")
                curl -H "Tags: rotating_light,MKVRN-API" -d "[MKVRN-API] Found $word_to_remove in $base_mkvfilename" "ntfy.sh/dragondb_ntfy"
                
                declare -g mkv_log=false
            fi
            
            #echo "" >> "$mkvlog_output_file"
            echo "Executing mkv delete name process on Track: $track_number" >> "$mkvlog_output_file"
            mkvpropedit "$filename" --edit track:$track_number --delete name
            
            #echo "" >> "$mkvlog_output_file"
            echo "Word '$word_to_remove' removed from Track $track_number name metadata."
            echo "Word '$word_to_remove' removed from Track $track_number name metadata." >> "$mkvlog_output_file"
            echo "_________________________________________________________________" >> "$mkvlog_output_file"
        else
            #echo "" >> "$mkvlog_output_file"
            echo "Word '$word_to_remove' not found in Track $track_number name metadata."
            echo "Word '$word_to_remove' not found in Track $track_number name metadata. Skipping." >> "$mkvlog_output_file"
            echo "_________________________________________________________________" >> "$mkvlog_output_file"
        fi
    done
    
    return
}

# Check if exactly one argument (the MKV file path) is provided
if [ "$#" -ne 1 ]; then
    echo "Invalid number of arguments provided"
    echo "Invalid Argments, Usage: $0 <path_to_mkv_file>" >> "$mkvlog_output_file"
    exit 1
fi

# Get the MKV file path from the argument
full_mkv_path="$1"

# Echo the MKV file path
echo "Received MKV file path: $full_mkv_path "
echo "#################################################################" >> "$mkvlog_output_file"
echo "Received MKV file path: $full_mkv_path" >> "$mkvlog_output_file"
echo "" >> "$mkvlog_output_file"

# Check if the provided file is a .mkv file & it exists
if [[ "$full_mkv_path" != *.mkv ]] || [ ! -f "$full_mkv_path" ]; then
    echo "Error: The provided file is not a .mkv file or does not exist."
    echo "Error: The provided file is not a .mkv file or does not exist." >> "$mkvlog_output_file"
    exit 1
fi

# Define an array of word to remove and pass it as arguments to mkv_rename_func
words_to_remove_arr=("TamilMV" "TamilCV" "GalaxyRG" "MovieRulz" "TamilBlasters" "Full4Movies")

# Iterate over the array and call mkv_rename function
for word in "${words_to_remove_arr[@]}"; do
    mkv_rename_func "$full_mkv_path" "$word"
done

echo "MKVRename API Script executed successfully"
echo "=================================================================" >> "$mkvlog_output_file"
echo "" >> "$mkvlog_output_file"
echo "" >> "$mkvlog_output_file"