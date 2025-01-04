# Firewall Management Script

This script is designed to help configure and manage firewalls on a Linux system, using two firewall management tools: **UFW (Uncomplicated Firewall)** and **firewalld(Firewall-CMD)**. It allows you to open and close ports, enable or disable the firewall, list active rules, and show the status of the firewalls.

Additionally, this script offers the functionality to specify **interfaces** (e.g., eth0, enp1s0) when enabling or disabling ports, allowing more control over the firewall rules especially if you're a newbie.

## What this does

- **UFW (Uncomplicated Firewall)**:
  - Enable or disable ports with interface restrictions.
  - List active UFW rules.
  - Enable or disable UFW firewall.
  - Show the status of UFW.

- **firewalld**:
  - Enable or disable ports with interface restrictions.
  - List active firewalld rules.
  - Enable or disable firewalld.
  - Show the status of firewalld.

## What need

- **UFW** or **firewalld** installed and configured on your system.
- `sudo` privileges to modify firewall settings.

## What do

1. **Download the script using curl:**
   ```bash
   curl -sSL https://github.com/cfunkz/linux-firewall-autoconfig/raw/main/firewall_config.sh -o firewall_config.sh
   chmod +x firewall_config.sh
   ./firewall_config.sh



