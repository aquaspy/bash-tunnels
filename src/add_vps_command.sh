vps_name=${args[--vps_name]}
vps_ip=${args[--vps_ip]}
vps_user=${args[--vps_user]}
ssh_port=${args[--ssh_port]}

# Automated mode validation
if [[ -n "$vps_name" ]] && ! validate_name "$vps_name"; then
    exit 1
fi
if [[ -n "$vps_ip" ]] && ! validate_ip "$vps_ip"; then
    exit 1
fi

if [[ -n "$vps_user" ]] && ! validate_user "$vps_user"; then
    exit 1
fi


if [[ -n "$ssh_port" ]] && ! validate_port "$ssh_port"; then
    exit 1
fi


# Interactive mode validation
if [[ -z "$vps_name" ]]; then
    while true; do
        green "Please type a unique VPS name with no spaces:"
        read vps_name
        if validate_name "$vps_name"; then
            break
        fi
    done
fi

if [[ -z "$vps_ip" ]]; then
    while true; do
        green "Please type the VPS IP:"
        read vps_ip
        if validate_ip "$vps_ip"; then
            break
        fi
    done
fi

if [[ -z "$vps_user" ]]; then
    while true; do
        green "Please type the VPS user:"
        read vps_user
        if validate_user "$vps_user"; then
            break
        fi
    done
fi


if [[ -z "$ssh_port" ]]; then
    while true; do
        green "Please type the SSH port:"
        read ssh_port
        if validate_port "$ssh_port"; then
            break
        fi
    done
fi

# Now we can finally setup the SSH key and actually add the VPS
setup_key #creating ssh key

echo "${vps_name},${vps_ip},${vps_user},${ssh_port}" >> "$VPS_FILE"
green_bold "VPS '${vps_name}' added."

setup_permissions