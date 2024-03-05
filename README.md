### GitSyncMaster 🔄

GitSyncMaster is a versatile tool designed to simplify the process of updating multiple Git repositories within a directory structure. It automates the Git updating process (git pull) for enhanced efficiency in managing your projects.

#### Features:

- **Exclusion Feature:**
  - Specify directories to exclude from updating, allowing for fine-grained control over the synchronization process.

- **Cron Integration:**
  - Seamlessly integrate GitSyncMaster with cron jobs for scheduled updates at predefined intervals, ensuring your repositories are always up to date.

#### Usage Instructions:

1. **Bash Script (git_update.sh):**
   - Ensure the script has execute permissions:
     ```bash
     chmod +x git_update.sh
     ```
   - Run the script:
     ```bash
     ./git_update.sh
     ```

2. **Python Script (git_update.py):**
   - Install Python if not already installed.
   - Run the script:
     ```bash
     python git_update.py
     ```

3. **Cron Integration:**
   - Open the crontab editor:
     ```bash
     crontab -e
     ```
   - Add the following line to run the script every hour:
     ```bash
     0 * * * * /path/to/git_update.sh
     ```
     Ensure to replace `/path/to/git_update.sh` with the actual path to the Bash script.


#### Usage Instructions (with Exclusions):

1. **Bash Script (git_update_exclude.sh):**
   - Ensure the script has execute permissions:
     ```bash
     chmod +x git_update_exclude.sh
     ```
   - Run the script:
     ```bash
     ./git_update_exclude.sh
     ```

2. **Python Script (git_update_exclude.py):**
   - Install Python if not already installed.
   - Run the script:
     ```bash
     python git_update_exclude.py
     ```

3. **Cron Integration:**
   - Open the crontab editor:
     ```bash
     crontab -e
     ```
   - Add the following line to run the script every hour:
     ```bash
     0 * * * * /path/to/git_update.sh
     ```
     Ensure to replace `/path/to/git_update.sh` with the actual path to the Bash script.

4. **Excluding Directories:**
   - To exclude directories from updating, edit the `exclude_directories` list in the script:
     ```bash
     exclude_directories=(
         "/path/dir1"
         "/path/dir2"
         # Add or remove more directories as needed
     )
     ```
   - Set `exclude_flag` to `true` to enable exclusion feature:
     ```bash
     exclude_flag=true
     ```
   - Run the script to perform updates with exclusions taken into account.


#### License:

This project is licensed under the BSD 3-Clause License. For more information, please see the [LICENSE](LICENSE) file.
