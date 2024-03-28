#!/bin/bash

# Verificar si el agente SSH está en ejecución y, si no, iniciar uno
if ! pgrep -U "$USER" -x ssh-agent >/dev/null; then
    echo "Starting SSH agent..."
    eval "$(ssh-agent -s)"
fi

# Añadir la clave SSH a la caché del agente SSH
ssh-add -l &>/dev/null || ssh-add

welcome() {
    echo -e "\033[1;32mWelcome to GitHub Repository Updater -GitSyncMaster-!\033[0m"
    echo -e "\033[1;32mThis software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license.\033[0m"
    echo -e "\033[1;32mDeveloped from Chile with love.\033[0m"
    echo -e "\033[1;32m----------------------------------------------------\033[0m"
    echo -e "\033[1;32m\033[1mEffortlessly Automate Git Repository Updates, Including Committing and Pulling, Across Directory Structures.\033[0m"
    echo -e "\033[1;32mPlease enter your SSH passphrase if prompted:\033[0m"
}

update_github_repositories() {
    echo -e "\nUpdating GitHub repositories...\n"
    found_repos=false
    for git_dir in $(find "$1" -type d -name ".git"); do
        repo_path=$(dirname "$git_dir")
        if [ -d "$git_dir" ]; then
            if [[ $include_aur == "true" || ! $repo_path =~ "-aur"$ ]]; then
                cd "$repo_path" || exit
                changes=$(git status --porcelain)
                if [ -n "$changes" ]; then
                    echo -e "\033[1;31mRepository in $repo_path requires a commit before updating.\033[0m"
                    if git pull; then
                        echo "Repository updated successfully."
                    else
                        echo "Error updating repository."
                    fi
                else
                    echo "Updating repository in $repo_path"
                    if git pull; then
                        echo "Repository updated successfully."
                    else
                        echo "Error updating repository."
                    fi
                fi
                cd "$1" || exit
            fi
            found_repos=true
        fi
    done
    if [ "$found_repos" = false ]; then
        echo "No GitHub repositories found in the current directory or its subdirectories. Exiting."
        exit 1
    fi
}

check_repos() {
    echo -e "\nChecking for repositories requiring actions...\n"
    repos_needing_action=()
    while IFS= read -r -d '' dir; do
        git_dir="$dir/.git"
        if [ -d "$git_dir" ]; then
            cd "$dir" || exit
            changes=$(git status --porcelain)
            if [ -n "$changes" ]; then
                repos_needing_action+=("$dir")
            fi
            cd "$1" || exit
        fi
    done < <(find "$1" -mindepth 1 -maxdepth 1 -type d -print0)
    if [ ${#repos_needing_action[@]} -gt 0 ]; then
        echo "The following repositories require actions:"
        printf "%s\n" "${repos_needing_action[@]}"
        return 0
    else
        echo "No repositories require actions."
        return 1
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
Enter option number (default is 2): " choice
    choice=${choice:-2}
    if [ "$choice" = "1" ]; then
        if check_repos "$current_directory"; then
            read -rp "Do you want to proceed with the action? (Y/n): " proceed
            proceed=${proceed:-y}
            proceed=${proceed,,}
            if [ "$proceed" != "y" ]; then
                echo "Action aborted."
                exit 1
            fi
            while IFS= read -r repo_path; do
                cd "$repo_path" || exit
                changes=$(git status --porcelain)
                echo -e "Repository: $repo_path\nChanges:\n$changes"
                read -rp "Do you want to stage these changes for commit? (Y/n): " stage_choice
                stage_choice=${stage_choice:-y}
                stage_choice=${stage_choice,,}
                if [ "$stage_choice" = "y" ]; then
                    git add .
                    read -rp "Enter commit message: " commit_message
                    git commit -m "$commit_message"
                    read -rp "Do you want to push these changes? (Y/n): " push_choice
                    push_choice=${push_choice:-y}
                    push_choice=${push_choice,,}
                    if [ "$push_choice" = "y" ]; then
                        git push
                    else
                        echo "Push aborted."
                    fi
                else
                    echo "Staging aborted."
                fi
                cd "$current_directory" || exit
            done < <(check_repos "$current_directory")
        else
            echo "No repositories require actions."
        fi
    elif [ "$choice" = "2" ]; then
        read -rp "Do you want to abort the process? (Press Enter for No, Y for Yes default is No): " abort_choice
        abort_choice=${abort_choice:-n}
        abort_choice=${abort_choice,,}
        if [ "$abort_choice" = "y" ]; then
            echo "Operation aborted."
            exit 1
        fi

        read -rp "Do you want to update repositories here? (Press Enter for Yes, No for cancel, default is Yes): " main_directory
        main_directory=${main_directory:-y}
        main_directory=${main_directory,,}
        if [ "$main_directory" = "y" ]; then
            read -rp "Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No, default is Yes): " exclude_choice
            exclude_choice=${exclude_choice:-y}
            exclude_choice=${exclude_choice,,}
            if [ "$exclude_choice" = "y" ]; then
                include_aur=false
            else
                include_aur=true
            fi
            update_github_repositories "$current_directory" "$include_aur"
        else
            echo "You need to be inside a directory with GitHub repositories to update them."
            exit 1
        fi
    else
        echo "Invalid option. Exiting."
        exit 1
    fi
}

main
