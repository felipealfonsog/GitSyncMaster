import os
import subprocess

def print_header():
    print("""
    ==========================================================

        .-. .-.,---.  ,'|"\8    .--.  ,-.    ,-.     
        | | | || .-.\ | |\ \   / /\ \ | |    | |     
        | | | || |-' )| | \ \ / /__\ \| |    | |     
        | | | || |--' | |  \ \|  __  || |    | |     
        | `-')|| |    /(|`-' /| |  |)|| `--. | `--.  
        `---(_)/(    (__)`--' |_|  (_)|( __.'|( __.' 
            (__)                    (_)    (_)     

    ==========================================================
    
    Upd8all: A tool to automate the process of checking and 
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
                        
                        # Attempt to merge PR using git directly (alternative approach)
                        if pr_number:
                            print(f"Attempting to merge PR #{pr_number} into {default_branch} using git...")
                            
                            # Checkout the default branch (main or master)
                            checkout_result = subprocess.run(
                                ["git", "checkout", default_branch],
                                capture_output=True, text=True
                            )
                            if checkout_result.returncode != 0:
                                print(f"Failed to checkout the default branch ({default_branch}). Error: {checkout_result.stderr}")
                                continue
                            
                            # Pull the latest updates from the remote default branch
                            pull_result = subprocess.run(
                                ["git", "pull", "origin", default_branch],
                                capture_output=True, text=True
                            )
                            if pull_result.returncode != 0:
                                print(f"Failed to pull the latest updates from {default_branch}. Error: {pull_result.stderr}")
                                continue
                            
                            # Merge the feature branch into the default branch
                            merge_result = subprocess.run(
                                ["git", "merge", current_branch],
                                capture_output=True, text=True
                            )
                            if merge_result.returncode != 0:
                                print(f"Failed to merge {current_branch} into {default_branch}. Error: {merge_result.stderr}")
                                continue
                            
                            # Push the merged changes to the remote repository
                            push_result = subprocess.run(
                                ["git", "push", "origin", default_branch],
                                capture_output=True, text=True
                            )
                            if push_result.returncode == 0:
                                print(f"Successfully merged and pushed changes to {default_branch}.")
                            else:
                                print(f"Failed to push changes to {default_branch}. Error: {push_result.stderr}")
                                continue
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
                                
                                # Ensure pr_number is valid before merging
                                if pr_number:
                                    print(f"Attempting to merge PR #{pr_number} into {default_branch}...")

                                    # Merge PR using git directly
                                    checkout_result = subprocess.run(
                                        ["git", "checkout", default_branch],
                                        capture_output=True, text=True
                                    )
                                    if checkout_result.returncode != 0:
                                        print(f"Failed to checkout the default branch ({default_branch}). Error: {checkout_result.stderr}")
                                        continue
                                    
                                    pull_result = subprocess.run(
                                        ["git", "pull", "origin", default_branch],
                                        capture_output=True, text=True
                                    )
                                    if pull_result.returncode != 0:
                                        print(f"Failed to pull the latest updates from {default_branch}. Error: {pull_result.stderr}")
                                        continue
                                    
                                    merge_result = subprocess.run(
                                        ["git", "merge", current_branch],
                                        capture_output=True, text=True
                                    )
                                    if merge_result.returncode != 0:
                                        print(f"Failed to merge {current_branch} into {default_branch}. Error: {merge_result.stderr}")
                                        continue
                                    
                                    push_result = subprocess.run(
                                        ["git", "push", "origin", default_branch],
                                        capture_output=True, text=True
                                    )
                                    if push_result.returncode == 0:
                                        print(f"Successfully merged and pushed changes to {default_branch}.")
                                    else:
                                        print(f"Failed to push changes to {default_branch}. Error: {push_result.stderr}")
                                else:
                                    print(f"Invalid PR number: {pr_number}. Merge skipped.")
                                break  # Exit after the PR is created and merged
                            else:
                                print(f"Failed to create pull request in {repo_path}. Error: {create_pr_process.stderr}")
                                break  # Exit after the first failed attempt
                        except subprocess.CalledProcessError as e:
                            print(f"Error while creating pull request in {repo_path}: {e}")
                            break  # Exit after the first failed attempt
                else:
                    print(f"No new commits detected for {repo_path} between {current_branch} and origin/{default_branch}. Skipping PR creation.")

                # Handle repos that require a commit before PR
                if not diff_result.stdout.strip():
                    repos_missing_commits.append(repo_path)

    # Output missing commit repositories
    if repos_missing_commits:
        print("\nThe following repositories require commits before creating a PR:")
        for repo in repos_missing_commits:
            print(f"- {repo}")
    
    if not pr_created:
        print("\nNo pull requests were created. Check the repository status for possible issues.")
    else:
        print("\nPull request was created and attempted to merge successfully.")





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

