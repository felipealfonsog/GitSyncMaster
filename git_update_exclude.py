import os

main_directory = "/path"
# True to exclude
exclude_flag = True
exclude_directories = [
    "/path/dir1",
    "/path/dir2",
    # Add more directories as needed
]

def is_excluded(directory):
    for excluded_dir in exclude_directories:
        if directory == excluded_dir:
            return True
    return False

def update_git_repositories():
    for root, dirs, files in os.walk(main_directory):
        if '.git' in dirs:
            git_dir = os.path.join(root, '.git')
            if os.path.isdir(git_dir) and (not exclude_flag or not is_excluded(root)):
                print(f"Updating repository in {root}")
                os.chdir(root)
                os.system('git pull')
                os.chdir(main_directory)

if __name__ == "__main__":
    update_git_repositories()

