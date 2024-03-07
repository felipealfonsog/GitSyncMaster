import os

def welcome():
    print("Welcome to GitHub Repository Updater!")
    print("This script will update all GitHub repositories within the specified directory.")

def update_github_repositories(main_directory, include_aur):
    print("\nUpdating GitHub repositories...\n")
    for root, dirs, files in os.walk(main_directory):
        if '.git' in dirs:
            git_dir = os.path.join(root, '.git')
            if os.path.isdir(git_dir):
                if include_aur or not root.endswith("-aur"):
                    print(f"Updating repository in {root}")
                    os.chdir(root)
                    os.system('git pull')
                    os.chdir(main_directory)

def main():
    welcome()
    main_directory = input("Enter the path to the directory containing GitHub repositories: ")
    include_aur = input("Do you want to include directories with the '-aur' suffix? (Y/N): ").lower() == 'y'
    update_github_repositories(main_directory, include_aur)

if __name__ == "__main__":
    main()
