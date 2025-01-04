#!/bin/bash

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

# Function to list active firewalld rules
list_firewalld_rules() {
    echo "Listing active firewalld rules..."
    sudo firewall-cmd --list-all
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

# Function to show status of firewalld
show_firewalld_status() {
    echo "firewalld status:"
    sudo firewall-cmd --state
}

# Main menu function
main_menu() {
    echo "Select the firewall you want to configure:"
    echo "1) firewalld"
    echo "2) Exit"
    read -p "Enter your choice (1/2): " firewall_choice

    case "$firewall_choice" in
        1)
            firewall_firewalld_menu
            ;;
        2)
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please choose again."
            main_menu
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
