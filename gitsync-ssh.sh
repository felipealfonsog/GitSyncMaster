#!/bin/bash

# Check if SSH agent is running, if not, start one
if ! pgrep -U "$USER" -x ssh-agent >/dev/null; then
    echo "Starting SSH agent..."
    eval "$(ssh-agent -s)"
fi

# Add SSH key to the agent's cache
ssh-add -l &>/dev/null || ssh-add

welcome() {
    cat <<EOF
    ==========================================================

            .__  __                               
    ____ |__|/  |_  _________.__. ____   ____  
   / ___\|  \   __\/  ___<   |  |/    \_/ ___\ 
  / /_/  >  ||  |  \___ \ \___  |   |  \  \___ 
  \___  /|__||__| /____  >/ ____|___|  /\___  >
 /_____/               \/ \/         \/     \/ 

    ==========================================================

    Gitsync: A tool to automate the process of checking and 
    creating pull requests for Git repositories with a simple 
    interface and improved functionality.

    License: BSD-3-Clause

    Programmed with love in Chile by Felipe Alfonso González
    Contact: f.alfonso@res-ear.ch
    GitHub: github.com/felipealfonsog

    ==========================================================
EOF
}

show_credits() {
    cat <<EOF
 ____________________________________________________________
               CREDITS               
--------------------------------------------------
By Computer Science Engineer Felipe Alfonso González
GitHub: https://github.com/felipealfonsog/
LinkedIn: https://www.linkedin.com/in/felipealfonso/
Twitter: https://twitter.com/felipealfonsog/
License: BSD 3-Clause License
--------------------------------------------------
____________________________________________________________
EOF
}

update_github_repositories() {
    echo -e "\nUpdating GitHub repositories...\n"
    found_repos=false
    for git_dir in $(find "$1" -type d -name ".git"); do
        repo_path=$(dirname "$git_dir")
        if [ -d "$git_dir" ]; then
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
            found_repos=true
        fi
    done
    if [ "$found_repos" = false ]; then
        echo "No GitHub repositories found in the current directory or its subdirectories. Exiting."
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
    else
        echo "No repositories require actions."
    fi
}

create_pull_request() {
    echo -e "\nCreating pull request...\n"
    for git_dir in $(find "$1" -type d -name ".git"); do
        repo_path=$(dirname "$git_dir")
        if [ -d "$git_dir" ]; then
            cd "$repo_path" || exit
            current_branch=$(git branch --show-current)
            if [ -n "$current_branch" ]; then
                echo "Current branch: $current_branch"
                read -rp "Enter target branch for PR (default: main): " target_branch
                target_branch=${target_branch:-main}
                echo "Creating pull request from $current_branch to $target_branch..."
                # Placeholder for PR creation logic
                echo "Pull request created successfully."
            else
                echo "No active branch found. Skipping $repo_path."
            fi
            cd "$1" || exit
        fi
    done
}

main() {
    welcome
    current_directory=$(pwd)
    if ! find "$current_directory" -type d -name ".git" | grep -q .; then
        echo "You need to be inside a directory with GitHub repositories to update them."
        exit 1
    fi

    while true; do
        echo -e "\nChoose an option:
1. Check repositories requiring actions.
2. Update repositories.
3. Find and create pull requests.
4. Show credits.
5. Exit."
        read -rp "Enter option number (default is 2): " choice
        choice=${choice:-2}

        case "$choice" in
            1)
                check_repos "$current_directory"
                ;;
            2)
                update_github_repositories "$current_directory"
                ;;
            3)
                create_pull_request "$current_directory"
                ;;
            4)
                show_credits
                ;;
            5)
                echo "Exiting... Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
}

main
