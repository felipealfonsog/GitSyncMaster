#!/bin/bash

welcome() {
    echo "
    ╔═══════════════════════════════════════╗
    ║                                       ║
    ║   ~ GitSyncMaster ~                   ║
    ║   Developed with ❤️ by                 ║
    ║   Felipe Alfonso González L.          ║
    ║   Computer Science Engineer           ║
    ║   Chile                               ║
    ║                                       ║
    ║   Contact: f.alfonso@res-ear.ch       ║
    ║   Licensed under BSD 3-clause         ║
    ║   GitHub: github.com/felipealfonsog   ║
    ║                                       ║
    ╚═══════════════════════════════════════╝
    "
    echo "Welcome to the GitHub Repository Updater -GitSyncMaster- installer!"
    echo "---------------------------------------------------------------------"
}

check_execute_permission() {
    if [[ ! -x "$0" ]]; then
        echo "The installer script does not have execute permission. Do you want to grant it?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes)
                    chmod +x "$0"
                    exec "$0" "$@"
                    ;;
                No)
                    echo "Exiting program."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Please choose a valid option."
                    ;;
            esac
        done
    fi
}

check_homebrew_installation_macOS() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed on macOS. Do you want to install it?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes)
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    break
                    ;;
                No)
                    echo "Exiting program."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Please choose a valid option."
                    ;;
            esac
        done
    fi
}

check_homebrew_installation_linux() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew/Linuxbrew is not installed on Linux. Do you want to install it?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes)
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    break
                    ;;
                No)
                    echo "Exiting program."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Please choose a valid option."
                    ;;
            esac
        done
    fi
}

install_dependencies_linux() {
    if ! command -v python3 &> /dev/null; then
        echo "Python3 is not installed on Linux. Do you want to install it?"
        select yn in "Yes, using Homebrew" "Yes, using package manager" "No"; do
            case $yn in
                "Yes, using Homebrew")
                    brew install python
                    break
                    ;;
                "Yes, using package manager")
                    if [[ -f /etc/arch-release ]]; then
                        sudo pacman -S python
                    elif [[ -f /etc/debian_version ]]; then
                        sudo apt-get update && sudo apt-get install python3
                    else
                        echo "Unsupported Linux distribution. Please install Python3 manually, read documentation according to your distro, and re-run the installer."
                        exit 1
                    fi
                    break
                    ;;
                "No")
                    echo "Exiting program."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Please choose a valid option."
                    ;;
            esac
        done
    fi
}


download_source_code() {
    if [[ $(uname) == "Darwin" ]]; then
        source_file_url="https://raw.githubusercontent.com/felipealfonsog/TermNotes/main/src/macos-linux-dev/git_update_macos.py"
        source_file_name="git_update_macos.py"
    elif [[ $(uname) == "Linux" ]]; then
        source_file_url="https://raw.githubusercontent.com/felipealfonsog/TermNotes/main/src/macos-linux-dev/git_update_linux.py"
        source_file_name="git_update_linux.py"
    else
        echo "Unsupported operating system. Please install manually, read documentation, and re-run the installer."
        exit 1
    fi

    curl -o "$source_file_name" "$source_file_url"
}




move_exec_file() {
    if [[ $(uname) == "Darwin" ]]; then
        # Transform the Python file into an executable
        echo '#!/usr/bin/env python3' > "gitsync"
        echo 'python3 /usr/local/bin/$source_file_name "$@"' >> "gitsync"
        chmod +x "gitsync"

        # Move the executable file to /usr/local/bin/
        sudo cp "gitsync" "/usr/local/bin/gitsync"
        sudo chmod +x "/usr/local/bin/gitsync"
    else
        # Transform the Python file into an executable
        echo '#!/usr/bin/env python3' > "gitsync"
        echo 'python3 /usr/local/bin/$source_file_name "$@"' >> "gitsync"
        chmod +x "gitsync"

        # Install the executable file to the appropriate location based on the distribution
        if [[ -f /etc/arch-release ]]; then
            sudo install -Dm755 "gitsync" "/usr/bin/gitsync"
        elif [[ -f /etc/debian_version ]]; then
            sudo install -Dm755 "gitsync" "/usr/local/bin/gitsync"
        else
            sudo install -Dm755 "gitsync" "/usr/local/bin/gitsync"
        fi
    fi
}





configure_path() {
    if [[ $(uname) == "Darwin" ]]; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
        source ~/.bash_profile
    else
        if [[ -f ~/.bashrc ]]; then
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
            source ~/.bashrc
        elif [[ -f ~/.bash_profile ]]; then
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
            source ~/.bash_profile
        else
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.profile
            source ~/.profile
        fi
    fi
}

reload_shell() {
    if [[ $(uname) == "Darwin" ]]; then
        source ~/.bash_profile
    elif [[ $(uname) == "Linux" ]]; then
        if [[ -f /etc/arch-release ]]; then
            source ~/.bashrc
        elif [[ -f /etc/debian_version ]]; then
            source ~/.bashrc
        else
            source ~/.bashrc
        fi
    fi
}

cleanup() {
    if [[ -f "$source_file_name" ]]; then
        rm "$source_file_name"
        echo "Downloaded file '$source_file_name' has been deleted."
    fi

    if [[ -f "installer.sh" ]]; then
        rm "installer.sh"
        echo "Installer script 'installer.sh' has been deleted."
    fi
}


main() {
    welcome
    check_execute_permission

    if [[ $(uname) == "Darwin" ]]; then
        check_homebrew_installation_macOS
    elif [[ $(uname) == "Linux" ]]; then
        check_homebrew_installation_linux
        install_dependencies_linux
    fi

    download_source_code
    move_exec_file
    configure_path
    reload_shell
    cleanup

    echo "-------------------------------------------------------------------"
    echo "You can now run the program by typing 'gitsync' in the terminal."
    echo "-------------------------------------------------------------------"
}

main