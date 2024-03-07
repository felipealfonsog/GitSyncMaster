import os

def welcome():
    print("Welcome to GitHub Repository Updater!")
    print("This script will update all GitHub repositories within the current directory or its subdirectories.")

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
    current_directory = os.getcwd()
    main_directory = input(f"Current directory is: {current_directory}\nDo you want to update repositories here? (Press Enter for Yes, N for No): ").lower()
    if main_directory == '' or main_directory == 'y':
        include_aur = input("Do you want to include directories with the '-aur' suffix? (Press Enter for Yes, N for No): ").lower() == 'y'
        update_github_repositories(current_directory, include_aur)
    else:
        print("You need to be inside a directory with GitHub repositories to update them.")

if __name__ == "__main__":
    main()
