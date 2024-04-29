### GitSyncMaster 🔄

GitSyncMaster* is a versatile tool designed to simplify the process of updating multiple Git repositories within a directory structure. It automates the Git updating process (git pull) for enhanced efficiency, among other actions... in managing your projects.


[![Version](https://img.shields.io/github/release/felipealfonsog/GitSyncMaster.svg?style=flat&color=red)](#)
[![Main Language](https://img.shields.io/github/languages/top/felipealfonsog/GitSyncMaster.svg?style=flat&color=blue)](#)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](https://github.com/Naereen/badges/)

[![BSD-3-Clause license](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
<!--
[![GPL license](https://img.shields.io/badge/License-GPL-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
-->

[![Vim](https://img.shields.io/badge/--019733?logo=vim)](https://www.vim.org/)
[![Visual Studio Code](https://img.shields.io/badge/--007ACC?logo=visual%20studio%20code&logoColor=ffffff)](https://code.visualstudio.com/)

[![Bash](https://img.shields.io/badge/-Bash-000000?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/downloads/release/python-311/)

<sub>* This is currently an experimental phase where the primary focus is on making the system functional and establishing a practical and logical pathway that aligns with both my vision and the project's goals. It might contain errors, bugs, etc. Many other non-core elements of the project are considered secondary.</sub>

#

#### Features:

- **Exclusion Feature:**
  - Specify directories to exclude from updating, allowing for fine-grained control over the synchronization process.

- **Cron Integration:**
  - Seamlessly integrate GitSyncMaster with cron jobs for scheduled updates at predefined intervals, ensuring your repositories are always up to date.

#### New Features

1. **Colorized Output**: The program now utilizes ANSI escape codes to provide colorized output for better readability. Messages such as success, errors, and prompts are now displayed in different colors, making it easier to distinguish different types of messages.

2. **Interactive Commit Workflow**: When choosing to check repositories requiring actions (option 1), users are presented with an interactive workflow for staging changes, committing them with a custom message, and optionally pushing the changes to the remote repository. This allows for a smoother and more user-friendly commit process directly from the command line.

3. **Enhanced Repository Update**: During repository update (option 2), if a directory requires a commit before updating, the program now displays a bold red message indicating the need for a commit. After attempting to pull changes from the remote repository, successful updates are displayed in bold blue text, while errors are shown in bold red text.

4. **Abort Confirmation**: Prior to initiating any action, the program prompts users with an abort confirmation to ensure they intend to proceed. This prevents accidental actions and provides users with the opportunity to cancel the operation if needed.

5. **Improved User Interface**: The program now offers a cleaner and more intuitive user interface with clear prompts and instructions at each step. Users are guided through the process of checking for repository actions or updating repositories, ensuring a seamless experience.

These new features aim to enhance the usability, functionality, and overall experience of the GitHub Repository Updater tool.

#

#### Screenshots

[![View Screenshots](https://img.shields.io/badge/View-Screenshots-yellow)](#)

#### Screenshot macOS

<p align="center">
  <img src="./images/sshot-mac.png" alt="Screenshot macOS" width="400" height="350">
</p>

#### Screenshot Linux (Arch)

<p align="center">
  <img src="./images/sshot-linux.png" alt="Screenshot Linux" width="400" height="350">
</p>

#

#### Installation (Special version for Arch Linux)*
#### Via AUR using YAY

[![AUR](https://img.shields.io/aur/version/gitsync)](https://aur.archlinux.org/packages/gitsync)

<!-- 
[![AUR](https://img.shields.io/aur/version/gitsync.svg)](https://aur.archlinux.org/packages/gitsync)
-->

<!-- 
https://aur.archlinux.org/packages/gitsync
-->

GitSyncMaster (gitsync on AUR) is available on AUR (Arch User Repository), and it can be installed using the `yay` package manager. Follow the steps below to install:

1. Make sure you have `yay` installed. If not, you can install it with the following command:
   
   ```
   sudo pacman -S yay
   ```
   Once yay is installed, you can install it by running the following command:
   
   ```
   yay -S gitsync
   ```
This command will automatically fetch the package from AUR and handle the installation process for you.

Then, run it with the following command:

```
gitsync
```

<sub>*IMPORTANT NOTE USAGE: Once it's installed, and you run the software, you should be able to update your repositories. However, you **must** be within a directory containing all the repositories you want to update. Currently, it will be tested using Python and/or Bash.</sub>

#

#### Bash Installer 🚀 for macOS and Linux

[![Bash Version](https://img.shields.io/badge/Bash%20Version-Available-brightgreen)](#)

#### To Install it: 
To install GitSyncMaster, simply run the installer script available [here](https://github.com/felipealfonsog/GitSyncMaster/raw/main/installer.sh).

Or just Copy - Paste in your terminal and use -curl- to start downloading the installer:

   ```
   curl -O https://raw.githubusercontent.com/felipealfonsog/GitSyncMaster/main/installer.sh
   ```

   For Apple Silicon:

   ```
   curl -O https://raw.githubusercontent.com/felipealfonsog/GitSyncMaster/main/installer_AppleSilicon.sh
   ```


If you want to use -wget- just copy/paste this line:

   ```
   wget https://github.com/felipealfonsog/GitSyncMaster/raw/main/installer.sh
   ```

   On macOS to download - wget - just install it with Homebrew:

   ```
   brew install wget
   ```

#### Important note when installing:

If you encounter issues executing the file in the terminal, like this message "-bash: ./installer.sh: Permission denied", follow these simple steps to fix it:

1. Open your terminal.
2. Navigate to the directory where the installer script is located using the `cd` command.
3. Run the following command to grant execute permission to the installer script:

   ```
   chmod +x installer.sh
   ```
   
4. Now you can run the installer without any problems.

   ```
   ./installer.sh
   ```
   NOTE: The script will ask for -sudo permissions-. Just simply type in macOS your macOS user password, and in Linux your -sudo- password.

Now type 'gitsync' in the terminal and enjoy using GitSyncMaster! 😊🚀

Feel free to reach out if you need any further assistance!

#### Updating with the script: 
If you want to update GitSyncMaster (gitsync) in your system, re-run the script:

   ```
   ./installer.sh
   ```
Please note that if you encounter any issues or have suggestions, feel free to raise an issue on the [GitSyncMaster repository](https://github.com/felipealfonsog/GitSyncMaster/issues). Your feedback is invaluable!

Thank you for joining me on this journey, and I hope GitSyncMasters brings value to your life and workflow. Let's continue making technology accessible and enjoyable for everyone!

#


#### Manual Installation

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

#

**Note: On macOS usually the directory can be like this:**

```
 main_directory="/Volumes/Macintosh\ HD/Users/user/Documents/Development"
```

Or possibly, you can use a relative path instead of an absolute one:

```
 main_directory="/Users/user/Documents/Development/excludedir1"
```
The code for macOS is in the following directory within the repository:

```
src/macos
```
#

#### 🤝 Support and Contributions

If you find this project helpful and would like to support its development, there are several ways you can contribute:

- **Code Contributions**: If you're a developer, you can contribute by submitting pull requests with bug fixes, new features, or improvements. Feel free to fork the project and create your own branch to work on.
- **Bug Reports and Feedback**: If you encounter any issues or have suggestions for improvement, please open an issue on the project's GitHub repository. Your feedback is valuable in making the project better.
- **Documentation**: Improving the documentation is always appreciated. If you find any gaps or have suggestions to enhance the project's documentation, please let me know.

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-FFDD00?style=flat-square&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/felipealfonsog)
[![PayPal](https://img.shields.io/badge/Donate%20with-PayPal-00457C?style=flat-square&logo=paypal&logoColor=white)](https://www.paypal.me/felipealfonsog)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor%20me%20on-GitHub-%23EA4AAA?style=flat-square&logo=github-sponsors&logoColor=white)](https://github.com/sponsors/felipealfonsog)

Your support and contributions are greatly appreciated! Thank you for your help in making this project better.


#### 📝Important

[![Experimental Project](https://img.shields.io/badge/Project-Type%3A%20Experimental-blueviolet)](#)


**This project is an experimental endeavor. Its usage is at your sole discretion and risk. It is provided without any warranty, express or implied. The developers shall not be liable for any damages arising from the use of this software.**


#### License:

This project is licensed under the BSD 3-Clause License. For more information, please see the [LICENSE](LICENSE) file.

