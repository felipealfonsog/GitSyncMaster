#!/bin/bash

welcome() {
    echo "Welcome to GitHub Repository Updater!"
    echo "This script will update all GitHub repositories within the current directory or its subdirectories."
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
    current_directory=$(pwd)
    read -p "Current directory is: $current_directory. Do you want to update repositories here? (Press Enter for Yes, N for No): " main_directory
    if [[ "$main_directory" == '' || "$main_directory" =~ [Yy] ]]; then
        read -p "Do you want to include directories with the '-aur' suffix? (Press Enter for Yes, N for No): " include_aur
        include_aur=$(echo "${include_aur,,}" | tr -d '\n')  # Convert to lowercase and remove newline characters
        include_aur=${include_aur:-n}  # Default to 'n' if user input is empty
        include_aur=${include_aur:0:1}  # Extract first character
        include_aur="${include_aur:-n}"  # Ensure it's 'y' or 'n'
        update_github_repositories "$current_directory" "$include_aur"
    else
        echo "You need to be inside a directory with GitHub repositories to update them."
    fi
}

main
