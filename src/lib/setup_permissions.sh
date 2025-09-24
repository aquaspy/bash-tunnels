
# Set ownership and permissions
setup_permissions(){
    ACTUAL_USER=$(basename "$user_home")
    chown -R $ACTUAL_USER:$ACTUAL_USER "$PROJECT_DIR"
    blue "Permissions set for $PROJECT_DIR."


}


