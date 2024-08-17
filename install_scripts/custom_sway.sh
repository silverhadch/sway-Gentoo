#!/bin/bash

# Main list of packages
packages=(
    "gui-wm/sway"
    "gui-apps/waybar"
    "gui-apps/swaylock"
    "gui-apps/swayidle"
    "gui-apps/swaybg"
    "gui-apps/mako"
)

# Function to read common packages from a file
read_common_packages() {
    local common_file="$1"
    if [ -f "$common_file" ]; then
        packages+=( $(< "$common_file") )
    else
        echo "Common packages file not found: $common_file"
        exit 1
    fi
}

# Read common packages from file
read_common_packages "$HOME/sway/install_scripts/common_packages.txt"

# Function to install packages if they are not already installed
install_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    # Check if each package is installed
    for pkg in "${pkgs[@]}"; do
        if ! equery list "$pkg" > /dev/null 2>&1; then
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

# Enable services using OpenRC
sudo rc-update add avahi-daemon default
sudo rc-update add acpid default

# Start services if needed
sudo rc-service avahi-daemon start
sudo rc-service acpid start

# Update user directories
xdg-user-dirs-update
mkdir -p ~/Screenshots/

# Nerd font installation
bash ~/sway/install_scripts/nerdfonts.sh

# Install nwg-look
bash ~/sway/install_scripts/nwg-look

# Install rofi-wayland
bash ~/sway/install_scripts/rofi-wayland

# Moving custom config files
cp -r ~/sway/configs/scripts/ ~
cp -r ~/sway/configs/sway/ ~/.config/
cp -r ~/sway/configs/swaync/ ~/.config/
cp -r ~/sway/configs/waybar/ ~/.config/
cp -r ~/sway/configs/rofi/ ~/.config/
cp -r ~/sway/configs/kitty/ ~/.config/
cp -r ~/sway/configs/backgrounds/ ~/.config/

# Adding GTK theme and icon theme
bash ~/sway/colorschemes/purple.sh
