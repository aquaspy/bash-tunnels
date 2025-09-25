# Find all matching service files
services=$(find "$SERVICE_DIR" -name "bash-tunnels-*.service" 2>/dev/null)

# Check if any services were found
if [[ -z "$services" ]]; then
    yellow "No bash-tunnels services found in $SERVICE_DIR."
    exit 0
fi

# Process each service
while IFS= read -r service; do
    # Extract the Description line (e.g., "bash-tunnels: Tunnel ...")
    description=$(grep "^Description=" "$service" | sed 's/Description=//')

    # Skip if no description found
    if [[ -z "$description" ]]; then
        yellow "Skipping $(basename "$service"): No valid Description found."
        continue
    fi

    # Print service name and description with colors
    echo ""
    magenta_bold "Tunnel title: $(basename "$service")"
    green_bold "  Description: " && white "$description"
done <<< "$services"