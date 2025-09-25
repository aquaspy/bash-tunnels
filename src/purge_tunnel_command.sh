tunnel_title=${args[--tunnel_title]}
if [[ ${args[--all]} = 1 ]]; then
    # Find all bash-tunnels services
    services=$(find /etc/systemd/system -name "bash-tunnels-*.service" 2>/dev/null)
    if [[ -z "$services" ]]; then
        yellow "No tunnels found to purge."
        exit 0
    fi

    # Purge all tunnels
    while IFS= read -r service_file; do
        service_name=$(basename "$service_file" .service)
        cyan_bold "Purging tunnel: $service_name"

        # Stop and disable
        sudo systemctl stop "$service_name" 2>/dev/null
        sudo systemctl disable "$service_name" 2>/dev/null

        # Remove the service file
        sudo rm -f "$service_file"
    done <<< "$services"

    # Reload systemd
    sudo systemctl daemon-reload
    green "All tunnels have been successfully purged."
    exit 0
fi

# Interactive mode for specific tunnel
if [[ -z "$tunnel_title" ]]; then
    while true; do
        green "Please type tunnel title (e.g., cool_game)"
        read tunnel_title
        if [[ -n "$tunnel_title" ]]; then
            break
        fi
    done
fi

# Construct service name (handle prefix/postfix as before)
base_title="$tunnel_title"
if [[ "$base_title" =~ \.service$ ]]; then
    base_title=$(echo "$base_title" | sed 's/\.service$//')
fi
if [[ "$base_title" =~ ^bash-tunnels- ]]; then
    service_name="${base_title}.service"
else
    service_name="bash-tunnels-${base_title}.service"
fi
service_file="/etc/systemd/system/$service_name"

# Check if the service exists
if [[ ! -f "$service_file" ]]; then
    red "Error: Tunnel with title '$tunnel_title' was not found. You can check the tunnel list with the list_tunnels command."
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
green "Tunnel '$tunnel_title' has been successfully purged."