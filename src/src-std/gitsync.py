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

def check_repositories(base_path):
    for root, dirs, _ in os.walk(base_path):
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

def find_and_create_pr(base_path):
    pr_created = False  # Flag to track if a PR was created
    pr_number = None  # Store the PR number to merge it later
    repos_missing_commits = []  # Track repos that require commits before PR creation

    for root, dirs, _ in os.walk(base_path):
        for d in dirs:
            repo_path = os.path.join(root, d)
            if os.path.isdir(os.path.join(repo_path, ".git")):
                print(f"\nChecking repository: {repo_path}")
                os.chdir(repo_path)

                # Get the current branch name
                branch_result = subprocess.run(["git", "branch", "--show-current"], capture_output=True, text=True)
                if branch_result.returncode != 0:
                    print(f"Failed to get the current branch for {repo_path}. Skipping.")
                    continue
                current_branch = branch_result.stdout.strip()

                if not current_branch:
                    print(f"Could not determine the current branch in {repo_path}. Skipping.")
                    continue

                print(f"Current branch: {current_branch}")

                # Fetch the latest updates from the remote repository
                fetch_result = subprocess.run(["git", "fetch"], capture_output=True, text=True)
                if fetch_result.returncode != 0:
                    print(f"Failed to fetch updates for {repo_path}. Error: {fetch_result.stderr}")
                    continue

                print(f"Fetching updates for {repo_path}...")

                # Check if the repository uses 'main' or 'master' as the default branch
                default_branch_result = subprocess.run(
                    ["git", "remote", "show", "origin"], capture_output=True, text=True
                )
                if default_branch_result.returncode != 0:
                    print(f"Failed to get the default branch for {repo_path}. Skipping.")
                    continue
                
                # Extract the default branch name (main or master)
                default_branch = None
                for line in default_branch_result.stdout.splitlines():
                    if "HEAD branch" in line:
                        default_branch = line.split(":")[1].strip()
                        break

                if not default_branch:
                    print(f"Could not determine the default branch for {repo_path}. Skipping.")
                    continue

                print(f"Default branch: {default_branch}")

                # Check for differences between local and remote branch using git diff
                diff_result = subprocess.run(
                    ["git", "diff", f"origin/{default_branch}..{current_branch}"],
                    capture_output=True, text=True
                )
                if diff_result.returncode != 0:
                    print(f"Error comparing branches in {repo_path}. Error: {diff_result.stderr}")
                    continue

                if diff_result.stdout.strip():
                    print(f"New commits detected in {repo_path}. Proceeding to create PR.")
                    
                    # Check if the PR already exists using GitHub API (gh)
                    pr_check_result = subprocess.run(
                        ["gh", "pr", "list", "--head", current_branch, "--state", "open"],
                        capture_output=True, text=True
                    )
                    
                    if pr_check_result.returncode == 0 and pr_check_result.stdout.strip():
                        # PR exists, show details
                        pr_url = pr_check_result.stdout.strip().split("\n")[0].split()[1]
                        pr_number = pr_check_result.stdout.strip().split("\n")[0].split()[0]
                        print(f"PR already exists for {repo_path}: {pr_url} (PR #{pr_number})")
                        
                        # Merge the PR directly using GitHub CLI
                        if pr_number:
                            print(f"Attempting to merge PR #{pr_number} into {default_branch}...")
                            merge_result = subprocess.run(
                                ["gh", "pr", "merge", pr_number, "--merge"],
                                capture_output=True, text=True
                            )
                            if merge_result.returncode == 0:
                                print(f"PR #{pr_number} successfully merged into {default_branch}.")
                            else:
                                print(f"Failed to merge PR #{pr_number}. Error: {merge_result.stderr}")
                        else:
                            print(f"Invalid PR number: {pr_number}. Merge skipped.")
                    else:
                        # Create a new PR if none exists
                        try:
                            create_pr_process = subprocess.run(
                                ["gh", "pr", "create", "--base", default_branch, "--head", current_branch, "--fill"],
                                capture_output=True, text=True
                            )
                            if create_pr_process.returncode == 0:
                                pr_number = create_pr_process.stdout.split()[0]
                                pr_url = create_pr_process.stdout.split()[1] if len(create_pr_process.stdout.split()) > 1 else "No URL"
                                print(f"Pull request successfully created for {repo_path}. PR #{pr_number}. URL: {pr_url}")
                                pr_created = True
                                
                                # Merge the PR after creation
                                if pr_number:
                                    print(f"Attempting to merge PR #{pr_number} into {default_branch}...")

                                    # Merge the PR directly using GitHub CLI
                                    merge_result = subprocess.run(
                                        ["gh", "pr", "merge", pr_number, "--merge"],
                                        capture_output=True, text=True
                                    )
                                    if merge_result.returncode == 0:
                                        print(f"PR #{pr_number} successfully merged into {default_branch}.")
                                    else:
                                        print(f"Failed to merge PR #{pr_number}. Error: {merge_result.stderr}")
                                else:
                                    print(f"Invalid PR number: {pr_number}. Merge skipped.")
                                break  # Exit after the PR is created and merged
                            else:
                                print(f"Failed to create pull request in {repo_path}. Error: {create_pr_process.stderr}")
                                break  # Exit after the first failed attempt
                        except subprocess.CalledProcessError as e:
                            print(f"Error while creating pull request in {repo_path}: {e}")
                            continue

def main():
    print_header()
    print("Welcome to the GitSync tool!\n")
    
    base_path = input("Enter the base path to check repositories: ")
    
    while True:
        print("\nChoose an option:")
        print("1. Check repositories for changes")
        print("2. Update all repositories")
        print("3. Find repositories and create PR")
        print("4. Exit")
        
        option = input("Enter your choice: ").strip()

        if option == "1":
            check_repositories(base_path)
        elif option == "2":
            update_repositories(base_path)
        elif option == "3":
            find_and_create_pr(base_path)
        elif option == "4":
            print("Goodbye!")
            break
        else:
            print("Invalid option. Please try again.")
