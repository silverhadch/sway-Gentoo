#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."

    # Use emerge to install git (Gentoo's package manager)
    if command -v emerge &> /dev/null; then
        sudo emerge --sync
        sudo emerge --ask --verbose dev-vcs/git
    else
        echo "Cannot install Git automatically using emerge. Please install Git manually and run this script again."
        exit 1
    fi

    # Check again if git is installed after attempting to install
    if ! command -v git &> /dev/null; then
        echo "Git installation failed. Please install Git manually and run this script again."
        exit 1
    fi
fi

echo "Git is installed. Continuing with the script..."

# Clone the repository into the home directory
git clone https://github.com/silverhadch/sway-Gentoo
cp -r sway-Gentoo ~/sway

clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |c|u|s|t|o|m| |s|c|r|i|p|t| 
 +-+-+-+-+-+-+ +-+-+-+-+-+-+                                                                                                            
"

# Run the setup script
bash ~/sway/install_scripts/setup.sh

clear

# Run the extra packages
bash ~/sway/install_scripts/packages.sh

clear

echo "Make sure a Display Manager is installed"

# Install SDDM (or another Display Manager)
bash ~/sway/install_scripts/display_manager.sh

clear

# Add bashrc configuration
bash ~/sway/install_scripts/add_bashrc.sh

clear 

# Run the printers setup script
bash ~/sway/install_scripts/printers.sh

clear 

# Run the Bluetooth setup script
bash ~/sway/install_scripts/bluetooth.sh

# Clean up unnecessary packages
sudo emerge --depclean

printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
