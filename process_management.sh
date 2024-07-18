#!/bin/bash

# Function to display help for process management
display_help_process_management() {
    echo "Displaying help information..."
    help_file="process_management_help.txt"  # specify the path to your help file here

    # Validate if the file exists
    if [ ! -f "$help_file" ]; then
        echo "Help file not found."
        return 1
    fi
    less -M "$help_file"  # Opens the file in less, which provides a read-only view
}

# Function to display running processes
view_processes() {
    echo "Displaying running processes..."
    ps aux
}

# Function to terminate a process
terminate_process() {
    read -p "Enter process name or PID to terminate: " process_input

    # Validate if input is numeric (PID) or string (process name)
    if [[ "$process_input" =~ ^[0-9]+$ ]]; then
        if ps -p $process_input > /dev/null; then
            kill $process_input
            echo "Process $process_input has been terminated."
        else
            echo "No process found with PID $process_input."
        fi
    elif [[ "$process_input" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        pkill -f $process_input
        echo "Processes with name $process_input have been terminated."
    else
        echo "Invalid input. Please enter a valid PID or process name."
        terminate_process
    fi
}

# Function to start a new process
start_process() {
    read -p "Enter the command to start a new process: " command
    # Ensure the command field is not empty
    if [ -z "$command" ]; then
        echo "Command cannot be empty. Please enter a valid command."
        start_process
    else
        $command &
        echo "Process started with command: $command"
    fi
}

# Main menu for process management
process_management() {
    while true; do
        echo "Process Management Options:"
        echo "1. View Running Processes"
        echo "2. Terminate a Process"
        echo "3. Start a Process"
        echo "4. View Help"
        echo "5. Exit"

        read -p "Enter your choice: " choice

        # Handle user input and provide options
        case $choice in
            1)
                view_processes
                ;;
            2)
                terminate_process
                ;;
            3)
                start_process
                ;;
            4)
                display_help_process_management
                ;;
            5)
                echo "Exiting Process Management..."
                break
                ;;
            *)
                echo "Invalid choice. Please enter a valid option."
                ;;
        esac
        # Adding a small pause and clear to improve user experience
        echo "Press any key to continue..."
        read -n 1
        clear
    done
}

# Start the process management interface
process_management
