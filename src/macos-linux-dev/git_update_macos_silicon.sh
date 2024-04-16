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


# Function to perform git add
perform_git_add() {
    git add .
}

# Function to perform git commit
perform_git_commit() {
    # Prompt for commit message
    read -rp "Enter commit message: " commit_message

    # Commit changes
    git commit -m "$commit_message"
}

# Function to update repositories over SSH
update_repos_ssh() {
    # Configure the SSH agent
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa

    # Update each repository
    for repo in */.git; do
        repo_dir=$(dirname "$repo")
        echo -e "\n--------------------------------"
        echo "Updating $(basename "$repo_dir")..."
        cd "$repo_dir" || continue
        # Check if there are pending changes
        result=$(git fetch origin "$(git symbolic-ref --short HEAD)" && git status -uno 2>&1)
        if [[ $result == *"Your branch is up to date"* ]]; then
            echo "Repository $(basename "$repo_dir") is already up-to-date."
        else
            git pull --quiet origin "$(git symbolic-ref --short HEAD)"
            echo "Repository $(basename "$repo_dir") has been updated."
        fi
        cd - >/dev/null || exit
    done

    echo -e "\n--------------------------------"
    echo "All repositories have been checked and updated if necessary."
}

# Function to update repositories over HTTPS
update_repos_https() {
    # Ask if the user wants to update repositories with '-aur' suffix
    read -rp "Do you want to update repositories with '-aur' suffix? (Y/n): " aur_choice
    aur_choice=${aur_choice:-y}
    aur_choice=${aur_choice,,} # Convert to lowercase

    # Update each repository
    for repo in */.git; do
        repo_dir=$(dirname "$repo")
        echo -e "\n--------------------------------"
        echo "Updating $(basename "$repo_dir") over HTTPS..."
        cd "$repo_dir" || continue
        git pull --quiet origin "$(git symbolic-ref --short HEAD)"
        echo "Repository $(basename "$repo_dir") has been updated."
        cd - >/dev/null || exit
    done

    echo -e "\n--------------------------------"
    echo "All repositories have been checked and updated if necessary."
}

# Function to check repositories and perform actions
check_repos() {
    local changed_dir=false  # Flag to check if any directory has changes

    # Loop through directories
    for dir in */; do
        # Check if the directory is a git repository
        if [ -d "$dir/.git" ]; then
            # Change directory to the git repository
            cd "$dir" || exit

            # Check if there are any changes
            if [[ -n $(git status --porcelain) ]]; then
                changed_dir=true  # Set flag to true
                # Ask if user wants to perform git add
                read -rp "Do you want to perform 'git add .' in '$dir'? (Y/n): " add_choice

                # Check user's choice
                case "$(tr '[:upper:]' '[:lower:]' <<< "$add_choice")" in

                    [y]|"")   perform_git_add;;
                    [n])      echo "Skipping 'git add .' in '$dir'."
                              continue;;
                    *)        echo "Invalid choice. Skipping 'git add .' in '$dir'."
                              continue;;
                esac

                # Check if there are changes to commit
                if ! git diff-index --quiet HEAD --; then
                    # Perform git commit
                    perform_git_commit

                    # Push changes
                    git push

                    # Check if push was successful
                    if [ $? -eq 0 ]; then
                        echo "Changes in '$dir' were successfully committed and pushed."
                    else
                        echo "Failed to push changes in '$dir'."
                    fi
                else
                    echo "No changes to commit in '$dir'."
                fi
            fi

            # Change directory back to the parent directory
            cd - >/dev/null || exit
        fi
    done

    # Check if no directory has changes
    if ! $changed_dir; then
        echo "No directories require actions."
    fi
}

# Main menu function
main_menu() {
    welcome
    echo "1. Update all repositories over SSH"
    echo "2. Update all repositories over HTTPS"
    echo "3. Check repositories for actions"
    echo "4. Quit"
    read -rp "Enter your choice: " choice

    case $choice in
        1) update_repos_ssh;;
        2) update_repos_https;;
        3) check_repos;;
        4) echo "Exiting..."; exit;;
        *) echo "Invalid choice. Please enter a valid option.";;
    esac
}

# Call the main menu function
main_menu
