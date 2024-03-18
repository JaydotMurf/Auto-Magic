#!/bin/bash

# Path to the software list configuration file
CONFIG_PATH="./configurations/software_list.conf"

# Function to check if apt-get update is needed based on the last update time
check_and_update_packages() {
    # Get the last modification time of the apt package cache
    last_update_str=$(ls -l /var/cache/apt/pkgcache.bin | cut -d' ' -f6-8)
    last_update=$(date -d "$last_update_str" +%s)

    # Get the current time
    current_time=$(date +%s)

    # Define the update interval (12 hours in seconds)
    local update_interval=$((12 * 60 * 60))

    # Update package lists if more than 12 hours have passed since the last update
    if (( current_time - last_update > update_interval )); then
        echo "Updating package lists..."
        sudo apt-get update
    else
        echo "Package lists are up to date."
    fi
}

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Function to install a package if not already installed
install_package() {
    local package=$1
    if is_installed "$package"; then
        echo "Package '$package' is already installed."
    else
        echo "Installing package '$package'..."
        sudo apt-get install -y "$package"
    fi
}

# Update package lists if necessary
check_and_update_packages

# Read and install packages from configuration file
echo "Installing packages from $CONFIG_PATH..."
while IFS= read -r package || [[ -n "$package" ]]; do
    # Skip lines that are empty or start with '#'
    [[ -z "$package" || "$package" == \#* ]] && continue
    install_package "$package"
done < "$CONFIG_PATH"

echo "Installation process completed."
