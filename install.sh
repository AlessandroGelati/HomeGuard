#!/bin/bash

# 1) initial check (Root and OS)
if [ "$EUID" -ne 0 ]; then
  echo "Error: Eseguire come root."
  exit 1
fi

# 2) OS validation
echo "Checking OS..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "ERROR: Unable to find /etc/os-release"
    echo "This OS is not supported."
    exit 1
fi

case "$ID" in
    debian | ubuntu | raspbian)
        echo "Supported OS detected: $PRETTY_NAME"
        echo "Begginning installation..."
        ;;
    *)
    
        echo "ERROR '$ID' not supported."
        exit 1
        ;;
esac

# 3) loading libraries
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/install_pihole.sh"
source "$LIB_DIR/install_unbound.sh"
source "$LIB_DIR/install_pivpn.sh"
source "$LIB_DIR/install_webapp.sh"

# 4) installation
echo "Avvio installazione completa..."

apt update && apt upgrade -y
apt install -y git curl whiptail


install_pihole_component
install_unbound_component
#link function
install_pivpn_component
install_webapp_component

echo "Installation completed!"
