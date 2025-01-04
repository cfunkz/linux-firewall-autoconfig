# Firewall Management Script
![image](https://github.com/user-attachments/assets/aef414c7-b1d6-4942-b3f6-03f2a3046b34)
![image](https://github.com/user-attachments/assets/e677f39a-8f31-46d0-8293-dfb6518486a1)
![image](https://github.com/user-attachments/assets/428459f8-9ebf-4a16-9e86-16157864b5d4)
![image](https://github.com/user-attachments/assets/4ebc2dc1-44ac-4d04-b7ba-e8a1bb4f3ae7)



This script is designed to help configure and manage firewalls on a Linux system, using two firewall management tool: **firewalld(Firewall-CMD)**. It allows you to open and close ports, enable or disable the firewall, list active rules, and show the status of the firewalls.

Additionally, this script offers the functionality to specify **interfaces** (e.g., eth0, enp1s0) when enabling or disabling ports, allowing more control over the firewall rules especially if you're a newbie.

## What this does

- **firewalld and UFW**:
  - Enable or disable ports with interface restrictions.
  - List active firewalld rules.
  - Enable or disable firewalld.
  - Show the status of firewalld.

## What need

- **firewalld** installed and configured on your system.
- `sudo` privileges to modify firewall settings.

## What do

1. **Download the script using curl:**
   ```bash
   curl -sSL https://github.com/cfunkz/linux-firewall-autoconfig/raw/main/firewall_config.sh -o firewall_config.sh
   chmod +x firewall_config.sh
   ./firewall_config.sh
