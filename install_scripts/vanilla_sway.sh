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
WLROOTS_REPO_URL="https://gitlab.freedesktop.org/wlroots/wlroots.git"
LIB_PATH="/usr/local/lib64"

# Clone Sway repository if it doesn't exist
if [ ! -d "sway-source" ]; then
    git clone "$SWAY_REPO_URL" sway-source
else
    echo "Sway source directory already exists. Skipping clone."
fi

# Enter the Sway source directory
cd sway-source || { echo "Failed to enter sway-source directory"; exit 1; }

# Clone wlroots if it doesn't exist
if [ ! -d "subprojects/wlroots" ]; then
    git clone "$WLROOTS_REPO_URL" subprojects/wlroots
else
    echo "wlroots directory already exists. Skipping clone."
fi

# Build and install sway
if [ -f "meson.build" ]; then
    echo "Building and installing sway..."
    meson setup build || { echo "Meson setup failed"; exit 1; }
    ninja -C build || { echo "Ninja build failed"; exit 1; }
    sudo ninja -C build install || { echo "Ninja install failed"; exit 1; }
else
    echo "Error: meson.build file not found in sway-source directory."
    exit 1
fi

# Remove the wlroots source directory after installation
if [ -d "subprojects/wlroots" ]; then
    echo "Removing wlroots source directory..."
    rm -rf subprojects/wlroots
else
    echo "wlroots directory does not exist. Skipping removal."
fi

# Go back to the previous directory and remove sway-source
cd ..
if [ -d "sway-source" ]; then
    echo "Removing sway source directory..."
    rm -rf sway-source
else
    echo "sway-source directory does not exist. Skipping removal."
fi

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
