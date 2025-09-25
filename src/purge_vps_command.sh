vps_name=${args[--vps_name]}
if [[ ${args[--all]} = 1 ]]; then
    # Create an empty temp file
    temp_file=$(mktemp)
    touch "$temp_file"
    # Replace the original file with the empty one
    mv "$temp_file" "$VPS_FILE"
    green "All VPS entries have been successfully purged from the list."
    exit 0
fi

# Interactive mode

if [[ -z "$vps_name" ]]; then
    while true; do
        green "Please type vps name (e.g., cool_vps)"
        read vps_name
        if [[ -n "$vps_name" ]]; then
            break
        fi
    done
fi

# Check if file exists
if [[ ! -f "$VPS_FILE" ]]; then
    red "Error: VPS file '$VPS_FILE' not found. Make sure you add a VPS first."
    exit 1
fi

# Check if the VPS exists in the file
if ! grep -q "^$vps_name," "$VPS_FILE"; then
    red "Error: VPS with name '$vps_name' was not found. You can check the VPS list with the list_vps command."
    exit 1
fi

# Create a temporary file for the updated content
temp_file=$(mktemp)

# Remove the matching line using sed (delete lines starting with vps_name,)
sed "/^$vps_name,/d" "$VPS_FILE" > "$temp_file"

# Check if sed succeeded (e.g., file was writable)
if [[ $? -ne 0 ]]; then
    red "Error: Failed to update the VPS file."
    rm -f "$temp_file"
    exit 1
fi

# Replace the original file with the temp file
mv "$temp_file" "$VPS_FILE"

#Setup permissions
setup_permissions

# Success message
green "VPS '$vps_name' has been successfully purged from the list."