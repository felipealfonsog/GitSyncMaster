import os
import subprocess

def print_header():
    print("""
    ==========================================================

                .__  __                               
        ____ |__|/  |_  _________.__. ____   ____  
        / ___\|  \   __\/  ___<   |  |/    \_/ ___\ 
        / /_/  >  ||  |  \___ \ \___  |   |  \  \___ 
        \___  /|__||__| /____  >/ ____|___|  /\___  >
        /_____/               \/ \/         \/     \/ 

    ==========================================================
    
    Gitsync: A tool to automate the process of checking and 
    creating pull requests for Git repositories with a simple 
    interface and improved functionality.

    License: BSD-3-Clause

    Programmed with love in Chile by Felipe Alfonso González
    Contact: f.alfonso@res-ear.ch
    GitHub: github.com/felipealfonsog

    ==========================================================
    """)

def print_credits():
    print("_" * 50)
    print(" " * 15 + "CREDITS" + " " * 15)
    print("-" * 50)
    print("-" * 50)
    print("By Computer Science Engineer Felipe Alfonso González")
    print("GitHub: https://github.com/felipealfonsog/")
    print("LinkedIn: https://www.linkedin.com/in/felipealfonso/")
    print("Twitter: https://twitter.com/felipealfonsog/")
    print("License: BSD 3-Clause License")
    print("-" * 50)
    print("_" * 50)


def check_repositories(base_path, exclude_suffix="-aur"):
    for root, dirs, _ in os.walk(base_path):
        dirs[:] = [d for d in dirs if not d.endswith(exclude_suffix)]
        for d in dirs:
            repo_path = os.path.join(root, d)
            if os.path.isdir(os.path.join(repo_path, ".git")):
                os.chdir(repo_path)

                status = subprocess.run(["git", "status", "--short"], capture_output=True, text=True)
                if status.stdout.strip():
                    print(f"\nChanges detected in repository: {repo_path}")
                    commit_msg = input("Enter commit message (default is 'Updates'): ").strip() or "Updates"
                    try:
                        subprocess.run(["git", "add", "-A"], check=True)
                        subprocess.run(["git", "commit", "-m", commit_msg], check=True)

                        # Get the current branch name
                        branch_result = subprocess.run(["git", "branch", "--show-current"], capture_output=True, text=True, check=True)
                        current_branch = branch_result.stdout.strip()

                        # Push to the current branch
                        subprocess.run(["git", "push", "origin", current_branch], check=True)
                        print(f"Changes pushed to repository: {repo_path}\n")

                    except subprocess.CalledProcessError as e:
                        print(f"Error while pushing changes in {repo_path}: {e}\n")
                else:
                    pass  # No changes detected, skip output

def update_repositories(base_path):
    for root, dirs, _ in os.walk(base_path):
        for d in dirs:
            repo_path = os.path.join(root, d)
            if os.path.isdir(os.path.join(repo_path, ".git")):
                print(f"\nUpdating repository in {repo_path}...")
                os.chdir(repo_path)

                process = subprocess.run(["git", "pull"], capture_output=True, text=True)
                print(process.stdout)

                if process.returncode == 0:
                    print("Repository updated successfully.\n")
                else:
                    print(f"Failed to update repository. Error: {process.stderr}\n")



def create_and_merge_pr(repo_path):
    os.chdir(repo_path)

    current_branch_result = subprocess.run(["git", "branch", "--show-current"], capture_output=True, text=True)
    current_branch = current_branch_result.stdout.strip()

    if not current_branch:
        print(f"Error getting the current branch in {repo_path}.")
        return

    print(f"Creating PR from {current_branch} to master in {repo_path}...")

    create_pr_result = subprocess.run(
        ["gh", "pr", "create", "--base", "master", "--head", current_branch, "--fill"],
        capture_output=True, text=True
    )

    if create_pr_result.returncode != 0:
        print(f"Error creating the PR: {create_pr_result.stderr}")
        return

    pr_number = create_pr_result.stdout.split()[0]
    print(f"PR created successfully with number: {pr_number}")

    merge_pr_result = subprocess.run(
        ["gh", "pr", "merge", pr_number, "--merge"],
        capture_output=True, text=True
    )

    if merge_pr_result.returncode != 0:
        print(f"Error merging the PR: {merge_pr_result.stderr}")
        return

    print(f"PR #{pr_number} successfully merged into master.")









def main():
    print_header()
    base_path = os.getcwd()

    while True:
        print("\nOptions:")
        print("1. Check repositories and push changes")
        print("2. Update repositories")
        print("3. Find and create pull requests")
        print("4. Show credits")
        print("5. Exit")

        option = input("Enter option number (default is 2): ").strip() or "2"

        if option == "1":
            exclude_dirs = input("Do you want to exclude directories with the '-aur' suffix? (Press Enter for Yes, N for No, default is Yes): ").strip().lower()
            if exclude_dirs != "n":
                check_repositories(base_path)
            else:
                check_repositories(base_path, exclude_suffix="")

        elif option == "2":
            update_repositories(base_path)

        elif option == "3":
            find_and_create_pr(base_path)

        elif option == "4":
            print_credits()

        elif option == "5":
            print("Exiting program. Goodbye!")
            break

        else:
            print("Invalid option. Please try again.")

if __name__ == "__main__":
    main()

