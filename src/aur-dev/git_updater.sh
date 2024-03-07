#!/bin/bash

welcome() {
    echo "Welcome to GitHub Repository Updater!"
    echo "This script was developed by Computer Science Engineer Felipe Alfonso González - github: github.com/felipealfonsog - under the BSD 3-clause license."
    echo "Developed from Chile with love."
    echo "----------------------------------------------------"
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
        read -p "Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No): " exclude_choice
        if [[ "$exclude_choice" == '' || "$exclude_choice" =~ [Yy] ]]; then
            include_aur=false
        else
            include_aur=true
        fi
        update_github_repositories "$current_directory" "$include_aur"
    else
        echo "You need to be inside a directory with GitHub repositories to update them."
    fi
}

main
