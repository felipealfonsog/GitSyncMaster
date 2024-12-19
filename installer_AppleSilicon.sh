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
    source_file_url="https://raw.githubusercontent.com/felipealfonsog/GitSyncMaster/refs/heads/main/src/src-std/gitsync.py"
    source_file_name="gitsync.py"

    curl -o "$source_file_name" "$source_file_url"
}

move_exec_file() {
    # Verificar si /usr/local/bin existe, si no, crearlo
    if [ ! -d "/usr/local/bin" ]; then
        sudo mkdir -p /usr/local/bin
    fi

    # Descargar el archivo Python y moverlo a /usr/local/bin/gitsync.py
    sudo curl -o /usr/local/bin/gitsync.py "$source_file_url"

    # Crear el script bash en /usr/local/bin/gitsync para ejecutar el archivo Python
    echo "#!/bin/bash" | sudo tee /usr/local/bin/gitsync > /dev/null
    echo "python3 /usr/local/bin/gitsync.py \"\$@\"" | sudo tee -a /usr/local/bin/gitsync > /dev/null

    # Hacer que el script bash y el archivo Python sean ejecutables
    sudo chmod +x /usr/local/bin/gitsync
    sudo chmod +x /usr/local/bin/gitsync.py
}



cleanup() {
    if [[ -f "$source_file_name" ]]; then
        rm "$source_file_name"
        echo "Downloaded file '$source_file_name' has been deleted."
    fi

    # Eliminar el instalador si lo estás ejecutando desde un archivo temporal
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
    cleanup

    echo "-------------------------------------------------------------------"
    echo "You can now run the program by typing 'gitsync' in the terminal."
    echo "-------------------------------------------------------------------"
}

main
