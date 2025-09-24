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
