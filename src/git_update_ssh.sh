#!/bin/bash

# Define the main directory containing GitHub repositories
MAIN_DIRECTORY="/path"

# Check if the main directory exists
if [ ! -d "$MAIN_DIRECTORY" ]; then
    echo "The specified main directory does not exist."
    exit 1
fi

# Change to the main directory
cd "$MAIN_DIRECTORY" || exit 1

# Configure the SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Update each repository in the main directory
for repo in *; do
    if [ -d "$repo/.git" ]; then
        echo -e "\n--------------------------------"
        echo "Updating $repo..."
        cd "$repo" || continue
        # Check if there are pending changes
        result=$(git fetch origin "$(git symbolic-ref --short HEAD)" && git status -uno 2>&1)
        if [[ $result == *"Your branch is up to date"* ]]; then
            echo "Repository $repo is already up-to-date."
        else
            git pull --quiet origin "$(git symbolic-ref --short HEAD)"
            echo "Repository $repo has been updated."
        fi
        cd ..
    fi
done

echo -e "\n--------------------------------"
echo "All repositories have been checked and updated if necessary."

