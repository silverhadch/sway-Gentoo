#!/bin/bash

# Function to check if a service is active and enabled
service_active_and_enabled() {
    local service="$1"
    rc-service "$service" status &> /dev/null && rc-update show default | grep -q "$service"
}

# Function to check if the display manager is set in /etc/conf.d/display-manager
check_display_manager() {
    grep -q 'DISPLAYMANAGER="' /etc/conf.d/display-manager
}

# Function to configure /etc/conf.d/display-manager
configure_display_manager() {
    local dm="$1"
    echo "Configuring $dm as the display manager..."
    sudo sed -i "s/^DISPLAYMANAGER=.*/DISPLAYMANAGER=\"$dm\"/" /etc/conf.d/display-manager
    sudo rc-update add display-manager default
}

# Function to install and configure GDM
install_gdm() {
    echo "Installing GDM..."
    sudo emerge --ask gnome-base/gdm || { echo "Failed to install GDM"; exit 1; }
    configure_display_manager gdm
    echo "GDM has been installed and configured."
}

# Function to install and configure SDDM
install_sddm() {
    echo "Installing SDDM..."
    sudo emerge --ask x11-misc/sddm || { echo "Failed to install SDDM"; exit 1; }
    configure_display_manager sddm
    echo "SDDM has been installed and configured."
}

# Function to install and configure LightDM
install_lightdm() {
    echo "Installing LightDM..."
    sudo emerge --ask x11-misc/lightdm || { echo "Failed to install LightDM"; exit 1; }
    configure_display_manager lightdm
    echo "LightDM has been installed and configured."
}

# Function to install and configure LXDM
install_lxdm() {
    echo "Installing LXDM..."
    sudo emerge --ask lxde-base/lxdm || { echo "Failed to install LXDM"; exit 1; }
    configure_display_manager lxdm
    echo "LXDM has been installed and configured."
}

# Function to install and configure SLiM
install_slim() {
    echo "Installing SLiM..."
    sudo emerge --ask x11-misc/slim || { echo "Failed to install SLiM"; exit 1; }
    configure_display_manager slim
    echo "SLiM has been installed and configured."
}

# Check if display-manager-init is installed
if ! command -v display-manager-init &> /dev/null; then
    echo "Installing display-manager-init..."
    sudo emerge --ask gui-libs/display-manager-init || { echo "Failed to install display-manager-init"; exit 1; }
fi

# Check if any display manager is already configured
if check_display_manager; then
    echo "A display manager is already configured in /etc/conf.d/display-manager."
    exit 0
fi

# Menu for user choice
echo "No display manager is configured. Choose an option to install and configure:"
echo "1. Install GDM (recommended)"
echo "2. Install SDDM"
echo "3. Install LightDM"
echo "4. Install LXDM"
echo "5. Install SLiM"

read -p "Enter your choice (1/2/3/4/5): " choice

case $choice in
    1)
        install_gdm
        ;;
    2)
        install_sddm
        ;;
    3)
        install_lightdm
        ;;
    4)
        install_lxdm
        ;;
    5)
        install_slim
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Start elogind required by the selected display manager

echo "Starting and enabling elogind service..."
sudo rc-update add elogind boot
sudo rc-service elogind start


echo "Display manager setup is complete. Please reboot to apply changes."
