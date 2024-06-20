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

file_management_help_doc() {
    local file_path="file_management_help_doc.txt"

    if [[ -f "$file_path" ]]; then
        less "$file_path"
    else
        echo "File does not exist."
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


