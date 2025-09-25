purge_tunnel_all(){
    # Find all bash-tunnels services (only in top-level, avoid symlinks in subdirs)
    services=($(find "$SERVICE_DIR" -maxdepth 1 -name "bash-tunnels-*.service" 2>/dev/null | sort | uniq))
    if [[ ${#services[@]} -eq 0 ]]; then
        yellow "No tunnels found to purge."
    fi

    # Purge all tunnels
    for service_file in "${services[@]}"; do
        service_name=$(basename "$service_file" .service)
        cyan_bold "Purging tunnel: $service_name"

        # Stop and disable
        sudo systemctl stop "$service_name" 2>/dev/null
        sudo systemctl disable "$service_name" 2>/dev/null

        # Remove the service file
        sudo rm -f "$service_file"
    done

    # Reload systemd
    sudo systemctl daemon-reload
    green "All tunnels have been successfully purged."
}

purge_tunnel(){
    base_title="$1"
    if [[ "$base_title" =~ \.service$ ]]; then
        base_title=$(echo "$base_title" | sed 's/\.service$//')
    fi
    if [[ "$base_title" =~ ^bash-tunnels- ]]; then
        service_name="${base_title}.service"
    else
        service_name="bash-tunnels-${base_title}.service"
    fi
    service_file="$SERVICE_DIR/$service_name"

    # Check if the service exists
    if [[ ! -f "$service_file" ]]; then
        red "Error: Tunnel with title '$1' was not found. You can check the tunnel list with the list_tunnels command."
        exit 1
    fi

    # Purge the specific tunnel
    cyan_bold "Purging tunnel: $service_name"

    # Stop and disable
    sudo systemctl stop "$service_name" 2>/dev/null
    sudo systemctl disable "$service_name" 2>/dev/null

    # Remove the service file
    sudo rm -f "$service_file"

    # Reload systemd
    sudo systemctl daemon-reload

    # Success message
    green "Tunnel '$1' has been successfully purged."
}
