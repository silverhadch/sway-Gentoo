#!/bin/bash

echo "Would you like to install Bluetooth services? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Installing Bluetooth services..."
    
    # Install Bluetooth packages
    sudo emerge --ask net-wireless/bluez net-wireless/blueman
    
    # Enable and start Bluetooth service using OpenRC
    sudo rc-update add bluetooth default
    sudo rc-service bluetooth start
    
    echo "Bluetooth services installed."
    
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Bluetooth services will not be installed."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
