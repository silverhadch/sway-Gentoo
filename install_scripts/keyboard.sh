#!/bin/bash

#Systemd
# File path to append the keyboard layout
#config_file="$HOME/sway/configs/sway/config.d/default"
# List all keyboard layouts
#echo "Available keyboard layouts:"
#localectl list-keymaps
# Ask the user to select a keyboard layout
#read -p "Enter the keyboard layout you want to use: " selected_layout
# Check if the selected layout is not empty
#if [ -n "$selected_layout" ]; then
  # Append the keyboard layout configuration to the Sway config file
  #echo -e "\n# Keyboard layout\ninput * {\n  xkb_layout \"$selected_layout\"\n}" >> "$config_file"
  #echo "Keyboard layout '$selected_layout' has been added to $config_file."
#else
  #echo "No layout selected. Exiting."
#fi

# Standard OpenRC
# Directory containing the keyboard layout files
keymap_dir="/usr/share/keymaps/$(uname -m)/"

# Check if the directory exists
if [ ! -d "$keymap_dir" ]; then
  echo "Error: The directory $keymap_dir was not found."
  exit 1
fi

# List available keyboard layouts
echo "Available keyboard layouts:"
ls "$keymap_dir"*/ | grep -E "\.map\.gz$" | sed "s|$keymap_dir||" | nl

# Ask the user to select a keyboard layout
read -p "Enter the name of the desired keyboard layout (e.g., de-latin1): " selected_layout

# Check if the selection is not empty
if [ -n "$selected_layout" ]; then
  # File to append the keyboard layout configuration
  sway_config="$HOME/sway/configs/sway/config.d/default"

  # Ensure the configuration file exists
  if [ ! -f "$sway_config" ]; then
    echo "Error: The file $sway_config was not found."
    exit 1
  fi

  # Add keyboard layout configuration
  echo -e "\n# Keyboard layout\ninput * {\n  xkb_layout \"$selected_layout\"\n}" >> "$sway_config"

  echo "Keyboard layout set to '$selected_layout'."
  echo "Changes have been saved to $sway_config."
else
  echo "No selection made. Exiting script."
fi
