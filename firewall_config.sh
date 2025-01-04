#!/bin/bash

# Function to enable port for UFW with interface restrictions
enable_ufw_port() {
    local protocol=$1
    local port=$2
    local interface=$3
    if [ -z "$interface" ]; then
        echo "Enabling $protocol port $port in UFW for all interfaces..."
        sudo ufw allow $protocol from any to any port $port
    else
        echo "Enabling $protocol port $port in UFW for interface $interface..."
        sudo ufw allow in on $interface to any port $port proto $protocol
    fi
}

# Function to disable UFW port rule for all interfaces or a specific interface
disable_ufw_port() {
    local protocol=$1
    local port=$2
    local interface=$3

    # If interface is empty, disable rule for all interfaces
    if [ -z "$interface" ]; then
        echo "Disabling $protocol port $port rule in UFW for all interfaces..."
        sudo ufw deny $protocol from any to any port $port
    else
        # If interface is specified, disable rule for that interface
        echo "Disabling $protocol port $port rule in UFW for interface $interface..."
        sudo ufw deny $protocol from any to any port $port proto $protocol on $interface
    fi

    # List the active UFW rules to confirm the changes
    sudo ufw status verbose
}


# Function to enable port for firewalld with interface restrictions
enable_firewalld_port() {
    local protocol=$1
    local port=$2
    local interface=$3
    echo "Enabling $protocol port $port in firewalld for interface $interface..."
    if [ -z "$interface" ]; then
        sudo firewall-cmd --permanent --add-port=$port/$protocol
    else
        sudo firewall-cmd --permanent --zone=public --add-port=$port/$protocol --interface=$interface
    fi
    sudo firewall-cmd --reload
}

# Function to disable port for firewalld with interface restrictions
disable_firewalld_port() {
    local protocol=$1
    local port=$2
    local interface=$3
    echo "Disabling $protocol port $port in firewalld for interface $interface..."
    if [ -z "$interface" ]; then
        sudo firewall-cmd --permanent --remove-port=$port/$protocol
    else
        sudo firewall-cmd --permanent --zone=public --remove-port=$port/$protocol --interface=$interface
    fi
    sudo firewall-cmd --reload
}

# Function to list active UFW rules
list_ufw_rules() {
    echo "Listing active UFW rules..."
    sudo ufw status verbose
}

# Function to list active firewalld rules
list_firewalld_rules() {
    echo "Listing active firewalld rules..."
    sudo firewall-cmd --list-all
}

# Function to enable UFW
enable_ufw() {
    echo "Enabling UFW..."
    sudo ufw enable
}

# Function to disable UFW
disable_ufw() {
    echo "Disabling UFW..."
    sudo ufw disable
}

# Function to enable firewalld
enable_firewalld() {
    echo "Enabling firewalld..."
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
}

# Function to disable firewalld
disable_firewalld() {
    echo "Disabling firewalld..."
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
}

# Function to show status of UFW
show_ufw_status() {
    echo "UFW status:"
    sudo ufw status
}

# Function to show status of firewalld
show_firewalld_status() {
    echo "firewalld status:"
    sudo firewall-cmd --state
}

# Main menu function
main_menu() {
    echo "Select the firewall you want to configure:"
    echo "1) UFW"
    echo "2) firewalld"
    echo "3) Exit"
    read -p "Enter your choice (1/2/3): " firewall_choice

    case "$firewall_choice" in
        1)
            firewall_ufw_menu
            ;;
        2)
            firewall_firewalld_menu
            ;;
        3)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please choose again."
            main_menu
            ;;
    esac
}

# UFW-specific menu
firewall_ufw_menu() {
    echo "Select an action for UFW:"
    echo "1) Enable port"
    echo "2) Disable port"
    echo "3) List active rules"
    echo "4) Enable UFW"
    echo "5) Disable UFW"
    echo "6) Show status"
    echo "7) Back to main menu"
    read -p "Enter your choice (1-7): " ufw_choice

    case "$ufw_choice" in
        1)
            read -p "Enter the ports to open (e.g., tcp/8080 udp/1000): " port_input
            read -p "Enter the interface (eth0, enp1s0 etc,. or leave empty for all): " interface
            for entry in $port_input; do
                protocol=$(echo $entry | cut -d'/' -f1)
                port=$(echo $entry | cut -d'/' -f2)
                enable_ufw_port $protocol $port $interface
            done
            firewall_ufw_menu
            ;;
        2)
            read -p "Enter the ports to close (e.g., tcp/8080 udp/1000): " port_input
            read -p "Enter the interface (eth0, enp1s0 etc,. or leave empty for all): " interface
            for entry in $port_input; do
                protocol=$(echo $entry | cut -d'/' -f1)
                port=$(echo $entry | cut -d'/' -f2)
                disable_ufw_port $protocol $port $interface
            done
            firewall_ufw_menu
            ;;
        3)
            list_ufw_rules
            firewall_ufw_menu
            ;;
        4)
            enable_ufw
            firewall_ufw_menu
            ;;
        5)
            disable_ufw
            firewall_ufw_menu
            ;;
        6)
            show_ufw_status
            firewall_ufw_menu
            ;;
        7)
            main_menu
            ;;
        *)
            echo "Invalid choice."
            firewall_ufw_menu
            ;;
    esac
}

# firewalld-specific menu
firewall_firewalld_menu() {
    echo "Select an action for firewalld:"
    echo "1) Enable port"
    echo "2) Disable port"
    echo "3) List active rules"
    echo "4) Enable firewalld"
    echo "5) Disable firewalld"
    echo "6) Show status"
    echo "7) Back to main menu"
    read -p "Enter your choice (1-7): " firewalld_choice

    case "$firewalld_choice" in
        1)
            read -p "Enter the ports to open (e.g., tcp/8080 udp/1000): " port_input
            read -p "Enter the interface (eth0, enp1s0 etc,. or leave empty for all): " interface
            for entry in $port_input; do
                protocol=$(echo $entry | cut -d'/' -f1)
                port=$(echo $entry | cut -d'/' -f2)
                enable_firewalld_port $protocol $port $interface
            done
            firewall_firewalld_menu
            ;;
        2)
            read -p "Enter the ports to close (e.g., tcp/8080 udp/1000): " port_input
            read -p "Enter the interface (eth0, enp1s0 etc,. or leave empty for all): " interface
            for entry in $port_input; do
                protocol=$(echo $entry | cut -d'/' -f1)
                port=$(echo $entry | cut -d'/' -f2)
                disable_firewalld_port $protocol $port $interface
            done
            firewall_firewalld_menu
            ;;
        3)
            list_firewalld_rules
            firewall_firewalld_menu
            ;;
        4)
            enable_firewalld
            firewall_firewalld_menu
            ;;
        5)
            disable_firewalld
            firewall_firewalld_menu
            ;;
        6)
            show_firewalld_status
            firewall_firewalld_menu
            ;;
        7)
            main_menu
            ;;
        *)
            echo "Invalid choice."
            firewall_firewalld_menu
            ;;
    esac
}

# Run the main menu
main_menu
