vps_name=${args[--vps_name]}
local_port=${args[--local_port]}
remote_port=${args[--remote_port]}
tunnel_title=${args[--tunnel_title]}


# Automated mode validation
if [[ -n "$vps_name" ]] && ! validate_vps_exists "$vps_name"; then
    exit 1
fi

if [[ -n "$local_port" ]] && ! validate_port "$local_port"; then
    exit 1
fi

if [[ -n "$remote_port" ]] && ! validate_port "$remote_port"; then
    exit 1
fi

if [[ -n "$tunnel_title" ]] && ! validate_title "$tunnel_title"; then
    exit 1
fi


# Interactive mode validation
if [[ -z "$vps_name" ]]; then
    while true; do
        green "Please type the VPS name:"
        read vps_name
        if validate_vps_exists "$vps_name"; then
            break
        fi
    done
fi

if [[ -z "$local_port" ]]; then
    while true; do
        green "Please type the local port:"
        read local_port
        if validate_port "$local_port" && validate_local_port "$local_port"; then
            break
        fi
    done
fi

if [[ -z "$remote_port" ]]; then
    while true; do
        green "Please type the remote port:"
        read remote_port
        if validate_port "$remote_port" && validate_remote_port "$remote_port"; then
            break
        fi
    done
fi

if [[ -z "$tunnel_title" ]]; then
    while true; do
        green "Please type the tunnel title:"
        read tunnel_title
        if validate_title "$tunnel_title"; then
            break
        fi
    done
fi

validate_vps_file #Checking if the VPS file is valid

validate_vps_connection "$vps_name" #Checking if the connection works

#validate_duplicated_port "$local_port" "$remote_port" #Checking if the ports were used before


#Getting the data for connection
local vps_line
vps_line=$(grep "^${vps_name}," "$VPS_FILE" 2>/dev/null)
IFS=',' read -r _ vps_ip vps_user ssh_port <<< "$vps_line"
service_name="bash-tunnels-${tunnel_title}.service"
service_path="$SERVICE_DIR/$service_name"

    cat > "$service_path" << EOF
[Unit]
Description=bash-tunnels: Tunnel ${tunnel_title} using server ${vps_name}. Local port ${local_port} to remote port ${remote_port}
After=network.target

[Service]
ExecStart=/usr/bin/ssh -o StrictHostKeyChecking=no -o GatewayPorts=yes -N -R ${remote_port}:localhost:${local_port} -i ${SSH_KEY_PATH} -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -p ${ssh_port} ${vps_user}@${vps_ip}
RestartSec=15
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "$service_name" 2>/dev/null
systemctl start "$service_name"
green_bold "Tunnel created and activated: $service_name"





