import os
import subprocess

def print_header():
    print("\n=== Repository Manager ===\n")

def print_credits():
    print("By Computer Science Engineer Felipe Alfonso González")
    print("GitHub: https://github.com/felipealfonsog/")
    print("LinkedIn: https://www.linkedin.com/in/felipealfonso/")
    print("Twitter: https://twitter.com/felipealfonsog/")
    print("License: BSD 3-Clause License\n")

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
                    
                    # Create a new pull request using the GitHub CLI (gh)
                    try:
                        create_pr_process = subprocess.run(
                            ["gh", "pr", "create", "--base", default_branch, "--head", current_branch, "--fill"],
                            capture_output=True, text=True
                        )
                        if create_pr_process.returncode == 0:
                            print(f"Pull request successfully created for {repo_path}.")
                            pr_created = True
                        else:
                            print(f"Failed to create pull request in {repo_path}. Error: {create_pr_process.stderr}")
                    except subprocess.CalledProcessError as e:
                        print(f"Error while creating pull request in {repo_path}: {e}")
                else:
                    print(f"No new commits detected for {repo_path} between {current_branch} and origin/{default_branch}. Skipping PR creation.")

    if not pr_created:
        print("\nNo pull requests were created. Check the repository status for possible issues.")
    else:
        print("\nPull requests were created for the repositories with changes.")



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

