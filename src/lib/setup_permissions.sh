
# Set ownership and permissions
setup_permissions(){
    ACTUAL_USER=$(basename "$user_home")
    chmod 700 "$PROJECT_DIR"
    chown -R $ACTUAL_USER:$ACTUAL_USER "$PROJECT_DIR"
    # Fix private key if exists
    if [[ -f "$SSH_KEY_PATH" ]]; then
        chmod 600 "$SSH_KEY_PATH"
    else
        yellow "Private key not found: $SSH_KEY_PATH"
    fi
    # Fix public key if exists
    if [[ -f "$PUBLIC_SSH_KEY_PATH" ]]; then
        chmod 644 "$PUBLIC_SSH_KEY_PATH"
    else
        yellow "Public key not found: $PUBLIC_SSH_KEY_PATH"
    fi


}


