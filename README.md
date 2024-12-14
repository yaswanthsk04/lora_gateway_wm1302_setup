# Setting up WM1302 LoRaWAN Gateway Module for Raspbian OS 12

This Setup follows [https://github.com/seeed-lora/WM1302-doc](https://github.com/seeed-lora/WM1302-doc])

WM1302 module is a new generation of LoRaWAN gateway module with mini-PCIe form-factor. Based on the Semtech® SX1302 baseband LoRaWAN® chip, WM1302 unlocks the greater potential capacity of long-range wireless transmission for gateway products. It features higher sensitivity, less power consumption, and lower operating temperature than the previous SX1301 and SX1308 LoRa® chip. 

## Getting Started
### This guide is for setting up SPI Version Only | For USB version please check Seeed Lora Docs reffered above

### Quick Start with WM1302

#### Step1. Mounting WM1302 Raspberry Pi Hat and install WM1302 module

It is easy to mount the Pi Hat on Raspberry Pi 40 Pin Header. Power off Raspberry Pi first, insert WM1302 module to the Pi Hat as the following picture and screw it down.

#### Step2. Enable the Raspbian I2C and SPI interface

WM1302 module communicates with Raspberry Pi with SPI and I2C. But these two interfaces are not enabled by default in Raspbian, so developer need to enable them before using WM1302. Here, we introduce a command line way to enable SPI and I2C interface.

First, login in Raspberry Pi via SSH or using a monitor(don't use serial console as the GPS module on the Pi Hat takes over the Pi's hardware UART pins), then type `sudo raspi-config` in command line to open Rasberry Pi Software Configuration Tool:

```
sudo raspi-config
```

1. Select `System Options`, then select `Desktop Autologin`, then if prompted for `Yes`.
  
2. Select `Interface Options`

3. Select `SPI`, then select `Yes` to enable it

4. Select `I2C`, then select `Yes` to enable it

5. Select `Serial Port`, then select `No` for "Would you like a login shell..." and select `Yes` for "Would you like the serial port hardware..."

6. After this, please reboot Raspberry Pi to make sure these settings work.

7. #### Step3. Run the Script in the Repo

The Script will take care of all the steps mentioned in the Docs provided by Seeed Studio Docs.
1. Reset pins are changed based on the docs
2. EUI ID of the Hardware is copied and the pased int eh global.conf file in packet_forwarder.
3. Server_address, server_inbound_port and server_outbound_port are all set.

All these changes are taken care by the script.

## Additionally, the script will also make sure that the packet_forwarder will start after everytime the rasp pi powers-up. To run this script, below commands must be run in order:

```
chmod +x script.sh
./script.sh
```
To Run the Packet_forwarder manuall, Run: 
`
./lora_pkt_fwd -c global_conf.json.sx1250.EU868
`
