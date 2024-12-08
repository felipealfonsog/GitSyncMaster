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
                    exec "$0" "$@"  # Re-run the script after adding execute permission
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

download_source_code() {
    source_file_url="https://raw.githubusercontent.com/felipealfonsog/GitSyncMaster/main/src/macos-linux-dev/git_update_macos_silicon.py"
    source_file_name="git_update_macos_silicon.py"

    curl -o "$source_file_name" "$source_file_url"
}

move_exec_file() {
    # Verificar si /usr/local/bin existe, si no, crearlo
    if [ ! -d "/usr/local/bin" ]; then
        sudo mkdir -p /usr/local/bin
    fi

    sudo cp "$source_file_name" /usr/local/bin/gitsync
    sudo chmod +x "/usr/local/bin/gitsync"
}

configure_path() {
    shell_config_file="~/.zshrc"

    # Check if the shell config file exists and add PATH to it
    if [ -f "$shell_config_file" ]; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> "$shell_config_file"
        source "$shell_config_file"
    else
        echo "Shell config file $shell_config_file not found."
    fi
}

cleanup() {
    if [[ -f "$source_file_name" ]]; then
        rm "$source_file_name"
        echo "Downloaded file '$source_file_name' has been deleted."
    fi

    # Check if 'installer_AppleSilicon.sh' exists before trying to delete
    if [[ -f "$0" ]]; then
        rm "$0"
        echo "Installer script has been deleted."
    fi
}

main() {
    welcome
    check_execute_permission
    check_homebrew_installation_macOS

    download_source_code
    move_exec_file
    configure_path
    cleanup

    echo "-------------------------------------------------------------------"
    echo "You can now run the program by typing 'gitsync' in the terminal."
    echo "-------------------------------------------------------------------"
}

main
