import os

def welcome():
    print("Welcome to GitHub Repository Updater!")
    print("This script was developed by Computer Science Engineer Felipe Alfonso González - github: github.com/felipealfonsog - under the BSD 3-clause license.")
    print("Developed from Chile with love.")
    print("----------------------------------------------------")
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
    main_directory = input(f"Current directory is: {current_directory}\nDo you want to update repositories here? (Y/N): ")
    if main_directory.lower() == 'y':
        exclude_choice = input("Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No): ").lower()
        if exclude_choice == '' or exclude_choice == 'y':
            include_aur = False
        else:
            include_aur = True
        update_github_repositories(current_directory, include_aur)
    else:
        print("You need to be inside a directory with GitHub repositories to update them.")

if __name__ == "__main__":
    main()
