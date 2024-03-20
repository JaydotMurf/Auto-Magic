#!/usr/bin/env bash

# Function to display error messages in red and exit
error_exit() {
    echo -e "\033[0;31mError: $1\033[0m" >&2
    exit 1
}

# Function to display success messages in green
success_msg() {
    echo -e "\033[0;32m$1\033[0m"
}

# Check if VScodium repository key exists, download if not
if [ ! -f "/usr/share/keyrings/vscodium-archive-keyring.gpg" ]; then
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | \
        gpg --dearmor | \
        sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg || error_exit "Failed to download and add VScodium repository key"
    success_msg "VScodium repository key downloaded and added successfully."
else
    success_msg "VScodium repository key already exists."
fi

# Check if VScodium repository is already in apt sources, add if not
if ! grep -qxF 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' /etc/apt/sources.list.d/vscodium.list; then
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | \
        sudo tee -a /etc/apt/sources.list.d/vscodium.list || error_exit "Failed to add VScodium repository to apt sources"
    success_msg "VScodium repository added to apt sources."
else
    success_msg "VScodium repository already added to apt sources."
fi

# Update apt cache and install VScodium
sudo apt update -y || error_exit "Failed to update apt cache"
sudo apt install codium -y || error_exit "Failed to install VScodium"

success_msg "VScodium installation completed successfully."
