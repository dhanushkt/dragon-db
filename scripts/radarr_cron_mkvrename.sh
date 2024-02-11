#!/bin/bash
# Script to automatically remove unwanted names from MKV track metadata based on cron job
# Running this script every 5 minutes
# */5 * * * * /home/trinityvoid/scripts/radarr_cron_mkvrename.sh >> /home/trinityvoid/scripts/mkvrename_logs/crontab_output.txt 2>&1
# Author: Dragon DB

# Global Log Variables
mkvlog_current_date=$(date +"%d-%m-%Y")
mkvlog_output_file="/home/trinityvoid/scripts/mkvrename_logs/radarr_mkvrename_log_${mkvlog_current_date}.txt"

# Directory to search for .mkv files
movies_directory="/home/trinityvoid/media/Movies"
# mkv_rename_func script location
source /home/trinityvoid/scripts/radarr_func_mkvrename.sh


find "$movies_directory" -name "*.mkv" -type f -mmin -5 |
while read -r file; do
    # Find .mkv files modified in the last 5 minutes
    echo "=================================================================" >> "$mkvlog_output_file"
    echo "> Found new MKV files | -----------------------------------------" >> "$mkvlog_output_file"
    
    # Fetch full path of the .mkv file
    full_mkv_path=$(realpath "$file")
    # Extract the filename
    mkv_filename=$(basename "$file")
    # Extract the parent directory name - for getting Movie name
    mkv_parent_directory=$(dirname "$full_mkv_path")
    
    echo "" >> "$mkvlog_output_file"
    echo "> DEBUG : file | ------------------------------------------------" >> "$mkvlog_output_file"
    echo "$file" >> "$mkvlog_output_file"
    echo "-----------------------------------------------------------------" >> "$mkvlog_output_file"
    
    echo "" >> "$mkvlog_output_file"
    echo "> Executing script on file | ------------------------------------" >> "$mkvlog_output_file"
    echo "$mkv_filename" >> "$mkvlog_output_file"
    echo "-----------------------------------------------------------------" >> "$mkvlog_output_file"
    
    # Define an array of word to remove and pass it as arguments to mkv_rename_func
    words_to_remove_arr=("TamilMV" "TamilCV" "GalaxyRG")
    
    # Iterate over the array and call mkv_rename function
    for word in "${words_to_remove_arr[@]}"; do
        mkv_rename_func "$full_mkv_path" "$word"
    done
    echo "=================================================================" >> "$mkvlog_output_file"
    echo "" >> "$mkvlog_output_file"
    echo "" >> "$mkvlog_output_file"
done

exit 0