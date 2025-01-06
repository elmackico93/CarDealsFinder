#!/bin/bash

# ============================================================
# Car Deals Finder - Version 1.0 Installer
# Features: Internationalization, Git Collaboration, SSL, Secure Workflow
# ============================================================

LOG_FILE="installation.log"
APP_DIR="/var/www/car_deals_finder"
VENV_DIR="$APP_DIR/venv"
USER=$(whoami)
LANGUAGE="it"  # Default language: Italian
PORT=8000       # Default port for Standalone Mode

# ============================================================
# Localization Support
# ============================================================

load_translations() {
    case "$LANGUAGE" in
        en)
            WELCOME_MSG="Welcome to the Car Deals Finder Installer!"
            MODE_PROMPT="Please select one of the following modes:"
            MODE_OPTION1="1) Client-Server Mode (Recommended for centralized data and scraping)"
            MODE_OPTION2="2) Standalone Mode (Run entirely on your device with limited scraping)"
            DOMAIN_PROMPT="Enter domain name (or leave blank for localhost): "
            SSL_PROMPT="Would you like to configure SSL with Let's Encrypt? (yes/no): "
            GIT_PROMPT="Do you want to collaborate on the original Git repository? (yes/no): "
            GITHUB_USER_PROMPT="Enter your GitHub username: "
            CONFIG_SUMMARY="Configuration Summary:"
            ;;
        de)
            WELCOME_MSG="Willkommen zum Car Deals Finder Installer!"
            MODE_PROMPT="Bitte wählen Sie einen der folgenden Modi:"
            MODE_OPTION1="1) Client-Server-Modus (Empfohlen für zentrale Daten und Scraping)"
            MODE_OPTION2="2) Standalone-Modus (Läuft vollständig auf Ihrem Gerät mit eingeschränktem Scraping)"
            DOMAIN_PROMPT="Geben Sie den Domainnamen ein (oder lassen Sie es für localhost leer): "
            SSL_PROMPT="Möchten Sie SSL mit Let's Encrypt konfigurieren? (ja/nein): "
            GIT_PROMPT="Möchten Sie am ursprünglichen Git-Repository mitarbeiten? (ja/nein): "
            GITHUB_USER_PROMPT="Geben Sie Ihren GitHub-Benutzernamen ein: "
            CONFIG_SUMMARY="Konfigurationsübersicht:"
            ;;
        *)
            WELCOME_MSG="Benvenuto nell'Installer di Car Deals Finder!"
            MODE_PROMPT="Si prega di selezionare una delle seguenti modalità:"
            MODE_OPTION1="1) Modalità Client-Server (Consigliata per dati centralizzati e scraping)"
            MODE_OPTION2="2) Modalità Standalone (Esegui interamente sul tuo dispositivo con scraping limitato)"
            DOMAIN_PROMPT="Inserisci il nome del dominio (o lascia vuoto per localhost): "
            SSL_PROMPT="Vuoi configurare SSL con Let's Encrypt? (sì/no): "
            GIT_PROMPT="Vuoi collaborare al repository Git originale? (sì/no): "
            GITHUB_USER_PROMPT="Inserisci il tuo nome utente GitHub: "
            CONFIG_SUMMARY="Riepilogo Configurazione:"
            ;;
    esac
}

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

ensure_root() {
    if [[ "$USER" != "root" ]]; then
        handle_error "This script must be run as root. Please use sudo."
    fi
}

secure_permissions() {
    chmod -R 750 "$APP_DIR" || handle_error "Failed to set secure permissions."
    chown -R "$USER:$USER" "$APP_DIR" || handle_error "Failed to set ownership for $APP_DIR."
}

# ============================================================
# Installation Workflow
# ============================================================

setup_configuration() {
    clear
    display_message "$WELCOME_MSG"

    echo -e "\n$MODE_PROMPT"
    echo -e "$MODE_OPTION1"
    echo -e "$MODE_OPTION2"
    read -p "Choice [1/2]: " MODE

    SERVER_MODE="False"
    [[ "$MODE" == "1" ]] && SERVER_MODE="True"

    if [[ "$SERVER_MODE" == "False" ]]; then
        read -p "Enter the port number for Standalone Mode (default: 8000): " PORT_INPUT
        PORT=${PORT_INPUT:-$PORT}
    fi

    read -p "$DOMAIN_PROMPT" DOMAIN
    DOMAIN=${DOMAIN:-localhost}

    read -p "$SSL_PROMPT" SSL
    SSL=${SSL,,}

    read -p "$GIT_PROMPT" COLLABORATE
    COLLABORATE=${COLLABORATE,,}
}

install_dependencies() {
    display_message "Installing dependencies..."
    apt-get update && apt-get install -y apache2 python3 python3-pip python3-venv certbot git || handle_error "Dependency installation failed."
}

initialize_git() {
    [[ "$COLLABORATE" == "yes" ]] || return
    read -p "$GITHUB_USER_PROMPT" GITHUB_USERNAME
    git clone "https://github.com/$GITHUB_USERNAME/CarDealsFinder.git" "$APP_DIR" || handle_error "Failed Git Setup"
}

configure_ssl() {
    [[ "$SSL" == "yes" ]] || return
    certbot --apache || handle_error "SSL configuration failed."
}

configure_systemd_service() {
    if [[ "$SERVER_MODE" == "True" ]]; then
        display_message "Configuring systemd service..." "info"
        SERVICE_FILE="/etc/systemd/system/car_deals_finder.service"
        sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Car Deals Finder - Gunicorn server
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_DIR/bin"
ExecStart=$VENV_DIR/bin/gunicorn --workers 3 --bind unix:$APP_DIR/car_deals_finder.sock wsgi:app

[Install]
WantedBy=multi-user.target
EOL
        sudo systemctl daemon-reload
        sudo systemctl enable car_deals_finder
        sudo systemctl start car_deals_finder
    else
        display_message "Starting Flask server in Standalone Mode on port $PORT..." "info"
        python3 -m flask run --host=0.0.0.0 --port="$PORT" &
    fi
}

final_steps() {
    display_message "Installation complete!" "success"
    display_message "Configuration Summary:"
    display_message " - Mode: ${SERVER_MODE}" "info"
    display_message " - Domain: ${DOMAIN}" "info"
    display_message " - Port: ${PORT}" "info"
}

# ============================================================
# Main Script Execution
# ============================================================

main() {
    ensure_root
    load_translations
    setup_configuration
    install_dependencies
    initialize_git
    configure_ssl
    configure_systemd_service
    final_steps
}

main