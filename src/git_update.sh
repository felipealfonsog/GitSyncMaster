#!/bin/bash

# Main directory where the subfolders containing git repositories are located
main_directory="/path"

# Iterate over subfolders
for dir in "$main_directory"/*/; do
    if [ -d "$dir/.git" ]; then
        # If it's a git repository, perform git pull
        echo "Updating repository in $dir"
        cd "$dir" || exit
        git pull
        cd - || exit
    fi
done

