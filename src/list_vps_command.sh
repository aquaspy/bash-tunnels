validate_vps_file

# Counter for numbering
counter=1

while IFS=',' read -r vps_name vps_ip vps_user ssh_port; do
    # Skip empty lines or lines with incorrect field count
    if [[ -z "$vps_name" || -z "$vps_ip" || -z "$vps_user" || -z "$ssh_port" ]]; then
        continue
    fi

    # Print each VPS block with colors
    echo ""
    magenta_bold "VPS #$counter:"
    green_bold "  VPS Name: " && white "$vps_name"
    green_bold "  IP: " && white "$vps_ip"
    green_bold "  User: " && white "$vps_user"
    green_bold "  SSH Port: " && white "$ssh_port"

    ((counter++))
done < "$VPS_FILE"

# If no valid entries were found
if [[ $counter -eq 1 ]]; then
    yellow "No valid VPS entries found in '$VPS_FILE'."
fi