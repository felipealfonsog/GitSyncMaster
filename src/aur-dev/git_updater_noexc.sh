#!/bin/bash

welcome() {
    echo "Welcome to GitHub Repository Updater!"
    echo "This script will update all GitHub repositories within the specified directory."
}

update_github_repositories() {
    echo -e "\nUpdating GitHub repositories...\n"
    for dir in "$1"/*/; do
        if [ -d "$dir/.git" ]; then
            echo "Updating repository in $dir"
            cd "$dir" || exit
            git pull
            cd - || exit
        fi
    done
}

main() {
    welcome
    read -p "Enter the path to the directory containing GitHub repositories: " main_directory
    update_github_repositories "$main_directory"
}

main
