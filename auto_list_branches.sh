#!/bin/bash

# Automatically detect the base directory from where the script is executed
base_dir=$(pwd)

echo "Searching for repositories in the base directory: $base_dir"

# Function to list branches of a Git repository
list_branches() {
    local repo_path="$1"
    echo "=== Branches in $repo_path ==="
    cd "$repo_path" || return
    git branch -a
    echo ""
}

# Automatically find Git repositories and list branches
find "$base_dir" -type d -name ".git" | while read -r git_dir; do
    repo_path=$(dirname "$git_dir") # Get the repository path
    list_branches "$repo_path"
done
