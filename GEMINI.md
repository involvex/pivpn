# PiVPN

## Project Overview

PiVPN is a set of shell scripts designed to easily turn a Raspberry Pi (or any Debian/Ubuntu-based system) into a VPN server using two free, open-source protocols:

* **WireGuard**
* **OpenVPN**

The project aims to provide a cost-effective, secure VPN solution for home users without requiring deep technical knowledge. It automates the installation and configuration process, applying hardened security settings by default.

### Key Technologies

* **Shell Scripting (Bash):** The core logic is implemented in Bash.
* **OpenVPN:** One of the supported VPN protocols.
* **WireGuard:** The other supported VPN protocol.
* **Git:** Used for version control and updates.

## Directory Structure

* `auto_install/`: Contains the main installation script (`install.sh`).
* `scripts/`: Contains utility scripts and the main `pivpn` CLI wrapper.
  * `scripts/pivpn`: The main CLI entry point.
  * `scripts/openvpn/`: OpenVPN-specific scripts.
  * `scripts/wireguard/`: WireGuard-specific scripts.
* `ciscripts/`: Scripts used for Continuous Integration and testing.
* `examples/`: Example configuration files for unattended installations.
* `files/`: Static files and templates used during installation.

## Installation & Usage

### Installation

The standard installation method is via curl:

```bash
curl -L https://install.pivpn.io | bash
```

For development or testing from a local clone:

```bash
git clone https://github.com/pivpn/pivpn.git
bash pivpn/auto_install/install.sh
```

### CLI Usage

After installation, the `pivpn` command is available to manage the VPN:

```bash
pivpn add              # Create a new client profile
pivpn revoke           # Revoke a client profile
pivpn list             # List connected clients
pivpn debug            # specific debug information
pivpn help             # Show help
```

## Development & Contribution

### Conventions

* **Style Guide:** The project follows the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html).
* **Formatting:** Use `shfmt` with the following flags: `shfmt -i 2 -ci -sr -w -bn`.
* **Branching:** Pull Requests should be targeted at the `test` branch, not `master`.

### Testing

Testing is handled by `ciscripts/test.sh`. It verifies the functionality of `pivpn` commands for both OpenVPN and WireGuard.

```bash
# To test OpenVPN
bash ciscripts/test.sh --openvpn

# To test WireGuard
bash ciscripts/test.sh --wireguard
```
