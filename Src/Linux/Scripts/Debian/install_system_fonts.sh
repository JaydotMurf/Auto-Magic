#!/usr/bin/env bash

dir_path="/usr/share/fonts/fira-code"
zip_file="/tmp/Fira_Code_v6.2.zip"
temp_extract_path="/tmp/fira-code-extract"

update_fonts() {
    echo "Updating your system's font cache..."
    sudo fc-cache -f -v

    echo "Confirming that Fira Code fonts are installed:"
    fc-list | grep "Fira"
}

cleanup() {
    echo "Cleaning up..."
    rm -f "$zip_file"
    rm -rf "$temp_extract_path"
}

if fc-list | grep -qi "Fira"; then
    echo "Fira Code fonts are already installed."
else
    mkdir -p "$dir_path" && echo "Directory ensured: $dir_path"
    
    if [ ! -f "$zip_file" ]; then
        echo "Downloading Fira Code font..."
        wget -O "$zip_file" https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip
    else
        echo "Font zip already downloaded."
    fi

    mkdir -p "$temp_extract_path"

    echo "Extracting font..."
    unzip -q "$zip_file" 'ttf/*' -d "$temp_extract_path"
    
    echo "Moving TTF fonts to $dir_path..."
    mv "$temp_extract_path"/ttf/* "$dir_path"

    update_fonts

    cleanup
fi