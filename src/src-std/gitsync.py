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
                print(f"\nChecking repository: {repo_path}")
                os.chdir(repo_path)

                status = subprocess.run(["git", "status", "--short"], capture_output=True, text=True)
                if status.stdout.strip():
                    print("Changes detected!")
                    commit_msg = input("Enter commit message (default is 'Updates'): ").strip() or "Updates"
                    try:
                        subprocess.run(["git", "add", "-A"], check=True)
                        subprocess.run(["git", "commit", "-m", commit_msg], check=True)
                        subprocess.run(["git", "push", "origin", "master"], check=True)
                        print(f"Changes pushed to repository: {repo_path}\n")
                    except subprocess.CalledProcessError as e:
                        print(f"Error while pushing changes: {e}\n")
                else:
                    print("No changes detected.")

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
    for root, dirs, _ in os.walk(base_path):
        for d in dirs:
            repo_path = os.path.join(root, d)
            if os.path.isdir(os.path.join(repo_path, ".git")):
                print(f"\nChecking repository: {repo_path}")
                os.chdir(repo_path)

                process = subprocess.run(["gh", "pr", "status"], capture_output=True, text=True)
                if "no open pull requests" in process.stdout.lower():
                    print("No open pull requests detected.")
                    create_pr = input("Do you want to create a new pull request? (Y/N, default is N): ").strip().lower()
                    if create_pr == "y":
                        try:
                            create_pr_process = subprocess.run(["gh", "pr", "create", "--fill"], capture_output=True, text=True)
                            if create_pr_process.returncode == 0:
                                print("Pull request created successfully.")
                                print(create_pr_process.stdout)
                            else:
                                print(f"Failed to create pull request. Error: {create_pr_process.stderr}\n")
                        except subprocess.CalledProcessError as e:
                            print(f"Error while creating pull request: {e}\n")
                else:
                    print("An open pull request already exists. Skipping...")

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
