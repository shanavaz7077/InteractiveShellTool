#!/bin/bash

# Function to display the file management submenu
file_management_menu() {
    echo "File Management Menu:"
    echo "1. Copy files"
    echo "2. Move files"
    echo "3. Delete files"
    echo "4. Rename files"
    echo "5. Search for files"
    echo "6. Archive files"
    echo "7. Unarchive files"
    echo "8. Batch operations"
    echo "8. Manage file permissions"
    echo "9. Compare files"
    echo "10. help"
    echo "11. Return to main menu"
    echo -n "Enter your choice [1-11]: "
}

validate_file_existence() {
    if [ ! -e "$1" ]; then
        echo "Error: File '$1' does not exist."
        return 1
    fi
    return 0
}

# Function to validate if a string is not empty
validate_string() {
    if [ -z "$1" ]; then
        echo "Error: Input cannot be empty."
        return 1
    fi
    return 0
}

# Function to get file path from user
get_file_path() {
    local prompt="$1"
    local file_path
    while true; do
        echo -n "$prompt"
        read file_path
        validate_string "$file_path" && return 0 || echo "Please try again."
    done
}

# Function to check for overwrite decision
check_overwrite() {
    local dest="$1"
    local overwrite_choice
    if [ -e "$dest" ]; then
        echo "Warning: File '$dest' already exists."
        while true; do
            echo -n "Do you want to overwrite it? (yes/no): "
            read overwrite_choice
            case $overwrite_choice in
                yes)
                    return 0
                    ;;
                no)
                    echo "Operation cancelled by user."
                    return 1
                    ;;
                *)
                    echo "Please answer 'yes' or 'no'."
                    ;;
            esac
        done
    fi
    return 0
}

# Function to copy a file
copy_file() {
    local src dest
    echo "Copy File Operation"
    get_file_path "Enter the source file path: " && src=$REPLY
    validate_file_existence "$src" || return 1

    get_file_path "Enter the destination file path: " && dest=$REPLY
    check_overwrite "$dest" || return 1

    # Attempt to copy the file
    if cp "$src" "$dest"; then
        echo "File copied successfully from '$src' to '$dest'."
    else
        echo "Error: Failed to copy the file. Please try again."
    fi
}

# Function to move a file
move_file() {
    local src dest
    echo "Move File Operation"
    get_file_path "Enter the source file path: " && src=$REPLY
    validate_file_existence "$src" || return 1

    get_file_path "Enter the destination file path: " && dest=$REPLY
    check_overwrite "$dest" || return 1

    # Attempt to move the file
    if mv "$src" "$dest"; then
        echo "File moved successfully from '$src' to '$dest'."
    else
        echo "Error: Failed to move the file. Please try again."
    fi
}


# Handling user input for file management submenu
handle_file_management_input() {
    local choice
    read choice
    case $choice in
        1) copy_files ;;
        2) move_files ;;
        3) delete_files ;;
        4) rename_files ;;
        5) search_files ;;
        6) archive_files ;;
        7) unarchive_files ;;
        8) manage_permissions ;;
        9) compare_files ;;
        10) file_management_help_doc ;;
        11) echo "Returning to main menu..." ;;
        *) echo "Invalid choice, please select a number between 1-11."
           file_management_menu
           handle_file_management_input ;;
    esac
}

# Main loop for file management
while true; do
    file_management_menu
    handle_file_management_input
    [[ "$choice" -eq 11 ]] && break
done


