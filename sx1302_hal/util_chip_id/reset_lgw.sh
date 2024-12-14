#!/bin/bash

# GPIO mapping
SX1302_RESET_PIN=17     # SX1302 reset
SX1302_POWER_EN_PIN=18  # SX1302 power enable
SX1261_RESET_PIN=5     # SX1261 reset (LBT / Spectral Scan)
AD5338R_RESET_PIN=13    # AD5338R reset (full-duplex CN490 reference design)

WAIT_GPIO() {
    sleep 0.1
}

init() {
    echo "Initializing GPIOs..."
    gpioinfo gpiochip0 | grep -E "line $SX1302_RESET_PIN|line $SX1302_POWER_EN_PIN|line $SX1261_RESET_PIN|line $AD5338R_RESET_PIN"
}

reset() {
    echo "Performing reset sequence..."

    # Set SX1302_POWER_EN_PIN to HIGH
    gpioset gpiochip0 $SX1302_POWER_EN_PIN=1
    WAIT_GPIO

    # Pulse SX1302_RESET_PIN
    gpioset gpiochip0 $SX1302_RESET_PIN=1
    WAIT_GPIO
    gpioset gpiochip0 $SX1302_RESET_PIN=0
    WAIT_GPIO

    # Pulse SX1261_RESET_PIN
    gpioset gpiochip0 $SX1261_RESET_PIN=0
    WAIT_GPIO
    gpioset gpiochip0 $SX1261_RESET_PIN=1
    WAIT_GPIO

    # Pulse AD5338R_RESET_PIN
    gpioset gpiochip0 $AD5338R_RESET_PIN=0
    WAIT_GPIO
    gpioset gpiochip0 $AD5338R_RESET_PIN=1
    WAIT_GPIO
}

term() {
    echo "Cleaning up GPIOs..."
    # Reset all pins to their default states
    gpioset gpiochip0 $SX1302_RESET_PIN=0
    gpioset gpiochip0 $SX1302_POWER_EN_PIN=0
    gpioset gpiochip0 $SX1261_RESET_PIN=0
    gpioset gpiochip0 $AD5338R_RESET_PIN=0
}

case "$1" in
    start)
    term # Ensure clean state
    reset
    ;;
    stop)
    reset
    term
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

exit 0