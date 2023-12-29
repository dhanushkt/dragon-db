#!/bin/bash
#Script to efficiently remove unwanted names from MKV track metadata
#Author: Dragon DB

# function to view only the name changes
mkv_rename_func() {
    # Get function arguments
    # 1: View Name 2: Delete Name 3: Replace Name
    local argument_1=$1
    
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo "---------------------------------------- | MKV Rename Function | --------------------------------------------------"
    echo "-------------------------------------------------------------------------------------------------------------------"
    echo -e "\n"
    
    echo "Enter the word to be removed: "
    read word_to_remove
    
    echo -e "\n"
    echo "################################################ | File Name | ####################################################"
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
                # mkvpropedit "$filename" --edit track:$track_number --delete name
            elif [ "$argument_1" -eq 3 ]; then
                # Bold, Red color
                echo -e "\e[1;31mExecuting --set name Process on Track: $track_number\e[0m"
                # mkvpropedit "$filename" --edit track:$track_number --set name="$new_name"
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

# function to view only the name changes


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
                    echo "1. Get MKV Info"
                    echo "2. View Name"
                    echo "3. Delete Name"
                    echo "4. Replace Name (BETA)"
                    echo "5. Exit"
                    echo "-------------------------------------------------------------------------------------------------------------------"
                    
                    # Prompt user for input
                    read -p "Enter your choice (1-5): " choice
                    
                    # Check user's choice
                    case $choice in
                        1)
                            echo "========================================== | MKV Info START | ====================================================="
                            mkvinfo "$filename"
                            echo "=========================================== | MKV Info END | ======================================================"
                            echo -e "\n"
                        ;;
                        2)
                            echo "View MKV name changes"
                            mkv_rename_func 1
                        ;;
                        3)
                            echo "Delete entire Name field"
                            mkv_rename_func 2
                        ;;
                        4)
                            echo "Replace Name to new value"
                            mkv_rename_func 3
                        ;;
                        5)
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
done