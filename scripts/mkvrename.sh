#!/bin/bash
#Script to efficiently remove unwanted names from MKV track metadata
#Author: Dragon DB

# Function to view/delete/replace track names
mkv_rename_func() {
    # Get function arguments
    # 1: View Name 2: Delete Name 3: Replace Name
    local argument_1=$1
    local filename=$2
    
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo "---------------------------------------- | MKV Rename Function | --------------------------------------------------"
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo -e "\n"
    
    #echo "Enter the word to be removed: "
    #read word_to_remove
    
    if [ -z "$word_to_remove" ]; then
        echo "Enter the word to be removed: "
        read word_to_remove
    fi
    
    echo -e "\n"
    # Bold, Red color
    echo -e "\e[1;31m################################################ | File Name | ####################################################\e[0m"
    echo "$filename"
    echo "############################################## | Word to remove | #################################################"
    echo "$word_to_remove"
    echo "###################################################################################################################"
    echo -e "\n"
    
    # Loop through tracks and view/delete/replace the name field if it contains the word_to_remove
    # echo "------------------------------------------------ | Track Loop | ---------------------------------------------------"
    mkvinfo "$filename" | grep "Track number" | while read -r line; do
        track_number=$(echo "$line" | awk '{print $5}')
        
        echo "==================================================================================================================="
        # Bold, Blue color
        echo -e "\e[1;34m| TRACK NUMBER: $track_number |\e[0m"
        echo "-------------------------------------------------------------------------------------------------------------------"
        
        # TODO: remove unwanted things from line such as "| + Name:" - DONE
        current_name=$(mkvinfo "$filename" | grep -A 10 "Track number: $track_number" | grep "Name" | sed 's/^[[:space:]]*Name:[[:space:]]*//;s/^[^:]*: //')
        
        echo "-------------------------------------------- | current_name | -----------------------------------------------------"
        echo "$current_name"
        echo "-------------------------------------------------------------------------------------------------------------------"
        
        
        if [[ "$current_name" == *"$word_to_remove"* ]]; then
            new_name=$(echo "$current_name" | sed "s/$word_to_remove//g")
            
            echo "---------------------------------------------- | new_name | -------------------------------------------------------"
            echo "$new_name"
            echo "-------------------------------------------------------------------------------------------------------------------"
            
            # TODO: Add an option to select to use set or delete name based on new_name also to override new name - DONE
            # Check the value of argument_1
            if [ "$argument_1" -eq 1 ]; then
                # Do Nothing
                :
            elif [ "$argument_1" -eq 2 ]; then
                # Bold, Red color
                echo -e "\e[1;31mExecuting --delete name Process on Track: $track_number\e[0m"
                mkvpropedit "$filename" --edit track:$track_number --delete name
            elif [ "$argument_1" -eq 3 ]; then
                # Bold, Red color
                echo -e "\e[1;31mExecuting --set name Process on Track: $track_number\e[0m"
                mkvpropedit "$filename" --edit track:$track_number --set name="$new_name"
            else
                echo "Function variable does not have proper value"
                exit 0
            fi
            
            echo "Word '$word_to_remove' removed from Track $track_number name field."
            echo "==================================================================================================================="
            echo -e "\n"
        else
            echo "Word '$word_to_remove' not found in Track $track_number name field. Skipping."
            echo "==================================================================================================================="
            echo -e "\n"
        fi
    done
    return
}

# Function to set default tack
mkv_default_func() {
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo "---------------------------------------- | MKV Default Function | -------------------------------------------------"
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo -e "\n"
    
    echo "Enter track number to mark default: "
    read track_number_default
    
    echo -e "\n"
    echo "################################################ | File Name | ####################################################"
    echo "$filename"
    echo "############################################### | Track Number | ##################################################"
    echo "$track_number_default"
    echo "###################################################################################################################"
    echo -e "\n"
    
    echo "-------------------------------------------------------------------------------------------------------------------"
    # Print 1 line before and 8 lines of the track seelcted
    mkvinfo "$filename" | grep -B 1 -A 8 "Track number: $track_number_default"
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo -e "\n"
    
    echo -e "\e[1;31mExecuting --set flag-default Process on Track: $track_number_default\e[0m"
    # mkvpropedit "$filename" --edit track:$track_number_default --set flag-default=1
    
    return
}

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
            media_path="/home/trinityvoid/media/TV Shows"
        ;;
        "Anime")
            media_path="/home/trinityvoid/media/Anime"
        ;;
        *)
            echo "Invalid selection."
            exit 1
        ;;
    esac
    
    PS3="-------------------------------------> Select Search type: "
    options=("File" "Folder")
    select file_type in "${options[@]}"
    do
        if [ "$file_type" == "File" ]; then
            #echo -e "\n"
            echo "############################################# | File Type | #######################################################"
            
            echo -e "\n"
            echo "Enter media file name to search:"
            read media_name
            
            # Search for files with case-insensitive partial name match
            # TODO: search only .mkv file and sort the output when adding to array - DONE
            readarray -t found_files < <(find "$media_path" -iname "*$media_name*.mkv" -type f | sort)
            
            echo -e "\n"
            echo "-------------------------------------------------------------------------------------------------------------------"
            echo "------------------------------------------- | Search Result | -----------------------------------------------------"
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
                        echo "########################################### | You Selected | ######################################################"
                        echo "$filename"
                        
                        # TODO: Add an option selection tool to: Get Info, Set Default, Remove Name, Edit Name - DONE
                        while true; do
                            # Display menu for Get Info, Set Default, Remove Name, Edit Name
                            echo -e "\n"
                            echo "-------------------------------------------------------------------------------------------------------------------"
                            echo "--------------------------------------------- | MKV Menu | --------------------------------------------------------"
                            echo "-------------------------------------------------------------------------------------------------------------------"
                            echo "1. Get Media Info"
                            echo "2. Get MKV Info"
                            echo "3. View Name"
                            echo "4. Delete Name"
                            echo "5. Replace Name (BETA)"
                            echo "6. Set Default"
                            echo "7. Exit"
                            echo "-------------------------------------------------------------------------------------------------------------------"
                            
                            # Prompt user for input
                            read -p "Enter your choice (1-7): " choice
                            
                            # Check user's choice
                            case $choice in
                                1)
                                    echo "========================================= | Media Info START | ===================================================="
                                    mediainfo "$filename"
                                    echo "========================================== | Media Info END | ====================================================="
                                    echo -e "\n"
                                ;;
                                2)
                                    echo "========================================== | MKV Info START | ====================================================="
                                    mkvinfo "$filename"
                                    echo "=========================================== | MKV Info END | ======================================================"
                                    echo -e "\n"
                                ;;
                                3)
                                    echo "View MKV name changes"
                                    mkv_rename_func 1 "$filename"
                                ;;
                                4)
                                    echo "Delete entire Name field"
                                    mkv_rename_func 2 "$filename"
                                ;;
                                5)
                                    echo "Replace Name to new value"
                                    mkv_rename_func 3 "$filename"
                                ;;
                                6)
                                    echo "Select & Set Default track"
                                    mkv_default_func
                                ;;
                                7)
                                    echo "=========================================== | Script Exit | ======================================================="
                                    exit 0
                                ;;
                                *)
                                    echo "Invalid choice. Please enter a number between 1 and 5."
                                ;;
                            esac
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
            
        elif [ "$file_type" == "Folder" ]; then
            echo -e "\n"
            echo "########################################### | Folder Type | #######################################################"
            
            read -p "Enter the folder name to search for: " folder_name
            #matching_folders=($(find "$media_path" -type d -name "*$folder_name*" 2>/dev/null))
            
            readarray -t matching_folders < <(find "$media_path" -iname "*$folder_name*" -type d | sort)
            
            if [ ${#matching_folders[@]} -eq 0 ]; then
                echo "No matching folders found."
                exit 1
            fi
            
            # Display the list of matching folders
            echo -e "\n"
            echo "-------------------------------------------------------------------------------------------------------------------"
            echo "------------------------------------------- | Search Result | -----------------------------------------------------"
            echo "-------------------------------------------------------------------------------------------------------------------"
            for ((i=0; i<${#matching_folders[@]}; i++)); do
                echo "$(($i+1)). ${matching_folders[$i]}"
            done
            
            # Ask user to select a folder
            echo -e "\n"
            read -p "Select a folder (enter the corresponding number): " selection
            
            # Validate the selection
            if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#matching_folders[@]}" ]; then
                echo "Invalid selection. Please enter a valid number."
                exit 1
            fi
            
            # Select the directory from array
            selected_folder="${matching_folders[$(($selection-1))]}"
            
            echo -e "\n"
            echo "########################################### | You Selected | ######################################################"
            echo "$selected_folder"
            
            # Select all MKV files inside selected folder and add to array
            readarray -t allMKV_files < <(find "$selected_folder" -iname "*.mkv" -type f | sort)
            
            # Display the list of matching folders
            echo -e "\n"
            echo "####################################### | Listing all MKV Files | #################################################"
            for ((i=0; i<${#allMKV_files[@]}; i++)); do
                echo "$(($i+1)). ${allMKV_files[$i]}"
            done
            echo "###################################################################################################################"
            
            while true; do
                # Display menu for Get Info, Set Default, Remove Name, Edit Name
                echo -e "\n"
                echo "-------------------------------------------------------------------------------------------------------------------"
                echo "--------------------------------------------- | MKV Menu | --------------------------------------------------------"
                echo "-------------------------------------------------------------------------------------------------------------------"
                echo "1. Get Media Info"
                echo "2. Get MKV Info"
                echo "3. View Name"
                echo "4. Delete Name"
                echo "5. Replace Name (BETA)"
                echo "6. Exit"
                echo "-------------------------------------------------------------------------------------------------------------------"
                
                # Prompt user for input
                read -p "Enter your choice (1-7): " choice
                
                # Check user's choice
                case $choice in
                    1)
                        for ((i=0; i<${#allMKV_files[@]}; i++)); do
                            echo "========================================= | Media Info START | ===================================================="
                            # Bold, Blue color
                            echo -e "\e[1;34m| FILE NUMBER: $(($i+1)) |\e[0m"
                            # echo -e "\n"
                            echo "$(($i+1)). ${allMKV_files[$i]}"
                            mediainfo "${allMKV_files[$i]}"
                            echo "========================================== | Media Info END | ====================================================="
                            echo -e "\n"
                        done
                    ;;
                    2)
                        for ((i=0; i<${#allMKV_files[@]}; i++)); do
                            echo "========================================== | MKV Info START | ====================================================="
                            # Bold, Blue color
                            echo -e "\e[1;34m| FILE NUMBER: $(($i+1)) |\e[0m"
                            echo "$(($i+1)). ${allMKV_files[$i]}"
                            mkvinfo "${allMKV_files[$i]}"
                            echo "=========================================== | MKV Info END | ======================================================"
                            echo -e "\n"
                        done
                    ;;
                    3)
                        echo "View MKV name changes"
                        for ((i=0; i<${#allMKV_files[@]}; i++)); do
                            mkv_rename_func 1 "${allMKV_files[$i]}"
                        done
                    ;;
                    4)
                        echo "Delete entire Name field"
                        for ((i=0; i<${#allMKV_files[@]}; i++)); do
                            mkv_rename_func 2 "${allMKV_files[$i]}"
                        done
                    ;;
                    5)
                        echo "Replace Name to new value"
                        for ((i=0; i<${#allMKV_files[@]}; i++)); do
                            mkv_rename_func 3 "${allMKV_files[$i]}"
                        done
                    ;;
                    6)
                        echo "=========================================== | Script Exit | ======================================================="
                        exit 0
                    ;;
                    *)
                        echo "Invalid choice. Please enter a number between 1 and 5."
                    ;;
                esac
            done
            
            echo "-------------------------------------------------------------------------------------------------------------------"
            echo "------------------------------------------- | MKV Edit End | ------------------------------------------------------"
            echo "-------------------------------------------------------------------------------------------------------------------"
            
            exit 1
            
            
        else
            echo "Selected Wrong Search Type"
        fi
    done
done