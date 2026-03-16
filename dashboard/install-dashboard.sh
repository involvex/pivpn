#!/bin/bash

# PiVPN Dashboard Installer (WireGuard-UI standalone)
# Designed for Raspberry Pi 2B (ARMv7/ARMv6 hybrid)

set -e

# Configuration
INSTALL_DIR="/opt/wireguard-ui"
WGUI_PORT="5000"
ARCH=$(uname -m)
WGUI_REPO="ngoduykhanh/wireguard-ui"
# Using v0.5.2 for guaranteed ARMv6 compatibility which avoids SIGILL on Raspbian 32-bit
VERSION="v0.5.2"

# Ensure we're running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "Installing WireGuard-UI Dashboard for architecture: $ARCH"

# Determine binary suffix
if [[ "$ARCH" == "armv6l" ]] || [[ "$ARCH" == "armv7"* ]]; then
  # Both armv6l and armv7 use the 'arm' binary in WireGuard-UI releases
  WGUI_ARCH="arm"
elif [[ "$ARCH" == "aarch64" ]]; then
  WGUI_ARCH="arm64"
elif [[ "$ARCH" == "x86_64" ]]; then
  WGUI_ARCH="amd64"
else
  echo "Unsupported architecture: $ARCH. Attempting 'arm' as fallback."
  WGUI_ARCH="arm"
fi

# Create install directory
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Download binary
BINARY_NAME="wireguard-ui-$VERSION-linux-$WGUI_ARCH.tar.gz"
DOWNLOAD_URL="https://github.com/$WGUI_REPO/releases/download/$VERSION/$BINARY_NAME"

echo "Downloading from $DOWNLOAD_URL..."
# Remove old junk if exists
rm -f wireguard-ui
curl -L "$DOWNLOAD_URL" -o "wgui.tar.gz"
tar -xzf "wgui.tar.gz"
rm "wgui.tar.gz"

# Set permissions
chmod +x wireguard-ui

# Generate a random session secret for security
SESSION_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Create Systemd Service
cat <<EOF > /etc/systemd/system/wireguard-ui.service
[Unit]
Description=WireGuard-UI Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/wireguard-ui
Environment=WGUI_LISTEN_ADDRESS=0.0.0.0:$WGUI_PORT
Environment=WGUI_MANAGE_START=true
Environment=WGUI_MANAGE_RESTART=true
Environment=WGUI_CONFIG_PATH=/etc/wireguard
Environment=SESSION_SECRET=$SESSION_SECRET
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload and Enable
systemctl daemon-reload
systemctl enable wireguard-ui
systemctl start wireguard-ui

echo "-------------------------------------------------------"
echo "Installation Complete!"
echo "Dashboard is running at: http://$(hostname -I | awk '{print $1}'):$WGUI_PORT"
echo "Username: admin"
echo "Password: admin"
echo "-------------------------------------------------------"
