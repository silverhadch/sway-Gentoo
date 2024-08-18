#!/bin/bash

# Main list of packages
packages=(
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
echo "Sway will be compiled from source due to dependency issues of the repo package"

# Define variables
SWAY_REPO_URL="https://github.com/swaywm/sway.git"
WLROOTS_REPO_URL="https://gitlab.com/swaywm/wlroots.git"
LIB_PATH="/usr/local/lib64"

# Clone sway repository
echo "Cloning sway-source repository..."
git clone $SWAY_REPO_URL sway-source

# Change into the sway directory
cd sway-source || { echo "Failed to change directory to sway"; exit 1; }

# Clone wlroots into the subprojects directory
echo "Cloning wlroots into subprojects/wlroots..."
git clone $WLROOTS_REPO_URL subprojects/wlroots

# Build and install sway
echo "Building and installing sway..."
meson build
ninja -C build
sudo ninja -C build install

# Remove the wlroots source directory after installation
echo "Removing wlroots source directory..."
rm -rf subprojects/wlroots

# Remove the sway source directory after installation
cd ..
echo "Removing sway source directory..."
rm -rf sway-source

# Configure library path
echo "Configuring library path..."
echo "$LIB_PATH" | sudo tee /etc/ld.so.conf.d/local-lib64.conf

# Update library cache
echo "Updating library cache..."
sudo ldconfig

# Check sway version
echo "Checking sway version..."
sway --version

echo "Sway-source completed."
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
