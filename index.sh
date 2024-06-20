#!/bin/bash

# Function to display the main menu
show_main_menu() {
    # Check if the welcome message file exists
    if [[ -f welcome_message.txt ]]; then
        cat welcome_message.txt  # Print the content of the welcome message file
    else
        echo "Welcome message file not found. Using default message."
        echo "Welcome to the Custom Terminal Interface"
    fi
    echo "-----------------------------------------"
    echo "1. File Management"
    echo "2. System Configuration"
    echo "3. Network Tools"
    echo "4. Text Manipulation"
    echo "5. Process Management"
    echo "6. Exit"
    echo "-----------------------------------------"
    echo -n "Enter your choice [1-6]: "
}

# Function to handle user input and navigate to the chosen submenu
handle_user_input() {
    local choice
    read choice
    case $choice in
        1) echo "File Management selected."
           # Placeholder for File Management submenu function
           ;;
        2) echo "System Configuration selected."
           # Placeholder for System Configuration submenu function
           ;;
        3) echo "Network Tools selected."
           # Placeholder for Network Tools submenu function
           ;;
        4) echo "Text Manipulation selected."
           # Placeholder for Text Manipulation submenu function
           ;;
        5) echo "Process Management selected."
           # Placeholder for Process Management submenu function
           ;;
        6) echo "Exiting program."
           exit 0
           ;;
        *) echo "Invalid choice, please select a number between 1-6."
           handle_user_input
           ;;
    esac
}

# Main script execution flow
while true; do
    show_main_menu
    handle_user_input
done
