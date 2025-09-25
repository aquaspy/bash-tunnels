tunnel_title=${args[--tunnel_title]}

if [[ -z "$tunnel_title" ]]; then
    while true; do
        green "Please type the tunnel service name (e.g., cool_game.service or bash-tunnels-cool_game.service)"
        read tunnel_title
        if [[ -n "$tunnel_title" ]]; then
            break
        fi
    done
fi

# Construct the full service name intelligently
# Remove .service if present, then check for bash-tunnels- prefix
base_title="$tunnel_title"
if [[ "$base_title" =~ \.service$ ]]; then
    base_title=$(echo "$base_title" | sed 's/\.service$//')
fi
if [[ "$base_title" =~ ^bash-tunnels- ]]; then
    service_name="${base_title}.service"
else
    service_name="bash-tunnels-${base_title}.service"
fi

# Check if service exists by trying systemctl status
if ! systemctl status "$service_name" &>/dev/null; then
    red "Error: Service '$service_name' not found in systemd."
    exit 1
fi

# Run systemctl status and capture output
status_output=$(systemctl status "$service_name" 2>&1)

# Extract active status
active=$(echo "$status_output" | grep "Active:" | sed 's/.*Active: //')

# Extract only systemd journal logs (lines starting with date/time, e.g., "Sep 24 21:17:28")
logs=$(echo "$status_output" | grep "^[A-Z][a-z][a-z] [0-9][0-9]* [0-9][0-9]:[0-9][0-9]:[0-9][0-9]" | tail -n 10)

# Display simplified status
cyan_bold "Status for: $service_name"
echo ""
if [[ "$active" =~ active ]]; then
    green_bold "Active: " && green "Yes ($active)"
else
    red_bold "Active: " && red "No ($active)"
fi

# Display recent logs
echo ""
cyan_bold "Recent Logs:"
if [[ -n "$logs" ]]; then
    white "$logs"
else
    yellow "No recent logs available."
fi