#!/bin/bash

# Main directory where the subfolders containing git repositories are located
main_directory="/path"
# Flag indicating whether to exclude directories. True to exclude.
exclude_flag=true
# Directories to exclude from updating
exclude_directories=(
    "/home/path/dir1"
    "/home/path/dir2"
    # Add more directories as needed
)

# Function to check if a directory is in the exclusion list
is_excluded() {
    local dir_to_check=$(realpath -m "$1")  # Get the full path of the directory to check
    for excluded_dir in "${exclude_directories[@]}"; do
        if [[ "$dir_to_check" == "$(realpath -m "$excluded_dir")" ]]; then
            return 0
        fi
    done
    return 1
}

# Iterate over subfolders
for dir in "$main_directory"/*/; do
    if [ -d "$dir/.git" ]; then
        if [ "$exclude_flag" = true ] && is_excluded "$dir"; then
            echo "Skipping $dir (excluded from update)"
            continue
        fi
        # If it's a git repository and not excluded, perform git pull
        echo "Updating repository in $dir"
        cd "$dir" || exit
        git pull
        cd - || exit
    fi
done
