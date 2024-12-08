import os
import platform
import subprocess

def is_command_available(command):
    """Check if a command is available in the system."""
    return subprocess.call(f"type {command}", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0

def welcome():
    print("\033[1;32mWelcome to GitHub Repository Updater - GitSyncMaster -!\033[0m")
    print("\033[1;32mEffortlessly Automate Git Repository Updates Across Platforms.\033[0m")
    print("\033[1;34mPlatform detected: {}\033[0m".format(platform.system()))

def check_prerequisites():
    """Ensure necessary commands are available."""
    required_commands = ['git', 'gh']
    missing = [cmd for cmd in required_commands if not is_command_available(cmd)]
    if missing:
        print(f"\033[1;31mError: Missing required commands: {', '.join(missing)}. Please install them first.\033[0m")
        exit(1)

def create_pull_request(repo_path):
    """Create a Pull Request (PR) in a repository."""
    print(f"\033[1;34mCreating a Pull Request in {repo_path}...\033[0m")
    os.chdir(repo_path)
    # Ensure there is a branch and changes are pushed
    branch_name = "update-branch"
    try:
        # Create and switch to a new branch
        subprocess.run(['git', 'checkout', '-b', branch_name], check=True)
        # Push changes to the branch
        subprocess.run(['git', 'push', '-u', 'origin', branch_name], check=True)
        # Create a PR using `gh`
        pr_result = subprocess.run(['gh', 'pr', 'create', '--fill'], capture_output=True, text=True)
        if pr_result.returncode == 0:
            print("\033[1;32mPull Request created successfully!\033[0m")
        else:
            print(f"\033[1;31mError creating Pull Request:\033[0m\n{pr_result.stderr}")
    except subprocess.CalledProcessError as e:
        print(f"\033[1;31mError managing branch or pushing changes: {e}\033[0m")
    finally:
        os.chdir(repo_path)

def check_repos(main_directory):
    print("\nChecking for repositories requiring actions...\n")
    repos_needing_action = []
    for root, dirs, _ in os.walk(main_directory):
        if '.git' in dirs:
            os.chdir(root)
            changes = subprocess.getoutput('git status --porcelain').strip()
            if changes:
                repos_needing_action.append(root)
            os.chdir(main_directory)

    if repos_needing_action:
        print("\033[1;33mThe following repositories require actions:\033[0m")
        for repo in repos_needing_action:
            print(f"\033[1;34m- {repo}\033[0m")
    else:
        print("\033[1;32mNo repositories require actions.\033[0m")
    return repos_needing_action

def update_repos(main_directory, include_aur):
    print("\nUpdating GitHub repositories...\n")
    for root, dirs, _ in os.walk(main_directory):
        if '.git' in dirs:
            if not include_aur and root.endswith("-aur"):
                continue
            os.chdir(root)
            print(f"\033[1;34mUpdating repository: {root}\033[0m")
            try:
                result = subprocess.run(['git', 'pull'], capture_output=True, text=True)
                if result.returncode == 0:
                    print("\033[1;32mRepository updated successfully.\033[0m")
                else:
                    print(f"\033[1;31mError updating repository:\033[0m\n{result.stderr}")
            except Exception as e:
                print(f"\033[1;31mError updating repository {root}: {e}\033[0m")
            os.chdir(main_directory)

def menu():
    print("\n\033[1;36mMenu Options:\033[0m")
    print("1. Check repositories requiring actions.")
    print("2. Update repositories.")
    print("3. Create Pull Requests for repositories needing action.")
    print("4. Exit.")
    choice = input("Enter your choice (default is 2): ").strip() or '2'
    return choice

def main():
    welcome()
    check_prerequisites()
    current_directory = os.getcwd()
    print(f"\033[1;34mCurrent Directory: {current_directory}\033[0m")
    if not any('.git' in dirs for _, dirs, _ in os.walk(current_directory)):
        print("\033[1;31mNo Git repositories found in the current directory or its subdirectories.\033[0m")
        exit(1)

    while True:
        choice = menu()
        if choice == '1':
            repos = check_repos(current_directory)
            if repos:
                print("\033[1;33mCheck completed. Use option 3 to create Pull Requests if needed.\033[0m")
            else:
                print("No repositories require actions.")
        elif choice == '2':
            exclude_aur = input("\nExclude directories with '-aur' suffix? (Y/n, default is Y): ").lower() or 'y'
            include_aur = False if exclude_aur == 'y' else True
            update_repos(current_directory, include_aur)
        elif choice == '3':
            repos = check_repos(current_directory)
            if repos:
                for repo in repos:
                    print(f"\033[1;34mProcessing repository: {repo}\033[0m")
                    create_pull_request(repo)
            else:
                print("\033[1;32mNo repositories require actions. Nothing to PR.\033[0m")
        elif choice == '4':
            print("\033[1;32mExiting GitSyncMaster. Goodbye!\033[0m")
            break
        else:
            print("\033[1;31mInvalid choice. Please try again.\033[0m")

if __name__ == "__main__":
    main()
