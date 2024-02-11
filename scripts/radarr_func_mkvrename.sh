#!/bin/bash
# Script to automatically remove unwanted names from MKV track metadata after Radarr import / upgrade
# Requirements: mkvinfo, mkvpropedit
# Author: Dragon DB

# Global Log Variables
mkvlog_current_date=$(date +"%d-%m-%Y")
mkvlog_output_file="/home/trinityvoid/scripts/mkvrename_logs/radarr_mkvrename_log_${mkvlog_current_date}.txt"
# Log flag to log mkvinfo & mediainfo if there are any changes
mkv_log=true

mkv_rename_func() {
    # Full file path of .mkv file (argument)
    local filename=$1
    # Word to be searched in Track name (argument)
    local word_to_remove=$2
    
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
        
        echo "" >> "$mkvlog_output_file"
        echo "> current_name | ------------------------------------------------" >> "$mkvlog_output_file"
        echo "$current_name" >> "$mkvlog_output_file"
        
        # TODO - Regex implimentation for searching the word to remove in one go
        if [[ "$current_name" == *"$word_to_remove"* ]]; then
            new_name=$(echo "$current_name" | sed "s/$word_to_remove//g")
            
            echo "> new_name | ----------------------------------------------------" >> "$mkvlog_output_file"
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
                curl -d "Found $word_to_remove in $base_mkvfilename" "ntfy.sh/dragondb_ntfy"
                
                declare -g mkv_log=false
            fi
            
            echo "" >> "$mkvlog_output_file"
            echo "Executing --delete name Process on Track: $track_number" >> "$mkvlog_output_file"
            mkvpropedit "$filename" --edit track:$track_number --delete name
            
            echo "" >> "$mkvlog_output_file"
            echo "Word '$word_to_remove' removed from Track $track_number name field." >> "$mkvlog_output_file"
            echo "_________________________________________________________________" >> "$mkvlog_output_file"
        else
            echo "" >> "$mkvlog_output_file"
            echo "Word '$word_to_remove' not found in Track $track_number name field. Skipping." >> "$mkvlog_output_file"
            echo "_________________________________________________________________" >> "$mkvlog_output_file"
        fi
    done
    return
}