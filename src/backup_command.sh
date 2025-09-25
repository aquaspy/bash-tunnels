# Create temp dir
temp_dir=$(mktemp -d)

# Save original directory
original_dir="$PWD"

# Copy files to temp dir
cp -r "$PROJECT_DIR" "$temp_dir/" 2>/dev/null || red "Failed to copy $PROJECT_DIR"
sudo cp "$SERVICE_DIR"/bash-tunnels-*.service "$temp_dir/" 2>/dev/null

# Change ownership to root for zipping
sudo chown -R root:root "$temp_dir"

# Create ZIP with timestamped name
BACKUP_FILE="bash-tunnels-backup-$(date +%Y-%m-%d_%H-%M-%S).zip"
cd "$temp_dir"
zip -r "$BACKUP_FILE" .

# Move to original dir
mv "$BACKUP_FILE" "$original_dir"

# Fix permissions and ownership
chmod 644 "$original_dir/$BACKUP_FILE"
ACTUAL_USER=$(basename "$user_home")
chown "$ACTUAL_USER:$ACTUAL_USER" "$original_dir/$BACKUP_FILE" 2>/dev/null

# Cleanup
rm -rf "$temp_dir"

green "Backup created: $BACKUP_FILE"
