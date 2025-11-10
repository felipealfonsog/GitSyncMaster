import os

def welcome():
    print("Welcome to GitHub Repository Updater!")
    print("This script will update all GitHub repositories within the specified directory.")

def update_github_repositories(main_directory):
    print("\nUpdating GitHub repositories...\n")
    for root, dirs, files in os.walk(main_directory):
        if '.git' in dirs:
            git_dir = os.path.join(root, '.git')
            if os.path.isdir(git_dir):
                print(f"Updating repository in {root}")
                os.chdir(root)
                os.system('git pull')
                os.chdir(main_directory)

def main():
    welcome()
    main_directory = input("Enter the path to the directory containing GitHub repositories: ")
    update_github_repositories(main_directory)

if __name__ == "__main__":
    main()
