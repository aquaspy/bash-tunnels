
# Set ownership and permissions
setup_permissions(){
    actual_user=$(basename "$user_home")
    chown -R $actual_user:$actual_user "$PROJECT_DIR"
    green "Permissions set for $PROJECT_DIR."


}


