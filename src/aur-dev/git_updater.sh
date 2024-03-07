#!/bin/bash

welcome() {
    echo "Welcome to GitHub Repository Updater!"
    echo "This script will update all GitHub repositories within the specified directory."
}

update_github_repositories() {
    echo -e "\nUpdating GitHub repositories...\n"
    for dir in "$1"/*/; do
        if [ -d "$dir/.git" ]; then
            if [ "$2" = true ] || [[ ! "$dir" =~ -aur$ ]]; then
                echo "Updating repository in $dir"
                cd "$dir" || exit
                git pull
                cd - || exit
            fi
        fi
    done
}

main() {
    welcome
    read -p "Enter the path to the directory containing GitHub repositories: " main_directory
    read -p "Do you want to include directories with the '-aur' suffix? (Y/N): " include_aur
    include_aur=$(echo "$include_aur" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase
    include_aur=${include_aur:-n}  # Default to 'n' if user input is empty
    include_aur=${include_aur:0:1}  # Extract first character
    include_aur="${include_aur:-n}"  # Ensure it's 'y' or 'n'
    include_aur=$(echo "$include_aur" | tr -d '\n')  # Remove newline characters
    include_aur=$(echo "$include_aur" | tr -d '[:space:]')  # Remove spaces
    include_aur=$(echo "$include_aur" | tr -d '[:punct:]')  # Remove punctuation
    include_aur=${include_aur:-n}  # Default to 'n' if all characters were removed
    include_aur=$(echo "$include_aur" | head -c 1)  # Only take the first character
    include_aur=$(echo "$include_aur" | tr -d '\n')  # Remove newline characters
    include_aur=${include_aur:-n}  # Default to 'n' if all characters were removed
    include_aur=$(echo "$include_aur" | tr -d '[:space:]')  # Remove spaces
    include_aur=${include_aur:-n}  # Default to 'n' if all characters were removed
    update_github_repositories "$main_directory" "$include_aur"
}

main
