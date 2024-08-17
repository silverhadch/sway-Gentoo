#!/bin/bash

echo "Would you like to install printing services? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Installing printing services..."
    sudo emerge --ask  --autounmask-write cups system-config-printer simple-scan
    sudo dispatch-conf
    sudo rc-update add cups default
    sudo rc-service cups start
    echo "Printing services installed."
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Printing services will not be installed."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
