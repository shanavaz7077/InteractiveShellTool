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

# Function to validate if a file exists
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


copy_file() {
    local src dest overwrite_choice

    while true; do
        # Get source file from user
        echo -n "Enter the source file path: "
        read src
        validate_string "$src" && validate_file_existence "$src" || continue

        # Get destination file from user
        echo -n "Enter the destination file path: "
        read dest
        validate_string "$dest" || continue

        # Check if the destination file already exists
        if [ -e "$dest" ]; then
            echo "Warning: File '$dest' already exists."
            echo -n "Do you want to overwrite it? (yes/no): "
            read overwrite_choice
            if [ "$overwrite_choice" != "yes" ]; then
                echo "Operation cancelled by user."
                return 0
            fi
        fi

        # Attempt to copy the file
        if cp "$src" "$dest"; then
            echo "File copied successfully from '$src' to '$dest'."
            return 0
        elses
            echo "Error: Failed to copy the file. Please try again."
        fi
    done
}

move_file() {
    local src dest overwrite_choice

    while true; do
        # Get source file from user
        echo -n "Enter the source file path: "
        read src
        validate_string "$src" && validate_file_existence "$src" || continue

        # Get destination file from user
        echo -n "Enter the destination file path: "
        read dest
        validate_string "$dest" || continue

        # Check if the destination file already exists
        if [ -e "$dest" ]; then
            echo "Warning: File '$dest' already exists."
            echo -n "Do you want to overwrite it? (yes/no): "
            read overwrite_choice
            if [ "$overwrite_choice" != "yes" ]; then
                echo "Operation cancelled by user."
                return 0
            fi
        fi

        # Attempt to move the file
        if mv "$src" "$dest"; then
            echo "File moved successfully from '$src' to '$dest'."
            return 0
        else
            echo "Error: Failed to move the file. Please try again."
        fi
    done
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


