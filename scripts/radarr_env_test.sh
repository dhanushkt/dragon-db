#!/bin/bash
# Script to test Radarr docker ENV variables using Custom Script connection type
# Author: Dragon DB

# Global Log Variables
log_current_date=$(date +"%d-%m-%Y")
log_output_file="/home/trinityvoid/scripts/radarr_mkvrename_log_${log_current_date}.txt"
# Log flag to log mkvinfo & mediainfo if there are any changes
# mkv_log=true

echo "=================================================================" >> "$log_output_file"
echo "Script Date: $log_current_date" >> "$log_output_file"
echo "Log file name: $log_output_file" >> "$log_output_file"


# mkv rename function script
# Function to view/delete/replace track names
source /home/trinityvoid/scripts/radarr_func_mkvrename.sh

# Test that this is a download event, so we don't run on grab or rename.
#if [[ "${radarr_eventtype}" != "Download" ]]; then
    #echo "Radarr Event Type is NOT Download, exiting."
    #exit
#fi

# TODO - Add date and time of changes
# TODO - Add a good line seperator to distinguish each log entry

echo "" >> "$log_output_file"
echo "> Movie Name | --------------------------------------------------" >> "$log_output_file"
echo "$radarr_movie_title" >> "$log_output_file"
echo "-----------------------------------------------------------------" >> "$log_output_file"

echo "" >> "$log_output_file"
echo "> Radarr ENV variables | ----------------------------------------" >> "$log_output_file"

# radarr_moviefile_relativepath: provides mkv filename (Movie Name 1080p.mkv)
echo "radarr_moviefile_relativepath: $radarr_moviefile_relativepath" >> "$log_output_file"

# radarr_moviefile_path: full path to movie file after import including mkv filename (/path/Movies/Movie Name/Movie Name 1080p.mkv)
echo "radarr_moviefile_path: $radarr_moviefile_path" >> "$log_output_file"

# radarr_movie_path: full path to movie folder after import excluding mkv filename (/path/Movies/Movie Name) 
echo "radarr_movie_path: $radarr_movie_path" >> "$log_output_file"

# radarr_moviefile_sourcepath: full path to download client save location including mkv filename (/path/downloads/Movie.Name.1080p.mkv)
echo "radarr_moviefile_sourcepath: $radarr_moviefile_sourcepath" >> "$log_output_file"

echo "-----------------------------------------------------------------" >> "$log_output_file"

# Check if the filename ends with ".mkv"
if [[ "$radarr_moviefile_path" != *.mkv ]]; then
    echo "" >> "$log_output_file"
    echo "The provided filename is not a .mkv file. Exiting" >> "$log_output_file"
    echo "=================================================================" >> "$log_output_file"
    echo "" >> "$log_output_file"
    echo "" >> "$log_output_file"
    exit 0
fi

# Define an array of word to remove and pass it as arguments to mkv_rename_func
words_to_remove_arr=("TamilMV" "TamilCV" "Unwanted")

# Iterate over the array and call mkv_rename function
for word in "${words_to_remove_arr[@]}"; do
    #mkv_rename_func "$radarr_moviefile_path" "$word"
done

echo "> Script End | ==================================================" >> "$log_output_file"
echo "=================================================================" >> "$log_output_file"
echo "" >> "$log_output_file"
echo "" >> "$log_output_file"

exit 0