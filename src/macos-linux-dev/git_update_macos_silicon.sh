#!/bin/bash

welcome() {
    if [[ $(uname -s) == "Darwin" ]]; then
        echo -e "\033[1;32mWelcome to GitHub Repository Updater -GitSyncMaster-!\033[0m"
        echo -e "\033[1;32mThis software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license.\033[0m"
        echo -e "\033[1;32mDeveloped from Chile with love.\033[0m"
        echo -e "\033[1;32m----------------------------------------------------\033[0m"
        echo -e "\033[1;32m\033[1mEffortlessly Automate Git Repository Updates, Including Committing and Pulling, Across Directory Structures.\033[0m"
    else
        echo "Welcome to GitHub Repository Updater -GitSyncMaster-!"
        echo "This software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license."
        echo "Developed from Chile with love."
        echo "----------------------------------------------------"
        echo "Effortlessly Automate Git Repository Updates, Including Committing and Pulling, Across Directory Structures."
    fi
}

update_github_repositories() {
    echo -e "\nUpdating GitHub repositories...\n"
    found_repos=false
    for repo in $(find "$1" -type d -name ".git" -exec dirname {} +); do
        found_repos=true
        if [[ "$2" == "true" || ! "$repo" =~ "-aur"$ ]]; then
            cd "$repo" || exit 1
            changes=$(git status --porcelain)
            if [[ -n "$changes" ]]; then
                echo "Repository in $repo requires a commit before updating."
                if git pull; then
                    echo "Repository updated successfully."
                else
                    echo "Error updating repository."
                fi
            else
                echo "Updating repository in $repo"
                if git pull; then
                    echo "Repository updated successfully."
                else
                    echo "Error updating repository."
                fi
            fi
            cd - >/dev/null || exit 1
        fi
    done
    if [[ "$found_repos" == false ]]; then
        echo "No GitHub repositories found in the current directory or its subdirectories. Exiting."
        exit 1
    fi
}

check_repos() {
    echo -e "\nChecking for repositories requiring actions...\n"
    repos_needing_action=()
    while IFS= read -r -d '' repo; do
        changes=$(git -C "$repo" status --porcelain)
        if [[ -n "$changes" ]]; then
            repos_needing_action+=("$repo")
        fi
    done < <(find "$1" -type d -name ".git" -exec dirname {} +)
    if [[ ${#repos_needing_action[@]} -gt 0 ]]; then
        echo "The following repositories require actions:"
        for repo in "${repos_needing_action[@]}"; do
            echo "$repo"
        done
        return 0
    else
        echo "No repositories require actions."
        return 1
    fi
}

update_repos_ssh() {
    echo -e "\nUpdating GitHub repositories over SSH...\n"
    found_repos=false
    for repo in $(find "$1" -type d -name ".git" -exec dirname {} +); do
        found_repos=true
        if [[ "$2" == "true" || ! "$repo" =~ "-aur"$ ]]; then
            cd "$repo" || exit 1
            echo "Updating repository in $repo"
            if git pull; then
                echo "Repository updated successfully."
            else
                echo "Error updating repository."
            fi
            cd - >/dev/null || exit 1
        fi
    done
    if [[ "$found_repos" == false ]]; then
        echo "No GitHub repositories found in the current directory or its subdirectories. Exiting."
        exit 1
    fi
}

main() {
    welcome
    current_directory=$(pwd)
    if ! find "$current_directory" -type d -name ".git" | grep -q .; then
        echo "You need to be inside a directory with GitHub repositories to update them."
        exit 1
    fi

    read -rp "Choose an option:
1. Check repositories requiring actions.
2. Update repositories.
3. Update repositories over SSH.
Enter option number (default is 2): " choice
    choice=${choice:-2}

    if [[ "$choice" == "1" ]]; then
        if check_repos "$current_directory"; then
            read -rp "Do you want to proceed with the action? (Y/n): " proceed
            proceed=$(echo "$proceed" | tr '[:upper:]' '[:lower:]')
            if [[ "$proceed" != "y" ]]; then
                echo "Action aborted."
                exit 0
            fi

            while IFS= read -r repo; do
                cd "$repo" || exit 1
                changes=$(git status --porcelain)
                echo -e "Repository: $repo\nChanges:\n$changes"
                read -rp "Do you want to stage these changes for commit? (Y/n): " stage_choice
                stage_choice=$(echo "$stage_choice" | tr '[:upper:]' '[:lower:]')
                if [[ "$stage_choice" == "y" ]]; then
                    git add .
                    read -rp "Enter commit message: " commit_message
                    git commit -m "$commit_message"
                    read -rp "Do you want to push these changes? (Y/n): " push_choice
                    push_choice=$(echo "$push_choice" | tr '[:upper:]' '[:lower:]')
                    if [[ "$push_choice" == "y" ]]; then
                        git push
                    else
                        echo "Push aborted."
                    fi
                else
                    echo "Staging aborted."
                fi
                cd - >/dev/null || exit 1
            done < <(check_repos "$current_directory")
        else
            echo "No repositories require actions."
        fi
    elif [[ "$choice" == "2" ]]; then
        read -rp "Do you want to abort the process? (Press Enter for No, Y for Yes default is No): " abort_choice
        abort_choice=$(echo "$abort_choice" | tr '[:upper:]' '[:lower:]')
        if [[ "$abort_choice" == "y" ]]; then
            echo "Operation aborted."
            exit 0
        fi

        read -rp "Do you want to update repositories here? (Press Enter for Yes, No for cancel, default is Yes): " main_directory
        main_directory=$(echo "$main_directory" | tr '[:upper:]' '[:lower:]')
        if [[ "$main_directory" == "y" ]]; then
            read -rp "Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No, default is Yes): " exclude_choice
            exclude_choice=$(echo "$exclude_choice" | tr '[:upper:]' '[:lower:]')
            if [[ "$exclude_choice" == "y" ]]; then
                include_aur=false
            else
                include_aur=true
            fi
            update_github_repositories "$current_directory" "$include_aur"
        else
            echo "You need to be inside a directory with GitHub repositories to update them."
            exit 1
        fi
    elif [[ "$choice" == "3" ]]; then
        read -rp "Do you want to update repositories over SSH? (Y/n): " ssh_choice
        ssh_choice=$(echo "$ssh_choice" | tr '[:upper:]' '[:lower:]')
        if [[ "$ssh_choice" == "y" ]]; then
            update_repos_ssh "$current_directory"
        else
            echo "SSH update aborted."
        fi
    else
        echo "Invalid option. Exiting."
        exit 1
    fi
}

main
