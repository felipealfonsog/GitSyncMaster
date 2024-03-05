### GitSyncMaster 🔄

GitSyncMaster* is a versatile tool designed to simplify the process of updating multiple Git repositories within a directory structure. It automates the Git updating process (git pull) for enhanced efficiency in managing your projects.


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
