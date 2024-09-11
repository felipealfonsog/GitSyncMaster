import os
import subprocess

def welcome():
    if os.uname().sysname == "Darwin":
        print("\033[1;32mWelcome to GitHub Repository Updater - GitSyncMaster -!\033[0m")
        print("\033[1;32mThis software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license.\033[0m")
        print("\033[1;32mDeveloped from Chile with love.\033[0m")
        print("\033[1;32m----------------------------------------------------\033[0m")
        print("\033[1;32m\033[1mEffortlessly Automate Git Repository Updates, Including Committing and Pulling, Across Directory Structures.\033[0m")
    else:
        print("Welcome to GitHub Repository Updater - GitSyncMaster -!")
        print("This software was developed by Computer Science Engineer Felipe Alfonso González - Github: github.com/felipealfonsog - Under the BSD 3-clause license.")
        print("Developed from Chile with love.")
        print("----------------------------------------------------")
        print("Effortlessly Automate Git Repository Updates, Including Committing and Pulling, Across Directory Structures.")

def perform_git_add():
    subprocess.run(["git", "add", "."], check=True)

def perform_git_commit():
    commit_message = input("Enter commit message: ")
    subprocess.run(["git", "commit", "-m", commit_message], check=True)

def update_repos_ssh():
    ssh_agent_result = subprocess.run(["ssh-agent", "-s"], capture_output=True, text=True, shell=True)
    if ssh_agent_result.returncode == 0:
        ssh_add_result = subprocess.run(["ssh-add", os.path.expanduser("~/.ssh/id_rsa")], capture_output=True, shell=True)
        if ssh_add_result.returncode == 0:
            for repo in filter(lambda x: os.path.isdir(os.path.join(x, ".git")), os.listdir()):
                repo_dir = os.path.join(os.getcwd(), repo)
                print("\n--------------------------------")
                print(f"Updating {os.path.basename(repo_dir)}...")
                os.chdir(repo_dir)
                branch_name = subprocess.run(["git", "symbolic-ref", "--short", "HEAD"], capture_output=True, text=True).stdout.strip()
                git_fetch_result = subprocess.run(["git", "fetch", "origin", branch_name], capture_output=True, text=True)
                if "Your branch is up to date" in git_fetch_result.stdout:
                    print(f"Repository {os.path.basename(repo_dir)} is already up-to-date.")
                else:
                    subprocess.run(["git", "pull", "--quiet", "origin", branch_name], check=True)
                    print(f"Repository {os.path.basename(repo_dir)} has been updated.")
                os.chdir("..")
            print("\n--------------------------------")
            print("All repositories have been checked and updated if necessary.")
        else:
            print("Failed to add SSH key to the agent.")
    else:
        print("Failed to start SSH agent.")

def update_repos_https():
    for repo in filter(lambda x: os.path.isdir(os.path.join(x, ".git")), os.listdir()):
        repo_dir = os.path.join(os.getcwd(), repo)
        print("\n--------------------------------")
        print(f"Updating {os.path.basename(repo_dir)} over HTTPS...")
        os.chdir(repo_dir)
        branch_name = subprocess.run(["git", "symbolic-ref", "--short", "HEAD"], capture_output=True, text=True).stdout.strip()
        subprocess.run(["git", "pull", "--quiet", "origin", branch_name], check=True)
        print(f"Repository {os.path.basename(repo_dir)} has been updated.")
        os.chdir("..")
    print("\n--------------------------------")
    print("All repositories have been checked and updated if necessary.")

def check_repos():
    changed_dir = False
    for dir in filter(os.path.isdir, os.listdir()):
        if os.path.isdir(os.path.join(dir, ".git")):
            os.chdir(dir)
            if subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True).stdout.strip():
                changed_dir = True
                add_choice = input(f"Do you want to perform 'git add .' in '{dir}'? (Y/n): ").lower()
                if add_choice in ["y", ""]:
                    perform_git_add()
                elif add_choice == "n":
                    print(f"Skipping 'git add .' in '{dir}'.")
                    continue
                else:
                    print("Invalid choice. Skipping 'git add .'.")
                    continue
                if not subprocess.run(["git", "diff-index", "--quiet", "HEAD", "--"], capture_output=True, text=True).stdout.strip():
                    perform_git_commit()
                    if subprocess.run(["git", "push"]).returncode == 0:
                        print(f"Changes in '{dir}' were successfully committed and pushed.")
                    else:
                        print(f"Failed to push changes in '{dir}'.")
                else:
                    print(f"No changes to commit in '{dir}'.")
            os.chdir("..")
    if not changed_dir:
        print("No directories require actions.")

def main_menu():
    welcome()
    print("1. Update all repositories over SSH")
    print("2. Update all repositories over HTTPS (default)")
    print("3. Check repositories for actions")
    print("4. Quit")
    choice = input("Enter your choice [2]: ") or "2"
    if choice == "1":
        update_repos_ssh()
    elif choice == "2":
        update_repos_https()
    elif choice == "3":
        check_repos()
    elif choice == "4":
        print("Exiting...")
        exit()
    else:
        print("Invalid choice. Please enter a valid option.")

if __name__ == "__main__":
    main_menu()
