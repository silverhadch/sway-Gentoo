#!/bin/bash

# Main list of packages
packages=(
    "gui-wm/sway"
    "gui-apps/swaylock"
    "gui-apps/swayidle"
    "gui-apps/swaybg"
)

# Function to read common packages from a file
read_base_packages() {
    local base_file="$1"
    if [ -f "$base_file" ]; then
        while IFS= read -r line; do
            packages+=("$line")
        done < "$base_file"
    else
        echo "Base packages file not found: $base_file"
        exit 1
    fi
}

# Read common packages from file
read_base_packages "$HOME/sway/install_scripts/base_packages.txt"

# Function to install packages if they are not already installed
install_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    # Check if each package is installed
    for pkg in "${pkgs[@]}"; do
        if ! equery l "$pkg" >/dev/null 2>&1; then
            missing_pkgs+=("$pkg")
        fi
    done

    # Install missing packages
    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Installing missing packages: ${missing_pkgs[@]}"
        sudo emerge --ask --autounmask-write "${missing_pkgs[@]}"
        sudo dispatch-conf
        if [ $? -ne 0 ]; then
            echo "Failed to install some packages. Exiting."
            exit 1
        fi
    else
        echo "All required packages are already installed."
    fi
}

# Call function to install packages
install_packages "${packages[@]}"

xdg-user-dirs-update
