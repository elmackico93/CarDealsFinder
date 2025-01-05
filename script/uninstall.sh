#!/bin/bash

# ============================================================
# Car Deals Finder - Uninstallation Script
# ============================================================

LOG_FILE="uninstallation.log"
APP_DIR="/var/www/car_deals_finder"
USER=$(whoami)

# Function for displaying messages
display_message() {
    echo -e "$1"
    echo "$(date) - $1" >> "$LOG_FILE"
}

handle_error() {
    display_message "$1"
    exit 1
}

# Ensure root permissions
ensure_root() {
    if [[ "$USER" != "root" ]]; then
        display_message "This script must be run as root. Please use sudo." "error"
        exit 1
    fi
}

# Remove application files
remove_files() {
    display_message "Removing application files..."
    rm -rf "$APP_DIR" || handle_error "Failed to remove application files."
}

# Remove systemd service (Linux)
remove_systemd_service() {
    display_message "Removing systemd service..." "info"
    sudo systemctl stop car_deals_finder || handle_error "Failed to stop systemd service."
    sudo systemctl disable car_deals_finder || handle_error "Failed to disable systemd service."
    sudo rm /etc/systemd/system/car_deals_finder.service || handle_error "Failed to remove systemd service file."
    sudo systemctl daemon-reload || handle_error "Failed to reload systemd daemon."
}

# Remove Nginx configuration
remove_nginx_config() {
    display_message "Removing Nginx configuration..." "info"
    sudo rm /etc/nginx/sites-enabled/car_deals_finder || handle_error "Failed to remove Nginx config."
    sudo rm /etc/nginx/sites-available/car_deals_finder || handle_error "Failed to remove Nginx config."
    sudo nginx -t || handle_error "Nginx configuration test failed."
    sudo systemctl restart nginx || handle_error "Failed to restart Nginx."
}

# Remove virtual environment
remove_virtualenv() {
    display_message "Removing virtual environment..." "info"
    rm -rf venv || handle_error "Failed to remove virtual environment."
}

# Final cleanup
final_cleanup() {
    display_message "Uninstallation complete!" "success"
    display_message "All application files and configurations have been removed." "info"
}

# Main execution
ensure_root
remove_files
remove_systemd_service
remove_nginx_config
remove_virtualenv
final_cleanup
