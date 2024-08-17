#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install Git if not already installed
install_git() {
    echo "Git is not installed. Attempting to install Git..."

    if command_exists emerge; then
        sudo emerge --sync
        sudo emerge --ask --verbose dev-vcs/git
    else
        echo "Cannot install Git automatically using emerge. Please install Git manually and run this script again."
        exit 1
    fi

    # Verify Git installation
    if ! command_exists git; then
        echo "Git installation failed. Please install Git manually and run this script again."
        exit 1
    fi
}

# Check if Git is installed
if ! command_exists git; then
    install_git
fi

echo "Git is installed. Continuing with the script..."

# Clone the repository and set up the directory
if [ ! -d "$HOME/sway" ]; then
    git clone https://github.com/silverhadch/sway-Gentoo "$HOME/sway"
else
    echo "Directory $HOME/sway already exists. Skipping clone."
fi
# Install eselect-repository if it's not already installed
sudo emerge app-admin/eselect-repository

# Add the gentoo overlay
sudo eselect repository add gentoo git https://github.com/gentoo/gentoo.git

# Sync the Portage tree
sudo emerge --sync

sudo emerge dev-build/ninja
# Display a welcome message
clear
cat << "EOF"
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |c|u|s|t|o|m| |s|c|r|i|p|t| 
 +-+-+-+-+-+-+ +-+-+-+-+-+-+                                                                                                            
EOF
# Additional ASCII art for GitHub and Porter to Gentoo
cat << "EOF"
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |s|i|l|v|e|r|h|a|d|c|h| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |P|o|r|t|e|r| |t|o| |G|e|n|t|o|o|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |https://github.com/silverhadch|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
EOF

# Initial instructions to the user
echo "This script will attempt to install and configure various packages and settings."
echo "Some packages might be masked and require adding 'ACCEPT_KEYWORDS=\"~amd64\"' to your /etc/portage/make.conf."
echo "If you haven't done so, please update your make.conf accordingly before proceeding."
echo "Failure to add this may result in installation errors."

# Pause to allow user to read the message
read -p "Press Enter to continue or Ctrl+C to exit..."
# Run setup scripts
for script in setup.sh packages.sh display_manager.sh add_bashrc.sh printers.sh bluetooth.sh; do
    script_path="$HOME/sway/install_scripts/$script"
    if [ -x "$script_path" ]; then
        bash "$script_path"
    else
        echo "Script $script_path not found or not executable. Skipping."
    fi
    clear
done

# Clean up unnecessary packages
sudo emerge --depclean

# Final message
printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
