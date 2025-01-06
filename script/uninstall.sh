#!/bin/bash

# ============================================================
# Car Deals Finder - Uninstallation Script
# ============================================================

LOG_FILE="uninstallation.log"
APP_DIR="/var/www/car_deals_finder"
VENV_DIR="$APP_DIR/venv"
USER=$(whoami)

# ============================================================
# Helper Functions
# ============================================================

display_message() {
    echo -e "$1"
    echo "$(date) - $1" >> "$LOG_FILE"
}

handle_error() {
    display_message "❌ $1"
    exit 1
}

# Ensure script is run as root
ensure_root() {
    if [[ "$USER" != "root" ]]; then
        handle_error "This script must be run as root. Please use sudo."
    fi
}

# ============================================================
# Uninstallation Steps
# ============================================================

remove_files() {
    display_message "Removing application files..." "info"
    if [ -d "$APP_DIR" ]; then
        rm -rf "$APP_DIR" || handle_error "Failed to remove application files."
        display_message "Application files removed successfully." "success"
    else
        display_message "No application files found to remove." "info"
    fi
}

remove_systemd_service() {
    if [ -f "/etc/systemd/system/car_deals_finder.service" ]; then
        display_message "Removing systemd service..." "info"
        sudo systemctl stop car_deals_finder || handle_error "Failed to stop systemd service."
        sudo systemctl disable car_deals_finder || handle_error "Failed to disable systemd service."
        sudo rm /etc/systemd/system/car_deals_finder.service || handle_error "Failed to remove systemd service file."
        sudo systemctl daemon-reload || handle_error "Failed to reload systemd daemon."
        display_message "Systemd service removed successfully." "success"
    else
        display_message "No systemd service found to remove." "info"
    fi
}

remove_nginx_config() {
    if [ -f "/etc/nginx/sites-enabled/car_deals_finder" ] || [ -f "/etc/nginx/sites-available/car_deals_finder" ]; then
        display_message "Removing Nginx configuration..." "info"
        sudo rm /etc/nginx/sites-enabled/car_deals_finder 2>/dev/null || handle_error "Failed to remove Nginx enabled config."
        sudo rm /etc/nginx/sites-available/car_deals_finder 2>/dev/null || handle_error "Failed to remove Nginx available config."
        sudo nginx -t || handle_error "Nginx configuration test failed."
        sudo systemctl restart nginx || handle_error "Failed to restart Nginx."
        display_message "Nginx configuration removed successfully." "success"
    else
        display_message "No Nginx configuration found to remove." "info"
    fi
}

remove_virtualenv() {
    if [ -d "$VENV_DIR" ]; then
        display_message "Removing virtual environment..." "info"
        rm -rf "$VENV_DIR" || handle_error "Failed to remove virtual environment."
        display_message "Virtual environment removed successfully." "success"
    else
        display_message "No virtual environment found to remove." "info"
    fi
}

remove_logs() {
    if [ -f "$LOG_FILE" ]; then
        display_message "Removing log file..." "info"
        rm -f "$LOG_FILE" || handle_error "Failed to remove log file."
        display_message "Log file removed successfully." "success"
    else
        display_message "No log file found to remove." "info"
    fi
}

# ============================================================
# Final Cleanup
# ============================================================

final_cleanup() {
    display_message "Uninstallation complete!" "success"
    display_message "All application files, configurations, and logs have been removed." "info"
}

# ============================================================
# Main Script Execution
# ============================================================

main() {
    ensure_root
    remove_files
    remove_systemd_service
    remove_nginx_config
    remove_virtualenv
    remove_logs
    final_cleanup
}

main