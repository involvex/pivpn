#!/bin/bash

# PiVPN Dashboard Installer (WireGuard-UI standalone)
# Designed for Raspberry Pi 2B (ARMv7)

set -e

# Configuration
INSTALL_DIR="/opt/wireguard-ui"
WGUI_PORT="5000"
ARCH=$(uname -m)
WGUI_REPO="ngoduykhanh/wireguard-ui"

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

# Fetch latest release version
LATEST_TAG=$(curl -s "https://api.github.com/repos/$WGUI_REPO/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
echo "Found latest version: $LATEST_TAG"

# Download binary
BINARY_NAME="wireguard-ui-$LATEST_TAG-linux-$WGUI_ARCH.tar.gz"
DOWNLOAD_URL="https://github.com/$WGUI_REPO/releases/download/$LATEST_TAG/$BINARY_NAME"

echo "Downloading from $DOWNLOAD_URL..."
curl -L "$DOWNLOAD_URL" -o "wgui.tar.gz"
tar -xzf "wgui.tar.gz"
rm "wgui.tar.gz"

# Set permissions
chmod +x wireguard-ui

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
echo "-------------------------------------------------------"
