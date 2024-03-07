#!/bin/bash

welcome() {
    echo "Welcome to GitHub Repository Updater -GitSyncMaster-!"
    echo "This software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license."
    echo "Developed from Chile with love."
    echo "----------------------------------------------------"
    echo "This software will update all GitHub repositories within the current directory or its subdirectories."
}

update_github_repositories() {
    echo -e "\nUpdating GitHub repositories...\n"
    found_repos=false
    for dir in "$1"/*/; do
        if [ -d "$dir/.git" ]; then
            found_repos=true
            if [ "$2" = true ] || [[ ! "$dir" =~ -aur$ ]]; then
                echo "Updating repository in $dir"
                cd "$dir" || exit
                git pull
                cd - || exit
            fi
        fi
    done
    if [ "$found_repos" = false ]; then
        echo "No GitHub repositories found in the current directory or its subdirectories. Exiting."
        exit
    fi
}

main() {
    welcome
    current_directory=$(pwd)
    if ! find "$current_directory" -type d -name '.git' | grep -q .; then
        echo "You need to be inside a directory with GitHub repositories to update them."
        return
    fi
    read -p "Do you want to update repositories here? (Press Enter for Yes, No for cancel, default is Yes): " main_directory
    if [[ "$main_directory" == '' || "$main_directory" =~ [Yy] ]]; then
        read -p "Do you want to abort the process? (Press Enter for No, Y for Yes default is No): " abort_choice
        if [[ "$abort_choice" =~ [Yy] ]]; then
            echo "Operation aborted."
            exit
        fi
    else
        echo "You need to be inside a directory with GitHub repositories to update them."
        return
    fi
    read -p "Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No, default is Yes): " exclude_choice
    if [[ "$exclude_choice" == '' || "$exclude_choice" =~ [Yy] ]]; then
        include_aur=false
    else
        include_aur=true
    fi
    update_github_repositories "$current_directory" "$include_aur"
}

main
