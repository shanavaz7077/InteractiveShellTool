#!/bin/bash

# Helper function to validate numeric input
validate_numeric(){
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "Error: Input must be numeric."
        return 1
    fi
    return 0
}

# Helper function to validate non-empty input
validate_non_empty(){
    if [[ -z "$1" ]]; then
        echo "Error: Input must not be empty."
        return 1
    fi
    return 0
}

# Display system information
view_system_info(){
    echo "System Information:"
    echo "OS Version:"
    cat /etc/os-release
    echo "Hostname:"
    hostname
    echo "Memory Usage:"
    free -h
    echo "Disk Usage:"
    df -h
    echo "CPU Info:"
    lscpu
}

# Manage user accounts
manage_user_accounts(){
    local action username
    echo "User Account Management:"
    echo "Options: create, delete, modify"
    read -p "Enter action (create/delete/modify): " action
    if ! validate_non_empty "$action"; then return 1; fi

    read -p "Enter username: " username
    if ! validate_non_empty "$username"; then return 1; fi

    case "$action" in
        create)
            sudo adduser "$username"
            if [ $? -ne 0 ]; then
                echo "Failed to create user."
                return 1
            fi
            ;;
        delete)
            sudo deluser "$username"
            if [ $? -ne 0 ]; then
                echo "Failed to delete user."
                return 1
            fi
            ;;
        modify)
            echo "Modifying user $username (Placeholder)"
            # Actual user modification commands go here
            ;;
        *)
            echo "Invalid action. Please choose create, delete, or modify."
            return 1
            ;;
    esac
}

# Install or remove software packages
manage_software(){
    local package action
    echo "Software Management:"
    echo "Options: install, remove"
    read -p "Enter action (install/remove): " action
    if ! validate_non_empty "$action"; then return 1; fi

    read -p "Enter package name: " package
    if ! validate_non_empty "$package"; then return 1; fi

    case "$action" in
        install)
            sudo apt-get install "$package"
            ;;
        remove)
            sudo apt-get remove "$package"
            ;;
        *)
            echo "Invalid action. Please choose install or remove."
            return 1
            ;;
    esac
}

# Real-time system monitoring
system_monitoring(){
    echo "Launching system monitor (top)..."
    top
}

# System backup and restore
system_backup_restore(){
    local action backup_path restore_path
    echo "System Backup and Restore Options:"
    echo "1. Backup"
    echo "2. Restore"
    read -p "Enter action (1 for Backup, 2 for Restore): " action
    if ! [[ "$action" =~ ^[12]$ ]]; then
        echo "Invalid action. Please select 1 for Backup or 2 for Restore."
        return 1
    fi

    if [ "$action" -eq 1 ]; then
        read -p "Enter directory path to backup: " backup_path
        if ! [ -d "$backup_path" ]; then
            echo "Error: Directory does not exist."
            return 1
        fi
        local current_date=$(date +%Y%m%d%H%M%S)
        local backup_file="backup-$current_date.tar.gz"
        tar -czf "$backup_file" "$backup_path"
        if [ $? -eq 0 ]; then
            echo "Backup was successful. File saved as $backup_file"
        else
            echo "Backup failed."
            return 1
        fi
    elif [ "$action" -eq 2 ]; then
        read -p "Enter path of backup file to restore: " restore_path
        if ! [ -f "$restore_path" ]; then
            echo "Error: Backup file does not exist."
            return 1
        fi
        tar -xzf "$restore_path"
        if [ $? -eq 0 ]; then
            echo "Restore was successful."
        else
            echo "Restore failed."
            return 1
        fi
    fi
}

# Display help information
display_help_system_configuration() {
    echo "Displaying help information..."
    help_file="system_configuration_help.txt"  # specify the path to your help file here
    # Validate path if the file exists
    if [ ! -f "$help_file" ]; then
        echo "Help file not found."
        return 1
    fi
    less -M "$help_file"  # Opens the file in less, which provides a read-only view
}

# Main menu function
show_menu(){
    echo "System Configuration Menu:"
    echo "1. View System Information"
    echo "2. Manage User Accounts"
    echo "3. Install/Remove Software"
    echo "4. Real-time System Monitoring"
    echo "5. System Backup and Restore"
    echo "6. Help"
    echo "7. Exit"
    local choice
    read -p "Enter your choice [1-7]: " choice
    if ! validate_numeric "$choice"; then return 1; fi

    case $choice in
        1) view_system_info ;;
        2) manage_user_accounts ;;
        3) manage_software ;;
        4) system_monitoring ;;
        5) system_backup_restore ;;
        6) display_help_system_configuration ;;
        7) exit 0 ;;
        *) echo "Invalid choice, please select a valid option from 1 to 7."; return 1;;
    esac
}

# Main loop
main(){
    while true; do
        show_menu || echo "An error occurred, please try again."
    done
}

main
