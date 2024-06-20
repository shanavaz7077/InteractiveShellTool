#!/bin/bash

# Function to display the file management menu
function show_menu() {
    echo "File Management Options:"
    echo "1. Copy files"
    echo "2. Move files"
    echo "3. Delete files"
    echo "4. Rename files"
    echo "5. Search for files"
    echo "6. Archive files"
    echo "7. Manage file permissions"
    echo "8. Exit"
    echo "Enter your choice (1-8):"
    read choice
    if ! [[ "$choice" =~ ^[1-8]$ ]]; then
        echo "Invalid choice: Please enter a number between 1 and 8."
        return 1
    fi
}

# Function to validate file path
function validate_path() {
    if [ ! -e "$1" ]; then
        echo "Error: The path '$1' does not exist."
        return 1
    fi
    return 0
}

# Function to copy files
function copy_files() {
    echo "Enter source file path:"
    read src
    validate_path "$src" || return
    echo "Enter destination path:"
    read dest
    # Perform the copy with overwrite prompt
    cp -i "$src" "$dest" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "File copied successfully."
    else
        echo "Failed to copy file. Please check the destination path and permissions."
    fi
}

# Function to move files
function move_files() {
    echo "Enter source file path:"
    read src
    validate_path "$src" || return
    echo "Enter destination path:"
    read dest
    # Perform the move with overwrite prompt
    mv -i "$src" "$dest" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "File moved successfully."
    else
        echo "Failed to move file. Please check the destination path and permissions."
    fi
}

# Function to delete files
function delete_files() {
    echo "Enter file path to delete:"
    read path
    # Validate the existence of the file before attempting to delete
    if [ ! -f "$path" ]; then
        echo "Error: The file '$path' does not exist."
        return
    fi
    # Confirm deletion with the user
    echo "Are you sure you want to delete '$path'? This action cannot be undone. (y/n)"
    read confirmation
    if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
        echo "Deletion cancelled by user."
        return
    fi
    # Perform the deletion with error checking
    rm -f "$path"
    if [ $? -eq 0 ]; then
        echo "File '$path' deleted successfully."
    else
        echo "Failed to delete file. Please check your permissions."
    fi
}


# Function to rename files
function rename_files() {
    echo "Enter current file path:"
    read current
    validate_path "$current" || return
    echo "Enter new file name:"
    read new
    # Perform the rename
    mv -i "$current" "$new" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "File renamed successfully."
    else
        echo "Failed to rename file. Please check the new path and permissions."
    fi
}

# Function to search for files
function search_files() {
    echo "Enter the directory to search in:"
    read directory
    # Check if the directory exists and is a directory
    if [ ! -d "$directory" ]; then
        echo "Error: The directory '$directory' does not exist or is not a directory."
        return
    fi

    echo "Enter the search pattern (e.g., '*.txt'):"
    read pattern
    # Check if the pattern is not empty
    if [[ -z "$pattern" ]]; then
        echo "Error: Search pattern cannot be empty."
        return
    fi

    # Perform the search with detailed output
    echo "Searching for files in '$directory' matching pattern '$pattern'..."
    local found_files=$(find "$directory" -type f -name "$pattern")

    if [[ -z "$found_files" ]]; then
        echo "No files found matching the pattern '$pattern' in the directory '$directory'."
    else
        echo "Found files:"
        echo "$found_files"
    fi
}



# Function to archive files
function archive_files() {
    echo "Enter directory containing files to archive:"
    read directory
    validate_path "$directory" || return
    echo "Enter archive name:"
    read archive_name
    # Perform archiving
    tar -czf "$archive_name.tar.gz" -C "$directory" . 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Files archived successfully."
    else
        echo "Failed to archive files. Please check the directory and permissions."
    fi
}

# Function to manage file permissions
function manage_permissions() {
    echo "Enter file path:"
    read path
    if [ ! -e "$path" ]; then
        echo "Error: The specified file or directory does not exist."
        return
    fi

    echo "Enter permissions (e.g., 755):"
    read permissions
    if ! [[ "$permissions" =~ ^[0-7]{3}$ ]]; then
        echo "Error: Invalid permissions format. Please enter a valid three-digit octal number (e.g., 755)."
        return
    fi

    # Change permissions
    chmod "$permissions" "$path"
    if [ $? -eq 0 ]; then
        echo "Permissions changed successfully."
    else
        echo "Failed to change permissions. Please check your permissions settings or ensure you have the necessary rights."
    fi
}


# Main loop
while true; do
    show_menu || continue
    case $choice in
        1) copy_files ;;
        2) move_files ;;
        3) delete_files ;;
        4) rename_files ;;
        5) search_files ;;
        6) archive_files ;;
        7) manage_permissions ;;
        8) echo "Exiting program."; break ;;
        *) echo "Unexpected error occurred." ;;
    esac
    echo
done
