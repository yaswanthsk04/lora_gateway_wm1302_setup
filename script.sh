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

# Give execute permissions to reset_lgw.sh
chmod +x reset_lgw.sh

# Run the chip_id file and extract the EUI
output=$(./chip_id)
eui=$(echo "$output" | grep -oP 'INFO: concentrator EUI: 0x\K[0-9a-fA-F]+')

# Convert lowercase letters to uppercase
eui_capitalized=$(echo $eui | tr '[:lower:]' '[:upper:]')

# Copy the EUI to the clipboard using xclip
echo $eui_capitalized | xclip -selection clipboard

# Navigate to packet_forwarder directory
cd ../packet_forwarder

# Update gateway_ID in global_conf.json.sx1250.EU868
if [ ! -z "$eui_capitalized" ]; then
    sed -i "s/\"gateway_ID\": \"[A-Fa-f0-9]*\"/\"gateway_ID\": \"$eui_capitalized\"/" global_conf.json.sx1250.EU868
    echo "gateway_ID updated to $eui_capitalized in global_conf.json.sx1250.EU868"
else
    echo "No EUI found to update gateway_ID."
fi

# Run the packet forwarder
if [ -x "./lora_pkt_fwd" ]; then
    ./lora_pkt_fwd -c global_conf.json.sx1250.EU868
    echo "Packet forwarder started with configuration file global_conf.json.sx1250.EU868"
else
    echo "Error: lora_pkt_fwd is not executable or missing."
fi
