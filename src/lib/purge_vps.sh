purge_vps_all() {
    if [[ -f "$VPS_FILE" ]]; then
        # Create an empty temp file
        temp_file=$(mktemp)
        touch "$temp_file"
        # Replace the original file with the empty one
        mv "$temp_file" "$VPS_FILE"
        green "All VPS entries have been successfully purged from the list."
    else
        yellow "No VPS file found to purge."
    fi
}


purge_vps(){
    vps_name="$1"
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

    # Success message
    green "VPS '$vps_name' has been successfully purged from the list."
}
