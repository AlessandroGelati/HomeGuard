#!/bin/bash

#logging
log_step() {
    echo "logging  $1"
}
log_success() {
    echo "ok  $1"
}
log_warning() {
    echo "warning: $1"
}
log_error() {
    echo "ko Error: $1"
    exit 1
}

# Pi-Hole installation
function install_pihole_component() {
    log_step "Starting Pi-hole installation..."

    # 1) detecting network interface
    log_step "Detecting network interface and IP address..."
    
    local PIHOLE_INTERFACE
    PIHOLE_INTERFACE=$(ip route get 1.1.1.1 | grep -oP 'dev \K\w+')
    
    local IPV4_ADDRESS
    IPV4_ADDRESS=$(ip -4 addr show dev "$PIHOLE_INTERFACE" | grep -oP 'inet \K[\d\.]+')

    if [ -z "$PIHOLE_INTERFACE" ] || [ -z "$IPV4_ADDRESS" ]; then
        log_error "Unable to automatically detect network interface or IP address."
    fi
    
    log_success "Detected interface: $PIHOLE_INTERFACE, IP: $IPV4_ADDRESS"

    # 2) creating configuration file
    log_step "Creazione file /etc/pihole/setupVars.conf..."
    
    #creating directory
    mkdir -p /etc/pihole

    cat << EOF > /etc/pihole/setupVars.conf
PIHOLE_INTERFACE=$PIHOLE_INTERFACE
IPV4_ADDRESS=$IPV4_ADDRESS
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=true
BLOCKING_ENABLED=true

# DNS settings for unbound 
PIHOLE_DNS_1=127.0.0.1#5353
PIHOLE_DNS_2=
EOF

    # 3) executing official installer
    log_step "Cloning Pi-hole repository..."
    local installer_dir="/tmp/pihole-installer"
    
    # remove previous clones
    rm -rf "$installer_dir"
    
    if ! git clone https://github.com/pi-hole/pi-hole.git "$installer_dir"; then
        log_error "Unable to clone Pi-Hole repository."
    fi

    # 4) executing non interactive installation
    log_step "Executing non interactive installation..."
    local install_script="$installer_dir/automated install/basic-install.sh"
    
    if ! sudo bash "$install_script" --unattended; then
        log_error "Script 'basic-install.sh' failed."
    fi

    # 5) retrieving webpassword
    log_step "Retrieving admin password..."
    local PIHOLE_PASSWORD
    PIHOLE_PASSWORD=$(grep 'WEBPASSWORD' /etc/pihole/setupVars.conf | awk -F'=' '{print $2}')

    if [ -z "$PIHOLE_PASSWORD" ]; then
        log_warning "Unable to automatically retrieve password."
        log_warning "Please manually set password with: pihole -a -p"
    fi

    # 6) cleaning up
    log_step "Cleaning installation file..."
    rm -rf "$installer_dir"

    log_success "Pi-hole installation successfully completed."
    echo ""
    echo "-----------------------------------------------------"
    echo "  Pi-hole admin access:"
    echo "  URL:      http://$IPV4_ADDRESS/admin/"
    echo "  Password: $PIHOLE_PASSWORD"
    echo "-----------------------------------------------------"
    echo ""
}
