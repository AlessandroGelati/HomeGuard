# HomeGuard
<img width="1024" height="1024" alt="E0ED8B2D-9D79-4D35-B5B0-FFDD3BDD9F58" src="https://github.com/user-attachments/assets/76ded056-ff2d-48c5-8b43-429c2aed6f2f" />
HomeGuard is an all-in-one automated installer that deploys a hardened network stack on your Linux server. It combines the power of WireGuard (via PiVPN), Pi-hole, and Unbound, all managed through a custom, lightweight Web GUI.
Forget manual configuration. This project automates the "perfect" privacy trio:
 * WireGuard: Secure, high-speed VPN access.
 * Pi-hole: Network-wide ad and tracker blocking.
 * Unbound: A private, recursive DNS resolver that doesn't trust third parties like Google or Cloudflare.

Architecture Flow
The data flow follows a strict privacy-first path:
Client -> WireGuard Tunnel -> Pi-hole (Filter) -> Unbound (Recursive Resolver) -> Root DNS Servers.

Features
 * Zero-Interaction Install: Automated scripts handle dependencies, configuration, and service linking.
 * Recursive DNS: Integrated Unbound setup pre-configured for Pi-hole.
 * VPN Management: Automated WireGuard setup for remote secure browsing.
 * Custom Management GUI: A Flask-based web interface to monitor status and manage VPN clients without touching the CLI.
 * Multi-OS Support: Optimized for Debian 12, Ubuntu 24.04 LTS, and Raspberry Pi OS.

Project Structure
pi-safestack/
├── .github/                # GitHub Actions and Issue templates
├── config_templates/       # Pre-configured templates for services
│   ├── unbound_pihole.conf # Hardened Unbound configuration
│   └── pihole_setupVars.conf # Non-interactive Pi-hole setup
├── docs/                   # Additional documentation
├── lib/                    # Modular installation scripts (The "Engine")
│   ├── common_utils.sh     # Shared logging and validation functions
│   ├── install_pihole.sh   # Pi-hole automation logic
│   ├── install_pivpn.sh    # PiVPN/WireGuard automation logic
│   ├── install_unbound.sh  # Unbound recursive DNS logic
│   └── install_webapp.sh   # GUI deployment logic
├── webapp/                 # Custom Management Web Interface
│   ├── static/             # CSS and JavaScript files
│   ├── templates/          # HTML templates
│   ├── backend.py          # Flask API server
│   ├── requirements.txt    # Python dependencies
│   └── service/            # Systemd service unit file
├── .gitignore              # Files to ignore in Git
├── install.sh              # MAIN ENTRY POINT (The Orchestrator)
├── LICENSE                 # MIT License
└── README.md               # You are here!

Installation
Prerequisites
 * A clean installation of Debian, Ubuntu, or Raspberry Pi OS.
 * Root or sudo privileges.
 * A static local IP address (recommended).
 * Port 51820/UDP forwarded on your router (for VPN access).
Run the Installer
Simply clone the repository and run the orchestrator:
git clone https://github.com/your-username/pi-safestack.git
cd pi-safestack
sudo chmod +x install.sh
sudo ./install.sh

Post-Installation
Once the script finishes:
 * Pi-hole Admin: Access via http://<your-ip>/admin.
 * Management GUI: Access your custom dashboard at http://<your-ip>:5000 (or your configured port).
 * VPN Clients: Use the Web GUI to generate .conf files or QR codes for your mobile devices.

Important Notes
> [!WARNING]
> This script modifies system firewall rules (ufw). If you are running other services, ensure you check your port configurations after installation.
> 
> [!TIP]
> Always run this on a fresh OS installation to avoid conflicts with existing web servers (like Apache or Nginx) that might fight over port 80.
> 

Contributing
Feel free to fork this project, report bugs, or submit pull requests. Let's make network privacy accessible to everyone!
License: MIT
Author: Alessandro Gelati
