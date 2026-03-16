#!/bin/bash

# PiVPN Optimization Script for Raspberry Pi 2B
# Applies overclocking and disables unnecessary services

set -e

# Ensure we're running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

CONFIG_FILE="/boot/config.txt"
[ ! -f "$CONFIG_FILE" ] && CONFIG_FILE="/boot/firmware/config.txt"

echo "Optimizing Pi 2B for PiVPN performance..."

# 1. Apply Overclocking
if ! grep -q "arm_freq=1000" "$CONFIG_FILE"; then
  echo "Adding overclocking settings to $CONFIG_FILE"
  cat <<EOF >> "$CONFIG_FILE"

# PiVPN Optimization Tweaks
arm_freq=1000
core_freq=500
sdram_freq=500
over_voltage=2
dtoverlay=disable-bt
dtparam=audio=off
EOF
else
  echo "Overclocking settings already present in $CONFIG_FILE"
fi

# 2. Network Tweaks (MTU and Queues)
echo "Optimizing network queues..."
cat <<EOF > /etc/sysctl.d/99-pivpn-optimization.conf
net.core.rmem_max=2097152
net.core.wmem_max=2097152
net.ipv4.tcp_rmem=4096 87380 2097152
net.ipv4.tcp_wmem=4096 65536 2097152
net.core.netdev_max_backlog=5000
EOF

sysctl --system

echo "-------------------------------------------------------"
echo "Optimizations Applied!"
echo "Please REBOOT your Raspberry Pi for changes to take effect."
echo "-------------------------------------------------------"
