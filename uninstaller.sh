#!/bin/bash

welcome_uninstaller() {
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
    echo "Welcome to the GitHub Repository Updater -GitSyncMaster- uninstaller!"
    echo "---------------------------------------------------------------------"
}

remove_exec_file() {
    if [[ $(uname) == "Darwin" ]]; then
        if [[ -f /usr/local/bin/gitsync ]]; then
            sudo rm /usr/local/bin/gitsync
            echo "Removed /usr/local/bin/gitsync"
        fi
    else
        if [[ -f /usr/bin/gitsync ]]; then
            sudo rm /usr/bin/gitsync
            echo "Removed /usr/bin/gitsync"
        elif [[ -f /usr/local/bin/gitsync ]]; then
            sudo rm /usr/local/bin/gitsync
            echo "Removed /usr/local/bin/gitsync"
        fi
    fi
}

remove_path_configuration() {
    if [[ $(uname) == "Darwin" ]]; then
        sed -i '' '/export PATH="\/usr\/local\/bin:$PATH"/d' ~/.bash_profile
        source ~/.bash_profile
    else
        if [[ -f ~/.bashrc ]]; then
            sed -i '/export PATH="\/usr\/local\/bin:$PATH"/d' ~/.bashrc
            source ~/.bashrc
        elif [[ -f ~/.bash_profile ]]; then
            sed -i '/export PATH="\/usr\/local\/bin:$PATH"/d' ~/.bash_profile
            source ~/.bash_profile
        else
            sed -i '/export PATH="\/usr\/local\/bin:$PATH"/d' ~/.profile
            source ~/.profile
        fi
    fi
}

cleanup() {
    if [[ -f "$source_file_name" ]]; then
        rm "$source_file_name"
        echo "Downloaded file '$source_file_name' has been deleted."
    fi
}

main() {
    welcome_uninstaller
    remove_exec_file
    remove_path_configuration
    cleanup

    echo "-------------------------------------------------------------------"
    echo "GitSyncMaster has been uninstalled successfully."
    echo "-------------------------------------------------------------------"
}

main
