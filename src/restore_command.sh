# Function to merge vps.txt (skip duplicates by name)
merge_vps() {
    local backup_vps="$temp_dir/.bash-tunnels/vps.txt"
    local current_vps="$PROJECT_DIR/vps.txt"

    if [[ ! -f "$backup_vps" ]]; then
        return
    fi

    # Get existing names
    local existing_names=()
    if [[ -f "$current_vps" ]]; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name=$(echo "$line" | awk '{print $1}')
            existing_names+=("$name")
        done < "$current_vps"
    fi

    # Append unique lines
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local name=$(echo "$line" | awk '{print $1}')
        if [[ ! " ${existing_names[@]} " =~ " ${name} " ]]; then
            echo "$line" >> "$current_vps"
        fi
    done < "$backup_vps"
}

BACKUP_FILE="${args[--backup_file]}"
if [[ -z "$BACKUP_FILE" || ! -f "$BACKUP_FILE" ]]; then
    red "Error: Valid --backup_file required."
    exit 1
fi

# If --clean is set, purge existing data
if [[ ${args[--clean]} = 1 ]]; then
    yellow "Clean mode: Purging existing data..."
    # Call purge functions
    purge_vps_all
    purge_tunnel_all
fi

# Extract to temp
temp_dir=$(mktemp -d)
unzip "$BACKUP_FILE" -d "$temp_dir"

# Restore files
if [[ ${args[--clean]} = 1 ]]; then
    # Clean mode: overwrite
    cp -r "$temp_dir/.bash-tunnels" "$user_home/"
    yellow "Restored $PROJECT_DIR (overwritten)"
    sudo cp "$temp_dir"/*.service "$SERVICE_DIR/" 2>/dev/null
    sudo chmod 644 "$SERVICE_DIR"/bash-tunnels-*.service 2>/dev/null
    yellow "Restored services (overwritten)"
else
    # Merge mode: skip existing files, merge vps.txt
    # Copy SSH keys (skip if exist)
    cp -n "$temp_dir/.bash-tunnels/id_ed25519" "$PROJECT_DIR/" 2>/dev/null
    cp -n "$temp_dir/.bash-tunnels/id_ed25519.pub" "$PROJECT_DIR/" 2>/dev/null
    yellow "Restored SSH keys (skipped existing if any)"

    # Merge vps.txt
    merge_vps
    yellow "Merged vps.txt (skipped duplicates by name)"

    # Restore services (skip existing)
    sudo cp -n "$temp_dir"/*.service "$SERVICE_DIR/" 2>/dev/null
    sudo chmod 644 "$SERVICE_DIR"/bash-tunnels-*.service 2>/dev/null
    yellow "Restored services (skipped existing services if any)"
fi

# Fix permissions
setup_permissions

# Enable and start all restored services
for service_file in "$SERVICE_DIR"/bash-tunnels-*.service; do
    if [[ -f "$service_file" ]]; then
        service_name=$(basename "$service_file")
        sudo systemctl enable "$service_name" 2>/dev/null
        sudo systemctl start "$service_name" 2>/dev/null
        green "Enabled and started: $service_name"
    fi
done

# Reload systemd
sudo systemctl daemon-reload

# Cleanup
rm -rf "$temp_dir"

green "Restore completed from $BACKUP_FILE."