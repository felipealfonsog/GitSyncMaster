import os

def welcome():
    print("Welcome to GitHub Repository Updater -GitSyncMaster-!")
    print("This software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license.")
    print("Developed from Chile with love.")
    print("----------------------------------------------------")
    print("This software will update all GitHub repositories within the current directory or its subdirectories.")

def update_github_repositories(main_directory, include_aur):
    print("\nUpdating GitHub repositories...\n")
    found_repos = False
    for root, dirs, files in os.walk(main_directory):
        if '.git' in dirs:
            found_repos = True
            git_dir = os.path.join(root, '.git')
            if os.path.isdir(git_dir):
                if include_aur or not root.endswith("-aur"):
                    print(f"Updating repository in {root}")
                    os.chdir(root)
                    result = os.system('git pull')
                    os.chdir(main_directory)
                    if result == 0:
                        print("Repository updated successfully.")
                    else:
                        print("Error updating repository.")
    if not found_repos:
        print("No GitHub repositories found in the current directory or its subdirectories. Exiting.")
        exit()

def main():
    welcome()
    current_directory = os.getcwd()
    if not any('.git' in root for root, _, _ in os.walk(current_directory)):
        print("You need to be inside a directory with GitHub repositories to update them.")
        exit()
    main_directory = input("Do you want to update repositories here? (Press Enter for Yes, No for cancel, default is Yes): ")
    if main_directory.lower() == '' or main_directory.lower() == 'y':
        abort_choice = input("Do you want to abort the process? (Press Enter for No, Y for Yes default is No): ").lower()
        if abort_choice == 'y':
            print("Operation aborted.")
            exit()
    else:
        print("You need to be inside a directory with GitHub repositories to update them.")
        exit()
    exclude_choice = input("Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No, default is Yes): ").lower()
    if exclude_choice == '' or exclude_choice == 'y':
        include_aur = False
    else:
        include_aur = True
    update_github_repositories(current_directory, include_aur)

if __name__ == "__main__":
    main()
