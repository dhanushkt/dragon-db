#!/bin/bash
#Script to efficiently remove unwanted names from MKV track metadata
#Author: Dragon DB

# Present options for media types
PS3="-------------------------------------> Select media type: "
options=("Movies" "TV" "Anime")
select media_type in "${options[@]}"
do
    case $media_type in
        "Movies")
            media_path="/home/trinityvoid/media/Movies"
        ;;
        "TV")
            media_path="/home/trinityvoid/media/'TV Shows'"
        ;;
        "Anime")
            media_path="/home/trinityvoid/media/Anime"
        ;;
        *)
            echo "Invalid selection."
            exit 1
        ;;
    esac
    
    echo -e "\n"
    echo "Enter media name to search:"
    read media_name
    
    # Search for files with case-insensitive partial name match
	# TODO: search only .mkv file and sort the output when adding to array - DONE
    readarray -t found_files < <(find "$media_path" -iname "*$media_name*.mkv" -type f | sort)
    
    echo -e "\n"
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo "------------------------------------------ | Search Result | ------------------------------------------------------"
    echo "-------------------------------------------------------------------------------------------------------------------"
    
    
    if [ ${#found_files[@]} -eq 0 ]; then
        echo "No matching files found."
    else
        # Present found files as numbered options for selection
        PS3="-------------------------------------> Select the desired media file: "
        select file_option in "${found_files[@]}"
        do
            #echo $file_option
            if [ -n "$file_option" ]; then
                filename="$file_option"
                
                echo -e "\n"
                echo "####################################### | You Selected | #######################################"
                echo "$filename"
                
                # TODO: Add an option selection tool to: Get Info, Set Default, Remove Name, Edit Name
                
                echo "-------------------------------------------------------------------------------------------------------------------"
                echo "------------------------------------------ | MKV Edit Start | -----------------------------------------------------"
                echo "-------------------------------------------------------------------------------------------------------------------"
                echo -e "\n"
                
                echo "Enter the word to be removed: "
                read word_to_remove
                
                echo -e "\n"
                echo "####################################### | File Name | ########################################"
                echo "$filename"
                echo "#################################### | Word to remove | ######################################"
                echo "$word_to_remove"
                echo "-------------------------------------------------------------------------------------------------------------------"
                
                # Loop through tracks and update the name field if it contains the word to remove
                echo "-------------------------------------------- | Process Start | ----------------------------------------------------"
                mkvinfo "$filename" | grep "Track number" | while read -r line; do
                    track_number=$(echo "$line" | awk '{print $5}')
                    
                    echo "==================================================================================================================="
                    echo "******************************************* | track_number: $track_number"
                    echo "-------------------------------------------------------------------------------------------------------------------"
                    
					# TODO: remove unwanted things from line such as "| + Name:"
                    current_name=$(mkvinfo "$filename" | grep -A 10 "Track number: $track_number" | grep "Name" | sed 's/^[[:space:]]*Name:[[:space:]]*//')
                    
                    echo "-------------------------------------------- | current_name | -----------------------------------------------------"
                    echo "$current_name"
                    echo "-------------------------------------------------------------------------------------------------------------------"
                    
                    
                    if [[ "$current_name" == *"$word_to_remove"* ]]; then
                        new_name=$(echo "$current_name" | sed "s/$word_to_remove//g")
                        
                        echo "---------------------------------------------- | new_name | -------------------------------------------------------"
                        echo "$new_name"
                        echo "-------------------------------------------------------------------------------------------------------------------"
                        
						# TODO: Add an option to select to use set or delete name based on new_name also to override new name
                        #mkvpropedit "$filename" --edit track:$track_number --set name="$new_name"
                        #mkvpropedit "$filename" --edit track:$track_number --delete name
                        
                        echo "Word '$word_to_remove' removed from Track $track_number name field."
                        echo "==================================================================================================================="
                        echo -e "\n"
                    else
                        echo "Word '$word_to_remove' not found in Track $track_number name field. Skipping."
                        echo "==================================================================================================================="
                        echo -e "\n"
                    fi
                done
                
                echo "-------------------------------------------------------------------------------------------------------------------"
                echo "------------------------------------------- | MKV Edit End | ------------------------------------------------------"
                echo "-------------------------------------------------------------------------------------------------------------------"
                
                exit 1
            else
                echo "Invalid selection. Please choose a number from the list."
                echo "===================================================================================================================="
            fi
        done
    fi
done