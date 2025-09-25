# Find all matching service files (only in the top-level directory, avoid symlinks in subdirs)
services=($(find "$SERVICE_DIR" -maxdepth 1 -name "bash-tunnels-*.service" 2>/dev/null | sort | uniq))

# Check if any services were found
if [[ ${#services[@]} -eq 0 ]]; then
    yellow "No bash-tunnels services found in $SERVICE_DIR."
    exit 0
fi

# Initialize counter
count=1

# Process each service
for service in "${services[@]}"; do
    # Extract the Description line (e.g., "bash-tunnels: Tunnel ...")
    description=$(grep "^Description=" "$service" | sed 's/Description=//')

    # Skip if no description found
    if [[ -z "$description" ]]; then
        yellow "Skipping $(basename "$service"): No valid Description found."
        continue
    fi

    # Print service name and description with colors
    echo ""
    magenta_bold "Tunnel #$count: $(basename "$service")"
    green_bold "  Description: " && white "$description"

    # Increment counter
    ((count++))
done
