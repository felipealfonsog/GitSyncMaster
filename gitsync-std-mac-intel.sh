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
    else
        echo "Homebrew is already installed."
    fi
}

download_source_code() {
    if [[ $(uname) == "Darwin" ]]; then
        source_file_url="https://raw.githubusercontent.com/felipealfonsog/GitSyncMaster/main/src/src-std/gitsync.py"
        source_file_name="gitsync.py"
    elif [[ $(uname) == "Linux" ]]; then
        source_file_url="https://raw.githubusercontent.com/felipealfonsog/GitSyncMaster/main/src/src-std/gitsync.py"
        source_file_name="gitsync.py"
    else
        echo "Unsupported operating system. Please install manually, read documentation, and re-run the installer."
        exit 1
    fi

    echo "Downloading the source code..."
    curl -o "$source_file_name" "$source_file_url" || { echo "Error downloading the file"; exit 1; }
}

add_shebang_and_make_executable() {
    echo "Adding shebang to the Python script and making it executable..."

    # Verifica si el archivo ya tiene el shebang
    if ! head -n 1 /usr/local/bin/gitsync.py | grep -q "^#!"; then
        # Agregar el shebang al inicio del archivo si no está presente
        echo "#!/usr/bin/env python3" | cat - /usr/local/bin/gitsync.py > temp && sudo mv temp /usr/local/bin/gitsync.py
    fi

    sudo chmod +x /usr/local/bin/gitsync.py
}

move_exec_file() {
    if [[ -f "$source_file_name" ]]; then
        # Mover el archivo descargado a /usr/local/bin/
        sudo mv "$source_file_name" /usr/local/bin/
        echo "Moved $source_file_name to /usr/local/bin/"
    else
        echo "Error: File $source_file_name not found."
        exit 1
    fi
}

create_symlink() {
    echo "Creating a symbolic link to make the command 'gitsync' available globally..."

    # Verificar y crear el enlace simbólico
    sudo ln -sf /usr/local/bin/gitsync.py /usr/local/bin/gitsync
}

configure_path() {
    if [[ $(uname) == "Darwin" ]]; then
        if [[ $SHELL == "/bin/zsh" ]]; then
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
            source ~/.zshrc
        else
            echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
            source ~/.bash_profile
        fi
    fi
}

reload_shell() {
    if [[ $(uname) == "Darwin" ]]; then
        source ~/.bash_profile
    fi
}

cleanup() {
    if [[ -f "$source_file_name" ]]; then
        rm "$source_file_name"
        echo "Downloaded file '$source_file_name' has been deleted."
    fi
}

main() {
    welcome
    check_execute_permission

    check_homebrew_installation_macOS
    download_source_code
    move_exec_file
    add_shebang_and_make_executable
    create_symlink
    configure_path
    reload_shell
    cleanup

    echo "-------------------------------------------------------------------"
    echo "You can now run the program by typing 'gitsync' in the terminal."
    echo "-------------------------------------------------------------------"
}

main

