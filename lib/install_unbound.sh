#!/bin/bash

# logging
log_step() {
    echo "starting $1"
}
log_success() {
    echo "ok $1"
}
log_error() {
    echo "ko Error: $1"
    exit 1
}

# installation function
function install_unbound_component() {
    log_step "Starting unbound installation..."
    
    # 1) installing packet
    log_step "Installing unbound packet..."
    if ! apt install -y unbound; then
        log_error "Installation failed"
    fi

    # 2) root hints download
    log_step "Downloading root hints..."
    if ! wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root; then
        log_error "Download failed."
    fi

    chown unbound:unbound /var/lib/unbound/root.hints

    # 3) loading conf file
    # SCRIPT_DIR in 'install.sh'
    # (SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd))
    local config_template="$SCRIPT_DIR/config_templates/unbound_pihole.conf"
    local config_dest="/etc/unbound/unbound.conf.d/pi-hole.conf"
    
    log_step "Loading config file..."
    if [ ! -f "$config_template" ]; then
        log_error "Error: config file not found $config_template"
    fi
    
    if ! cp "$config_template" "$config_dest"; then
        log_error "Error: config file loading failed"
    fi

    # 4) Start and enable service
    log_step "Starting and enabling service 'unbound'..."
    if ! systemctl restart unbound; then
        log_error "Starting service 'unbound' failed."
    fi
    
    if ! systemctl enable unbound; then
        log_error "Enabling service 'unbound' failed."
    fi

    log_success "Installation and configuration of unbound complete."
    log_step "Unbound si active and listening on 127.0.0.1:5335."
}
