#!/bin/bash

# Main list of packages
packages=(
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
echo "Sway will be compiled from source due to dependency issues of the repo package"

# Define variables
SWAY_REPO_URL="https://github.com/swaywm/sway.git"
WLROOTS_REPO_URL="https://gitlab.com/swaywm/wlroots.git"
LIB_PATH="/usr/local/lib64"

git clone https://github.com/swaywm/sway.git sway-source                                                                                                 ─╯
cd sway-source        
git clone https://gitlab.freedesktop.org/wlroots/wlroots.git subprojects/wlroots


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

xdg-user-dirs-update
