#!/bin/bash

# Checking for required commands
for cmd in ifconfig nmcli iftop traceroute ping; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd could not be found, please install it before running this script."
        exit 1
    fi
done

# Function to display network information
view_network_info() {
    echo "Network Information:"
    ifconfig | grep -E 'inet|netmask' || {
        echo "Failed to retrieve network information."
        return 1
    }
}

# Function to ping a host
ping_host() {
    read -p "Enter the host to ping: " host
    if [[ -z "$host" ]]; then
        echo "No host entered, operation cancelled."
        return 1
    fi
    ping -c 4 "$host" || {
        echo "Ping operation failed."
        return 1
    }
}

# Function for basic network diagnostics using traceroute
network_diagnostics() {
    read -p "Enter destination to trace: " destination
    if [[ -z "$destination" ]]; then
        echo "No destination entered, operation cancelled."
        return 1
    fi
    traceroute "$destination" || {
        echo "Traceroute operation failed."
        return 1
    }
}

# Function to manage network connections (enable/disable)
manage_network_connections() {
    read -p "Enter the interface (e.g., eth0, wlan0): " interface
    read -p "Enable (e) or Disable (d): " action
    case $action in
        e)
            ifconfig "$interface" up || {
                echo "Failed to enable $interface."
                return 1
            }
            ;;
        d)
            ifconfig "$interface" down || {
                echo "Failed to disable $interface."
                return 1
            }
            ;;
        *)
            echo "Invalid choice. Please enter 'e' to enable or 'd' to disable."
            return 1
            ;;
    esac
}

# Function to monitor network traffic
network_traffic_monitoring() {
    echo "Monitoring network traffic. Press Ctrl+C to stop."
    iftop || {
        echo "Failed to start network traffic monitoring."
        return 1
    }
}

# Function to manage Wi-Fi settings
manage_wifi() {
    echo "Available Wi-Fi networks:"
    nmcli dev wifi
    read -p "Enter Wi-Fi SSID to connect: " ssid
    read -s -p "Enter password: " password
    echo
    nmcli dev wifi connect "$ssid" password "$password" || {
        echo "Failed to connect to Wi-Fi network $ssid."
        return 1
    }
}

# Function to display help information
display_help_network_tools() {
    echo "Displaying help information..."
    help_file="network_tools_help.txt"  # specify the path to your help file here
    if [ ! -f "$help_file" ]; then
        echo "Help file not found."
        return 1
    fi
    less -M "$help_file"  # Opens the file in less, which provides a read-only view
}

while true; do
    echo "Welcome to the Network Tools Management Interface!"
    echo "Select a network tool operation:"
    echo "1. View Network Information"
    echo "2. Ping a Host"
    echo "3. Network Diagnostics"
    echo "4. Manage Network Connections"
    echo "5. Network Traffic Monitoring"
    echo "6. Wi-Fi Management"
    echo "7. Help"
    echo "8. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) view_network_info;;
        2) ping_host;;
        3) network_diagnostics;;
        4) manage_network_connections;;
        5) network_traffic_monitoring;;
        6) manage_wifi;;
        7) display_help_network_tools;;
        8) echo "Exiting program..."; break;;
        *) echo "Invalid choice. Please select a valid option.";;
    esac
done
