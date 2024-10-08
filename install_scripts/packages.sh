#!/bin/bash

# Function to install selected packages
install_packages() {
    sudo emerge --ask --autounmask-write "$@"
    sudo dispatch-conf
}

# File Managers
file_managers=("xfce-base/thunar" "x11-misc/pcmanfm" "kde-misc/krusader" "gnome-base/nautilus" "gnome-extra/nemo" "kde-apps/dolphin" "app-misc/ranger" "app-misc/nnn" "app-misc/lf")

echo "Choose File Managers to install (space-separated list, e.g., 1 3 5):"
for i in "${!file_managers[@]}"; do
    echo "$((i+1)). ${file_managers[i]}"
done
read -rp "Selection: " file_manager_selection

selected_file_managers=()
for index in $file_manager_selection; do
    selected_file_managers+=("${file_managers[index-1]}")
done

# Graphics
graphics=("media-gfx/gimp" "media-gfx/flameshot" "media-gfx/eog" "media-gfx/sxiv" "media-gfx/qimgv" "media-gfx/inkscape" "media-gfx/scrot")

echo "Choose graphics applications to install (space-separated list, e.g., 1 3 5):"
for i in "${!graphics[@]}"; do
    echo "$((i+1)). ${graphics[i]}"
done
read -rp "Selection: " graphics_selection

selected_graphics=()
for index in $graphics_selection; do
    selected_graphics+=("${graphics[index-1]}")
done

# Terminals
terminals=("x11-terms/alacritty" "x11-terms/gnome-terminal" "x11-terms/kitty" "kde-apps/konsole" "x11-terms/terminator" "x11-terms/xfce4-terminal" "x11-terms/tilix")

echo "Choose Terminals to install (space-separated list, e.g., 1 3):"
for i in "${!terminals[@]}"; do
    echo "$((i+1)). ${terminals[i]}"
done
read -rp "Selection: " terminal_selection

selected_terminals=()
for index in $terminal_selection; do
    selected_terminals+=("${terminals[index-1]}")
done

# Text Editors
text_editors=("dev-util/geany" "kde-apps/kate" "app-editors/gedit" "app-editors/l3afpad" "app-editors/mousepad" "app-editors/pluma")

echo "Choose Text Editors to install (space-separated list, e.g., 1 3 5):"
for i in "${!text_editors[@]}"; do
    echo "$((i+1)). ${text_editors[i]}"
done
read -rp "Selection: " text_editor_selection

selected_text_editors=()
for index in $text_editor_selection; do
    selected_text_editors+=("${text_editors[index-1]}")
done

# Multimedia
multimedia=("media-video/mpv" "media-video/vlc" "media-sound/audacity" "kde-apps/kdenlive" "media-video/obs-studio" "media-sound/rhythmbox" "media-sound/ncmpcpp" "media-video/mkvtoolnix")

echo "Choose Multimedia applications to install (space-separated list, e.g., 1 3 5):"
for i in "${!multimedia[@]}"; do
    echo "$((i+1)). ${multimedia[i]}"
done
read -rp "Selection: " multimedia_selection

selected_multimedia=()
for index in $multimedia_selection; do
    selected_multimedia+=("${multimedia[index-1]}")
done

# Utilities
utilities=("sys-block/gparted" "sys-apps/gnome-disk-utility" "app-misc/fastfetch" "x11-misc/nitrogen" "x11-misc/numlockx" "sci-calculators/galculator" "sys-apps/cpu-x" "net-misc/whois" "net-misc/curl" "app-text/tree" "sys-process/btop" "sys-process/htop" "sys-apps/bat" "app-misc/brightnessctl" "x11-misc/redshift" "x11-misc/gammastep")

echo "Choose utilities applications to install (space-separated list, e.g., 1 3 5):"
for i in "${!utilities[@]}"; do
    echo "$((i+1)). ${utilities[i]}"
done
read -rp "Selection: " utilities_selection

selected_utilities=()
for index in $utilities_selection; do
    selected_utilities+=("${utilities[index-1]}")
done

# Install selected packages
install_packages "${selected_file_managers[@]}" "${selected_graphics[@]}" "${selected_terminals[@]}" "${selected_text_editors[@]}" "${selected_multimedia[@]}" "${selected_utilities[@]}"
