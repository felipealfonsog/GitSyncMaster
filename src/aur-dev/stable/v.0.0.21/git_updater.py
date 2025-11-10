import os

def welcome():
    print("\033[1;32mWelcome to GitHub Repository Updater -GitSyncMaster-!\033[0m")
    print("\033[1;32mThis software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license.\033[0m")
    print("\033[1;32mDeveloped from Chile with love.\033[0m")
    print("\033[1;32m----------------------------------------------------\033[0m")
    print("\033[1;32m\033[1mEffortlessly Automate Git Repository Updates, Including Committing and Pulling, Across Directory Structures.\033[0m")

def update_github_repositories(main_directory, include_aur):
    print("\nUpdating GitHub repositories...\n")
    found_repos = False
    for root, dirs, files in os.walk(main_directory):
        if '.git' in dirs:
            found_repos = True
            git_dir = os.path.join(root, '.git')
            if os.path.isdir(git_dir):
                if include_aur or not root.endswith("-aur"):
                    os.chdir(root)
                    changes = os.popen('git status --porcelain').read().strip()
                    if changes:
                        print(f"\033[1;31mRepository in {root} requires a commit before updating.\033[0m")
                        try:
                            result = os.system('git pull')
                            if result == 0:
                                print("Repository updated successfully.")
                            else:
                                print("Error updating repository.")
                        except Exception as e:
                            print(f"Error updating repository: {e}")
                    else:
                        print(f"Updating repository in {root}")
                        try:
                            result = os.system('git pull')
                            if result == 0:
                                print("Repository updated successfully.")
                            else:
                                print("Error updating repository.")
                        except Exception as e:
                            print(f"Error updating repository: {e}")
                    os.chdir(main_directory)
    if not found_repos:
        print("No GitHub repositories found in the current directory or its subdirectories. Exiting.")
        exit()

def check_repos(main_directory):
    print("\nChecking for repositories requiring actions...\n")
    repos_needing_action = []
    for root, dirs, _ in os.walk(main_directory):
        for dir in dirs:
            repo_path = os.path.join(root, dir)
            git_dir = os.path.join(repo_path, '.git')
            if os.path.isdir(git_dir):
                os.chdir(repo_path)
                changes = os.popen('git status --porcelain').read().strip()
                if changes:
                    repos_needing_action.append(repo_path)
                os.chdir(main_directory)

    if repos_needing_action:
        print("The following repositories require actions:")
        for repo in repos_needing_action:
            print(repo)
        return repos_needing_action
    else:
        print("No repositories require actions.")
        return []

def main():
    welcome()
    current_directory = os.getcwd()
    if not any('.git' in root for root, _, _ in os.walk(current_directory)):
        print("You need to be inside a directory with GitHub repositories to update them.")
        exit()

    choice = input("Choose an option:\n1. Check repositories requiring actions.\n2. Update repositories.\nEnter option number (default is 2): ").strip() or '2'
    if choice == '1':
        repos = check_repos(current_directory)
        if repos:
            proceed = input("Do you want to proceed with the action? (Y/n): ").lower()
            if proceed not in ['', 'y']:
                print("Action aborted.")
                exit()
            
            for repo_path in repos:
                os.chdir(repo_path)
                changes = os.popen('git status --porcelain').read().strip()
                print(f"Repository: {repo_path}\nChanges:\n{changes}")
                stage_choice = input("Do you want to stage these changes for commit? (Y/n): ").lower()
                if stage_choice in ['', 'y']:
                    os.system('git add .')
                    commit_message = input("Enter commit message: ")
                    os.system(f'git commit -m "{commit_message}"')
                    push_choice = input("Do you want to push these changes? (Y/n): ").lower()
                    if push_choice in ['', 'y']:
                        os.system('git push')
                    else:
                        print("Push aborted.")
                else:
                    print("Staging aborted.")
                os.chdir(current_directory)
        else:
            print("No repositories require actions.")
    elif choice == '2':
        abort_choice = input("Do you want to abort the process? (Press Enter for No, Y for Yes default is No): ").lower() or 'n'
        if abort_choice == 'y':
            print("Operation aborted.")
            exit()

        main_directory = input("Do you want to update repositories here? (Press Enter for Yes, No for cancel, default is Yes): ")
        if main_directory.lower() == '' or main_directory.lower() == 'y':
            exclude_choice = input("Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No, default is Yes): ").lower() or 'y'
            if exclude_choice == 'y':
                include_aur = False
            else:
                include_aur = True
            update_github_repositories(current_directory, include_aur)
        else:
            print("You need to be inside a directory with GitHub repositories to update them.")
            exit()
    else:
        print("Invalid option. Exiting.")
        exit()

if __name__ == "__main__":
    main()
