# Validate name
validate_name() {
    local name="$1"  # Use the passed argument
    if [[ -z "$name" ]] || [[ "$name" =~ [[:space:]] ]] || grep -q "^${name}," "$VPS_FILE" 2>/dev/null; then
        red "Invalid or duplicate name (must be non-empty and no spaces)."
        return 1
    fi
}


# Validate IP
validate_ip() {
    local ip="$1"
    # Basic regex for IPv4 or IPv6 (supports compressed IPv6 like ::1)
    if [[ -z "$ip" ]] || ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$|^([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4}$|^::1$|^::$ ]]; then
        red "Invalid IP address (must be non-empty and a valid IPv4 or IPv6 format)."
        return 1
    else
        return 0
    fi
}

# Validate user
validate_user() {
    local user="$1"
    if [[ -z "$user" ]] || [[ "$user" =~ [[:space:]] ]] || ! [[ "$user" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
        red "Invalid username (must be non-empty, no spaces, and contain only letters, numbers, underscores, hyphens, or dots)."
        return 1
    fi
    return 0
}

# Validate port
validate_port() {
    local port="$1"
    if [[ -z "$port" ]] || ! [[ "$port" =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
        red "Invalid SSH port (must be non-empty and a number between 1 and 65535)."
        return 1
    else
        return 0
    fi
}

# Validate VPS
validate_vps_file() {
    if [[ ! -f "$VPS_FILE" ]] || [[ ! -s "$VPS_FILE" ]]; then
        red "No VPSs added. Use bash-tunnel add_vps first."
        return 1
    fi

}


validate_vps_exists() {
    local vps_name="$1"
    if [[ -z "$vps_name" ]]; then
        red "No VPS name provided."
        return 1
    fi

    if grep -q "^${vps_name}," "$VPS_FILE" 2>/dev/null; then
        return 0  # VPS exists
    else
        red "VPS '$vps_name' not found."
        return 1  # VPS does not exist
    fi
}



validate_vps_connection() {
    local vps_name="$1"
    yellow "Checking connection to the VPS..."

    # Parse comma-separated values (name,ip,user,port)
    local vps_line
    vps_line=$(grep "^${vps_name}," "$VPS_FILE" 2>/dev/null)
    IFS=',' read -r _ vps_ip vps_user ssh_port <<< "$vps_line"
    if [[ -z "$vps_ip" || -z "$vps_user" || -z "$ssh_port" ]]; then
        echo "bash-tunnels: Invalid VPS data for '$vps_name'."
        return 1
    fi

    # Test SSH connection (quick echo command with timeout)
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY_PATH" -p "$ssh_port" "${vps_user}@${vps_ip}" "echo 'Connection test successful'" >/dev/null 2>&1; then
        green "Connection to '$vps_name' is possible."
        return 0
    else
        red "Cannot connect to '$vps_name' (check IP, port, user, or key)."
        return 1
    fi
}

validate_title() {
    local title="$1"  # Use the passed argument
    if [[ -z "$title" ]] || [[ "$title" =~ [[:space:]] ]]; then
        red "Invalid tunnel title (must be non-empty and no spaces)."
        return 1
    fi

    # Check if a systemd service with this title already exists
    local service_name="bash-tunnels-${title}.service"
    if [[ -f "/etc/systemd/system/${service_name}" ]]; then
        red "Service '$service_name' already exists (title '$title' is in use)."
        return 1
    fi

    return 0  # Valid
}


validate_local_port() {
    local local_port="$1"
    local services
    services=$(find /etc/systemd/system -name "bash-tunnels-*.service" 2>/dev/null)
    if [[ -z "$services" ]]; then
        return 0
    fi

    # Check each service for matching local port
    for service in $services; do
        local exec_line
        exec_line=$(grep "ExecStart=" "$service" | sed 's/.*ExecStart=//')
        if [[ "$exec_line" =~ -R[[:space:]]*([0-9]+):localhost:([0-9]+) ]]; then
            local existing_local="${BASH_REMATCH[2]}"
            if [[ "$existing_local" == "$local_port" ]]; then
                red "Local port $local_port already in use (in $(basename "$service"))"
                return 1
            fi
        fi
    done

    return 0
}

validate_remote_port() {
    local remote_port="$1"
    local services
    services=$(find /etc/systemd/system -name "bash-tunnels-*.service" 2>/dev/null)
    if [[ -z "$services" ]]; then
        return 0
    fi

    # Check each service for matching remote port
    for service in $services; do
        local exec_line
        exec_line=$(grep "ExecStart=" "$service" | sed 's/.*ExecStart=//')
        if [[ "$exec_line" =~ -R[[:space:]]*([0-9]+):localhost:([0-9]+) ]]; then
            local existing_remote="${BASH_REMATCH[1]}"
            if [[ "$existing_remote" == "$remote_port" ]]; then
                red "Remote port $remote_port already in use (in $(basename "$service"))"
                return 1
            fi
        fi
    done

    return 0
}







