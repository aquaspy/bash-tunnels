tunnel_title=${args[--tunnel_title]}

if [[ ${args[--all]} = 1 ]]; then
purge_tunnel_all 
else
# Interactive mode for specific tunnel
if [[ -z "$tunnel_title" ]]; then
    while true; do
        green "Please type tunnel title (e.g., cool_game)"
        read tunnel_title
        if [[ -n "$tunnel_title" ]]; then
            break
        fi
    done
fi
purge_tunnel "$tunnel_title"
fi