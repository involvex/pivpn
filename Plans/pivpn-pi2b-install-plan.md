# Implementation Plan: PiVPN on Raspberry Pi 2B with MyFRITZ! (Local Repo Setup)

## 1. Objectives
*   Install and configure PiVPN (WireGuard) on a Raspberry Pi 2B.
*   Integrate MyFRITZ! DDNS for global availability.
*   Deploy a lightweight management dashboard (WireGuard-UI) using scripts from this repository.
*   Apply hardware and OS optimizations for the Pi 2B.

## 2. Key Context & Requirements
*   **Hardware:** Raspberry Pi 2B (900MHz Quad-Core, 1GB RAM).
*   **Network:** FRITZ!Box router with MyFRITZ! enabled.
*   **Software:** Raspberry Pi OS Lite (32-bit).

## 3. Implementation Steps

### Phase 1: Preparation & OS Optimization
1.  **Flash OS:** Install **Raspberry Pi OS Lite** (32-bit) onto a high-quality SD card.
2.  **Initial Config:** Enable SSH and set a static IP address for the Pi in your FRITZ!Box settings.
3.  **Run Optimization Script:** 
    Clone this repo and run the optimization script to apply overclocking and disable unnecessary services:
    ```bash
    sudo bash scripts/optimize-pi2b.sh
    sudo reboot
    ```
4.  **Update System:** Run `sudo apt update && sudo apt upgrade -y`.

### Phase 2: PiVPN Installation
1.  **Run Installer:** 
    ```bash
    curl -L https://install.pivpn.io | bash
    ```
2.  **Configuration Choices:**
    *   **User:** Select the default `pi` user.
    *   **Protocol:** Choose **WireGuard**.
    *   **Port:** Use default **51820**.
    *   **DNS:** Choose a fast provider like **Cloudflare (1.1.1.1)**.
    *   **Public IP/DNS:** Select **DNS Entry**.
    *   **MyFRITZ! Address:** Enter your full MyFRITZ! domain (e.g., `xxxxxxxxx.myfritz.net`).

### Phase 3: Global Availability (FRITZ!Box)
1.  **MyFRITZ! Setup:** Ensure MyFRITZ! is active under **Internet > MyFRITZ!-Account**.
2.  **Port Forwarding:** 
    *   Navigate to **Internet > Permit Access > Port Sharing**.
    *   Add a new sharing rule for the Raspberry Pi.
    *   Choose **Port sharing** -> **UDP** -> Port **51820**.

### Phase 4: Dashboard Setup (via Local Repo)
1.  **Clone Repo:** On your Raspberry Pi, clone this repository:
    ```bash
    git clone https://github.com/involvex/pivpn.git
    cd pivpn
    ```
2.  **Run Dashboard Installer:**
    ```bash
    sudo bash dashboard/install-dashboard.sh
    ```
    This script will:
    *   Detect your Pi 2B's architecture.
    *   Download the latest WireGuard-UI binary.
    *   Set up a systemd service to run the dashboard on port 5000.
3.  **Access:** Open `http://<your-pi-ip>:5000` in your browser.

### Phase 5: Client Management
1.  **Add Clients:** Use the dashboard or run `pivpn add` in the CLI.
2.  **Connect:** Scan the generated QR code (`pivpn -qr`) using the WireGuard app on your mobile device.

## 4. Verification & Testing
1.  **Local Check:** Run `pivpn status` to verify the WireGuard service is active.
2.  **External Connectivity:** Disconnect your mobile device from Wi-Fi (use LTE/5G) and attempt to connect to the VPN.
3.  **Performance Test:** Run an internet speed test while connected to the VPN to ensure the Pi 2B is handling the encryption load effectively.
