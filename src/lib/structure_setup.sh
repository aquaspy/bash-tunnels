#Initial setup and global variables

# Get the real user's home directory (not root's)
if [[ -n "$SUDO_USER" ]]; then
    user_home=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    user_home="$HOME"
fi
PROJECT_DIR="$user_home/.bash-tunnels"
SSH_KEY_PATH="$PROJECT_DIR/id_ed25519"
VPS_FILE="$PROJECT_DIR/vps.txt"
SERVICE_DIR="/etc/systemd/system"


# Check if root
if [[ $EUID -ne 0 ]]; then
    echo "bash-tunnels: This script must be run as root (use sudo)."
    exit 1
fi

setup_key() {
    # Create project directory if it doesn't exist
    mkdir -p "$PROJECT_DIR"

    # Generate SSH key if it doesn't exist
    if [[ ! -f "$SSH_KEY_PATH" ]]; then
        yellow "Generating Ed25519 SSH key..."
        ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N "" >/dev/null 2>&1  # Suppress output
        green_bold "Key generated successfully at $SSH_KEY_PATH."
        green_underlined "Add the following public key to the external server:"
        cyan "$(cat "${SSH_KEY_PATH}.pub")"
    else
        yellow "SSH key already exists at $SSH_KEY_PATH."
    fi
}




