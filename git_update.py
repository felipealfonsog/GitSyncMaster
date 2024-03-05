import os

main_directory = "/path"

def update_git_repositories():
    for root, dirs, files in os.walk(main_directory):
        if '.git' in dirs:
            git_dir = os.path.join(root, '.git')
            if os.path.isdir(git_dir):
                print(f"Updating repository in {root}")
                os.chdir(root)
                os.system('git pull')
                os.chdir(main_directory)

if __name__ == "__main__":
    update_git_repositories()

