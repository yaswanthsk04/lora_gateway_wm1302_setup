#!/bin/bash

# Ensure xclip is installed
if ! command -v xclip &> /dev/null
then
    echo "xclip could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y xclip
fi

# Copy the sx1302_hal directory to the home directory
cp -r sx1302_hal ~/sx1302_hal

# Navigate to the copied sx1302_hal directory
cd ~/sx1302_hal

# Run the make command
make

# Navigate to the util_chip_id folder
cd util_chip_id

# Run the chip_id file and extract the EUI
output=$(./chip_id)
eui=$(echo "$output" | grep -oP 'concentrator EUI: \K[0-9a-fA-F]+')

# Convert lowercase letters to uppercase
eui_capitalized=$(echo $eui | tr '[:lower:]' '[:upper:]')

# Copy the EUI to the clipboard using xclip
echo $eui_capitalized | xclip -selection clipboard

# Output the copied EUI to the terminal (optional)
echo "EUI ($eui_capitalized) copied to clipboard."
