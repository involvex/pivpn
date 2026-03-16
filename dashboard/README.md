# PiVPN Dashboard (WireGuard-UI)

This directory contains a standalone installer for **WireGuard-UI**, a lightweight web interface for managing your WireGuard VPN. It is optimized for low-resource hardware like the Raspberry Pi 2B.

## Features
*   Create, Delete, and Manage WireGuard clients.
*   Generate QR codes for mobile setup.
*   Monitor client status.
*   Lightweight standalone binary (no Docker required).

## Installation

1.  Clone this repository to your Raspberry Pi:
    ```bash
    git clone https://github.com/involvex/pivpn.git
    cd pivpn
    ```

2.  Run the dashboard installer:
    ```bash
    sudo bash dashboard/install-dashboard.sh
    ```

3.  Access the dashboard:
    Open your browser and go to `http://<your-pi-ip>:5000`.

## Configuration
The dashboard runs as a systemd service. You can manage it with these commands:
*   **Check status:** `sudo systemctl status wireguard-ui`
*   **Restart:** `sudo systemctl restart wireguard-ui`
*   **Stop:** `sudo systemctl stop wireguard-ui`
