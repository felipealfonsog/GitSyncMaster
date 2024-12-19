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
    repositories_with_pr = []  # List to store repositories that need PR creation

    for root, dirs, _ in os.walk(base_path):
        for d in dirs:
            repo_path = os.path.join(root, d)
            if os.path.isdir(os.path.join(repo_path, ".git")):
                os.chdir(repo_path)

                # Get the current branch name
                branch_result = subprocess.run(["git", "branch", "--show-current"], capture_output=True, text=True)
                current_branch = branch_result.stdout.strip()

                if not current_branch:
                    print(f"\nFailed to determine the current branch in {repo_path}. Skipping repository.")
                    continue

                # Fetch the latest changes from the remote repository
                fetch_result = subprocess.run(["git", "fetch"], capture_output=True, text=True)
                if fetch_result.returncode != 0:
                    print(f"Failed to fetch updates for {repo_path}. Error: {fetch_result.stderr}")
                    continue  # Skip creating PR if fetch failed

                # Check if there are any new commits between local and remote branch
                diff_result = subprocess.run(
                    ["git", "log", f"origin/{current_branch}..{current_branch}", "--oneline"],
                    capture_output=True, text=True
                )

                if diff_result.returncode != 0 or not diff_result.stdout.strip():
                    print(f"No new commits between {current_branch} and origin/{current_branch} in {repo_path}. Skipping PR creation.")
                    continue  # No new commits, silently skip

                # Add to the list of repositories needing a PR
                repositories_with_pr.append(repo_path)

    if repositories_with_pr:
        for repo in repositories_with_pr:
            print(f"\nPR Creation needed for repository: {repo}")
            try:
                # Create a new pull request
                create_pr_process = subprocess.run(
                    ["gh", "pr", "create", "--base", "main", "--head", current_branch, "--title", "Update repository", "--body", "This pull request contains the latest changes from the local branch."],
                    capture_output=True, text=True
                )
                if create_pr_process.returncode == 0:
                    print(f"Pull request created successfully in {repo}.")
                    pr_created = True
                else:
                    print(f"Failed to create pull request in {repo}. Error: {create_pr_process.stderr}")
            except subprocess.CalledProcessError as e:
                print(f"Error while creating pull request in {repo}: {e}")

    if not pr_created:
        print("\nNo repositories had changes that required a pull request.")
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

