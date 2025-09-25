    yellow "Uninstalling bash-tunnels..."

    # Purge data
    purge_tunnel_all
    purge_vps_all

    # Remove project directory
    if [[ -d "$PROJECT_DIR" ]]; then
        rm -rf "$PROJECT_DIR"
        green "Removed $PROJECT_DIR"
    fi

    # Remove symlink if exists
    if [[ -L "/usr/local/bin/bash-tunnels" ]]; then
        rm /usr/local/bin/bash-tunnels
        green "Removed symlink from /usr/local/bin/bash-tunnels"
    fi

    green "Uninstallation complete."