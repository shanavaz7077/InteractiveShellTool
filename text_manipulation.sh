#!/bin/bash

# Function to search within text files using grep
search_text() {
    echo "Enter the file name:"
    read filename
    if [[ ! -f "$filename" ]]; then
        echo "File does not exist."
        return
    fi
    
    echo "Enter the string or pattern to search:"
    read pattern
    grep --color=always -n "$pattern" "$filename"
}

# Function to replace text within files
replace_text() {
    echo "Enter the file name:"
    read filename
    if [[ ! -f "$filename" ]]; then
        echo "File does not exist."
        return
    fi
    
    echo "Enter the text to replace:"
    read old_text
    echo "Enter the new text:"
    read new_text
    
    sed -i "s/$old_text/$new_text/g" "$filename"
    echo "Text replacement complete."
}

# Function to compare two text files
compare_files() {
    echo "Enter the first file name:"
    read file1
    if [[ ! -f "$file1" ]]; then
        echo "First file does not exist."
        return
    fi

    echo "Enter the second file name:"
    read file2
    if [[ ! -f "$file2" ]]; then
        echo "Second file does not exist."
        return
    fi
    
    diff --color=always "$file1" "$file2"
}

# Function to display help information for text manipulation
display_help_text_manipulation() {
    echo "Displaying help information..."
    help_file="text_manipulation_help.txt"  # specify the path to your help file here
    if [ ! -f "$help_file" ]; then
        echo "Help file not found."
        return 1
    fi
    less -M "$help_file"  # Opens the file in less, which provides a read-only view
}

# Main menu function
main_menu() {
    while true; do
        echo "Text Manipulation Options:"
        echo "1. Search within text files"
        echo "2. Replace text within files"
        echo "3. Compare text files"
        echo "4. Display Help for Text Manipulation"
        echo "5. Exit"
        echo "Enter your choice: "
        read choice
        
        case $choice in
            1) search_text ;;
            2) replace_text ;;
            3) compare_files ;;
            4) display_help_text_manipulation ;;
            5) echo "Exiting..."; break ;;
            *) echo "Invalid choice, please try again." ;;
        esac
    done
}

# Run the main menu
main_menu
