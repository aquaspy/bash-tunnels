vps_name=${args[--vps_name-]}
if [[ ${args[--all]} = 1 ]]; then
    purge_vps_all
    setup_permissions
else
    # Interactive mode for specific VPS
    if [[ -z "$vps_name" ]]; then
        while true; do
            green "Please type VPS name (e.g., cool_vps)"
            read vps_name
            if [[ -n "$vps_name" ]]; then
                break
            fi
        done
    fi
    purge_vps "$vps_name"
    setup_permissions
fi