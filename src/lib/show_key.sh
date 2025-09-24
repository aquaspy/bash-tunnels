show_key() {
    # Create the key if it does not exist
    if [[ ! -f "$PUBLIC_SSH_KEY_PATH" ]]; then
        setup_key
    else
        green_bold "This is your SSH public key:"
        cyan "$(cat "$PUBLIC_SSH_KEY_PATH")"
        echo ""
        yellow "Instructions:"
        echo "1. Copy the key above."
        echo "2. On your VPS, log in as the desired user."
        echo "3. Add the key to ~/.ssh/authorized_keys (one key per line)."
        echo "4. Ensure the file permissions are 600: chmod 600 ~/.ssh/authorized_keys"
        echo ""
        cyan "If you need these instructions again, run: bash-tunnels show_key"
    fi
}
